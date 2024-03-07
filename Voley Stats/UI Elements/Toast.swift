//
//  Toast.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 7/11/23.
//

import SwiftUI

enum ToastType {
    case error
    case success
    case warning
    case info
}


struct Toast: View {
    @Binding var show: Bool
    var type: ToastType
    var message: String
    
    var body: some View {
        VStack{
            
            HStack{
                let styles = getStyles()
                Image(systemName: styles.0).foregroundStyle(styles.1)
                Text(message)
            }
            .foregroundColor(.white)
            .padding([.top,.bottom],20)
            .padding([.leading,.trailing],40)
            .background(.black)
            .clipShape(Capsule())
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width / 1.25)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.show = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            self.show = false
                        }
                    }
                })
    }
    
    func getStyles() -> (String, Color){
        var name = ("question.mark", Color.gray)
        switch type {
            case .error:
            name = ("multiply.circle", Color.red)
            case .success:
            name = ("checkmark.circle", Color.green)
            case .warning:
            name = ("warning", Color.yellow)
            case .info:
            name = ("i.circle", Color.blue)
        }
        return name
    }
}

struct ToastModifier : ViewModifier {
    @Binding var show: Bool
    
    let toastView: Toast
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                toastView
            }
        }
    }
}
