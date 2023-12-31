import SwiftUI
import UIPilot
import UniformTypeIdentifiers
import PDFKit



struct ListTeams: View {
    
    @ObservedObject var viewModel: ListTeamsModel
    @Namespace var animation: Namespace.ID
    @State var rotation: Int = 0
    @State var loading: Bool = false
    @State var offset = CGFloat.zero
    /*#-code-walkthrough(1.body)*/
    var body: some View {
//        NavigationView{
            VStack{
//                Text("your.teams".trad()).font(.title)
//                TabView(selection: $viewModel.selected){
//                    ForEach(viewModel.allTeams, id: \.id){team in
                if !viewModel.allTeams.isEmpty && viewModel.selected<viewModel.allTeams.count{
                    NavigationLink(destination: TeamData(viewModel: TeamDataModel(pilot: viewModel.appPilot, team: viewModel.team()))){
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
//                                    viewModel.getMatchesElements(team: viewModel.team())
                                }
                                })
                        //                            .onTapGesture {
                        //                            viewModel.editTeam(team: team)
                    }
                    .confirmationDialog("team.delete.message".trad(), isPresented: $viewModel.deleteDialog, titleVisibility: .visible){
                        Button("team.delete.title".trad(), role: .destructive){
                            if viewModel.team().delete(){
                                viewModel.getAllTeams()
                            }
                        }
                    }.onChange(of: viewModel.selected, perform: {i in
                        if viewModel.selected < viewModel.allTeams.count{
                            viewModel.getMatchesElements(team: viewModel.team())
                        }
//                        print(viewModel.selected)
                    })
                }
//                    }
                    //                if viewModel.allTeams.isEmpty{
                if viewModel.selected == viewModel.allTeams.count{
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
//                            .stroke(.white, style: StrokeStyle(dash: [5]))
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
                    }.frame(maxWidth: 300, maxHeight: 200).padding()
                        .onTapGesture {
                            viewModel.onAddButtonClick()
                        }
                    
                }
                    //                }
//                }.id(viewModel.selected)
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
                }.frame(height: 5, alignment: .center).padding()
//                .tabViewStyle(.page)
//                .frame(maxHeight: 300)
                VStack{
                    HStack{
                        TabButton(selection: $viewModel.tab, title: "matches".trad(), animation: animation, action: {})
//                        TabButton(selection: $viewModel.tab, title: "training".trad(), animation: animation, action: {})
                        TabButton(selection: $viewModel.tab, title: "team.stats".trad(), animation: animation, action: {
                            loading = true
                            
                            if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                //                            viewModel.teamStats=viewModel.actionsData(team: viewModel.team())
                                if viewModel.showMonthStats{
                                    viewModel.teamStats =  viewModel.team().fullStats(interval: 1)
                                } else {
                                    viewModel.teamStats =  viewModel.team().fullStats()
                                }
                            }
                            loading = false
                            
                        })
                        TabButton(selection: $viewModel.tab, title: "scouting".trad(), animation: animation, action: {
                            viewModel.getScouts(team: viewModel.team())
                        })
                    }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
                    VStack{
                        if viewModel.tab == "matches".trad() {
                            if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                ListMatches(viewModel: viewModel).padding()
                            }
//                        }else if viewModel.tab == "training".trad(){
//                            VStack{
//                                if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
//                                    VStack{
//                                        Button(action:{
//                                            viewModel.trainStats(team: viewModel.team())
//                                        }){
//                                            Text("stats".trad())
//                                            Image(systemName: "chart.line.uptrend.xyaxis")
//
//                                        }.foregroundColor(.white).frame(maxWidth: .infinity, alignment: .trailing).padding()
//                                        Text("exercises".trad()).font(.title)
//                                        ScrollView(.vertical){
//                                            ForEach(viewModel.allExercises, id:\.id){exercise in
//                                                ExerciseListElement(team: viewModel.team(), exercise: exercise, viewModel: viewModel) {}
//                                            }
//                                            ZStack{
////                                                Capsule()
//                                                RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
////                                                Button(action:{ viewModel.editExercise(exercise: nil)
////                                                }){
//                                                NavigationLink(destination: SessionData(viewModel: SessionDataModel(pilot: viewModel.appPilot, team: viewModel.team(), session: nil))){
//                                                    Image(systemName: "plus").foregroundColor(viewModel.team().players().isEmpty ? .gray : .white)
//                                                }.padding().frame(maxWidth: .infinity).disabled(viewModel.team().players().isEmpty)
////                                                }.padding().frame(maxWidth: .infinity)
//                                            }.foregroundColor(.white).padding(.vertical)
//                                        }
//                                    }.padding()
//                                }
//                            }.background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(.white.opacity(0.1)))
//                                .padding()
                        } else if viewModel.tab == "team.stats".trad(){
                            if loading{
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .cyan)).scaleEffect(3)
                            }else{
                                ScrollView{
                                    if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                        
                                        Section(header:HStack{
                                            Text("stats.general".trad()).font(.title).frame(maxWidth: .infinity, alignment: .center)
                                            HStack{
                                                Button(action:{
                                                    viewModel.statsFile = PDF().lastMonthReport(team: viewModel.team()).generate()
//                                                    viewModel.export.toggle()
                                                    
                                                }){
                                                    Text("PDF")
                                                }
                                            }.padding()
                                        }){
                                            Toggle("last.month.stats".trad(), isOn: $viewModel.showMonthStats).tint(.cyan)
                                                .onChange(of: viewModel.showMonthStats){ value in
                                                    if viewModel.showMonthStats{
                                                        viewModel.teamStats = viewModel.team().fullStats(interval: 1)
                                                    } else {
                                                        viewModel.teamStats = viewModel.team().fullStats()
                                                    }
                                                }
                                                .padding()
                                            LazyVGrid(columns:[GridItem(.adaptive(minimum: 250))], spacing: 20){
                                                
                                                ForEach(Array(viewModel.teamStats.keys.sorted()), id:\.self){area in
                                                    let data = viewModel.teamStats[area]!
                                                    PieChart(title: area.trad().capitalized, total: data["total"]!, error: data["error"]!, earned: data["earned"]!, size: 175, action:{})
                                                }
                                            }
                                        }.frame(maxWidth: .infinity, alignment: .center)
                                            
                                        
                                        //                                Section(header:Text("rotations.best".trad()).font(.title)){
                                        //
                                        //                                    let team = viewModel.team()
                                        //                                    let rot = team.rotations()
                                        //                                    ForEach(rot.indices, id:\.self){r in
                                        //                                        let players = rot[r].map{p in return Player.find(id: p) ?? Player(name: "NOne", number: 0, team: 0, active: 0, id: 0)}
                                        //                                        Court(rotation: players, numberPlayers: team.matches().first?.n_players ?? 4, stats: team.rotationStats(rotation: rot[r])).tag(r)
                                        //                                    }
                                        //                                }
                                    }
                                }
                            }
                        } else if viewModel.tab == "scouting".trad(){
                            VStack{
                                if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                                    VStack{
                                        Text("teams.analyzed".trad()).font(.title)
                                        ScrollView(.vertical){
                                            ZStack{
//                                                Capsule()
                                                RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
                                                Button(action:{
                                                    viewModel.newScout(team: viewModel.team())
                                                }){
                                                    Image(systemName: "plus")
                                                }.padding().frame(maxWidth: .infinity)
                                            }.foregroundColor(.white).padding(.vertical)
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
                                                            viewModel.editScout(team: viewModel.team(), scout: scout)
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
                                                    viewModel.goScouting(team: viewModel.team(), scout: scout)
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }.padding()
                                }
                            }.background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(.white.opacity(0.1)))
                                .padding()
                        }
                    }.frame(maxHeight:.infinity).foregroundColor(.white)
                }.frame(maxHeight: .infinity)
            }
            .navigationTitle("your.teams".trad())
            .environment(\.colorScheme, .dark)
            .fileImporter(isPresented: $viewModel.importFile, allowedContentTypes: [.commaSeparatedText], allowsMultipleSelection: false) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    guard selectedFile.startAccessingSecurityScopedResource() else { return }
                    
                    guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                    print(viewModel.loading)
                    viewModel.loading.toggle()
                    print(viewModel.loading)
                    DB.fillFromCsv(csv: message)
                    
                    viewModel.getAllTeams()
                    viewModel.getAllExercises()
                    if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                        viewModel.getScouts(team: viewModel.team())
                        viewModel.getMatchesElements(team: viewModel.team())
                    }
                    print(viewModel.loading)
                    viewModel.loading.toggle()
                    print(viewModel.loading)
                    selectedFile.stopAccessingSecurityScopedResource()
                } catch {
                    Swift.print(error.localizedDescription)
                }
            }
            .fileMover(isPresented: $viewModel.export, file: viewModel.dbFile){result in
                viewModel.export = false
            }
            .toolbar{
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: {
                            viewModel.importFile.toggle()
                        }){
                            Text("data.import".trad())
                            Image(systemName: "square.and.arrow.down")
                        }.frame(maxWidth: .infinity)
                        Button(action: {
                            viewModel.dbFile=DB.createCSV()
                            viewModel.export.toggle()
                            
                        }){
                            Text("data.export".trad())
                            Image(systemName: "square.and.arrow.up")
                        }.frame(maxWidth: .infinity)
                        Section{
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
                            }.disabled(false)
                            
                        }
                    }
                label: {
                    Label("More actions", systemImage: "ellipsis.circle").font(.title2)
                }.padding(.top)
                    //                                .padding(.top, 40)
                }
            }
            .quickLookPreview($viewModel.statsFile)
            .onAppear{
                viewModel.getAllTeams()
                viewModel.getAllExercises()
                if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
//                    viewModel.showTournaments = false
//                    print(viewModel.tournament?.name)
                    viewModel.getScouts(team: viewModel.team())
                    viewModel.getMatchesElements(team: viewModel.team())
                }
                
            }
            .overlay(viewModel.loading ? ZStack{
                Color.black
                Text("Loading...")
                
            }.frame(width: .infinity, height: .infinity) : nil)
            .background(
                Color.swatch.dark.high
            )
            .foregroundColor(.white)
//        }
    }
}
class ListTeamsModel: ObservableObject{
    @Published var deleteDialog: Bool = false
    @Published var allTeams: [Team]=[]
    @Published var reportMatches: [Match]=[]
    @Published var selectMatches:Bool = false
    @Published var allExercises: [Exercise]=[]
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
    var dbFile: URL? = nil
    let appPilot: UIPilot<AppRoute>
    
    init(pilot: UIPilot<AppRoute>){
        self.appPilot = pilot
    }
    func team()->Team{
//        if self.selected<=allTeams.count{
            return allTeams[self.selected]
//        }
    }
    func onAddButtonClick(){
        appPilot.push(.InsertTeam(team: nil))
    }
    func getAllTeams(){
        allTeams = Team.all()
    }
    func getAllExercises(){
        allExercises = Exercise.all()
    }
    func getScouts(team: Team){
        scouts = team.scouts()
    }
    func newScout(team:Team){
        appPilot.push(.NewScouting(team: team, scout: nil))
    }
    func editScout(team:Team, scout: Scout){
        appPilot.push(.NewScouting(team: team, scout: scout))
    }
    func goScouting(team:Team, scout:Scout){
        appPilot.push(.Scouting(team: team, scout: scout))
    }
    func addMatch(team: Team){
        appPilot.push(.InsertMatch(team: team, match: nil))
    }
    func getMatchesElements(team:Team){
        self.matches = team.matches().filter{$0.league == self.league && $0.tournament == self.tournament}
        
        self.tournaments = team.tournaments()
    }
    func deleteMatch(match: Match){
        let delete = match.delete()
        if delete {
            getAllTeams()
        }
    }
    func trainStats(team: Team){
        appPilot.push(.TrainStats(team: team))
    }
    func editMatch(team:Team, match: Match){
        appPilot.push(.InsertMatch(team: team, match: match))
    }
    func deleteTeam(team: Team){
        let delete = team.delete()
        if delete {
            getAllTeams()
        }
    }
    func editTeam(team: Team){
        appPilot.push(.InsertTeam(team: team))
    }
    func setupSet(team:Team, match: Match, set: Set){
        appPilot.push(.SetupSet(team: team, match: match, set: set))
    }
    func captureStats(team:Team, match: Match, set: Set){
        appPilot.push(.CaptureStats(team: team, match: match, set: set))
    }
    func startExercise(team: Team, exercise:Exercise){
        appPilot.push(.ExerciseView(team: team, exercise: exercise))
    }
    func editExercise(exercise: Exercise?){
        appPilot.push(.InsertExercise(exercise: exercise))
    }
    func rotate1(imageView: UIImageView, aCircleTime: Double) { //CABasicAnimation
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
    }
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
