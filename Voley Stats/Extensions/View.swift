import SwiftUI

extension View {
    func toast(show: Binding<Bool>, _ toastView: Toast) -> some View {
        self.modifier(ToastModifier.init(show: show, toastView: toastView))
    }
    
    func dropdownOverlay(_ dropdown: Binding<Dropdown<Model>>) -> some View {
        self.overlay{
            if dropdown.wrappedValue.open{
                ScrollView{
                    VStack{
                        ForEach(dropdown.wrappedValue.options, id: \.id){ option in
                            HStack{
                                if dropdown.wrappedValue.selection.contains(option){
                                    Image(systemName: "checkmark")
                                }
                                Text(option.description)
                            }.padding().frame(maxWidth: .infinity, alignment: .leading)
                                .onTapGesture {
                                    if dropdown.wrappedValue.selection.contains(option){
                                        dropdown.wrappedValue.selection = dropdown.wrappedValue.selection.filter{$0 != option}
                                    }else{
                                        dropdown.wrappedValue.selection.append(option)
                                    }
                                }
                        }
                    }.padding().frame(maxWidth: .infinity, maxHeight: 300)
                }
                    .background(.black).clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
