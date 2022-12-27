import XCTest
@testable import CombineCore

final class CombineCoreTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CombineCore().text, "Hello, World!")
    }
    
    func testSearchingStop() {
        let request = URLRequest.rate(body: .init(amount: 10, to_currency: "USD", from_currency: "EUR"))
        if #available(iOS 13.0, *) {
            let expectation = XCTestExpectation(description: "http desc")
            Task {
                var searching: Bool = true
                let resp = await URLSession.shared.fetchAsync(for: request, with: RateResponse.self)
                
                if !Task.isCancelled {
                    searching = false
                    XCTAssertEqual(searching, false)
                }
                switch resp {
                case .failure(_):
                    expectation.fulfill()
                case .success(_):
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 3.0)
        } else {
        }
        
    }
    
    func testSearching() {
        let request = URLRequest.rate(body: .init(amount: 10, to_currency: "USD", from_currency: "EUR"))
        if #available(iOS 13.0, *) {
            let expectation = XCTestExpectation(description: "http desc")
            Task {
                var searching: Bool = true
                XCTAssertEqual(searching, true)
                let resp = await URLSession.shared.fetchAsync(for: request, with: RateResponse.self)
                
                if !Task.isCancelled {
                    searching = false
                    XCTAssertEqual(searching, false)
                }
                switch resp {
                case .failure(_):
                    expectation.fulfill()
                case .success(_):
                    expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 3.0)
        } else {
        }
        
    }
    
    func testAsync() {
        let request = URLRequest.rate(body: .init(amount: 10, to_currency: "USD", from_currency: "EUR"))
        if #available(iOS 13.0, *) {
            let expectation = XCTestExpectation(description: "http desc")
            Task {
                print("isSearching", true)
                let resp = await URLSession.shared.fetchAsync(for: request, with: RateResponse.self)
                
                if !Task.isCancelled {
                    print("isSearching", false)
                }
                switch resp {
                case .failure(let f):
                    print(f.localizedDescription)
                    XCTAssertEqual(f.localizedDescription, "The operation couldn’t be completed. (CombineCore.ErrorType error 0.)")
                    expectation.fulfill()
                case .success(let suc):
                    XCTAssertEqual(suc.amount, 2)
                    expectation.fulfill()
                }
                print(resp)
            }
            
            wait(for: [expectation], timeout: 3.0)
        } else {
            // Fallback on earlier versions
        }
        
    }
}

