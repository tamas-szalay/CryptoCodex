import Foundation
import Combine

class CurrencyListViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case empty
        case failed(CCError)
        case loaded([Currency])
    }
    
    private let currencyService: CurrencyService
    
    private var loadSubscription: AnyCancellable?
    
    @Published private (set) var state = State.loading
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
        
        load()
    }
    
    deinit {
        loadSubscription?.cancel()
    }
    
    func load() {
        DispatchQueue.global().async { [self] in
            loadSubscription = currencyService.getCurrencies()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                        self?.state = .failed(error)
                    case .finished:
                        return
                    }
                }, receiveValue: { [weak self] result in
                    self?.state = result.isEmpty ? .empty : .loaded(result)
                })
        }
    }
}
