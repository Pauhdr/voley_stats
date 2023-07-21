import SwiftUI

struct TabButton: View{
    @Binding var selection: String
    var title: String
    var animation:Namespace.ID
    var action: () -> Void
    var body: some View{
        Button(action:{
            withAnimation(.spring()){
                selection=title
                action()
            }
        }){
            ZStack{
//                Capsule()
                    RoundedRectangle(cornerRadius: 7).fill(.clear).frame(height: 30)
                if selection == title{
//                    Capsule()
                    RoundedRectangle(cornerRadius: 7).fill(Color.swatch.cyan.base).frame(height: 30)
                        .matchedGeometryEffect(id: "tab", in: animation)
                }
                Text(title.trad())
//                    .foregroundColor(selection == title ? .black : .white)
                    .fontWeight(selection == title ? .bold : .regular).padding(.horizontal, 3)
            }
        }.frame(minWidth: CGFloat(integerLiteral: title.count)*15)
    }
}

//struct TabButton_Previews: PreviewProvider {
//    static var previews: some View {
////        TabButton(selection: $tab, title: "hey", animation:anim)
////        TabButton(selection: tab, title: "hey2", animation:anim)
//        Text("no preview")
//    }
//}
