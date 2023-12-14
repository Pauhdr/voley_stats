import SwiftUI
import UIPilot

struct MatchStats: View {
    @ObservedObject var viewModel: MatchStatsModel
    @Namespace var animation
    var body: some View {
        
        VStack {
            HStack{
                TabButton(selection: $viewModel.tab, title: "match".trad(), animation: animation, action: {
                    viewModel.selectedSet = nil
                    viewModel.stats = viewModel.match.stats()
                })
                ForEach(viewModel.match.sets(), id:\.id){ s in
                    if s.first_serve != 0{
                        TabButton(selection: $viewModel.tab, title: "Set \(s.number)", animation: animation, action: {
                            viewModel.selectedSet = s
                            viewModel.historical = false
                            viewModel.stats = s.stats()
                        })
                    }
                }
                
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
//            if viewModel.tab == "match".trad(){
//                Toggle(isOn: $viewModel.historical) {
//                    Text("stats.historical".trad())
//                }.padding().disabled(false)
//            }
            
                ScrollView{
                    CollapsibleListElement(expanded: true, title: "General"){
                        subviews["general", [], viewModel]
                    }
                    if viewModel.tab == "match".trad(){
                        CollapsibleListElement(expanded: false, title: "rotation".trad()){
                            subviews["rotation", [], viewModel]
                        }
                    }
                    ForEach(Array(actionsByType.keys).sorted(), id:\.self) {key in
                        let actions = actionsByType[key]
                        CollapsibleListElement(expanded: false, title: "\(key.trad().capitalized)"){
                            subviews[key, actions ?? [], viewModel]
                        }.foregroundColor(.white)
                    }
                }
            
            
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("\(viewModel.tab == "match".trad() ? "match.stats".trad() : "set.stats".trad())")
        
        //#-learning-task(createDetailView)
    }
    @ViewBuilder
    func matchStat() -> some View {
        
    }
    enum subviews {
        @ViewBuilder static subscript(string: String, actions:[Int], viewModel:MatchStatsModel) -> some View {
            
//            let stats =  viewModel.tab != "Match" ? viewModel.selectedSet?.stats() ?? viewModel.match.stats() : viewModel.match.stats()
            
            switch string {
            case "block":
                BlockTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: viewModel.historical)
            case "serve":
                ServeTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: viewModel.historical)
            case "dig":
                DigTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: viewModel.historical)
            case "fault":
                FaultTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: viewModel.historical)
            case "attack":
                AttackTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: viewModel.historical)
            case "set":
                SetTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: viewModel.historical)
            case "receive":
                ReceiveTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: viewModel.historical)
            case "free":
                FreeTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: false)
            case "downhit":
                DownBallTable(actions: actions , players: viewModel.team.players(), stats: viewModel.stats, historical: false)
            case "general":
                GeneralTable(stats: viewModel.stats, bests: viewModel.tab == "match".trad())
            case "rotation":
                RotationTable(match: viewModel.match)
            default:
                fatalError()
            }
        }
    }
}


class MatchStatsModel: ObservableObject{
    @Published var sourceMatch:Bool = false
    @Published var tab: String = "match".trad()
    @Published var selectedSet: Set? = nil
    @Published var historical: Bool = false
    var stats: [Stat]
    var match: Match
    var team: Team
    init(team: Team, match: Match){
        self.match = match
        self.team = team
        self.stats = match.stats()
    }
}


