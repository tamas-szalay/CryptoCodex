import XCTest
@testable import CryptoCodex

final class CryptoCodexTests: XCTestCase {

    func testAssetsRepository_List() throws {
        let searchString = "swift"
        
        let queryExpectation = self.expectation(description: "Query")
        let pathExpectation = self.expectation(description: "Path")
        let methodExpectation = self.expectation(description: "HttpMethod")
        
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "Assets", withExtension: "json")
            
            if path == "v2/assets" {
                pathExpectation.fulfill()
            }
            if let limit = query?["limit"], limit == "10" {
                queryExpectation.fulfill()
            }
            if method == "GET" {
                methodExpectation.fulfill()
            }
            
            return .success(try! Data(contentsOf: url!))
        }))
        
        let response = try awaitPublisher(repository.fetch(top: 10))
        
        waitForExpectations(timeout: 1)
        
        XCTAssertEqual(response.data.count, 10, "Assets response count mismatch")
    }

    func testCurrencyService_List() throws {
        
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "Assets", withExtension: "json")
            return .success(try! Data(contentsOf: url!))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let response = try awaitPublisher(service.getCurrencies())
        
        XCTAssertEqual(response.count, 10, "Currencies count mismatch")
        XCTAssertEqual(response.first!.id, "bitcoin", "Id not matches")
        XCTAssertEqual(response.first!.iconUrl, "https://assets.coincap.io/assets/icons/btc@2x.png", "Icon URL mismatch")
        XCTAssertEqual(response.first!.symbol, "BTC", "Id not matches")
        XCTAssertEqual(response.first!.name, "Bitcoin", "Id not matches")
        XCTAssertEqual(response.first!.supply, 17193925, "Id not matches")
        XCTAssertEqual(response.first!.price, Decimal(string: "6929.8217756835584756"), "Id not matches")
        XCTAssertEqual(response.first!.changePercent24Hr, Decimal(string: "-0.8101417214350335"), "Id not matches")
        
    }

    func testCurrencyListViewmodel_Success() throws {
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "Assets", withExtension: "json")
            return .success(try! Data(contentsOf: url!))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let viewmodel = CurrencyViewModel(currencyService: service)
        
        XCTAssertTrue(viewmodel.state == .loading, "Initial loading state missing")
        
        let loadedExpectation = XCTestExpectation(description: "Loaded state")
        
        let cancellable = viewmodel.$state
            .dropFirst()
            .sink(receiveValue: { state in
                switch state {
                case .loaded(let result):
                    XCTAssertTrue(result.count == 10, "Currencies count mismatch")
                    loadedExpectation.fulfill()
                default:
                    break
                }
            })
        
        wait(for: [loadedExpectation], timeout: 2)
        cancellable.cancel()
    }
    
    func testCurrencyListViewmodel_Failure() throws {
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            return .failure(.httpError(404))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let viewmodel = CurrencyViewModel(currencyService: service)
        
        XCTAssertTrue(viewmodel.state == .loading, "Initial loading state missing")
        
        let failedExpectation = XCTestExpectation(description: "Failed state")
        
        let cancellable = viewmodel.$state
            .dropFirst()
            .sink(receiveValue: { state in
                switch state {
                case .failed(let exception):
                    XCTAssertTrue(exception == .httpError(404), "Failed state mismatch")
                    failedExpectation.fulfill()
                default:
                    break
                }
            })
        
        wait(for: [failedExpectation], timeout: 2)
        cancellable.cancel()
    }
    
    func testCurrencyListViewmodel_Empty() throws {
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "AssetsEmpty", withExtension: "json")
            return .success(try! Data(contentsOf: url!))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let viewmodel = CurrencyViewModel(currencyService: service)
        
        XCTAssertTrue(viewmodel.state == .loading, "Initial loading state missing")

        let emptyExpectation = XCTestExpectation(description: "Empty state")
        
        let cancellable = viewmodel.$state
            .dropFirst()
            .sink(receiveValue: { state in
                switch state {
                case .empty:
                    emptyExpectation.fulfill()
                default:
                    break
                }
            })
        
        wait(for: [emptyExpectation], timeout: 2)
        cancellable.cancel()
    }
    
    func testNumberFormatter_ChangePercentFormat() {
        let negativeRoundDown = NumberFormatter.changePercentFormat(-1.23942342)
        XCTAssertEqual(negativeRoundDown, "-1.24%")
        let negativeRoundUp = NumberFormatter.changePercentFormat(-1.23342342)
        XCTAssertEqual(negativeRoundUp, "-1.23%")
        let positiveRoundDown = NumberFormatter.changePercentFormat(0.28342342)
        XCTAssertEqual(positiveRoundDown, "0.28%")
        let positiveRoundUp = NumberFormatter.changePercentFormat(0.28942342)
        XCTAssertEqual(positiveRoundUp, "0.29%")
    }
    
    func testNumberFormatter_PriceFormat() {
        let belowThousand = NumberFormatter.priceFormat(870.12)
        XCTAssertEqual(belowThousand, "$870.12")
        let aboveThousand = NumberFormatter.priceFormat(1870.12)
        XCTAssertEqual(aboveThousand, "$1.87K")
        let aboveMillion = NumberFormatter.priceFormat(18701234.12)
        XCTAssertEqual(aboveMillion, "$18.70M")
        let aboveBillion = NumberFormatter.priceFormat(187012300476.12)
        XCTAssertEqual(aboveBillion, "$187.01B")
    }
    
}