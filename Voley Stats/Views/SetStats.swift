import SwiftUI
import UIPilot

struct SetStats: View {
    @ObservedObject var viewModel: SetStatsModel
    @Namespace var animation
    var body: some View {
        
        VStack {
//            Text("\(viewModel.tab.lowercased()).stats".trad()).font(.title.bold())
            HStack{
                TabButton(selection: $viewModel.tab, title: "match".trad(), animation: animation, action:{})
//                TabButton(selection: $viewModel.tab, title: "Set", animation: animation, action:{})
                ForEach(viewModel.match.sets(), id:\.id){ set in
                    if set.first_serve != 0{
                        TabButton(selection: $viewModel.tab, title: "Set \(set.number)", animation: animation, action: {
                            viewModel.selectedSet = set
                        })
                    }
                }
                
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
            ScrollView{
                VStack{
                    CollapsibleListElement(expanded: true, title: "General"){
                        subviews["general", [], viewModel]
                    }
//                    BannerView().frame(maxWidth: .infinity).padding(.vertical)
                    if viewModel.tab == "match".trad(){
                        CollapsibleListElement(expanded: false, title: "rotation".trad()){
                            subviews["rotation", [], viewModel]
                        }
                    }
                    ForEach(Array(actionsByType.keys.enumerated()).sorted(by: {$0.element < $1.element}), id:\.offset) {index, key in
                        let actions = actionsByType[key]
                        VStack{
//                            print(index, index%2)
//                            Text("\(index), \(index%2)")
                            if index % 2 == 0{
                                VStack{
                                    BannerView().frame(width: 500, height: 60).padding(.vertical)
                                }
                            }
                            VStack{
                                CollapsibleListElement(expanded: false, title: "\(key.trad().capitalized)"){
                                    subviews[key, actions ?? [], viewModel]
                                }
                            }
                        }
                    }
//                    BannerView().frame(maxWidth: .infinity).padding(.vertical)
                }
            }
            
        }.background(Color.swatch.dark.high)
            .navigationTitle("set.stats".trad())
        
        //#-learning-task(createDetailView)
    }
    enum subviews {
        @ViewBuilder static subscript(string: String, actions:[Int], viewModel:SetStatsModel) -> some View {
            let stats = viewModel.tab.contains("Set") ? viewModel.selectedSet.stats() : viewModel.match.stats()
            switch string {
            case "block":
                BlockTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "serve":
                ServeTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "dig":
                DigTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "fault":
                FaultTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "attack":
                AttackTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "set":
                SetTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "receive":
                ReceiveTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "free":
                FreeTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "downhit":
                DownBallTable(actions: actions , players: viewModel.team.players(), stats: stats, historical: false)
            case "general":
                GeneralTable(stats: stats, bests: viewModel.tab == "match".trad())
            case "rotation":
                RotationTable(match: viewModel.match)
            default:
                fatalError()
            }
        }
    }
}


class SetStatsModel: ObservableObject{
    @Published var sourceMatch:Bool = false
    @Published var tab: String
    @Published var selectedSet: Set
    var match: Match
    var set: Set
    var team: Team
    init(team: Team, match: Match, set: Set){
        self.match = match
        self.set = set
        self.team = team
        self.selectedSet = set
        self.tab = "Set \(set.number)"
    }
}


