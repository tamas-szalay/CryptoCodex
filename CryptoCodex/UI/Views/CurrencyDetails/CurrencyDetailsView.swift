import SwiftUI

struct CurrencyDetailsView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: CurrencyDetailsViewModel
    
    var body: some View {
        Background {
            Card(padding: .all(0)) {
                ZStack(alignment: .center) {
                    VStack(spacing: 24) {
                        HStack {
                            title("CurrencyDetailsPrice")
                            Spacer()
                            value(NumberFormatter.priceFormat(viewModel.currency.price))
                        }
                        HStack {
                            title("CurrencyDetailsChange24h")
                            Spacer()
                            PriceChangeText(priceChange: viewModel.currency.changePercent24Hr)
                        }
                        Color.bgSeparator.frame(height: 1)
                        HStack {
                            title("CurrencyDetailsMarketCap")
                            Spacer()
                            value(NumberFormatter.priceFormat(viewModel.currency.marketCap))
                        }
                        HStack {
                            title("CurrencyDetailsVolume24h")
                            Spacer()
                            value(NumberFormatter.priceFormat(viewModel.currency.volume24Hr))
                        }
                        HStack {
                            title("CurrencyDetailsSupply")
                            Spacer()
                            value(NumberFormatter.abbreviationFormat(viewModel.currency.supply))
                        }
                        if (viewModel.state == .failed) {
                            Text("CurrencyDetailsErrorMessage").font(.applicationRegular(size: 14)).foregroundStyle(.fgNegative)
                        }
                        Spacer()
                    }.padding(24)
                    
                    if viewModel.state == .loading {
                        Color.white.opacity(0.7)
                        ProgressView().tint(.fgDefault)
                    }
                        
                }
            }.padding(.init(top: 24, leading: 16, bottom: 24, trailing: 16))
        }.navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        router.navigateBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(Font.system(size: 23, weight: .medium))
                    }.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                }
                ToolbarItem(placement: .principal) {
                    NavigationTitle(text: viewModel.currency.name.uppercased())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    AsyncImage(url: URL(string: viewModel.currency.iconUrl)) { image in
                        image.image?.resizable().aspectRatio(contentMode: .fill)
                    }.frame(width: 40, height: 40).padding(.top, 8)
                }
                
            }
            .onAppear(perform: viewModel.load)
    }
    
    private func title(_ text: String.LocalizationValue) -> Text {
        Text(String(localized: text)).font(.applicationRegular(size: 16)).foregroundStyle(.fgDefault)
    }
    
    private func value(_ text: String) -> Text {
        Text(text).font(.applicationBold(size: 16)).foregroundStyle(.fgDefault)
    }
}

#Preview {
    CurrencyDetailsView(
        viewModel: CurrencyDetailsViewModel(
            currencyService: DIContainer.shared.resolve(),
            currency: .init(
                id: "bitcoin",
                iconUrl: "https://assets.coincap.io/assets/icons/btc@2x.png",
                name: "Bitcoin",
                symbol: "BTC",
                price: 52125.48,
                changePercent24Hr: -0.34,
                supply: 19629518,
                volume24Hr: 2927959461.18,
                marketCap: 119150835874.47
            )
        )
    )
}
