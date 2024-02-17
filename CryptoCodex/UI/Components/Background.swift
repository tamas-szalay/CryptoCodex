

import SwiftUI

struct Background<Content> : View where Content : View  {
    let content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.gradientStart.opacity(0.3), .gradientEnd.opacity(0.3)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            content
        }.toolbarBackground(.hidden, for: .navigationBar).background(.bgDefault)
    }
    
}

#Preview {
    Background {
        
    }
}
