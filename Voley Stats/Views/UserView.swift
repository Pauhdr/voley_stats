import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import ProvisioningProfile

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    @EnvironmentObject var network : NetworkMonitor
    @Environment(\.dismiss) var dismiss
    @State var tab: String = "general".trad()
    @Namespace var animation
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "person.circle.fill").resizable().scaledToFit().frame(width: 100, height: 100).frame(maxWidth: .infinity, alignment: .center)
                VStack{
                    Text("\(Auth.auth().currentUser?.displayName ?? "")").font(.title).padding(.vertical).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(Auth.auth().currentUser?.email ?? "")").frame(maxWidth: .infinity, alignment: .leading).foregroundStyle(.gray)
                }.padding()
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding()
            HStack{
                TabButton(selection: $tab, title: "general".trad(), animation: animation, action:{})
                TabButton(selection: $tab, title: "settings".trad(), animation: animation, action:{})
//                TabButton(selection: $viewModel.tab, title: "Set", animation: animation, action:{})
                
                
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
            if tab == "general".trad(){
                VStack{
                    HStack{
                        VStack{
                            Text("teams".trad()).font(.title).frame(maxWidth: .infinity)
                            Text("\(Team.all().count)").font(.system(size: 60))
                        }.padding().background(.orange).clipShape(RoundedRectangle(cornerRadius: 15)).onTapGesture {
                            viewModel.arrangeTeams.toggle()
                        }
                        VStack{
                            Text("players".trad()).font(.title).frame(maxWidth: .infinity)
                            Text("\(Player.all().count)").font(.system(size: 60))
                        }.padding().background(.purple).clipShape(RoundedRectangle(cornerRadius: 15))
                    }.padding()
                    HStack{
                        VStack{
                            Text("tournaments".trad()).font(.title).frame(maxWidth: .infinity)
                            Text("\(Tournament.all().count)").font(.system(size: 60))
                        }.padding().background(.pink).clipShape(RoundedRectangle(cornerRadius: 15))
                        VStack{
                            Text("matches".trad()).font(.title).frame(maxWidth: .infinity)
                            Text("\(Match.all().count)").font(.system(size: 60))
                        }.padding().background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
                    }.padding()
//                    HStack{
//                        Text(viewModel.df.string(from: ProvisioningProfile.profile()?.expiryDate ?? .now))
//                    }.padding().background(.red.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 15))
                }.frame(maxHeight: .infinity, alignment: .top)
            }
            if tab == "settings".trad(){
                VStack{
                    HStack{
                        if viewModel.importing {
                            ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            HStack{
                                Text("data.import".trad())
                                Image(systemName: "square.and.arrow.down").padding(.horizontal)
                            }.frame(maxWidth: .infinity)
                        }
                    }.padding().background(.white.opacity(network.isConnected ? 0.1 : 0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        if network.isConnected{
                            viewModel.importing = true
                            viewModel.importFromFirestore()
                        }
                    }
                    HStack{
                        if viewModel.saving{
                            ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            HStack{
                                Text("data.export".trad())
                                Image(systemName: "square.and.arrow.up").padding(.horizontal)
                            }.frame(maxWidth: .infinity)
                        }
                    }.padding().background(.white.opacity(network.isConnected ? 0.1 : 0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        if network.isConnected{
                            viewModel.saving.toggle()
                            viewModel.saveFirestore()
                        }
                    }
                    
                    CollapsibleListElement(title: "languaje".trad()){
                        VStack{
                            HStack{
                                Text("spanish".trad()).frame(maxWidth: .infinity)
                                if viewModel.lang == "es" {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).onTapGesture {
                                viewModel.lang = "es"
                                UserDefaults.standard.set("es", forKey: "locale")
                                viewModel.langChanged.toggle()
                                self.tab = "settings".trad()
                            }
                            HStack{
                                Text("english".trad()).frame(maxWidth: .infinity)
                                if viewModel.lang == "en" {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).onTapGesture {
                                viewModel.lang = "en"
                                UserDefaults.standard.set("en", forKey: "locale")
                                viewModel.langChanged.toggle()
                                self.tab = "settings".trad()
                            }
                        }
                    }
                    HStack{
                        if viewModel.closing{
                            ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            HStack{
                                Text("log.out".trad())
                                //                        Image(systemName: "door").padding(.horizontal)
                            }.frame(maxWidth: .infinity)
                        }
                    }.padding().background(.white.opacity(network.isConnected ? 0.1 : 0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        if network.isConnected{
                            viewModel.closing.toggle()
                            do{
                                try Auth.auth().signOut()
                                
                            } catch {
                                print("error")
                            }
                            dismiss()
                        }
                    }.disabled(!network.isConnected)
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }.background(Color.swatch.dark.high).foregroundStyle(.white)
            .navigationTitle("user.area".trad())
            .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.toastType, message: viewModel.msg))
            .overlay(viewModel.arrangeTeams ? arrangeTeams() : nil)
    }
    @ViewBuilder
    func arrangeTeams() ->some View{
        VStack{
            ZStack{
                Text("manage.teams".trad()).frame(maxWidth: .infinity, alignment: .center)
                Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                    viewModel.arrangeTeams.toggle()
                }
            }.padding().font(.title)
            VStack{
                ForEach(viewModel.teams, id:\.id){team in
                    HStack{
                        //                    Text("\(team.order)")
                        HStack{
                            if team.order != 1{
                                Image(systemName: "chevron.up").onTapGesture {
                                    team.order -= 1
                                    let prev = viewModel.teams[team.order-1]
                                    prev.order += 1
                                    if team.update() && prev.update(){
                                        viewModel.teams = Team.all()
                                    }
                                }
                            }
                            if team.order != viewModel.teams.count{
                                Image(systemName: "chevron.down").onTapGesture {
                                    team.order += 1
                                    let prev = viewModel.teams[team.order-1]
                                    prev.order -= 1
                                    if team.update() && prev.update(){
                                        viewModel.teams = Team.all()
                                    }
                                }
                            }
                        }.frame(width: 70)
                        Text("\(team.name)").frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "trash").foregroundStyle(.red).padding().background(.red.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }.padding()
        }.padding().foregroundStyle(.white).background(.black).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity, maxHeight: .infinity).padding()
    }
}
class UserViewModel: ObservableObject{
    @Published var lang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @Published var langChanged:Bool = false
    @Published var saving:Bool = false
    @Published var importing:Bool = false
    @Published var closing:Bool = false
    @Published var showToast: Bool = false
    @Published var toastType: ToastType = .success
    @Published var msg: String = ""
    @Published var countTransferred: Int = 0
    @Published var teams: [Team] = Team.all()
    @Published var arrangeTeams: Bool = false
//    let df = DateFormatter()
    func makeToast(msg: String, type: ToastType){
        self.msg = msg
        self.toastType = type
        self.showToast.toggle()
    
//        df.dateFormat = "dd/MM/yyyy"
//        print(ProvisioningProfile.profile()?.expiryDate)
    }
    func saveFirestore(){
        let db = Firestore.firestore()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser!.uid
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent("database")
            
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent("db.sqlite")
                storage.child("\(uid).sqlite").putFile(from: dbPath)
                self.saving.toggle()
                self.makeToast(msg: "backup.saved".trad(), type: .success)
                print("SQLiteDataStore upload from: \(dbPath) ")
            } catch {
                self.saving.toggle()
                self.makeToast(msg: "backup.error".trad(), type: .error)
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            self.saving.toggle()
            self.makeToast(msg: "backup.error".trad(), type: .error)
//            db = nil
        }
        
//        self.countTransferred = 0
//        let batch = db.batch()
//        var deviceRef = db.collection(uid).document("iPad")
//        for team in Team.all(){
//            batch.setData(team.toJSON(), forDocument: deviceRef.collection("teams").document(team.id.description))
//        }
//        print("teams")
//        self.countTransferred += 1
//        for player in Player.all(){
//            batch.setData(player.toJSON(), forDocument: deviceRef.collection("player").document(player.id.description))
//        }
//        print("players")
//        self.countTransferred += 1
//        for playerTeam in Player.playerTeamsToJSON(){
//            batch.setData(playerTeam, forDocument: deviceRef.collection("player_teams").document("\(playerTeam["id"]!)"))
//        }
//        print("playerrTeams")
//        self.countTransferred += 1
//        for measure in PlayerMeasures.all(){
//            batch.setData(measure.toJSON(), forDocument: deviceRef.collection("player_measures").document(measure.id.description))
//        }
//        print("measures")
//        self.countTransferred += 1
//        for tournament in Tournament.all(){
//            batch.setData(tournament.toJSON(), forDocument: deviceRef.collection("tournaments").document(tournament.id.description))
//        }
//        print("tournament")
//        self.countTransferred += 1
//        for match in Match.all(){
//            batch.setData(match.toJSON(), forDocument: deviceRef.collection("matches").document(match.id.description))
//        }
//        print("matches")
//        self.countTransferred += 1
//        for set in Set.all(){
//            batch.setData(set.toJSON(), forDocument: deviceRef.collection("sets").document(set.id.description))
//        }
//        print("sets")
//        self.countTransferred += 1
//        for stat in Stat.all(){
//            batch.setData(stat.toJSON(), forDocument: deviceRef.collection("stats").document(stat.id.description))
//        }
//        print("stats")
//        self.countTransferred += 1
//        for rotation in Rotation.all(){
//            batch.setData(rotation.toJSON(), forDocument: deviceRef.collection("rotations").document(rotation.id.description))
//        }
//        print("rotations")
//        self.countTransferred += 1
//        batch.commit(){ err in
//            if let err = err {
//                print("err:"+err.localizedDescription)
//                self.saving.toggle()
//                self.makeToast(msg: "backup.error".trad(), type: .error)
//            } else {
//                self.saving.toggle()
//                self.makeToast(msg: "backup.saved".trad(), type: .success)
//            }
//          }
//        db.collection("backups").document(Auth.auth().currentUser!.uid).setData(["data":txt, "date":Date().timeIntervalSince1970]){err in
//            if err != nil{
//                print(err!.localizedDescription)
//                self.makeToast(msg: "backup.error".trad(), type: .error)
//                return
//            }
//            
//        }
    }
    func importFromFirestore(){
        DB.truncateDatabase()
//        self.countTransferred = 0
//        let db = Firestore.firestore()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser!.uid
//        let deviceRef = db.collection(uid).document("iPad")
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent("database")
            
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent("db.sqlite")
                storage.child("\(uid).sqlite").write(toFile: dbPath){url, err in
                    if let err = err {
                        self.importing.toggle()
                        self.makeToast(msg: "error.importing".trad(), type: .error)
                    }else{
                        self.importing.toggle()
                        self.makeToast(msg: "data.imported".trad(), type: .success)
                        DB.shared = DB()
                        print("SQLiteDataStore upload from: \(dbPath) ")
                    }
                }
                
            } catch {
                self.importing.toggle()
                self.makeToast(msg: "error.importing".trad(), type: .error)
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            self.importing.toggle()
            self.makeToast(msg: "error.importing".trad(), type: .error)
//            db = nil
        }
//        var error = false
//        deviceRef.collection("teams").getDocuments(){ (snap, err) in
//            if let err = err {
//                self.importing.toggle()
//                self.makeToast(msg: "error.importing".trad(), type: .error)
//                error=true
//            }else{
//                for doc in snap!.documents{
//                    Team.createTeam(team: Team(name: doc.get("name") as! String, organization: doc.get("organization") as! String, category: doc.get("category") as! String, gender: doc.get("gender") as! String, color: Color(hex: doc.get("color") as! String) ?? .red, id: doc.get("id") as! Int))
//                }
//                self.newImport()
//                deviceRef.collection("player").getDocuments(){ (snap, err) in
//                    if let err = err {
//                        self.importing.toggle()
//                        self.makeToast(msg: "error.importing".trad(), type: .error)
//                        error=true
//                    }else{
//                        for doc in snap!.documents{
//                            Player.createPlayer(player: Player(name: doc.get("name") as! String, number: doc.get("number") as! Int, team: doc.get("team") as! Int, active: doc.get("active") as! Int, birthday: Date(timeIntervalSince1970: doc.get("birthday") as! TimeInterval), position: PlayerPosition(rawValue: doc.get("position") as? String ?? "universal")!, id: doc.get("id") as! Int))
//                        }
//                        self.newImport()
//                        deviceRef.collection("player_measures").getDocuments(){ (snap, err) in
//                            if let err = err {
//                                self.importing.toggle()
//                                self.makeToast(msg: "error.importing".trad(), type: .error)
//                                error=true
//                            }else{
//                                for doc in snap!.documents{
//                                    PlayerMeasures.create(measure: PlayerMeasures(id: doc.get("id") as! Int, player: Player.find(id: doc.get("player") as! Int)!, date: Date(timeIntervalSince1970: doc.get("date") as! TimeInterval), height: doc.get("height") as! Int, weight: doc.get("weight") as! Double, oneHandReach: doc.get("oneHandReach") as! Int, twoHandReach: doc.get("twoHandReach") as! Int, attackReach: doc.get("attackReach") as! Int, blockReach: doc.get("blockReach") as! Int, breadth: doc.get("breadth") as! Int))
//                                }
//                                self.newImport()
//                            }
//                        }
//                        deviceRef.collection("rotations").getDocuments(){ (snap, err) in
//                            if let err = err {
//                                self.importing.toggle()
//                                self.makeToast(msg: "error.importing".trad(), type: .error)
//                                error=true
//                            }else{
//                                for doc in snap!.documents{
//                                    Rotation.create(rotation: Rotation(id: doc.get("id") as! Int, name: doc.get("name") as? String, team: Team.find(id: doc.get("team") as! Int)!, one: Player.find(id: doc.get("one") as! Int), two: Player.find(id: doc.get("two") as! Int), three: Player.find(id: doc.get("three") as! Int), four: Player.find(id: doc.get("four") as! Int), five: Player.find(id: doc.get("five") as! Int), six: Player.find(id: doc.get("six") as! Int)), force: true)
//                                }
//                                self.newImport()
//                                deviceRef.collection("sets").getDocuments(){ (snap, err) in
//                                    if let err = err {
//                                        self.importing.toggle()
//                                        self.makeToast(msg: "error.importing".trad(), type: .error)
//                                        error=true
//                                    }else{
//                                        for doc in snap!.documents{
////                                            print( doc.data())
//                                            Set.createSet(set: Set(
//                                                id: doc.get("id") as! Int,
//                                                number: doc.get("number") as! Int,
//                                                first_serve: doc.get("first_serve") as! Int,
//                                                match: doc.get("match") as! Int,
//                                                rotation: Rotation.find(id: doc.get("rotation") as! Int) ?? Rotation(),
//                                                liberos: doc.get("liberos") as! [Int?],
//                                                result: doc.get("result") as! Int,
//                                                score_us: doc.get("score_us") as! Int,
//                                                score_them: doc.get("score_them") as! Int,
//                                                gameMode: doc.get("gameMode") as? String ?? "6-6"))
//                                        }
//                                        self.newImport()
//                                    }
//                                }
//                                deviceRef.collection("stats").getDocuments(){ (snap, err) in
//                                    if let err = err {
//                                        self.importing.toggle()
//                                        self.makeToast(msg: "error.importing".trad(), type: .error)
//                                        error=true
//                                    }else{
//                                        for doc in snap!.documents{
//                                            var r = Rotation.find(id: doc.get("rotation") as! Int)
//                                            if r != nil{
//                                                Stat.createStat(stat: Stat(
//                                                    id: doc.get("id") as! Int,
//                                                    match: doc.get("match") as! Int,
//                                                    set: doc.get("set") as! Int,
//                                                    player: doc.get("player") as! Int,
//                                                    action: doc.get("action") as! Int,
//                                                    rotation: r!,
//                                                    rotationTurns: doc.get("rotationTurns") as! Int,
//                                                    rotationCount: doc.get("rotationCount") as! Int,
//                                                    score_us: doc.get("score_us") as! Int,
//                                                    score_them: doc.get("score_them") as! Int,
//                                                    to: doc.get("to") as! Int,
//                                                    stage: doc.get("stage") as! Int,
//                                                    server: doc.get("server") as! Int,
//                                                    player_in: doc.get("player_in") as? Int,
//                                                    detail: doc.get("detail") as! String,
//                                                    setter: Player.find(id: doc.get("setter") as? Int ?? 0)
//                                                ))
//                                            } else {
//                                                print(doc.get("id") as! Int, doc.get("rotation") as! Int)
//                                            }
//                                        }
//                                        self.newImport()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                deviceRef.collection("player_teams").getDocuments(){ (snap, err) in
//                    if let err = err {
//                        self.importing.toggle()
//                        self.makeToast(msg: "error.importing".trad(), type: .error)
//                        error=true
//                    }else{
//                        for doc in snap!.documents{
//                            Player.importTeams(id:doc.get("id") as! Int, player: doc.get("player") as! Int, team: doc.get("team") as! Int, position: doc.get("position") as? String ?? PlayerPosition.universal.rawValue, number: doc.get("number") as? Int ?? 0, active: doc.get("active") as? Int ?? 0)
//                        }
//                        self.newImport()
//                    }
//                }
//                deviceRef.collection("tournaments").getDocuments(){ (snap, err) in
//                    if let err = err {
//                        self.importing.toggle()
//                        self.makeToast(msg: "error.importing".trad(), type: .error)
//                        error=true
//                    }else{
//                        for doc in snap!.documents{
//                            Tournament.create(tournament: Tournament(id: doc.get("id") as! Int, name: doc.get("name") as! String, team: Team.find(id: doc.get("team") as! Int)!, location: doc.get("location") as! String, startDate: Date(timeIntervalSince1970: doc.get("startDate") as! TimeInterval), endDate: Date(timeIntervalSince1970: doc.get("endDate") as! TimeInterval)))
//                        }
//                        self.newImport()
//                        deviceRef.collection("matches").getDocuments(){ (snap, err) in
//                            if let err = err {
//                                self.importing.toggle()
//                                self.makeToast(msg: "error.importing".trad(), type: .error)
//                                error=true
//                            }else{
//                                for doc in snap!.documents{
//                                    Match.createMatch(match: Match(opponent: doc.get("opponent") as! String, date:Date(timeIntervalSince1970: doc.get("date") as! TimeInterval), location: doc.get("location") as! String, home: doc.get("home") as! Bool, n_sets: doc.get("n_sets") as! Int, n_players: doc.get("n_players") as! Int, team: doc.get("team") as! Int, league: doc.get("league") as! Bool, tournament: Tournament.find(id: doc.get("tournament") as! Int), id: doc.get("id") as! Int))
//                                }
//                                self.newImport()
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        
        
        
//        self.importing.toggle()
        
        
        
        
        
//        self.loading = true
//        db.collection("backups").document(Auth.auth().currentUser!.uid).getDocument{ snap, err in
//            if err != nil{
//                print(err!.localizedDescription)
//                return
//            }
//            if snap != nil{
//                let csv = snap!.get("data") as! String
//                DB.fillFromCsv(csv: csv)
////                self.getAllTeams()
////                self.getAllExercises()
////                if !self.allTeams.isEmpty && self.selected < self.allTeams.count{
////                    self.getScouts(team: self.team())
////                    self.getMatchesElements(team: self.team())
////                }
////        if !error{
//            self.importing.toggle()
//            self.makeToast(msg: "data.imported".trad(), type: .success)
//        }else{
//            print("error reading")
//            self.makeToast(msg: "error.importing".trad(), type: .error)
//        }
//        }
        
    }
    
    func newImport(){
        self.countTransferred += 1
        if self.countTransferred == 9{
            self.importing.toggle()
            self.makeToast(msg: "data.imported".trad(), type: .success)
        }
    }
    
}
