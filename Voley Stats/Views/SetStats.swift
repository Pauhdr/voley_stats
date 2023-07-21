import SwiftUI
import UIPilot

struct SetStats: View {
    @ObservedObject var viewModel: SetStatsModel
    @Namespace var animation
    var body: some View {
        
        VStack {
//            Text("\(viewModel.tab.lowercased()).stats".trad()).font(.title.bold())
            HStack{
                TabButton(selection: $viewModel.tab, title: "match", animation: animation, action:{})
                TabButton(selection: $viewModel.tab, title: "Set", animation: animation, action:{})
                //                ForEach(viewModel.match.sets(), id:\.id){ set in
                //                    TabButton(selection: $viewModel.tab, title: "Set \(set.number)", animation: animation)
                //                }
                
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
            ScrollView{
                CollapsibleListElement(expanded: true, title: "General"){
                    subviews["general", [], viewModel]
                }
                ForEach(Array(actionsByType.keys).sorted(), id:\.self) {key in
                    let actions = actionsByType[key]
                    CollapsibleListElement(expanded: false, title: "\(key.trad().capitalized)"){
                        subviews[key, actions ?? [], viewModel]
                    }
                }
            }
            
        }.background(Color.swatch.dark.high)
            .navigationTitle("\(viewModel.tab.lowercased()).stats".trad())
        
        //#-learning-task(createDetailView)
    }
    enum subviews {
        @ViewBuilder static subscript(string: String, actions:[Int], viewModel:SetStatsModel) -> some View {
            let stats = viewModel.tab == "Set" ? viewModel.set.stats() : viewModel.match.stats()
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
            default:
                fatalError()
            }
        }
    }
}


class SetStatsModel: ObservableObject{
    @Published var sourceMatch:Bool = false
    @Published var tab: String = "Set"
    var match: Match
    var set: Set
    var team: Team
    init(team: Team, match: Match, set: Set){
        self.match = match
        self.set = set
        self.team = team
    }
}


