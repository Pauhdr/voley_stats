import SwiftUI

struct TextFieldPlus: TextFieldStyle {
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, style: StrokeStyle(dash: [5]))
                .frame(height: 40)
            
            HStack {
                Image(systemName: "plus")
//                    .frame(maxWidth: .infinity, alignment: .center)
                // Reference the TextField here
                configuration
            }
            .padding(.leading)
            
            .foregroundColor(.gray)
        }
    }
}

struct TextFieldDark: TextFieldStyle {
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity(0.1))
                .frame(height: 40)
            
            configuration
            .padding()
            .foregroundColor(.white)
        }
    }
}

extension TextEditor{
    func customBackground(_ content: Color) -> some View{
        if #available(iOS 16.0, *){
            return self.scrollContentBackground(.hidden).padding().background(content)
        }
        UITextView.appearance().backgroundColor = .clear
        return self.padding().background(content)
    }
}
