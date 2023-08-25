import SwiftUI
import UIPilot

struct TeamData: View {
    @ObservedObject var viewModel: TeamDataModel
    var body: some View {
        VStack {
//            Text("team.data".trad()).font(.title)
            HStack(alignment: .top) {
                if (viewModel.team != nil){
                    VStack {
                        Text("players".trad()).font(.title).padding()
                        Divider().background(Color.gray)
                        ScrollView(.vertical, showsIndicators: false){
                            ForEach(viewModel.players, id:\.id){player in
                                NavigationLink(destination: PlayerView(viewModel: PlayerViewModel(player: player))){
                                    HStack {
                                        if (player.active == 1){
                                            Button(action:{
                                                player.active = 0
                                                if player.update(){
                                                    viewModel.getPlayers()
                                                }
                                            }){
                                                Image(systemName: "eye.fill")
                                            }
                                        }else{
                                            Button(action:{
                                                player.active = 1
                                                if player.update(){
                                                    viewModel.getPlayers()
                                                }
                                            }){
                                                Image(systemName: "eye.slash.fill").foregroundColor(.gray)
                                            }
                                        }
                                        Text("\(player.number)").padding()
                                        Text("\(player.name)").frame(maxWidth: .infinity, alignment: .leading)
    //                                    Button(action:{
    //                                        viewModel.insertPlayer(player: player)
    //                                    }){
                                        
    //                                        Image(systemName: "square.and.pencil")
                                        
                                        Button(action:{
    //                                        viewModel.deleteDialog.toggle()
                                            
                                            if viewModel.deletePlayer(player: player){
                                                viewModel.getPlayers()
                                            }
                                        }){
                                            Image(systemName: "multiply")
                                        }.padding()
                                    }.frame(maxWidth: .infinity)
                                        .confirmationDialog("player.delete.description".trad(), isPresented: $viewModel.deleteDialog, titleVisibility: .visible){
                                            Button("player.delete".trad(), role: .destructive){
                                                if player.delete(){
                                                    viewModel.getPlayers()
                                                }
                                                
                                            }
                                        }
                                }
                                Divider().background(Color.gray)
                            }
                        }.padding()
                        Button(action:{
                            viewModel.insertPlayer(player: nil)
                        }){
                            Image(systemName: "plus")
                            Text("player.add".trad())
                        }.padding().foregroundColor(Color.cyan)
                    }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 25.0, style: .circular)).padding()
                    
                }
                VStack{
                    
                    VStack{
                        Section{
                            VStack{
                                VStack(alignment: .leading){
                                    Text("name".trad()).font(.caption)
                                    TextField("name".trad(), text: $viewModel.name).textFieldStyle(TextFieldDark())
                                }.padding(.bottom)
                                VStack(alignment: .leading){
                                    Text("organization".trad()).font(.caption)
                                    TextField("organization".trad(), text: $viewModel.organization).textFieldStyle(TextFieldDark())
                                }.padding(.bottom)
                                HStack{
                                    Text("category".trad()).frame(maxWidth: .infinity, alignment: .leading)
                                    Picker(selection: $viewModel.categoryId, label: Text("category".trad())) {
                                        Text("pick.one".trad()).tag(0)
                                        Text("Benjamin").tag(1)
                                        Text("Alevin").tag(2)
                                        Text("Infantil").tag(3)
                                        Text("Cadete").tag(4)
                                        Text("Juvenil").tag(5)
                                        Text("Junior").tag(6)
                                        Text("Senior").tag(7)
                                    }
                                }.padding(.bottom)
                                VStack(alignment: .leading){
                                    Text("gender".trad()).font(.caption)
                                    Picker(selection: $viewModel.genderId, label: Text("gender".trad())) {
                                        //                            Text("Pick one").tag(0)
                                        Text("male".trad()).tag(1)
                                        Text("female".trad()).tag(2)
                                    }.pickerStyle(.segmented)
                                }
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        }
                        Spacer()
                        Section{
                            VStack{
                                ColorPicker("Color", selection: $viewModel.color)
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Spacer()
                        Button(action:{viewModel.onAddButtonClick()}){
                            Text("save".trad())
                        }.frame(maxWidth: .infinity, alignment: .center).disabled(viewModel.emptyFields()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan)
                        Button(action:{viewModel.deleteTeam()}){
                            HStack{
                                Text("team.delete.title".trad())
                                Image(systemName: "trash.fill").padding(.horizontal)
                            }
                        }.frame(maxWidth: .infinity, alignment: .center).disabled(viewModel.team == nil).padding().background(viewModel.team == nil ? .white.opacity(0.1) : .red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor( viewModel.team == nil ? .gray : .red )
                        Spacer()
                        Spacer()
//                        Spacer()
//                        Spacer()
                    }.padding()
                }
            }.frame(maxHeight: .infinity, alignment: .top)
        }
        .background(Color.swatch.dark.high).foregroundColor(.white)
        .onAppear {
            viewModel.getPlayers()
        }
        .navigationTitle("team.data".trad())
        //#-learning-task(createDetailView)
    }
}

class TeamDataModel: ObservableObject{
    @Published var deleteDialog: Bool = false
    @Published var name: String = ""
    @Published var organization: String = ""
    @Published var selectedColor: Int = 0
    var category: Array = ["pick.one".trad(), "Benjamin", "Alevin", "Infantil", "Cadete", "Juvenil", "Junior", "Senior"]
    @Published var categoryId: Int = 0
    var gender: Array = ["pick.one".trad(), "Male", "Female"]
    @Published var genderId: Int = 0
    @Published var team: Team? = nil
    @Published var players: [Player] = []
    @Published var showAlert: Bool = false
    @Published var color: Color = .orange
    private let appPilot: UIPilot<AppRoute>
    var update: Bool = false
    
    init(pilot: UIPilot<AppRoute>, team: Team?){
        self.appPilot=pilot
        self.team = team
        name = team?.name ?? ""
        organization = team?.orgnization ?? ""
        categoryId = category.firstIndex(of: team?.category ?? "pick.one".trad())!
        genderId = gender.firstIndex(of: team?.gender ?? "pick.one".trad())!
        color = team?.color ?? .orange
    }
    func insertPlayer(player: Player?){
        if team != nil {
            update = true
            appPilot.push(.InsertPlayer(team: team, player: player))
        }
    }
    func deletePlayer(player: Player) -> Bool {
        if player.team == self.team!.id {
            player.team = 0
            return player.update()
        }else{
            return team!.deletePlayer(player: player)
        }
    }
    func deleteTeam(){
        if self.team != nil {
            if self.team!.delete(){
                appPilot.pop()
            }
        }
    }
    func emptyFields() -> Bool{
        return genderId == 0 || categoryId == 0 || name.isEmpty || organization.isEmpty
    }
    func getPlayers(){
        players = self.team?.players() ?? []
    }
    func onAddButtonClick(){
        if(name == "" || organization == "" || genderId == 0 || categoryId == 0) {
            showAlert = true
        }else{
            if self.team != nil {
                team?.name = name
                team?.category = category[categoryId]
                team?.gender = gender[genderId]
                team?.orgnization = organization
                let updated = team?.update()
                if (updated ?? false){
                    appPilot.pop()
                }
            }else{
                let newTeam = Team(name: name, organization: organization, category: category[categoryId], gender: gender[genderId], color: color, id: nil)
                let id = Team.createTeam(team: newTeam)
                if id != nil {
                    appPilot.pop()
                }
            }
        }
        
    }
}


