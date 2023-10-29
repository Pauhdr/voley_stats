import SwiftUI
import UIPilot

struct SetData: View {
    @ObservedObject var viewModel: SetDataModel
//    @Binding var rootActive:Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack (alignment: .center){
//            Text("setup".trad()+" set \(viewModel.number)").font(.title.bold())
            VStack {
//                Spacer()
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
//                Spacer()
                rotation()
//                Spacer()
                liberosForm()
//                Spacer()
                NavigationLink(destination: StatsView(viewModel: StatsViewModel(pilot: viewModel.appPilot, team: viewModel.team, match: viewModel.match, set: viewModel.set)), isActive: $viewModel.saved){
                    Button(action:{
//                        self.presentationMode.wrappedValue.dismiss()
                        viewModel.onAddButtonClick()
                        
                    }){
                        Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                    }.disabled(viewModel.validate()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.validate() ? .gray : .cyan)
                }
//                Spacer()
//                Spacer()
//                Spacer()
//                Spacer()
            }.padding()
        }.frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("setup".trad() + " set \(viewModel.number)")
        .background(Color.swatch.dark.high).foregroundColor(.white)
        
        .onAppear{
            viewModel.players = viewModel.team.activePlayers()
        }
        //#-learning-task(createDetailView)
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
                                    if (viewModel.rotation.contains(player.id) && viewModel.liberos[0] != player.id){
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
                                    if (viewModel.rotation.contains(player.id) && viewModel.liberos[1] != player.id){
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
            VStack{
                ForEach(1...viewModel.match.n_players, id:\.self){index in
                    HStack{
                        Text("\(index):").frame(maxWidth: .infinity, alignment: .leading)
                        Picker(selection: $viewModel.rotation[index-1], label: Text("\(index)")) {
                            Text("pick.one".trad()).tag(0)
                            ForEach(viewModel.players, id:\.id){player in
                                HStack{
                                    if (viewModel.rotation.contains(player.id) && viewModel.rotation[index-1] != player.id){
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
    @Published var rotation: Array<Int>
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
        rotation = [0,0,0,0,0,0]
    }
    func validate()->Bool{
        return first_serve==0 || rotation.filter{p in p != 0}.count < match.n_players
    }
    func onAddButtonClick(){
        set.number = number
        set.first_serve = first_serve
        set.match = match.id
        set.liberos = liberos
        if(validate()){
            showAlert = true
        }else {
            let r = rotation.map{Player.find(id: $0)}
            let newr = Rotation.create(rotation: Rotation(team: self.team, one: r[0], two: r[1], three: r[2], four: r[3], five: r[4], six: r[5]))
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


