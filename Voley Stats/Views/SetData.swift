import SwiftUI
import UIPilot

struct SetData: View {
    @ObservedObject var viewModel: SetDataModel
//    @Binding var rootActive:Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack (alignment: .center){
            VStack {
                VStack{
                    VStack{
                        Text("first.serve".trad().uppercased()).font(.caption).foregroundColor(.gray).padding(.horizontal)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    VStack{
                        Text("first.serve".trad()).frame(maxWidth: .infinity, alignment: .leading).font(.caption)
                        Picker(selection: $viewModel.first_serve, label: Text("first.serve".trad())) {
                            //                        Text("Pick one").tag(0)
                            Text("us".trad()).tag(1)
                            Text("them".trad()).tag(2)
                        }.pickerStyle(.segmented)
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                rotation().padding(.top)
                liberosForm().padding(.top)
                NavigationLink(destination: StatsView(viewModel: StatsViewModel(pilot: viewModel.appPilot, team: viewModel.team, match: viewModel.match, set: viewModel.set)), isActive: $viewModel.saved){
                    Button(action:{
                        viewModel.onAddButtonClick()
                        
                    }){
                        Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                    }.disabled(viewModel.validate()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.validate() ? .gray : .cyan).padding(.top)
                }
            }.padding()
        }.frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("setup".trad() + " set \(viewModel.number)")
        .background(Color.swatch.dark.high).foregroundColor(.white)
        
        .onAppear{
            viewModel.players = viewModel.team.activePlayers()
        }
    }
    @ViewBuilder
    func liberosForm()-> some View {
        VStack{
            VStack{
                Text("LIBEROS").font(.caption).foregroundColor(.gray).padding(.horizontal)
            }.frame(maxWidth: .infinity, alignment: .leading)
            VStack{
                Toggle("liberos.activate".trad(), isOn: $viewModel.hasLiberos).disabled(viewModel.match.n_players<6).tint(.cyan)
                if viewModel.hasLiberos{
                    HStack{
                        Text("Libero 1:").frame(maxWidth: .infinity, alignment:.leading)
                        Picker(selection: $viewModel.liberos[0], label: Text("Libero 1")) {
                            Text("pick.one".trad()).tag(0)
                            ForEach(viewModel.players, id:\.id){player in
                                HStack{
                                    if (viewModel.rotation.contains(player) && viewModel.liberos[0] != player.id){
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                    Text("\(player.name)").tag(player.id)
                                }
                                
                            }
                        }
                    }
                    HStack{
                        Text("Libero 2:").frame(maxWidth: .infinity, alignment:.leading)
                        Picker(selection: $viewModel.liberos[1], label: Text("Libero 2")) {
                            Text("pick.one".trad()).tag(0)
                            ForEach(viewModel.players, id:\.id){player in
                                HStack{
                                    if (viewModel.rotation.contains(player) && viewModel.liberos[1] != player.id){
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                    Text("\(player.name)").tag(player.id)
                                }
                                
                            }
                        }
                    }
                }
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    @ViewBuilder
    func rotation() -> some View{
        VStack{
            VStack{
                Text("rotation".trad().uppercased()).font(.caption).foregroundColor(.gray).padding(.horizontal)
            }.frame(maxWidth: .infinity, alignment: .leading)
            HStack{
                Spacer()
                Court(rotation: $viewModel.rotation, numberPlayers: viewModel.match.n_players, showName: true, editable: true, teamPlayers: viewModel.players).padding(.vertical)
                Spacer()
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).frame(maxWidth: .infinity)
        }.frame(maxWidth: .infinity)
    }
}

class SetDataModel: ObservableObject{
    @Published var number: Int = 0
    @Published var first_serve: Int = 0
    @Published var showAlert: Bool = false
    @Published var liberos: Array = [0, 0]
    @Published var hasLiberos: Bool = false
    @Published var players: [Player] = []
    @Published var saved:Bool = false
    var match: Match
    @Published var rotation: [Player?]=[nil, nil, nil, nil, nil, nil]
    var set: Set
    let team: Team
    let appPilot: UIPilot<AppRoute>
    
    init(pilot: UIPilot<AppRoute>, team: Team, match: Match, set: Set){
        self.appPilot=pilot
        self.number = set.number
        self.first_serve = set.first_serve
        self.match = match
        self.set = set
        self.team = team
//        rotation = [0,0,0,0,0,0]
    }
    func validate()->Bool{
        return first_serve==0 || rotation.count < match.n_players
    }
    func onAddButtonClick(){
        set.number = number
        set.first_serve = first_serve
        set.match = match.id
        set.liberos = liberos
        if(validate()){
            showAlert = true
        }else {
//            let r = rotation.map{Player.find(id: $0)}
            let rotationObj = rotation//+[Player?](repeating: nil, count: 6-match.n_players)
            let newr = Rotation.create(rotation: Rotation(team: self.team, one: rotationObj[0], two: rotationObj[1], three: rotationObj[2], four: rotationObj[3], five: rotationObj[4], six: rotationObj[5]))
            if newr != nil{
                set.rotation = newr!
                if set.update() {
                    self.saved = true
                }
            }
        }
        showAlert = false
    }
}


