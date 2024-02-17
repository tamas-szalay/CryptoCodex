
import Foundation
import Combine

class CurrencyDetailsViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case failed
        case idle
    }
    
    private let currencyService: CurrencyService
    
    private var loadSubscription: AnyCancellable?
    
    private(set) var currency: Currency
    
    @Published private (set) var state = State.idle
    
    init(currencyService: CurrencyService, currency: Currency) {
        self.currencyService = currencyService
        self.currency = currency
    }
    
    deinit {
        loadSubscription?.cancel()
    }
    
    func load() {
        state = .loading
        DispatchQueue.global().async { [self] in
            loadSubscription = currencyService.getCurrency(id: currency.id)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.state = .failed
                    case .finished:
                        return
                    }
                }, receiveValue: { [weak self] result in
                    self?.currency = result
                    self?.state = .idle
                })
        }
    }
}

