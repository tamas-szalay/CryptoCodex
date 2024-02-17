import SwiftUI

struct CurrencyListCard: View {
    let action: () -> Void
    let currency: Currency
    
    var body: some View {
        Card(padding: .all(16)) {
            Button(action: action, label: {
                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: URL(string: currency.iconUrl)) { image in
                        image.image?.resizable().aspectRatio(contentMode: .fill)
                    }.frame(width: 56, height: 56)
                    VStack(alignment: .trailing) {
                        HStack(alignment: .bottom) {
                            Text(currency.name).font(.applicationBold(size: 20))
                            Spacer()
                            Text(NumberFormatter.priceFormat(currency.price)).font(.applicationBold(size: 16))
                        }
                        HStack(alignment: .bottom) {
                            Text(currency.symbol).font(.applicationRegular(size: 16))
                            Spacer()
                            PriceChangeText(priceChange: currency.changePercent24Hr)
                        }
                        Image("ArrowRight")
                    }
                    
                }
            }).foregroundColor(.fgDefault).buttonStyle(.borderless)
        }
    }

}

#Preview {
    Background {
        VStack(alignment: .center) {
            CurrencyListCard(
                action: {},
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
            ).padding()
        }
    }
    
}
