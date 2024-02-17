import SwiftUI

struct CurrencyListView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: CurrencyViewModel

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
                                router.navigateTo(.currencyDetails)
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
                    Image(systemName: "xmark.circle").resizable().frame(width: 50, height: 50, alignment: .center)
                    Text("Error").font(.applicationRegular(size: 20))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                VStack(alignment: .center, spacing: 20) {
                    Image(systemName: "doc").resizable().frame(width: 50, height: 50, alignment: .center)
                    Text("No results found").font(.applicationRegular(size: 20))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
               NavigationTitle(text: "COINS")
            }
        
        }
    }
}

extension Currency: Identifiable {
}

#Preview {
    CurrencyListView(viewModel: CurrencyViewModel(currencyService: DIContainer.shared.resolve()))
}
