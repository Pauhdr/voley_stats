import SwiftUI
import Charts

struct LineChartView: View {
    var title: String
    var dataPoints: [(Color, [(Date, Double)], String)]
//    var labels: [String]
//  var lineColor: Color = .red
//  var outerCircleColor: Color = .red
//  var innerCircleColor: Color = .white
//    var highestPoint: Double {
//        let max = dataPoints.flatMap{$0.1}.max() ?? 1.0
//      if max == 0 { return 1.0 }
//      return max
//    }
  var body: some View {
      VStack{
          Text(title.trad()).font(.headline).padding(.vertical)
          Divider().overlay(.white.opacity(0.6))
          Chart{
              ForEach(dataPoints, id:\.0){dp in
                  ForEach(dp.1, id: \.0){point in
                      LineMark(x: .value("Date", point.0.formatted(.dateTime.day().month())), y: .value("Data", point.1), series: .value(dp.2, dp.2.trad()))
                          .foregroundStyle(dp.0)
                  }
              }
          }.padding()
          Divider()
          HStack{
              
              ForEach(dataPoints, id:\.0){data in
                  HStack{
                      Circle().fill(data.0).frame(width: 15, height: 15)
                      Text(data.2.trad())
                  }.padding(.horizontal)
              }
              
          }.padding(.vertical)
//          GeometryReader { geometry in
//              let height = geometry.size.height
//              let width = geometry.size.width
//              HStack{
//                  ForEach(1..<labels.count) {index in
//                      Text(labels[index-1]).position(CGPoint(x: CGFloat(index) * width / CGFloat(dataPoints.count - 1), y: 0))
//                  }
//              }
//          }
      }
        .padding(4)
          .background(Color.white.opacity(0.1).cornerRadius(15))
          .padding()
  }
}


//struct LineView: View {
//  var dataPoints: [Double]
////    var labels: [String]
//  var highestPoint: Double
//
//  var body: some View {
//      
//          GeometryReader { geometry in
//              let height = geometry.size.height
//              let width = geometry.size.width
//              
//              Path { path in
//                  path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))
//                  for index in 1..<dataPoints.count {
//                      
//                      path.addLine(to: CGPoint(
//                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
//                        y: height * self.ratio(for: index)))
////                      Text(labels[index-1])
//                      
//                  }
//              }
//              .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
//              
//          }
//          .padding(.vertical)
//      
//  }
//
//  private func ratio(for index: Int) -> Double {
//    1 - (dataPoints[index] / highestPoint)
//  }
//}
//
//struct LineChartCircleView: View {
//  var dataPoints: [Double]
//  var radius: CGFloat
//
//  var highestPoint: Double
//
//  var body: some View {
//    GeometryReader { geometry in
//      let height = geometry.size.height
//      let width = geometry.size.width
//
//      Path { path in
////        path.move(to: CGPoint(x: 0, y: (height * self.ratio(for: 0)) - radius))
//
//        path.addArc(center: CGPoint(x: 0, y: height * self.ratio(for: 0)),
//                    radius: radius, startAngle: .zero,
//                    endAngle: .degrees(360.0), clockwise: false)
//
//        for index in 1..<dataPoints.count {
////          path.move(to: CGPoint(
////            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
////            y: height * dataPoints[index] / highestPoint))
//
//          path.addArc(center: CGPoint(
//            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
//            y: height * self.ratio(for: index)),
//                      radius: radius, startAngle: .zero,
//                      endAngle: .degrees(360.0), clockwise: false)
//        }
//      }
//      .stroke(Color.accentColor, lineWidth: 4)
//    }
//    .padding(.vertical)
//  }
//
//  private func ratio(for index: Int) -> Double {
//    1 - (dataPoints[index] / highestPoint)
//  }
//}
