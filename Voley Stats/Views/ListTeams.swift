import SwiftUI
import UniformTypeIdentifiers
import PDFKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import ProvisioningProfile

struct ListTeams: View {
    @EnvironmentObject var network: NetworkMonitor
    @ObservedObject var viewModel: ListTeamsModel
    @Namespace var animation: Namespace.ID
    @State var rotation: Int = 0
    @State var offset = CGFloat.zero
    
    var body: some View {
        VStack{
//            if viewModel.loading{
//                
//            }else{
                VStack{
                    VStack{
                        ZStack{
                            if !viewModel.allTeams.isEmpty && viewModel.selected<viewModel.allTeams.count{
                                NavigationLink(destination: TeamData(viewModel: TeamDataModel(team: viewModel.team()))){
                                    TeamCard(team: viewModel.team(), deleteTap:{viewModel.deleteDialog.toggle()})
                                        .offset(x: offset)
                                        .gesture(DragGesture()
                                            .onChanged{c in
                                                offset = c.translation.width
                                            }
                                            .onEnded{v in
                                                offset = -v.translation.width
                                                withAnimation(.easeInOut(duration: 0.1)){
                                                    
                                                    switch(v.translation.width, v.translation.height) {
                                                        
                                                    case (...0, -200...200):
                                                        if viewModel.selected < viewModel.allTeams.count {
                                                            viewModel.selected = viewModel.selected + 1
                                                        }else{
                                                            viewModel.selected = 0
                                                        }
                                                    case (0..., -200...200):
                                                        if viewModel.selected > 0 {
                                                            viewModel.selected = viewModel.selected - 1
                                                        }else{
                                                            viewModel.selected = viewModel.allTeams.count
                                                        }
                                                    default: print("default")
                                                    }
                                                    offset = CGFloat.zero
                                                }
                                                viewModel.tab = "matches".trad()
                                                viewModel.showTournaments = false
                                                viewModel.tournament = nil
                                                if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                                    viewModel.getScouts(team: viewModel.team())
                                                    viewModel.getMatchesElements(team: viewModel.team())
                                                }
                                            })
                                }
                                .confirmationDialog("team.delete.message".trad(), isPresented: $viewModel.deleteDialog, titleVisibility: .visible){
                                    Button("team.delete.title".trad(), role: .destructive){
                                        if viewModel.team().delete(){
                                            viewModel.getAllTeams()
                                        }
                                    }
                                }
                                .onChange(of: viewModel.selected, perform: {i in
                                    if viewModel.selected < viewModel.allTeams.count{
                                        viewModel.getMatchesElements(team: viewModel.team())
                                    }
                                })
                            }
                            if viewModel.selected == viewModel.allTeams.count{
                                NavigationLink(destination: TeamData(viewModel: TeamDataModel(team: nil))){
                                    ZStack{
                                        
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(.white.opacity(0.4))
                                            .offset(x: offset)
                                            .gesture(DragGesture()
                                                .onChanged{c in
                                                    offset = c.translation.width
                                                }
                                                .onEnded{v in
                                                    offset = -v.translation.width
                                                    withAnimation(.easeInOut(duration: 0.1)){
                                                        switch(v.translation.width, v.translation.height) {
                                                            
                                                        case (...0, -200...200):
                                                            if viewModel.selected < viewModel.allTeams.count {
                                                                viewModel.selected = viewModel.selected + 1
                                                            }else{
                                                                viewModel.selected = 0
                                                            }
                                                        case (0..., -200...200):
                                                            if viewModel.selected > 0 {
                                                                viewModel.selected = viewModel.selected - 1
                                                            }else{
                                                                viewModel.selected = viewModel.allTeams.count
                                                            }
                                                        default: print("default")
                                                        }
                                                        offset = CGFloat.zero
                                                    }
                                                })
                                        Image(systemName: "plus").font(.custom("add", size: 30)).foregroundColor(Color.swatch.dark.high).offset(x: offset)
                                    }.frame(maxHeight: 200).padding()
                                }
                                
                            }
                            HStack{
                                HStack(alignment: .center){
                                    ForEach(0..<viewModel.allTeams.count, id:\.self){t in
                                        Circle().fill(viewModel.selected == t ? .white : .gray).onTapGesture{
                                            viewModel.selected = t
                                        }.frame(width: 5, height: 5)
                                    }
                                    Image(systemName: "plus").foregroundColor(viewModel.selected == viewModel.allTeams.count ? .white : .gray).onTapGesture{
                                        viewModel.selected = viewModel.allTeams.count
                                    }.frame(width: 5, height: 5).padding(.horizontal, 5)
                                }
                            }.padding(10).background(.black.opacity(0.1)).clipShape(Capsule()).frame(height: 5, alignment: .center).padding().frame(maxHeight: 200, alignment: .bottom)
                        }
                        VStack{
                            if !viewModel.allTeams.isEmpty{
                                HStack{
                                    TabButton(selection: $viewModel.tab, title: "matches".trad(), animation: animation, action: {
                                        viewModel.showTournaments = false
                                    })
                                    TabButton(selection: $viewModel.tab, title: "tournaments".trad(), animation: animation, action: {
                                        viewModel.showTournaments = true
                                    })
                                    //                        TabButton(selection: $viewModel.tab, title: "training".trad(), animation: animation, action: {})
                                    TabButton(selection: $viewModel.tab, title: "team.stats".trad(), animation: animation, action: {
                                        //                                    loading = true
                                        //
                                        //                                    if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                        //                                        //                            viewModel.teamStats=viewModel.actionsData(team: viewModel.team())
                                        //                                        if viewModel.showMonthStats{
                                        //                                            viewModel.teamStats =  viewModel.team().fullStats(startDate: viewModel.startDate, endDate: viewModel.endDate)
                                        //                                        } else {
                                        //                                            viewModel.teamStats =  viewModel.team().fullStats()
                                        //                                        }
                                        //                                    }
                                        //                                    loading = false
                                        
                                    })
                                    //                            TabButton(selection: $viewModel.tab, title: "scouting".trad(), animation: animation, action: {
                                    //                                viewModel.getScouts(team: viewModel.team())
                                    //                            })
                                    
                                    
                                }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding([.horizontal, .top])
                            }
                            VStack{
                                if viewModel.tab == "matches".trad() || viewModel.tab == "tournaments".trad() {
                                    if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                        ListMatches(viewModel: viewModel).padding()
                                    }
                                } else if viewModel.tab == "team.stats".trad(){
                                    if viewModel.loading{
                                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .cyan)).scaleEffect(3)
                                    }else{
                                        if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                            VStack{
                                                ZStack{
                                                    Text("stats.general".trad()).font(.title).frame(maxWidth: .infinity, alignment: .center)
                                                    HStack{
                                                        Button(action:{
                                                            viewModel.statsFile = PDF().lastMonthReport(team: viewModel.team(), startDate: viewModel.startDate, endDate: viewModel.endDate).generate()
                                                            //                                                    viewModel.export.toggle()
                                                            
                                                        }){
                                                            Text("PDF").font(.caption)
                                                        }.padding(.horizontal).padding(.vertical, 10).background(.white.opacity(0.1)).clipShape(Capsule()).frame(maxWidth: .infinity, alignment: .trailing)
                                                    }.padding()
                                                    HStack{
                                                        Image(systemName: viewModel.showFilterbar ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle").font(.title3).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal).foregroundStyle(viewModel.showFilterbar ? .cyan : .white).onTapGesture{
                                                            withAnimation{
                                                                viewModel.showFilterbar.toggle()
                                                            }
                                                        }
                                                    }.padding(.horizontal)
                                                }
                                                if viewModel.showFilterbar{
                                                    VStack{
                                                        //                                                    HStack{
                                                        //                                                        VStack{
                                                        //                                                            Text("matches".trad().uppercased()).font(.caption).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                                        //                                                            MultiPicker(selection: $viewModel.filterMatches, items: viewModel.matches, placeholder: "Select matches")
                                                        //                                                        }
                                                        //                                                        VStack{
                                                        //                                                            Text("tournament".trad().uppercased()).font(.caption).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                                        //                                                            MultiPicker(selection: $viewModel.filterTournaments, items: viewModel.tournaments, placeholder: "Select tournaments")
                                                        //                                                        }
                                                        //                                                    }.padding(.vertical)
                                                        HStack{
                                                            VStack{
                                                                Text("start.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading)
                                                                DatePicker("start.date".trad(), selection: $viewModel.startDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                                                            }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                                                            VStack{
                                                                Text("end.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                                                DatePicker("end.date".trad(), selection: $viewModel.endDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                                                            }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                                                        }.padding(.vertical)
                                                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
                                                }
                                                TeamStats(team: viewModel.team(), startDate: $viewModel.startDate, endDate: $viewModel.endDate, matches: $viewModel.filterMatches, tournaments: $viewModel.filterTournaments)
                                            }
                                        }
                                    }
                                } else if viewModel.tab == "scouting".trad(){
                                    VStack{
                                        if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                            VStack{
                                                Text("teams.analyzed".trad()).font(.title)
                                                ScrollView(.vertical){
                                                    //                                            ZStack{
                                                    ////                                                Capsule()
                                                    //                                                RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
                                                    //                                                Button(action:{
                                                    //                                                    viewModel.newScout(team: viewModel.team())
                                                    //                                                }){
                                                    //                                                    Image(systemName: "plus")
                                                    //                                                }.padding().frame(maxWidth: .infinity)
                                                    //                                            }.foregroundColor(.white).padding(.vertical)
                                                    ForEach(viewModel.scouts, id:\.id){scout in
                                                        ZStack{
                                                            //                                                    Capsule().fill(.white.opacity(0.1))
                                                            //                                                        .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
                                                            RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
                                                            HStack{
                                                                VStack(alignment: .leading){
                                                                    Text("\(scout.teamName)").fontWeight(.bold)
                                                                    
                                                                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                                                Button(action:{
                                                                    //                                                                viewModel.editScout(team: viewModel.team(), scout: scout)
                                                                }){
                                                                    Image(systemName: "square.and.pencil").padding(.horizontal)
                                                                }
                                                                Button(action:{
                                                                    viewModel.scoutSelected = scout
                                                                    viewModel.deleteScouting.toggle()
                                                                }){
                                                                    Image(systemName: "trash").padding(.horizontal).foregroundColor(.red)
                                                                }
                                                                
                                                            }.frame(maxWidth: .infinity, alignment: .trailing).padding()
                                                        }
                                                        .alert("scout.delete.title".trad(), isPresented: $viewModel.deleteScouting, actions: {
                                                            Button("delete".trad(), role: .destructive){
                                                                if viewModel.scoutSelected?.delete() ?? false{
                                                                    viewModel.getScouts(team: viewModel.team())
                                                                }
                                                            }
                                                        }, message: {Text("scout.delete.message".trad())})
                                                        
                                                        .onTapGesture{
                                                            //                                                        viewModel.goScouting(team: viewModel.team(), scout: scout)
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }.padding()
                                        }
                                    }.background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(.white.opacity(0.1)))
                                        .padding()
                                }
                            }.frame(maxHeight:.infinity).foregroundColor(.white)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    if !network.isConnected{
                        HStack{
                            Text("offline".trad()).font(.caption).padding(5).frame(maxWidth: .infinity, alignment: .center)
                        }.background(.gray)
                    }
                }
                
//            }
        }
        .onAppear{
            viewModel.getAllTeams()
            if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                viewModel.getScouts(team: viewModel.team())
                viewModel.getMatchesElements(team: viewModel.team())
            }
//            print(Calendar.current.dateComponents([.day], from: .now, to: ProvisioningProfile.profile()?.expiryDate ?? .now).day)
            
        }
        
        .navigationTitle("your.teams".trad())
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.colorScheme, .dark)
            .toolbar{
                ToolbarItem(placement: .primaryAction) {
                    if Auth.auth().currentUser != nil {
                        NavigationLink(destination: UserView(viewModel: UserViewModel())){
                            Image(systemName: "person.circle").font(.title3)
                        }
                    } else {
                        HStack{
                            NavigationLink(destination: Login(viewModel: LoginModel(login: true))){
                                Text("login".trad().uppercased()).font(.caption)
                            }.disabled(!network.isConnected)
                            NavigationLink(destination: Login(viewModel: LoginModel(login: false))){
                                Text("sign.up".trad().uppercased()).font(.caption).padding(10).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8))
                            }.disabled(!network.isConnected)
                            Menu {
                                Button(action: {
                                    viewModel.lang = "es"
                                    UserDefaults.standard.set("es", forKey: "locale")
                                    viewModel.tab = viewModel.tab.lowercased().trad()
                                }){
                                    Text("spanish".trad())
                                    if viewModel.lang == "es" {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                }.frame(maxWidth: .infinity)
                                Button(action: {
                                    viewModel.lang = "en"
                                    UserDefaults.standard.set("en", forKey: "locale")
                                    viewModel.tab = viewModel.tab.trad()
                                }){
                                    Text("english".trad())
                                    if viewModel.lang == "en" {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                }.frame(maxWidth: .infinity)
                            } label: {
                                Label("language".trad(), systemImage: "globe")
                            }
                        }.padding(.vertical)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Text(viewModel.df.string(from: ProvisioningProfile.profile()?.expiryDate ?? .now)).font(.caption)
                }
            }
            .quickLookPreview($viewModel.statsFile)
            
            .overlay(viewModel.reportLang && viewModel.matchSelected != nil ? langChooseModal() : nil)
            
            .background(
                Color.swatch.dark.high
            )
            .foregroundColor(.white)
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
            //            Text("language".trad()).font(.title2).padding([.bottom, .horizontal])
            //            HStack{
            //                ZStack{
            //                    RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.blue)
            //                    Text("spanish".trad()).foregroundColor(.white).padding(5)
            //                }.clipped().onTapGesture {
            //                    if (actualLang != "es"){
            //                        UserDefaults.standard.set("es", forKey: "locale")
            //                    }
            //                    if viewModel.matchSelected != nil{
            //                        viewModel.statsFile = Report(team:viewModel.team(), match: viewModel.matchSelected!).generate()
            //                    }
            //                    if (actualLang != "es"){
            //                        UserDefaults.standard.set(actualLang, forKey: "locale")
            //                    }
            //                    viewModel.reportLang.toggle()
            //                }
            //                ZStack{
            //                    RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.blue)
            //                    Text("english".trad()).foregroundColor(.white).padding(5)
            //                }.clipped().onTapGesture {
            //                    if (actualLang != "en"){
            //                        UserDefaults.standard.set("en", forKey: "locale")
            //                    }
            //                    if viewModel.matchSelected != nil{
            //                        viewModel.statsFile = Report(team:viewModel.team(), match: viewModel.matchSelected!).generate()
            //                    }
            //                    if (actualLang != "en"){
            //                        UserDefaults.standard.set(actualLang, forKey: "locale")
            //                    }
            //                    viewModel.reportLang.toggle()
            //                }
            //            }.padding()
            if viewModel.matchSelected != nil{
                ReportConfigurator(team: viewModel.team(), match: viewModel.matchSelected!, fileUrl: $viewModel.statsFile, show: $viewModel.reportLang).padding()
            }
        }
        .background(.black.opacity(0.9))
//        .frame(width:500, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 25)).padding()
    }
//    }
}
class ListTeamsModel: ObservableObject{
    @Published var deleteDialog: Bool = false
    @Published var allTeams: [Team]=[]
    @Published var reportMatches: [Match]=[]
    @Published var selectMatches:Bool = false
    @Published var deleteMatch: Bool = false
    @Published var matchSelected: Match? = nil
    @Published var matchClicked: Bool = false
    @Published var tab: String = "matches".trad()
    @Published var export: Bool = false
    @Published var exportStats: Bool = false
    @Published var importFile: Bool = false
    @Published var loading:Bool = false
    @Published var teamStats:Dictionary<String,Dictionary<String,Int>>=[:]
    @Published var showMonthStats: Bool = false
    @Published var scouts: [Scout] = []
    @Published var deleteScouting: Bool = false
    @Published var scoutSelected: Scout? = nil
    @Published var lang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @Published var matches: [Match] = []
    @Published var league:Bool = false
    @Published var tournaments: [Tournament] = []
    @Published var tournament:Tournament?=nil
    @Published var showTournaments:Bool=false
    @Published var tournamentMatches: Bool = false
    @Published var statsFile: URL? = nil
    @Published var selected: Int = 0
    @Published var reportLang: Bool = false
    @Published var isActiveRoot:Bool = false
    @Published var startDate:Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var endDate:Date = Date()
    @Published var matchId: Int = 0
    @Published var tournamentId: Int = 0
    @Published var filterMatches: [Match] = []
    @Published var filterTournaments: [Tournament] = []
    @Published var showFilterbar:Bool = true
    var dbFile: URL? = nil
    let df = DateFormatter()
    
    init(){
//        self.loading = true
        self.getAllTeams()
//        print(viewModel.allTeams)
//                viewModel.getAllExercises()
//        Rotation.find(id: 0)
//        Rotation.find(id: 295)
        df.dateFormat = "dd/MM/yyyy"
        if !self.allTeams.isEmpty && self.selected < self.allTeams.count{
//            self.getScouts(team: self.team())
            self.getMatchesElements(team: self.team())
        }
    }
    func team()->Team{
//        if self.selected<=allTeams.count{
            return allTeams[self.selected]
//        }
    }
    
    
    func getAllTeams(){
        allTeams = Team.all()
    }
    
    func getScouts(team: Team){
        scouts = team.scouts()
    }
    func getMatchesElements(team:Team){
        self.matches = team.matches().filter{$0.league == self.league && $0.tournament == self.tournament}
        
        self.tournaments = team.tournaments()
    }
    func deleteMatch(match: Match){
        let delete = match.delete()
        if delete {
            self.getMatchesElements(team: self.team())
        }
    }
//    func trainStats(team: Team){
//        appPilot.push(.TrainStats(team: team))
//    }
//    func editMatch(team:Team, match: Match){
//        appPilot.push(.InsertMatch(team: team, match: match))
//    }
    func deleteTeam(team: Team){
        let delete = team.delete()
        if delete {
            getAllTeams()
        }
    }
//    func editTeam(team: Team){
//        appPilot.push(.InsertTeam(team: team))
//    }
//    func setupSet(team:Team, match: Match, set: Set){
//        appPilot.push(.SetupSet(team: team, match: match, set: set))
//    }
//    func captureStats(team:Team, match: Match, set: Set){
//        appPilot.push(.CaptureStats(team: team, match: match, set: set))
//    }
    
    func actionsData(team:Team)->Dictionary<String,Dictionary<String,Int>>{
        let stats = team.stats()
        let serve = stats.filter{s in return s.stage == 0 && s.to != 0}
        let receive = stats.filter{actionsByType["receive"]!.contains($0.action)}
        let block = stats.filter{actionsByType["block"]!.contains($0.action)}
        let dig = stats.filter{actionsByType["dig"]!.contains($0.action)}
        let set = stats.filter{actionsByType["set"]!.contains($0.action)}
        let attack = stats.filter{actionsByType["attack"]!.contains($0.action)}
        
        return [
            "block": [
                "total":block.count,
                "earned":block.filter{$0.action==13}.count,
                "error":block.filter{[20,31].contains($0.action)}.count
            ],
            "serve":[
                "total":serve.count,
                "earned":serve.filter{$0.action==8}.count,
                "error":serve.filter{[15, 32].contains($0.action)}.count
            ],
            "dig":[
                "total":dig.count,
                "earned":0,
                "error":dig.filter{[23, 25].contains($0.action)}.count
            ],
            "receive":[
                "total":receive.count,
                "earned":receive.filter{$0.action==4}.count,
                "error":receive.filter{$0.action==22}.count
            ],
            "attack":[
                "total":attack.count,
                "earned":attack.filter{[9, 10, 11, 12].contains($0.action)}.count,
                "error":attack.filter{[16, 17, 18, 19].contains($0.action)}.count
            ],
            "set": [
                "total":set.count,
                "earned":0,
                "error":set.filter{$0.action==24}.count
            ],
        ]
    }
    
}

/*#-code-walkthrough(1.preview)*/
