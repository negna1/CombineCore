//
//  File.swift
//  
//
//  Created by Nato Egnatashvili on 18.11.22.
//

import Foundation
import Combine

public extension URLSession {
    @available(iOS 13.0, *)
    func fetch<Response: Decodable>(for request: URLRequest,
                                    with type: Response.Type) -> AnyPublisher<Response, Error>{
        dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
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
}
