import XCTest
@testable import CryptoCodex

final class CryptoCodexTests: XCTestCase {
    
    func testAssetsRepository_List() throws {
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
    
    func testAssetsRepository_Single() throws {
        let pathExpectation = self.expectation(description: "Path")
        let methodExpectation = self.expectation(description: "HttpMethod")
        
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "AssetsSingle", withExtension: "json")
            
            if path == "v2/assets/bitcoin" {
                pathExpectation.fulfill()
            }
            if method == "GET" {
                methodExpectation.fulfill()
            }
            
            return .success(try! Data(contentsOf: url!))
        }))
        
        let response = try awaitPublisher(repository.fetchSingle(id: "bitcoin"))
        
        waitForExpectations(timeout: 1)
    }
    
    func testCurrencyService_List() throws {
        
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "Assets", withExtension: "json")
            return .success(try! Data(contentsOf: url!))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let response = try awaitPublisher(service.getCurrencies())
        
        XCTAssertEqual(response.count, 10, "Currencies count mismatch")
        XCTAssertEqual(response.first!.id, "bitcoin", "Id mismatch")
        XCTAssertEqual(response.first!.iconUrl, "https://assets.coincap.io/assets/icons/btc@2x.png", "Icon URL mismatch")
        XCTAssertEqual(response.first!.symbol, "BTC", "Symbol mismatch")
        XCTAssertEqual(response.first!.name, "Bitcoin", "Name mismatch")
        XCTAssertEqual(response.first!.supply, 17193925, "Supply mismatch")
        XCTAssertEqual(response.first!.price, Decimal(string: "6929.8217756835584756"), "Price mismatch")
        XCTAssertEqual(response.first!.changePercent24Hr, Decimal(string: "-0.8101417214350335"), "Change percent mismatch")
        XCTAssertEqual(response.first!.volume24Hr, Decimal(string: "2927959461.1750323310959460"), "Volume mismatch")
        XCTAssertEqual(response.first!.marketCap, Decimal(string: "119150835874.4699281625807300"), "Market cap mismatch")
    }
    
    func testCurrencyService_Single() throws {
        
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "AssetsSingle", withExtension: "json")
            return .success(try! Data(contentsOf: url!))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let response = try awaitPublisher(service.getCurrency(id: "bitcoin"))
        
        
        XCTAssertEqual(response.id, "bitcoin", "Id mismatch")
        XCTAssertEqual(response.iconUrl, "https://assets.coincap.io/assets/icons/btc@2x.png", "Icon URL mismatch")
        XCTAssertEqual(response.symbol, "BTC", "Symbol mismatch")
        XCTAssertEqual(response.name, "Bitcoin", "Name mismatch")
        XCTAssertEqual(response.supply, 17193925, "Supply mismatch")
        XCTAssertEqual(response.price, Decimal(string: "6929.8217756835584756"), "Price mismatch")
        XCTAssertEqual(response.changePercent24Hr, Decimal(string: "-0.8101417214350335"), "Change percent mismatch")
        XCTAssertEqual(response.volume24Hr, Decimal(string: "2927959461.1750323310959460"), "Volume mismatch")
        XCTAssertEqual(response.marketCap, Decimal(string: "119150835874.4699281625807300"), "Market cap mismatch")
        
    }
    
    func testCurrencyListViewmodel_Success() throws {
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "Assets", withExtension: "json")
            return .success(try! Data(contentsOf: url!))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let viewmodel = CurrencyListViewModel(currencyService: service)
        
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
        let viewmodel = CurrencyListViewModel(currencyService: service)
        
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
        let viewmodel = CurrencyListViewModel(currencyService: service)
        
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
    
    func testCurrencyDetailsViewmodel_Success() throws {
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            let url = Bundle(for: type(of: self)).url(forResource: "AssetsSingle", withExtension: "json")
            return .success(try! Data(contentsOf: url!))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let viewmodel = CurrencyDetailsViewModel(currencyService: service, currency: .init(
            id: "",
            iconUrl: "",
            name: "",
            symbol: "",
            price: 0,
            changePercent24Hr: 0,
            supply: 0,
            volume24Hr: 0,
            marketCap: 0
        ))
        
        XCTAssertTrue(viewmodel.state == .idle, "Initial idle state missing")
        
        let loadedExpectation = XCTestExpectation(description: "Loaded state")
        
        let cancellable = viewmodel.$state
            .dropFirst()
            .sink(receiveValue: { state in
                switch state {
                case .idle:
                    XCTAssertEqual(viewmodel.currency.id, "bitcoin", "Id mismatch")
                    XCTAssertEqual(viewmodel.currency.iconUrl, "https://assets.coincap.io/assets/icons/btc@2x.png", "Icon URL mismatch")
                    XCTAssertEqual(viewmodel.currency.symbol, "BTC", "Symbol mismatch")
                    XCTAssertEqual(viewmodel.currency.name, "Bitcoin", "Name mismatch")
                    XCTAssertEqual(viewmodel.currency.supply, 17193925, "Supply mismatch")
                    XCTAssertEqual(viewmodel.currency.price, Decimal(string: "6929.8217756835584756"), "Price mismatch")
                    XCTAssertEqual(viewmodel.currency.changePercent24Hr, Decimal(string: "-0.8101417214350335"), "Change percent mismatch")
                    XCTAssertEqual(viewmodel.currency.volume24Hr, Decimal(string: "2927959461.1750323310959460"), "Volume mismatch")
                    XCTAssertEqual(viewmodel.currency.marketCap, Decimal(string: "119150835874.4699281625807300"), "Market cap mismatch")
                    loadedExpectation.fulfill()
                default:
                    break
                }
            })
        
        viewmodel.load()
        
        wait(for: [loadedExpectation], timeout: 2)
        cancellable.cancel()
    }
    
    func testCurrencyDetailsViewmodel_Failure() throws {
        let repository = AssetsRemoteRepository(httpConnection: MockHttpConnection(mockCallback: { path, method, query in
            return .failure(.httpError(404))
        }))
        
        let service = CurrencyServiceImpl(repository: repository)
        let viewmodel = CurrencyDetailsViewModel(currencyService: service, currency: .init(
            id: "",
            iconUrl: "",
            name: "",
            symbol: "",
            price: 0,
            changePercent24Hr: 0,
            supply: 0,
            volume24Hr: 0,
            marketCap: 0
        ))
        
        XCTAssertTrue(viewmodel.state == .idle, "Initial idle state missing")
        
        let failedExpectation = XCTestExpectation(description: "Failed state")
        
        let cancellable = viewmodel.$state
            .dropFirst()
            .sink(receiveValue: { state in
                switch state {
                case .failed:
                    XCTAssertEqual(viewmodel.currency.id, "", "Id mismatch")
                    XCTAssertEqual(viewmodel.currency.iconUrl, "", "Icon URL mismatch")
                    XCTAssertEqual(viewmodel.currency.symbol, "", "Symbol mismatch")
                    XCTAssertEqual(viewmodel.currency.name, "", "Name mismatch")
                    XCTAssertEqual(viewmodel.currency.supply, 0, "Supply mismatch")
                    XCTAssertEqual(viewmodel.currency.price, 0, "Price mismatch")
                    XCTAssertEqual(viewmodel.currency.changePercent24Hr, 0, "Change percent mismatch")
                    XCTAssertEqual(viewmodel.currency.volume24Hr, 0, "Volume mismatch")
                    XCTAssertEqual(viewmodel.currency.marketCap, 0, "Market cap mismatch")
                    failedExpectation.fulfill()
                default:
                    break
                }
            })
        
        viewmodel.load()
        
        wait(for: [failedExpectation], timeout: 2)
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
