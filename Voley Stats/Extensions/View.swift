import SwiftUI

extension View {
    func toast(show: Binding<Bool>, _ toastView: Toast) -> some View {
        self.modifier(ToastModifier.init(show: show, toastView: toastView))
    }
}
