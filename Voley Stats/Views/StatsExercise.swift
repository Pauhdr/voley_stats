import SwiftUI
import UIPilot

struct StatExercise: View {
    @ObservedObject var viewModel: StatExerciseModel
    var sq: CGFloat = 90
    let actions: [[Action]] = Action.all()
    let statb = RoundedRectangle(cornerRadius: 10.0, style: .continuous)
    
    var body: some View {
        VStack {
//            Text("capture.training".trad()).font(.title.bold())
            HStack {
                ZStack{
                    statb.fill(.gray)
                    HStack{
                        ZStack{
                            statb.fill(viewModel.player?.id == nil ? .black.opacity(0.4) : viewModel.player?.id == 0 ? .pink : .blue)
                            Text("\(viewModel.player?.name ?? "player".trad())")
                        }
                        ZStack{
                            statb.fill(viewModel.action?.color() ?? .black.opacity(0.4))
                            Text("\(viewModel.action?.name ?? "action".trad())")
                        }
                        
                    }.frame(maxHeight: sq/2).padding()
                }
                
                HStack {
                    ZStack{
                        statb.fill(.pink)
                        Text("clear".trad()).foregroundColor(.white)
                        
                    }.onTapGesture {
                        viewModel.clear()
                    }
                    ZStack{
                        statb.fill(.pink)
                        Text("undo".trad()).foregroundColor(.white)
                        
                    }.onTapGesture {
                        viewModel.undo()
                    }
                    ZStack{
                        statb.fill(.blue)
                        
                        Text("enter".trad()).foregroundColor(.white)
                    }.onTapGesture {
                        viewModel.saveAction()
                    }
                }.frame(maxWidth: sq*4)
            }.frame(maxHeight: sq).padding(.horizontal)
            
            HStack (alignment: .top) {
                VStack{
                    HStack{
                        Text("players".trad()).font(.headline)
                        Button(action:{
                            viewModel.edit.toggle()
                        }){
                            if viewModel.edit {
                                Text("save".trad())
                            } else {
                                Image(systemName: "square.and.pencil")
                            }
                            
                        }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(.white)
                    }
                    ScrollView{
                        var players = viewModel.edit ? viewModel.allPlayers : viewModel.activePlayers
                        ForEach(players, id:\.id){player in
                            ZStack{
                                statb.fill(player.active == 1 ? .blue : .gray).frame(maxHeight: 90)
                                VStack {
                                    if(viewModel.edit){
                                        if (player.active == 1){
                                            Button(action:{
                                                player.active = 0
                                                if player.update() {
                                                    viewModel.getPlayers()
                                                }
                                            }){
                                                Image(systemName: "eye.fill").font(.caption)
                                            }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                        }else{
                                            Button(action:{
                                                player.active = 1
                                                if player.update() {
                                                    viewModel.getPlayers()
                                                }
                                            }){
                                                Image(systemName: "eye.slash.fill").font(.caption)
                                            }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                        }
                                    }
                                    Text("\(player.name)")
                                }.foregroundColor(.white)
                            }.onTapGesture {
                                viewModel.player = player
                            }.frame(height: 90)
                        }
                    }
                }.frame(maxWidth: sq*2)
                VStack {
                    Text("actions".trad()).font(.headline)
                    HStack {
                        ForEach(actions, id:\.self){sub in
                            VStack{
                                ForEach(sub, id:\.id){action in
                                    ZStack{
                                        statb.fill(action.color())
                                        Text("\(action.name.trad())").foregroundColor(.white).padding(5)
                                    }.clipped().onTapGesture {
                                        viewModel.actionTap(action: action)
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }.padding()
        }
        .background(Color.swatch.dark.high)
        .frame(maxHeight: .infinity)
        .font(.custom("stats", size: 12))
        .onAppear{
            viewModel.getPlayers()
        }
        
    }
}

class StatExerciseModel: ObservableObject{
    @Published var action: Action? = nil
    @Published var player: Player? = nil
    @Published var edit:Bool = false
    @Published var allPlayers:[Player]=[]
    @Published var activePlayers:[Player]=[]
    let team: Team
    let exercise: Exercise
    var lastStat:Improve? = nil
    
    //    let appPilot: UIPilot<AppRoute>
    init(team: Team, exercise:Exercise){
        self.exercise = exercise
        self.team = team
        //        self.appPilot = pilot
        
    }
    
    func actionTap(action: Action){
        self.action = action
    }
    func clear(){
        self.action = nil
        self.player = nil
    }
    func undo(){
        if (lastStat != nil){
            self.action = Action.find(id: Int(lastStat!.comment)!)
            self.player = lastStat?.player
            lastStat!.delete()
            lastStat=nil
        }
    }
    
    func getPlayers(){
        self.allPlayers = self.team.players()
        self.activePlayers = self.team.activePlayers()
    }
    
    func saveAction() {
        if (player != nil && action != nil){
            let newImprove = Improve(
                player: self.player!,
                area: self.action!.getArea(),
                comment: String(self.action!.id),
                date: Date(),
                exercise: self.exercise
            )
            let imp = Improve.createImprove(improve: newImprove)
            if imp != nil {
                self.lastStat = imp
                self.clear()
            }
        }
    }
}





