import SwiftUI

struct ProgressBar: View{
    var label:String
    var value:Float
    var max: Double
    var width: CGFloat
    var body: some View{
        VStack{
            Text(label)
            ZStack{
                RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
                RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.5)).frame(width: (Double(value)*Double(width))/max)
            }.frame(width: width, height: 25)
        }
    }
}
