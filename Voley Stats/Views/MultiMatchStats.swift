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
//                        viewModel.url = PDF().multiMatchReport(team: viewModel.team, matches: viewModel.matches).generate()
                        viewModel.reportLang.toggle()
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
                            TabButton(selection: $viewModel.tab, title: "\(s.opponent) (\(s.date.formatted(Date.FormatStyle().month(.abbreviated))))", animation: animation, action: {
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
            
        }
        .overlay(viewModel.reportLang ? langChooseModal() : nil)
        .background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("\("tournament.stats".trad())")
            .onAppear{
                viewModel.stats = viewModel.matches.flatMap{$0.stats()}
            }
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
    
    @ViewBuilder
    func langChooseModal() -> some View {
        VStack{
            let actualLang = UserDefaults.standard.string(forKey: "locale") ?? "en"
            HStack{
                Button(action:{viewModel.reportLang.toggle()}){
                    Image(systemName: "multiply").font(.title2)
                }
            }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
            Text("language".trad()).font(.title2).padding([.bottom, .horizontal])
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.blue)
                    Text("spanish".trad()).foregroundColor(.white).padding(5)
                }.clipped().onTapGesture {
                    if (actualLang != "es"){
                        UserDefaults.standard.set("es", forKey: "locale")
                    }
                    viewModel.url = PDF().multiMatchReport(team: viewModel.team, matches: viewModel.matches).generate()
                    if (actualLang != "es"){
                        UserDefaults.standard.set(actualLang, forKey: "locale")
                    }
                    viewModel.reportLang.toggle()
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.blue)
                    Text("english".trad()).foregroundColor(.white).padding(5)
                }.clipped().onTapGesture {
                    if (actualLang != "en"){
                        UserDefaults.standard.set("en", forKey: "locale")
                    }
                    viewModel.url = PDF().multiMatchReport(team: viewModel.team, matches: viewModel.matches).generate()
                    if (actualLang != "en"){
                        UserDefaults.standard.set(actualLang, forKey: "locale")
                    }
                    viewModel.reportLang.toggle()
                }
            }.padding()
        }
        .background(.black.opacity(0.9))
        .frame(width:500, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}


class MultiMatchStatsModel: ObservableObject{
    @Published var sourceMatch:Bool = false
    @Published var tab: String = "general".trad()
    @Published var selectedSet: Set? = nil
    @Published var historical: Bool = false
    @Published var url:URL?
    @Published var reportLang: Bool = false
    @Published var stats: [Stat] = []
    var match: Match? = nil
    var matches: [Match] = []
    var team: Team
    init(team: Team, matches: [Match]){
        self.matches = matches
        self.team = team
//        self.stats = matches.flatMap{$0.stats()}
        self.url = nil
    }
}


