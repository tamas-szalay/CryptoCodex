import SwiftUI

struct CurrencyListView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: CurrencyListViewModel
    
    var body: some View {
        Background {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .accessibility(identifier: "progress")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .loaded(let result):
                
                VStack {
                    Color.clear.frame(height: 8)
                    List {
                        ForEach(result) { currency in
                            CurrencyListCard(action: {
                                router.navigateTo(.currencyDetails(currency))
                            }, currency: currency)
                        }.listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .selectionDisabled()
                        
                    }.listRowSpacing(0)
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .contentMargins(.bottom, 16, for: .scrollContent)
                        .accessibility(identifier: "result")
                }
            case .failed:
                VStack(alignment: .center, spacing: 20) {

                    Text("CurrencyListErrorMessage").font(.applicationBold(size: 24))
                    Button {
                        viewModel.load()
                    } label: {
                        Image(systemName: "arrow.clockwise.circle").font(.system(size: 60))
                    }.tint(.fgDefault)

                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                VStack(alignment: .center, spacing: 20) {
                    Image(systemName: "doc").resizable().frame(width: 50, height: 50, alignment: .center)
                    Text("CurrencyListEmptyMessage").font(.applicationRegular(size: 20))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationTitle(text: String(localized: "CurrencyListScreenTitle"))
            }
            
        }
    }
}

extension Currency: Identifiable {
}

#Preview {
    CurrencyListView(viewModel: CurrencyListViewModel(currencyService: DIContainer.shared.resolve()))
}
