import SwiftUI

class PathManager: ObservableObject{
    var path: NavigationPath
    
    init(){
        path = NavigationPath()
    }
}
