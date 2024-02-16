import SwiftUI

struct CurrencyListView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        VStack(alignment: .center) {
            Button {
                router.navigateTo(.currencyDetails)
            } label: {
                Text("Details")
            }

        }

    }
}

#Preview {
    CurrencyListView()
}
