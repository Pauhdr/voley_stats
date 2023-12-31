import SwiftUI
import UIPilot
import QuickLook

struct MultiMatchStats: View {
    @ObservedObject var viewModel: MultiMatchStatsModel
    @Namespace var animation
    
    var body: some View {
        
        VStack {
            HStack{
                Text("PDF")
                    .onTapGesture {
                        viewModel.url = PDF().multiMatchReport(team: viewModel.team, matches: viewModel.matches).generate()
                    }
                    .quickLookPreview($viewModel.url)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
            }
            GeometryReader { g in
                ScrollView(.horizontal, showsIndicators: false) {
                
                
                    HStack{
                        TabButton(selection: $viewModel.tab, title: "general".trad(), animation: animation, action: {
                            viewModel.match = nil
                        })
                        ForEach(viewModel.matches, id:\.id){ s in
                            TabButton(selection: $viewModel.tab, title: "\(s.opponent)", animation: animation, action: {
                                viewModel.match = s
                            })
                        }
                        
                    }.background(RoundedRectangle(cornerRadius: 7).fill(.white.opacity(0.1))).padding().frame(maxWidth: .infinity)
                }
            }.frame(maxHeight: 30).padding(.bottom)
            if viewModel.match == nil{
                ScrollView{
                    CollapsibleListElement(expanded: true, title: "General"){
                        subviews["general", [], viewModel]
                    }
                    //                if viewModel.tab == "match".trad(){
                    //                    CollapsibleListElement(title: "rotation.analysis".trad()){
                    //                        VStack{
                    //                            let team = viewModel.team
                    //                            let rot = team.rotations(match: viewModel.match)
                    //                            ForEach(rot.indices, id:\.self){r in
                    //                                var players = rot[r].map{p in return Player.find(id: p) ?? Player(name: "none".trad(), number: 0, team: 0, active: 0, id: 0)}
                    //                                Court(rotation: players, numberPlayers: team.matches().first?.n_players ?? 4, stats: team.rotationStats(rotation: rot[r])).tag(r)
                    //                            }
                    //                        }
                    //                    }
                    //                }
                    ForEach(Array(actionsByType.keys).sorted(), id:\.self) {key in
                        let actions = actionsByType[key]
                        CollapsibleListElement(expanded: false, title: "\(key.trad().capitalized)"){
                            subviews[key, actions ?? [], viewModel]
                        }.foregroundColor(.white)
                    }
                }
            } else {
                MatchStats(viewModel: MatchStatsModel(team: viewModel.team, match: viewModel.match!))
            }
            
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("\("tournament.stats".trad())")
        
        //#-learning-task(createDetailView)
    }
    @ViewBuilder
    func matchStat() -> some View {
        
    }
    enum subviews {
        @ViewBuilder static subscript(string: String, actions:[Int], viewModel:MultiMatchStatsModel) -> some View {
            
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
                GeneralTable(stats: viewModel.stats, bests: true)
            default:
                fatalError()
            }
        }
    }
}


class MultiMatchStatsModel: ObservableObject{
    @Published var sourceMatch:Bool = false
    @Published var tab: String = "general".trad()
    @Published var selectedSet: Set? = nil
    @Published var historical: Bool = false
    @Published var url:URL?
    var stats: [Stat]
    var match: Match? = nil
    var matches: [Match] = []
    var team: Team
    init(team: Team, matches: [Match]){
        self.matches = matches
        self.team = team
        self.stats = matches.flatMap{$0.stats()}
        self.url = nil
    }
}


