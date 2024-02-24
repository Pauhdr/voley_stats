import UniformTypeIdentifiers
import SwiftUI

extension String{
    func trad()->String{
        return Lang.dict[UserDefaults.standard.string(forKey: "locale") ?? "en"]![self.description] ?? self.description
    }
    func widthOfString(usingFont font: UIFont) -> CGFloat {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = self.size(withAttributes: fontAttributes)
            return size.width
        }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
