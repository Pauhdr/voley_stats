import SwiftUI
import UIPilot

struct PlayerData: View {
    @ObservedObject var viewModel: PlayerDataModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
//            Text("player.new".trad()).font(.title)
            VStack{
                Section{
                    VStack{
                        VStack(alignment: .leading){
                            Text("number".trad()).font(.caption)
                            TextField("number".trad(), value: $viewModel.number, format: .number).textFieldStyle(TextFieldDark()).keyboardType(.numberPad)
//                            Stepper("\(viewModel.number)", value: $viewModel.number, in: 1...99)
                        }.padding(.bottom)
                        VStack(alignment: .leading){
                            Text("name".trad()).font(.caption)
                            TextField("name".trad(), text: $viewModel.name).textFieldStyle(TextFieldDark())
                        }
                        
                        
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                if viewModel.player != nil{
                    Section{
                        VStack{
                            DatePicker("birthday".trad(), selection: $viewModel.birthday, displayedComponents: [.date]).padding(.vertical, 3)
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                Button(action:{
                    viewModel.onAddButtonClick()
                    if viewModel.saved{
                        dismiss()
                    }
                }){
                    Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                }.disabled(viewModel.name.isEmpty || viewModel.number == 0).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor((viewModel.name.isEmpty || viewModel.number == 0) ? .gray : .cyan)
                if viewModel.team != nil && viewModel.player == nil{
                    Spacer()
                    Section{
                        HStack{
                            Text("player.restore".trad()).frame(maxWidth: .infinity, alignment: .leading)
                            Picker(selection: $viewModel.restored, label: Text("player.restore".trad())) {
                                Text("pick.one".trad()).tag(0)
                                ForEach(Player.deleted(), id:\.id){player in
                                    HStack{
                                        Text("\(player.name)").tag(player.id)
                                    }
                                }
                            }
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Button(action:{viewModel.restoreDialog.toggle()}){
                        Text("restore".trad()).frame(maxWidth: .infinity, alignment: .center)
                    }.disabled(viewModel.restored == 0).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.restored == 0 ? .gray : .cyan)
                        .confirmationDialog("restore.description".trad(), isPresented: $viewModel.restoreDialog, titleVisibility: .visible){
                            Button("restore".trad()){
                                viewModel.restorePlayer()
                                if viewModel.saved{
                                    dismiss()
                                }
                            }
                            Button("cancel".trad(), role: .cancel){}
                        }
                    Spacer()
                    Button(action:{viewModel.addFromTeam.toggle()}){
                        Text("add.from.team".trad()).frame(maxWidth: .infinity, alignment: .center)
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(.cyan)
                }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .sheet(isPresented: $viewModel.addFromTeam){
                VStack{
                    Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).onTapGesture {
                        viewModel.selectedTeam = nil
                        viewModel.selectedPlayers = []
                        viewModel.addFromTeam.toggle()
                    }.padding()
                    
                    if viewModel.selectedTeam == nil{
                        Text("pick.team".trad()).font(.title)
                        Spacer()
                        ForEach(viewModel.teams, id: \.id){team in
                            Text(team.name).padding().frame(height: 60).frame(maxWidth: .infinity).background(.white.opacity(0.1)).onTapGesture {
                                viewModel.selectedTeam = team
                            }
                        }
                    } else {
                        Text("pick.player".trad()).font(.title)
                        Spacer()
                        ForEach(viewModel.selectedTeam!.players(), id: \.id){player in
                            HStack{
                                if viewModel.selectedPlayers.contains(player) {
                                    Image(systemName: "checkmark.circle.fill").padding(.horizontal).font(.title2)
                                }else{
                                    Image(systemName: "circle").padding(.horizontal).font(.title2)
                                }
                                Text(player.name)
                            }.padding().frame(height: 60).frame(maxWidth: .infinity, alignment: .leading).background(.white.opacity(0.1)).onTapGesture {
                                viewModel.selectedPlayers.append(player)
                            }
                        }
                        Button(action:{
                            viewModel.addPlayers()
                            if viewModel.saved{
                                dismiss()
                            }
                        }){
                            Text("add.players".trad())
                        }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).frame(height: 60).frame(maxWidth: .infinity).foregroundColor(.cyan)
                    }
                    Spacer()
                }.padding().background(Color.swatch.dark.high).frame(maxWidth: .infinity, maxHeight:  .infinity)
            }
        
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("player.new".trad())
    }
}

class PlayerDataModel: ObservableObject{
    @Published var name: String = ""
    @Published var number: Int = 1
    @Published var birthday: Date = Date()
    var team: Team?
    var player: Player? = nil
    var teams:[Team]
    @Published var restored: Int = 0
    @Published var restoreDialog: Bool = false
    @Published var addFromTeam: Bool = false
    @Published var selectedTeam: Team? = nil
    @Published var selectedPlayers:[Player]=[]
    @Published var saved: Bool = false
    
    init(team: Team?, player: Player?){
        self.team = team ?? nil
        name = player?.name ?? ""
        number = player?.number ?? 0
        birthday = player?.birthday ?? Date()
        self.player = player
        self.teams = Team.all().filter{$0.id != team!.id}
    }
    func restorePlayer(){
        var player = Player.find(id: self.restored)!
        player.team = team!.id
        if player.update(){
            saved.toggle()
        }
    }
    func addPlayers(){
        selectedPlayers.forEach{p in
            team?.addPlayer(player: p)
        }
        saved.toggle()
    }
    func onAddButtonClick(){
        if self.player != nil {
            player?.name = name
            player?.number = number
            player?.birthday = birthday
            let updated = player?.update()
            if updated ?? false {
                saved.toggle()
            }
        }else{
            let newPlayer = Player(name: name, number: number, team: team?.id ?? 0, active:1, birthday: birthday, id: nil)
            let id = Player.createPlayer(player: newPlayer)
            if id != nil {
                saved.toggle()
            }
        }
        
        
    }
}



