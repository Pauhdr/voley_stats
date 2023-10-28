import SwiftUI

class SessionManager: ObservableObject {
    var isLoggedIn: Bool = false {
        didSet {
            rootId = UUID()
        }
    }
    
    @Published
    var rootId: UUID = UUID()
}
