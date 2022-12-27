import Foundation
import Combine

public extension URLSession {
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    func fetch<Response: Decodable>(for request: URLRequest,
                                    with type: Response.Type) -> AnyPublisher<Response, Error>{
        dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    @available(macOS 10.15.0, *)
    @available(iOS 13.0, *)
    func errorCase<Response: Decodable>(with type: Response.Type,
                                        data: Data,
                                        response: URLResponse) -> Result<Response, Error>? {
        do {
            if let dataError = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?], dataError["error"] != nil {
                return .failure(ErrorType.error((dataError["reason"] as? String) ?? "Error"))
            }
            
            guard let resp = response as? HTTPURLResponse,
                  resp.statusCode == 200 else {
                return .failure(ErrorType.httpStatusCode((response as? HTTPURLResponse)?.statusCode ?? 0))
            }
        }catch {
            return .failure(ErrorType.noData)
        }
        return nil
    }
    
    @available(macOS 10.15.0, *)
    @available(iOS 13.0, *)
    func fetchAsync<Response: Decodable>(for request: URLRequest,
                                         with type: Response.Type) async -> Result<Response, Error> {
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let dataDecoded  = try JSONDecoder().decode(type, from: data)
            if let error = errorCase(with: Response.self,
                                     data: data,
                                     response: response) {
                return error
            }
            return .success(dataDecoded)
        }
        catch {
            return .failure(ErrorType.noData)
        }
    }
    
    func fetchForLowVersion<Response: Decodable>(for request: URLRequest,
                                                 responseType: Response.Type,
                                     completion: @escaping (Result<Response, Error>) -> ()) {
        dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(ErrorType.noData))
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(ErrorType.decoderError))
            }
            
        }.resume()
    }
}

public enum ErrorType: Error {
    case urlError
    case noData
    case decoderError
    case httpStatusCode(Int)
    case error(String)
}
