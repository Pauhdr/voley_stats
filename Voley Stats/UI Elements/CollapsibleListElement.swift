import SwiftUI

struct CollapsibleListElement<Content: View>: View{
    @State var expanded: Bool = false
    @State var subviewHeight : CGFloat = 0
    var title: String
    @State var content: () -> Content
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15, style: .continuous).fill(.white.opacity(0.1)).shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
            VStack{
                HStack{
                    Text(title).font(.body.weight(.heavy))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action:{
                        withAnimation{
                            expanded.toggle()
                        }
                    }){
                        if expanded{
                            Image(systemName: "chevron.down")
                        }else{
                            Image(systemName: "chevron.right")
                        }
                        
                    }.foregroundColor(.white)
                }
                if expanded {
                    content()
                }
            }.padding()
        }
        .onTapGesture {
            withAnimation{
                expanded.toggle()
            }
        }
        .foregroundColor(.white)
        .background(GeometryReader {
            Color.clear.preference(key: ViewHeightKey.self,
                                   value: $0.frame(in: .local).size.height)
        })
        .onPreferenceChange(ViewHeightKey.self) { subviewHeight = $0 }
        .frame(height: expanded ? subviewHeight : 60, alignment: .top)
        .padding()
        .clipped()
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .bottom))
        
    }
}
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
//struct CollapsibleListElement_Previews: PreviewProvider {
//    static var previews: some View {
//        CollapsibleListElement(expanded: false, title: "General stats"){
//            HStack{
//                Text("now expanded")
//            }.padding()
//        }
//    }
//}
