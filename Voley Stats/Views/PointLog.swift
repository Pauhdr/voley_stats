import SwiftUI
import UIPilot
import Charts

struct PointLog: View {
    @ObservedObject var viewModel: PointLogModel
    @State var height: CGFloat = 0
//    var x = 0
    var body: some View {
        VStack {
//            Text("point.log".trad()).font(.title.bold())
            Toggle("show.game.graph".trad(), isOn: $viewModel.gameGraph).padding().tint(.cyan)
//                RoundedRectangle(cornerRadius: 25, style: .continuous).fill(.thinMaterial)
            if viewModel.gameGraph {
                VStack{
                    HStack{
                        Text("player".trad()).frame(width: 50, alignment: .center)
                        Text("to".trad()).frame(width: 50, alignment: .center)
                        Text("action".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Text("them".trad()).frame(width: 200, alignment: .center)
                        Text("us".trad()).frame(width: 200, alignment: .center)
                        
                    }.padding().background(.white.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 15))
                    ScrollView{
                        ForEach(viewModel.finalsLog, id: \.id){stat in
                            let diff = stat.score_us - stat.score_them
                            HStack{
                                Text("\(stat.to == 1 ? "+" : "-")").foregroundStyle(stat.to == 1 ? .blue : .red).frame(width: 50, alignment: .center)
                                Text("\(Player.find(id: stat.player)?.number ?? 0)").frame(width: 50, alignment: .center)
                                Text("\(Action.find(id: stat.action)?.name.trad() ?? "error")").frame(maxWidth: .infinity, alignment: .leading)
                                HStack{
                                    if diff < 0{
                                        RoundedRectangle(cornerRadius: 8).fill(.red).frame(width: CGFloat(abs(diff)*200/25), height: 20)
                                    }
                                }.frame(width:200, alignment: .trailing)
                                Divider().overlay(.white)
                                HStack{
                                    if diff > 0{
                                        RoundedRectangle(cornerRadius: 8).fill(.green).frame(width: CGFloat(abs(diff)*200/25), height: 20)
                                    }
                                }.frame(width: 200, alignment: .leading)
                            }
                        }
                    }
                }.background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
//                VStack{
////                    HStack{
////                        Divider().overlay(.white).frame(width: 500)
////                    }.frame(maxWidth: .infinity, alignment: .trailing)
//                    HStack{
//                        Text("player".trad())
//                        Text("to".trad())
//                        Text("action".trad())//.frame(maxWidth: .infinity, alignment: .leading)
//                        Text("us".trad()).frame(maxWidth: .infinity, alignment: viewModel.mid < 0 ? .leading : .center)
//                        Text("them".trad()).frame(maxWidth: .infinity, alignment: viewModel.mid > 0 ? .trailing : .center)
////                        ZStack{}.frame(width: 500)
//                    }.padding().background(.white.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 15))
//                    VStack{
//                        //                        gameGraph()
//                        
//                        ScrollView{
//                            ForEach(0..<viewModel.gameGraphData.count, id:\.self){i in
//                                let stat = viewModel.gameGraphData[i]
//                                HStack{
//                                    Text("\(stat.0)").frame(width: 30)
//                                    Text(stat.2 == 1 ? "+" : "-").foregroundStyle(stat.2 == 1 ? .blue : .red).frame(width: 20)
//                                    Text(stat.1).frame(maxWidth: .infinity, alignment: .leading)
//                                    ZStack{}.frame(width: 500)
//                                }.overlay(Image(systemName: "line.diagonal").scaleEffect(x: stat.2 == 1 ? 1.5 : -1.5, y: 1.5).offset(x: stat.3))
//                            }
//                        }
//                    }.overlay(HStack{Divider().overlay(.white).offset(x: viewModel.mid)}).padding()
//                }.background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
            }else{
                VStack{
                    ZStack{
                        //                        Capsule()
                        RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.3))
                        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50)), count: 8), spacing: 20){
                            Text("order".trad())
                            Text("stage".trad())
                            Text("server".trad())
                            Text("player".trad())
                            Text("action.type".trad())
                            Text("action".trad())
                            Text("point.to".trad())
                            Text("score".trad())
                        }.padding()
                    }.clipped().frame(maxHeight: 20).padding(.vertical)
                    ScrollView {
                        ForEach(viewModel.finals ? viewModel.finalsLog : viewModel.fullLog, id:\.id){ stat in
                            if(stat.action == 0){
                                HStack(spacing: 20){
                                    Text("time.out.by".trad()+(stat.to == 1 ? "us".trad() : "them".trad()))
                                }.frame(maxWidth: .infinity, alignment: .center).background(.gray).padding(.horizontal)
                            }else if (stat.action == 99){
                                HStack(spacing: 20){
                                    Text("change.player".trad())
                                    Image(systemName: "arrow.up.circle.fill").foregroundColor(.red)
                                    Text("\(Player.find(id: stat.player_in ?? 0)?.name ?? "")")
                                    Image(systemName: "arrow.down.circle.fill").foregroundColor(.green)
                                    Text("\(Player.find(id: stat.player)?.name ?? "")")
                                }.frame(maxWidth: .infinity, alignment: .center).background(.gray).padding(.horizontal)
                            }else if (stat.action == 98){
                                HStack(spacing: 20){
                                    Text("score.adjust".trad())
                                    //                                    Text("\(Player.find(id: stat.player_in!)?.name ?? "")")
                                    //                                    Image(systemName: "arrowshape.right.fill")
                                    //                                    Text("\(Player.find(id: stat.player)?.name ?? "")")
                                }.frame(maxWidth: .infinity, alignment: .center).background(.gray).padding(.horizontal)
                            }else{
                                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50)), count: 7), spacing: 20){
                                    let action = Action.find(id: stat.action)!
                                    Text("\(stat.order)")
                                    Text("\(stat.stage == 0 ? "serve".trad().capitalized : "receive".trad().capitalized)")
                                    Text("\(stat.server == 0 ? "their.player".trad() : Player.find(id: stat.server)?.name ?? "")")
                                    Text("\(stat.player == 0 ? "their.player".trad() : Player.find(id: stat.player)?.name ?? "")")
                                    Text("\(action.getType().trad().capitalized)")
                                    Text("\(action.name.trad())\(stat.detail != "" ? " ["+stat.detail.lowercased().trad()+"]" : "")")
                                    Text("\(stat.to == 0 ? "none".trad() : stat.to == 1 ? "us".trad() : "them".trad())").foregroundColor(stat.to == 0 ? .gray : stat.to == 1 ? .blue : .red)
                                    Text("\(stat.score_us)-\(stat.score_them)")
                                    
                                }
                            }
                        }
                    }
                }.background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
            }
        }
        .onAppear{
            viewModel.obtainLog()
        }.padding()
            .background(Color.swatch.dark.high)
            .navigationTitle("point.log".trad())
        
    }
}
class PointLogModel: ObservableObject{
    @Published var fullLog: [Stat] = []
    @Published var finalsLog: [Stat] = []
    @Published var finals:Bool = false
    @Published var gameGraph:Bool = false
    @Published var gameGraphData:[(Int, String, Int, CGFloat)] = []
    var x:CGFloat = 0
    var mid:CGFloat = 0
    var set:Set
    init(set: Set, gameGraph: Bool = false){
        self.set = set
        self.gameGraph = gameGraph
    }
    func obtainLog(){
        fullLog = set.stats()
        var order = 1.0
        fullLog.forEach{s in
            if s.order == 0 && s != fullLog.first{
                s.order = order
                if s.update(){
                    order += 1
                }
            }
        }
        finalsLog = set.stats().filter{s in return s.to != 0 && ![98, 99, 0].contains(s.action)}
//        print(finalsLog.map{$0.description})
    }
    
//    func incrementX(_ by: Int){
//        print(by)
//        self.x += by
//    }
//    func decrementX(_ by: Int){
//        self.x -= by
//    }
}


