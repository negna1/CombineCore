import Foundation


public extension URLComponents {
    
    init(scheme: String = "https",
                host: String = "myApp.com",
                path: String,
                queryItems: [URLQueryItem]? = nil) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        self = components
    }
}

public protocol Bodyable {
    var toBody: [String: Any] {get set}
}
