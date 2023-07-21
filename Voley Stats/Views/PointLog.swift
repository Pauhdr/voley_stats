import SwiftUI
import UIPilot

struct PointLog: View {
    @ObservedObject var viewModel: PointLogModel
    var body: some View {
        VStack {
//            Text("point.log".trad()).font(.title.bold())
            Toggle("show.finals".trad(), isOn: $viewModel.finals).padding().tint(.cyan)
//                RoundedRectangle(cornerRadius: 25, style: .continuous).fill(.thinMaterial)
                VStack{
                    ZStack{
//                        Capsule()
                        RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.3))
                        LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 50)), count: 7), spacing: 20){
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
                }.background(RoundedRectangle(cornerRadius: 25).fill(.white.opacity(0.1)))
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
    var set:Set
    init(set: Set){
        self.set = set
    }
    func obtainLog(){
        fullLog = set.stats()
        finalsLog = set.stats().filter{s in return s.to != 0}
    }
}


