import SwiftUI

extension Color : Equatable {
    static func ==(lhs: Color, rhs: Color) -> Bool {
        return lhs.toHex() == rhs.toHex()
    }
    
    struct swatch{
        struct blue{
            static let base = Color.blue
        }
        struct red{
            static let base = Color.red
        }
        struct green{
            static let base = Color.green
        }
        struct orange{
            static let base = Color.orange
        }
        struct yellow{
            static let base = Color(hex: "f2ac0a") ?? .yellow
        }
        struct purple{
            static let base = Color(hex: "6D0C74") ?? Color.purple
        }
        struct pink{
            static let base = Color.pink
        }
        struct gray{
            static let base = Color.gray
        }
        struct dark{
            static let high = Color(hex:"0F1919") ?? Color.black
            static let mid = Color(hex:"1F3333") ?? Color.black
            static let low = Color(hex:"3b4e4e") ?? Color.black
        }
        struct cyan{
            static let light = Color(hex:"99FEFF") ?? Color.cyan
            static let base = Color.cyan
        }
        struct gradient{
            static let purpleBlue = LinearGradient(colors: [
                Color(hex: "6D0C74") ?? .purple,
                Color(hex:"B983FF") ?? .purple,
                Color(hex:"94B3FD") ?? .blue,
                Color(hex:"99FEFF") ?? .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            static let orangeYellow = LinearGradient(colors: [
                Color(hex: "FF8D29") ?? .orange,
                Color(hex:"FEB139") ?? .orange,
                Color(hex:"FFCD38") ?? .yellow,
                Color(hex:"FFE26F") ?? .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
            static let blueGreen = LinearGradient(colors: [
                Color(hex: "002B5B") ?? .blue,
                Color(hex:"2B4865") ?? .blue,
                Color(hex:"256D85") ?? .green,
                Color(hex:"8FE3CF") ?? .green], startPoint: .topLeading, endPoint: .bottomTrailing)
            static let greenYellow = LinearGradient(colors: [
                Color(hex: "217756") ?? .green,
                Color(hex:"63B75D") ?? .green,
                Color(hex:"B0D553") ?? .yellow,
                Color(hex:"FCED25") ?? .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
            static let redWhite = LinearGradient(colors: [
                Color(hex: "740021") ?? .red,
                Color(hex:"8D0033") ?? .red,
                Color(hex:"BD3246") ?? .white,
                Color(hex:"FDC8AA") ?? .white], startPoint: .topLeading, endPoint: .bottomTrailing)
            static let gray = LinearGradient(colors: [Color(hex: "6C7A89") ?? .gray, Color(hex: "E0E7E9") ?? .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
            static let all = [purpleBlue, orangeYellow, blueGreen, greenYellow, redWhite]
        }
    }
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
