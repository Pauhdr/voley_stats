import SwiftUI
import UIPilot

struct TeamData: View {
    @ObservedObject var viewModel: TeamDataModel
    @EnvironmentObject var path: PathManager
    let colors : [Color] = [.red, .blue, .green, .orange, .purple, .gray]
//    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @Environment(\.dismiss) var dismiss
//    @available(iOS 16.0, *)
//    @available(iOS 16.0, *)
    var body: some View {
            VStack {
                //            Text("team.data".trad()).font(.title)
                //            if viewModel.load{
                //                ProgressView()
                //            }else{
                HStack(alignment: .top) {
                    if (viewModel.team != nil){
                        VStack {
                            Text("players".trad()).font(.title).padding()
                            Divider().background(Color.gray)
                            ScrollView(.vertical, showsIndicators: false){
                                ForEach(viewModel.players, id:\.id){player in
//                                    NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: viewModel.team, player: player))){
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
                                                if player.team == viewModel.team!.id {
                                                    player.team = 0
                                                    if player.update(){
                                                        viewModel.getPlayers()
                                                    }
                                                }else{
                                                    if viewModel.team!.deletePlayer(player: player){
                                                        viewModel.getPlayers()
                                                    }
                                                }
                                            }){
                                                Image(systemName: "multiply")
                                            }.padding()
                                        }
                                        .padding(.horizontal)
                                        .background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(player.active == 1 ? 0.1 : 0.05)))
                                        .frame(maxWidth: .infinity)
                                        .confirmationDialog("player.delete.description".trad(), isPresented: $viewModel.deleteDialog, titleVisibility: .visible){
                                            Button("player.delete".trad(), role: .destructive){
                                                if player.delete(){
                                                    viewModel.getPlayers()
                                                }
                                                
                                            }
                                        }
                                    }
                                    //                                Divider().background(Color.gray)
                                }
                            }.padding()
                            Divider().background(Color.gray)
                            NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: viewModel.team!, player: nil))){
                                Image(systemName: "plus")
                                Text("player.add".trad())
                            }.padding().foregroundColor(Color.cyan)
                        }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding().frame(maxWidth: .infinity)
                        
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
                                    Text("Color").font(.caption).padding([.top, .leading]).frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                        //                                ColorPicker("Color", selection: $viewModel.color)
                                        HStack{
                                            ForEach(colors, id: \.self){color in
                                                ZStack{
                                                    //                                                if viewModel.color == color{
                                                    //                                                    Circle().fill(.white).frame(width: 45, height: 45)
                                                    //                                                }
                                                    Circle().strokeBorder(viewModel.color == color ? .white : .clear, lineWidth: 3)
                                                        .background(Circle().fill(color)).frame(width: 40, height: 40).onTapGesture{
                                                            viewModel.color = color
                                                        }
                                                    
                                                }.padding(.horizontal, 3)
                                            }
                                        }//.frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                                    }.padding()
                                }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Spacer()
                            Button(action:{
                                if viewModel.onAddButtonClick(){
//                                    path = []
                                    self.presentationMode.wrappedValue.dismiss()
//                                    dismiss()
                                }
                            }){
                                Text("save".trad())
                            }.frame(maxWidth: .infinity, alignment: .center).disabled(viewModel.emptyFields()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan)
                            if viewModel.team != nil{
                                Button(action:{
                                    if viewModel.team!.delete(){
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }){
                                    HStack{
                                        Text("team.delete.title".trad())
                                        Image(systemName: "trash.fill").padding(.horizontal)
                                    }
                                }.frame(maxWidth: .infinity, alignment: .center).disabled(viewModel.team == nil).padding().background(viewModel.team == nil ? .white.opacity(0.1) : .red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor( viewModel.team == nil ? .gray : .red )
                            }
                            Spacer()
                            Spacer()
                            //                        Spacer()
                            //                        Spacer()
                        }.padding()
                    }
                }.frame(maxHeight: .infinity, alignment: .top)
            }
        
        .onAppear{
            viewModel.getPlayers()
//            viewModel.load.toggle()
        }
        .background(Color.swatch.dark.high).foregroundColor(.white)
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
    @Published var load: Bool = true
    var update: Bool = false
    
    init(team: Team?){
        self.team = team
        name = team?.name ?? ""
        organization = team?.orgnization ?? ""
        categoryId = category.firstIndex(of: team?.category ?? "pick.one".trad())!
        genderId = gender.firstIndex(of: team?.gender ?? "pick.one".trad())!
        color = team?.color ?? .orange
//        self.getPlayers()
    }
    func emptyFields() -> Bool{
        return genderId == 0 || categoryId == 0 || name.isEmpty || organization.isEmpty
    }
    func getPlayers(){
        players = self.team?.players().sorted{ $0.number < $1.number} ?? []
    }
    func onAddButtonClick()->Bool{
        if(name == "" || organization == "" || genderId == 0 || categoryId == 0) {
            showAlert = true
        }else{
            if self.team != nil {
                team!.name = name
                team!.category = category[categoryId]
                team!.gender = gender[genderId]
                team!.orgnization = organization
                team!.color = color
                return team!.update()
            }else{
                let newTeam = Team(name: name, organization: organization, category: category[categoryId], gender: gender[genderId], color: color, id: nil)
                let id = Team.createTeam(team: newTeam)
                return id != nil
            }
        }
        return false
    }
}


