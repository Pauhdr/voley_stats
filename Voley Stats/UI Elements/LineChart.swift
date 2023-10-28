import SwiftUI

struct LineChartView: View {
    var title: String
  var dataPoints: [(Color, [Double], String)]
//    var labels: [String]
//  var lineColor: Color = .red
//  var outerCircleColor: Color = .red
//  var innerCircleColor: Color = .white
    var highestPoint: Double {
        let max = dataPoints.flatMap{$0.1}.max() ?? 1.0
      if max == 0 { return 1.0 }
      return max
    }
  var body: some View {
      VStack{
          Text(title.trad()).font(.headline).padding(.vertical)
          Divider().overlay(.white.opacity(0.6))
          HStack{
              VStack{
                  Text("\(String(format: "%.2f", highestPoint))").frame(maxHeight: .infinity, alignment: .top)
                  Text("\(String(format: "%.2f", highestPoint/2))")
                  Text("0").frame(maxHeight: .infinity, alignment: .bottom)
              }.padding().font(.caption)
              ZStack {
                  ForEach(dataPoints, id:\.0){data in
                      if !data.1.isEmpty {
                          LineView(dataPoints: data.1, highestPoint: highestPoint)
                              .accentColor(data.0)
//                          LineChartCircleView(dataPoints: data.1, radius: 1.0, highestPoint: highestPoint)
//                              .accentColor(data.0)
                      }
                  }
                  
                  
                  //      LineChartCircleView(dataPoints: dataPoints, radius: 3.0)
                  //        .accentColor(outerCircleColor)
                  //
                                
              }.frame(height: 200)
          }.frame(maxHeight: .infinity)
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
          .background(Color.white.opacity(0.1).cornerRadius(16))
          .padding()
  }
}


struct LineView: View {
  var dataPoints: [Double]
//    var labels: [String]
  var highestPoint: Double

  var body: some View {
      
          GeometryReader { geometry in
              let height = geometry.size.height
              let width = geometry.size.width
              
              Path { path in
                  path.move(to: CGPoint(x: 0, y: height * self.ratio(for: 0)))
                  for index in 1..<dataPoints.count {
                      
                      path.addLine(to: CGPoint(
                        x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
                        y: height * self.ratio(for: index)))
//                      Text(labels[index-1])
                      
                  }
              }
              .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
              
          }
          .padding(.vertical)
      
  }

  private func ratio(for index: Int) -> Double {
    1 - (dataPoints[index] / highestPoint)
  }
}

struct LineChartCircleView: View {
  var dataPoints: [Double]
  var radius: CGFloat

  var highestPoint: Double

  var body: some View {
    GeometryReader { geometry in
      let height = geometry.size.height
      let width = geometry.size.width

      Path { path in
//        path.move(to: CGPoint(x: 0, y: (height * self.ratio(for: 0)) - radius))

        path.addArc(center: CGPoint(x: 0, y: height * self.ratio(for: 0)),
                    radius: radius, startAngle: .zero,
                    endAngle: .degrees(360.0), clockwise: false)

        for index in 1..<dataPoints.count {
//          path.move(to: CGPoint(
//            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
//            y: height * dataPoints[index] / highestPoint))

          path.addArc(center: CGPoint(
            x: CGFloat(index) * width / CGFloat(dataPoints.count - 1),
            y: height * self.ratio(for: index)),
                      radius: radius, startAngle: .zero,
                      endAngle: .degrees(360.0), clockwise: false)
        }
      }
      .stroke(Color.accentColor, lineWidth: 4)
    }
    .padding(.vertical)
  }

  private func ratio(for index: Int) -> Double {
    1 - (dataPoints[index] / highestPoint)
  }
}
