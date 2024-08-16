import SwiftUI

struct DirectionsGraph: View{
    @ObservedObject var viewModel: DirectionsGraphModel
    var rect: some View = Rectangle().fill(.orange)
    
    var body: some View{
        VStack{
            let height = viewModel.height
            let width = viewModel.width
            ZStack{
                VStack(spacing: 0){
//                        HStack{
//                            Rectangle().fill(viewModel.isServe ? .orange : .gray)
//                            Rectangle().fill(viewModel.isServe ? .orange : .gray)
//                            Rectangle().fill(viewModel.isServe ? .orange : .gray)
//                        }.frame(width: width, height: height*0.1)
                    if !viewModel.heatmap{
                        ZStack(alignment: .top){
                            
                            VStack(spacing: 0){
                                HStack(spacing: 3){
                                    rect //Rectangle().fill(viewModel.isServe ? .gray : .orange)
                                    rect //Rectangle().fill(viewModel.isServe ? .gray : .orange)
                                    rect //Rectangle().fill(viewModel.isServe ? .gray : .orange)
                                }.frame(width: width,height: height/3)
                                HStack(spacing: 3){
                                    rect //Rectangle().fill(viewModel.isServe ? .gray : .orange)
                                    rect //Rectangle().fill(viewModel.isServe ? .gray : .orange)
                                    rect //Rectangle().fill(viewModel.isServe ? .gray : .orange)
                                }.frame(width: width,height: height/6)
                            }
                            //                            VStack{
                            Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/2)
                            Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/3)
                            //                            }
                        }//.padding(.bottom)
                    }
                    let rows = [[4,3,2],[7,8,9],[5,6,1]]
                    ZStack(alignment: .bottom){
                        VStack(spacing: 0){
                            ForEach(Array(zip(rows.indices, rows)), id:\.0){idy, row in
                                HStack(spacing: 3){
                                    ForEach(Array(zip(row.indices, row)), id:\.0){idx, pos in
                                        
                                        VStack(spacing: 0){
                                            HStack(spacing: 0){
                                                let a = viewModel.stats.filter{s in s.0.contains("\(pos)A")}.first?.1 ?? 0
                                                let b = viewModel.stats.filter{s in s.0.contains("\(pos)B")}.first?.1 ?? 0
                                                rect.overlay(viewModel.heatmap ? Rectangle().fill(.red.opacity(Double(a/viewModel.max))) : nil)//.overlay{Text("A").foregroundStyle(.white)}
                                                rect.overlay(viewModel.heatmap ? Rectangle().fill(.red.opacity(Double(b/viewModel.max))) : nil)//.overlay{Text("B").foregroundStyle(.white)}
                                            }
                                            HStack(spacing: 0){
                                                let c = viewModel.stats.filter{s in s.0.contains("\(pos)C")}.first?.1 ?? 0
                                                let d = viewModel.stats.filter{s in s.0.contains("\(pos)D")}.first?.1 ?? 0
                                                rect.overlay(viewModel.heatmap ? Rectangle().fill(.red.opacity(Double(d/viewModel.max))) : nil)//.overlay{Text("D").foregroundStyle(.white)}
                                                rect.overlay(viewModel.heatmap ? Rectangle().fill(.red.opacity(Double(c/viewModel.max))) : nil)//.overlay{Text("C").foregroundStyle(.white)}
                                            }
                                        }//.overlay{Text("\(pos)").font(.title2).foregroundStyle(.white)}
                                    }
                                }.frame(width: width,height: height/6)
                            }
                        }
//                        Rectangle().stroke(.black, lineWidth: 3).frame(width: width, height: height/6)
                        Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/2)
                        Rectangle().stroke(.black, lineWidth: 7).frame(width: width, height: height/3)
                    }
                }.frame(maxWidth: .infinity, alignment: .center)//.background(.red)
                
                ForEach(viewModel.stats, id:\.0){dir in
                    let coord = viewModel.getCoords(direction: dir.0)
                    Path{path in
                        path.move(to: CGPoint(x: coord.0.0, y: coord.0.1))
                        path.addLine(to: CGPoint(x: coord.1.0, y: coord.1.1))
                    }.stroke(.red, style: StrokeStyle(lineWidth: CGFloat((dir.1*7)/viewModel.max), lineCap: .round))
//                    .stroke(.red, lineWidth: CGFloat((dir.1*7)/viewModel.max))
                }
                
                
            }
        }.frame(width: viewModel.width, height: viewModel.heatmap ? viewModel.height/2 : viewModel.height)
        
    }
}

class DirectionsGraphModel: ObservableObject{
    var numberPlayers: Int = 6
    var isServe: Bool = true
    var stats: [(String, Int)]
    var width: CGFloat
    var height: CGFloat
    var max: Int
    var heatmap: Bool
    
    init(stats: [String], isServe: Bool, heatmap: Bool, numberPlayers: Int, width: CGFloat, height: CGFloat){
//        let st = stats.filter{$0.direction != ""}.map{$0.direction}
        self.isServe = isServe
        self.numberPlayers = numberPlayers
        self.width = width
        self.height = height
        self.heatmap = heatmap
        if heatmap {
            self.stats = stats.filter{$0.contains("#")}.map{String($0.split(separator: "#")[1])}.map{s in (s, stats.filter{$0 == s}.count)}
        }else{
            self.stats = stats.filter{$0.contains("#")}.map{s in (s, stats.filter{$0 == s}.count)}
        }
        self.max = self.stats.max{a, b in a.1 < b.1}?.1 ?? 1
    }
    
    func getCoords(direction: String)->((Int, Int), (Int, Int)){
        var dest = ((0,0), (0,0))
        let codes = direction.split(separator: "#")
        let from = Int(codes[0])
        let to = codes[1].first!
        let subTo = codes[1].last!
        
        switch from {
        case 1:
            dest.0 = (Int(width/6), Int(width/3))
        case 2:
            dest.0 = (Int(width/6), Int(5*width/6))
        case 3:
            dest.0 = (Int(width/2), Int(5*width/6))
        case 4:
            dest.0 = (Int(5*width/6), Int(5*width/6))
        case 5:
            dest.0 = (Int(5*width/6), Int(width/3))
        case 6:
            dest.0 = (Int(width/2), Int(width/3))
        default:
            dest.0 = (0, 0)
        }
        
        switch to{
        case "1":
            dest.1 = (Int(5*width/6), Int(5*width/3))
        case "2":
            dest.1 = (Int(5*width/6), Int(width/6))
        case "3":
            dest.1 = (Int(width/2), Int(width/6))
        case "4":
            dest.1 = (Int(width/6), Int(width/6))
        case "5":
            dest.1 = (Int(width/6), Int(5*width/3))
        case "6":
            dest.1 = (Int(width/2), Int(5*width/3))
        case "7":
            dest.1 = (Int(width/6), Int(width/2))
        case "8":
            dest.1 = (Int(width/2), Int(width/2))
        case "9":
            dest.1 = (Int(5*width/6), Int(width/2))
        default:
            dest.1 = (0, 0)
        }
        
        switch subTo{
        case "A":
            dest.1.0 -= Int(width/12)
            dest.1.1 -= Int(width/12)
        case "B":
            dest.1.0 += Int(width/12)
            dest.1.1 -= Int(width/12)
        case "C":
            dest.1.0 += Int(width/12)
            dest.1.1 += Int(width/12)
        case "D":
            dest.1.0 -= Int(width/12)
            dest.1.1 += Int(width/12)
            
        default:
            dest.1 = (0, 0)
        }
        
        if (self.isServe){
            dest.0.1 = 0
        }
        
        dest.1.1 += Int(height/2)
        
        return dest
    }
    
}

//struct Court_Previews: PreviewProvider {
//
//    static var previews: some View {
//        DirectionsCourt(viewModel: DirectionsCourtModel())
//    }
//}
