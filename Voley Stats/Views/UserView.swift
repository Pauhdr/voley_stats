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
                ZStack{
                    Text(viewModel.avatar).font(.system(size: 70))//.scaledToFit().lineLimit(1).frame(width: 100, height: 100)
                }.frame(width: 100, height: 100).background(.white.opacity(0.1)).clipShape(Circle()).frame(maxWidth: .infinity, alignment: .center)
//                Image(systemName: "person.circle.fill").resizable().scaledToFit().frame(width: 100, height: 100).frame(maxWidth: .infinity, alignment: .center)
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
                    VStack{
                        ZStack{
                            Text("season".trad()).font(.title).frame(maxWidth: .infinity)
                            Image(systemName: "gearshape.fill").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture{
                                viewModel.manageSeasons.toggle()
                            }
                        }
                        Text("\(viewModel.activeSeason ?? "no.season".trad())").font(.system(size: 60))
                    }.padding().background(.blue).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
                        viewModel.manageSeasons.toggle()
                    }
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
                    
                    CollapsibleListElement(title: "language".trad()){
                        VStack{
                            HStack{
                                Text("spanish".trad()).frame(maxWidth: .infinity)
                                if viewModel.lang == "es" {
                                    Image(systemName: "checkmark.circle.fill").padding(.horizontal)
                                }
                            }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                viewModel.lang = "es"
                                UserDefaults.standard.set("es", forKey: "locale")
                                viewModel.langChanged.toggle()
                                self.tab = "settings".trad()
                            }
                            HStack{
                                Text("english".trad()).frame(maxWidth: .infinity)
                                if viewModel.lang == "en" {
                                    Image(systemName: "checkmark.circle.fill").padding(.horizontal)
                                }
                            }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                viewModel.lang = "en"
                                UserDefaults.standard.set("en", forKey: "locale")
                                viewModel.langChanged.toggle()
                                self.tab = "settings".trad()
                            }
                        }.padding()
                    }
                    HStack{
                        if viewModel.closing{
                            ProgressView().progressViewStyle(CircularProgressViewStyle()).tint(.cyan).frame(maxWidth: .infinity, alignment: .center)
                        }else{
                            HStack{
                                Text("log.out".trad())
                                Image(systemName: "rectangle.portrait.and.arrow.right").padding(.horizontal)
                            }.frame(maxWidth: .infinity).foregroundStyle(network.isConnected ? .red : .gray)
                        }
                    }.padding().background(network.isConnected ? .red.opacity(0.1) : .white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture {
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
            .overlay(viewModel.manageSeasons ? addSeason() : nil)
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
    
    @ViewBuilder
        func addSeason() ->some View{
    //        let season = Season.active()!
            ZStack{
                Rectangle().fill(.black.opacity(0.7)).ignoresSafeArea()
                VStack{
                    ZStack{
                        Text("name.season".trad()).font(.title2).frame(maxWidth: .infinity, alignment: .center)
                        Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                            viewModel.manageSeasons.toggle()
                        }
                    }.padding().font(.title)
                    
                    VStack(alignment: .leading){
                        //                Text("opponent".trad()).font(.caption)
                        TextField("season".trad(), text: $viewModel.seasonName).textFieldStyle(TextFieldDark())
                    }.padding()
                    HStack{
                        Image(systemName: "info.circle").padding(.trailing)
                        Text("add.season.message".trad()).frame(maxWidth: .infinity, alignment: .leading)
                    }.padding()
                    if !network.isConnected{
                        HStack{
                            Image(systemName: "exclamationmark.triangle").foregroundStyle(.yellow).padding(.trailing)
                            Text("add.season.network.message".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        }.padding().background(.yellow.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
                    }
                    if viewModel.creating{
                        ProgressView().tint(.white).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8))
                    }else {
                        HStack{
                            Text("keep.teams".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.cyan).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                //                    season.delete(keepTeams: true)
                                viewModel.creating.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    viewModel.createSeason(backup: network.isConnected, keepTeams: true)
                                }
                                //                    if Season.create(season: Season(name: viewModel.seasonName), keepTeams: true) != nil{
                                //                        viewModel.seasons = Season.all()
                                //                        viewModel.newSeason.toggle()
                                //                    }
                            }
                            Text("keep.players".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.cyan).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                //                    season.delete(keepPlayers: true)
                                viewModel.creating.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    viewModel.createSeason(backup: network.isConnected, keepPlayers: true)
                                }
                                //                    if Season.create(season: Season(name: viewModel.seasonName), keepPlayers: true) != nil{
                                //                        viewModel.seasons = Season.all()
                                //                        viewModel.newSeason.toggle()
                                //                    }
                            }
                        }
                        Text("start.scratch".trad()).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.creating.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                viewModel.createSeason(backup: network.isConnected)
                            }
                            //                if Season.create(season: Season(name: viewModel.seasonName)) != nil{
                            //                    viewModel.seasons = Season.all()
                            //                    viewModel.newSeason.toggle()
                            //                }
                        }
                        Text("rename.current.season".trad()).padding().frame(maxWidth: .infinity).foregroundStyle(.cyan).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            //                    viewModel.creating.toggle()
                            UserDefaults.standard.set(viewModel.seasonName, forKey: "season")
                            viewModel.manageSeasons.toggle()
                            //                if Season.create(season: Season(name: viewModel.seasonName)) != nil{
                            //                    viewModel.seasons = Season.all()
                            //                    viewModel.newSeason.toggle()
                            //                }
                        }
                    }
                }.padding().foregroundStyle(.white).background(Color.swatch.dark.mid).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity, maxHeight: .infinity).padding()
                        }
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
    @Published var activeSeason:String? = UserDefaults.standard.string(forKey: "season")
    @Published var manageSeasons: Bool = false
    @Published var creating: Bool = false
    @Published var avatar: String
//    @Published var newSeason: Bool = false
    @Published var seasonName: String = "\("season".trad()) \(Date.now.formatted(.dateTime.year()))-\(Calendar.current.date(byAdding: .year, value: 1, to: Date.init())?.formatted(.dateTime.year()) ?? Date.now.formatted(.dateTime.year()))"
    init(){
        let a = UserDefaults.standard.string(forKey: "avatar")
        avatar = a ?? String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
        if a == nil {
            UserDefaults.standard.set(avatar, forKey: "avatar")
        }
    }
    func makeToast(msg: String, type: ToastType){
        self.msg = msg
        self.toastType = type
        self.showToast.toggle()
    
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
        }
    }
    func importFromFirestore(){
        DB.truncateDatabase()
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser!.uid
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
        }
    }
    
    func createSeason(backup: Bool, keepTeams: Bool = false, keepPlayers: Bool = false){
            //TODO: add loading state
            if backup{
                print("saving")
                self.saveFirestore()
            }
            if keepTeams{
                Match.all().forEach{$0.delete()}
                Tournament.all().forEach{$0.delete()}
                Rotation.all().forEach{$0.delete()}
            }else if keepPlayers {
                Team.all().forEach{$0.delete(deletePlayers: false)}
            }else{
                Team.all().forEach{$0.delete()}
            }
            UserDefaults.standard.set(self.seasonName, forKey: "season")
            self.creating.toggle()
//            self.newSeason.toggle()
            self.manageSeasons.toggle()
        }
    
    func newImport(){
        self.countTransferred += 1
        if self.countTransferred == 9{
            self.importing.toggle()
            self.makeToast(msg: "data.imported".trad(), type: .success)
        }
    }
    
}
