# CombineCore
It is Network layer with combine, It is easy to use, Don't need many protocols, It is easy to test because everything is extension


How To use?
 Create YOURAPINAME.URLRequestComponent
 you can add body, header, method. For components you can add queries. so everything is in here.
 (If you don't need query parameters you can create general component and only changed file will be url component).
 
```
import Foundation
import CombineCore

extension URLComponents {
    static var rate: Self {
        Self(host: "elementsofdesign.api.stdlib.com",
             path: "/aavia-currency-converter@dev/")

    }
}

extension URLRequest {
    static func rate(body: RateRequest) -> Self {
        Self(components: .rate)
            .add(httpMethodType: .POST)
            .add(body: body)
    }
}
```

create YOURAPINAME.RequestResponse, 
It is important that your request should confirm Bodyable protocol, which means that you should have struct and wrote toBody variable.

```
import CombineCore

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
```

Final usage
```
import CombineCore
import Combine

class TestCoreViewModel: ObservableObject {
    var cancellableSet: Set<AnyCancellable> = []
    func catchSomething() {
        let body = RateRequest(amount: 12.3, to_currency: "EUR", from_currency: "USD")
        let request = URLRequest.rate(body: body)
        let responsePubliser =  URLSession.shared.fetch(for: request, with: RateResponse.self )
        responsePubliser.sink { completion in
            switch completion {
            case .failure(let error):
                print(error)
            default:
                break
            }
        } receiveValue: { response in
            print(response)
        }.store(in: &cancellableSet)
    }
}
```
You don't need to change or add network cases, only thing is to add this case in urlrequest and component and that's all. 
