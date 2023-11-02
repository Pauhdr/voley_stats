import SwiftUI

struct MultiPicker<Selectable: Descriptable>: View{
    var selection: Binding<Array<Selectable>>
    var items: [Selectable]
    var multi: Bool = true
    var placeholder:String
    
    @State var expanded:Bool = false
    var body: some View{
        VStack{
            HStack{
                Text(placeholder).frame(maxWidth: .infinity, alignment: .leading)
                if expanded {
                    Image(systemName: "chevron.down")
                } else {
                    Image(systemName: "chevron.right")
                }
            }.padding().background(Color.swatch.dark.high).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal).onTapGesture {
                withAnimation{
                    if !items.isEmpty{
                        expanded.toggle()
                    }
                }
            }
            if expanded{
                VStack{
                    ForEach(items, id:\.id){ item in
                        HStack{
                            Text(item.description).frame(maxWidth: .infinity, alignment: .leading)
                            //                                if selection.wrappedValue.contains(item){
                            //
                            //                                }
                        }
                    }
                }.padding().background(Color.swatch.dark.high).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)//.offset(y: 70)
            }
        }
                .foregroundStyle(items.isEmpty ? .gray : .white).zIndex(10)
    }
}

//struct MultiPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        MultiPicker(items: [], placeholder: "pick a match")
//    }
//}
