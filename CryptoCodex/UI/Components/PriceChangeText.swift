import SwiftUI

struct PriceChangeText: View  {
    let priceChange: Decimal
    
    
    var body: some View {
        Text(NumberFormatter.changePercentFormat(priceChange))
            .font(.applicationBold(size: 16))
            .foregroundStyle(priceChange > 0 ? .fgPositive : .fgNegative)
    }
    
}
