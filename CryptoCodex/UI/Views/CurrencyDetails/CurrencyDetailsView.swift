import SwiftUI

struct CurrencyDetailsView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        Background {
            
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
                NavigationTitle(text: "DETAILS")
            }
        
        }
        
    }
}

#Preview {
    CurrencyDetailsView()
}
