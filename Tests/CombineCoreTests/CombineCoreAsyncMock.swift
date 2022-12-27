import XCTest
@testable import CombineCore

extension URLComponents {
    static var rate: Self {
        Self(host: "elementsofdesign.api.stdlib.com",
             path: "/aavdjf")

    }
}

extension URLRequest {
    static func rate(body: RateRequest) -> Self {
        Self(components: .rate)
            .add(httpMethodType: .POST)
            .add(body: body)
    }
}

struct RateResponse: Decodable {
    let amount: Double?
    let rate: Double?
}

struct RateRequest: Bodyable {
    var toBody: [String : Any] = [:]
    let amount: Double
    let to_currency: String
    let from_currency: String
    
    public init(amount: Double,
                  to_currency: String,
                  from_currency: String) {
        self.amount = amount
        self.to_currency = to_currency
        self.from_currency = from_currency
        
        self.toBody = ["amount": amount,
                       "to_currency": to_currency,
                       "from_currency": from_currency]
    }
}
