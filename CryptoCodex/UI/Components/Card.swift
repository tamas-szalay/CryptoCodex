
import SwiftUI

struct Card<Content> : View where Content : View  {
    let content: Content
    let padding: EdgeInsets
    
    init(padding: EdgeInsets, @ViewBuilder _ content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    
    var body: some View {
        content.padding(padding).background(.bgDefault.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 16), style: FillStyle())
    }
    
}

#Preview {
    Background {
        Card(padding: .all(20)) {
            Text("Text")
        }.padding()
    }
}
