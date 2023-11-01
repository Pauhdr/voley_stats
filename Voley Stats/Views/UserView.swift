import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
    @EnvironmentObject var network : NetworkMonitor
    var body: some View {
        VStack{
            VStack{
                HStack{
                    HStack{
                        Text("data.import".trad())
                        Image(systemName: "square.and.arrow.down").padding(.horizontal)
                    }.frame(maxWidth: .infinity)
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture {
                    if network.isConnected{
                        viewModel.loading=true
                        viewModel.importFromFirestore()
                    }
                }
                HStack{
                    HStack{
                        Text("data.export".trad())
                        Image(systemName: "square.and.arrow.up").padding(.horizontal)
                    }.frame(maxWidth: .infinity)
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding().onTapGesture {
                    if network.isConnected{
                        viewModel.saveFirestore(txt: DB.createCSVString())
                    }
                }
                
                CollapsibleListElement(title: "languaje".trad()){
                    VStack{
                        HStack{
                            Text("spanish".trad()).frame(maxWidth: .infinity)
                            if viewModel.lang == "es" {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.lang = "es"
                            UserDefaults.standard.set("es", forKey: "locale")
                            viewModel.langChanged.toggle()
                        }
                        HStack{
                            Text("english".trad()).frame(maxWidth: .infinity)
                            if viewModel.lang == "en" {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                            viewModel.lang = "en"
                            UserDefaults.standard.set("en", forKey: "locale")
                            viewModel.langChanged.toggle()
                        }
                    }
                }
            }
                .frame(maxHeight: .infinity, alignment: .top)
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("user.area".trad())
    }
}
class UserViewModel: ObservableObject{
    @Published var lang: String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @Published var langChanged:Bool = false
    @Published var loading:Bool = false
    init(){
    }
    func saveFirestore(txt: String){
        let db = Firestore.firestore()
        db.collection("backups").document("userid").setData(["data":txt, "date":Date().timeIntervalSince1970]){err in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
        }
    }
    func importFromFirestore(){
        let db = Firestore.firestore()
//        self.loading = true
        db.collection("backups").document("userid").getDocument{ snap, err in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            if snap != nil{
                let csv = snap!.get("data") as! String
                DB.fillFromCsv(csv: csv)
//                self.getAllTeams()
//                self.getAllExercises()
//                if !self.allTeams.isEmpty && self.selected < self.allTeams.count{
//                    self.getScouts(team: self.team())
//                    self.getMatchesElements(team: self.team())
//                }
                self.loading = false
            }else{
                print("error reading")
            }
        }
        
    }
    
    
}
