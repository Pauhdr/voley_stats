import SwiftUI
import UIPilot
let quickNotes={}
struct QuickNoteExercise: View {
    @ObservedObject var viewModel: QuickNoteExerciseModel
    let statb = RoundedRectangle(cornerRadius: 10.0, style: .continuous)
    var body: some View {
        VStack{
//            Text("quick.note.title".trad()).font(.title.bold()).padding(.bottom)
            HStack {
                ZStack{
                    statb.fill(.gray)
                    HStack{
                        ZStack{
                            statb.fill(viewModel.player?.id == nil ? .black.opacity(0.4) : viewModel.player?.id == 0 ? .red : .blue)
                            Text("\(viewModel.player?.name ?? "player".trad())")
                        }
                        ZStack{
                            statb.fill(viewModel.area != nil ? .red : .black.opacity(0.4))
                            Text("\(viewModel.area?.trad() ?? "area".trad())")
                        }
                    }.frame(maxHeight: 90/2).padding()
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
                        viewModel.saveImprove()
                    }
                }.frame(maxWidth: 90*5)
            }.frame(maxHeight:90)
            HStack{
                VStack{
                    HStack{
                        Text("players".trad()).font(.headline)
                        Button(action:{
                            viewModel.edit.toggle()
                        }){
                            Image(systemName: "square.and.pencil")
                        }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(.white)
                    }
//                    ZStack{
//                        statb.fill(.orange).frame(maxHeight: 90)
//                        VStack {
//                            Text("all".trad())
//                        }.foregroundColor(.white)
//                    }.onTapGesture {
//                        viewModel.player = Player(name: "All", number: 0, team: 0, active:1, id: 0)
//                    }.frame(height: 90)
                    ScrollView(.vertical){
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
                    }.frame(maxWidth: 90*2, maxHeight: .infinity)
                }.frame(maxWidth: 90*2, maxHeight: .infinity).padding(.top)
                VStack{
                    Text("areas".trad()).font(.headline)
                    let areas = Array(qns.keys)
                    HStack{
                        ForEach(areas[..<3], id:\.self){area in
                            ZStack{
                                statb.fill(.pink)
                                VStack {
                                    Text("\(area.trad())")
                                }.foregroundColor(.white)
                            }.frame(maxHeight:90).onTapGesture {
                                viewModel.area = area
                            }
                        }
                    }
                    HStack{
                        ForEach(areas[3...], id:\.self){area in
                            ZStack{
                                statb.fill(.pink)
                                VStack {
                                    Text("\(area.trad())")
                                }.foregroundColor(.white)
                            }.frame(maxHeight:90).onTapGesture {
                                viewModel.area = area
                            }
                        }
                    }.padding(.bottom)
                    Text("comments".trad()).font(.headline)
                    VStack{
                        ScrollView{
                       
                            if(viewModel.area != nil){
                                ForEach(qns[viewModel.area!] ?? [], id:\.self){qn in
                                    ZStack{
                                        statb.fill(viewModel.comment == qn ? .yellow : .gray)
                                        VStack {
                                            Text("\(qn.comments.trad())")
                                        }.foregroundColor(.white)
                                    }.onTapGesture {
                                        viewModel.comment = qn
                                    }.frame(height:90)
                                }
                                TextField("", text: $viewModel.newComment).textFieldStyle(TextFieldPlus())
                                    .padding(.vertical)
                            }else{
                                Text("area.not.selected".trad())
                            }
                        }
//                        .frame(minHeight: .infinity)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }.padding(.top)
            }.frame(maxHeight:.infinity, alignment: .top)
        }
        .background(Color.swatch.dark.high)
        .frame(maxHeight: .infinity).padding().onAppear{
            viewModel.getPlayers()
        }
    }
    //#-learning-task(createDetailView)
}


class QuickNoteExerciseModel: ObservableObject{
    @Published var player:Player?=nil
    @Published var area:String?=nil
    @Published var comment:QuickNote?=nil
    @Published var newComment:String=""
    @Published var edit:Bool = false
    @Published var allPlayers:[Player]=[]
    @Published var activePlayers:[Player]=[]
    let appPilot: UIPilot<AppRoute>
    let team: Team
    let exercise: Exercise
    
    
    init(pilot: UIPilot<AppRoute>, team: Team, exercise: Exercise){
        self.appPilot=pilot
        self.team = team
        self.exercise = exercise
    }
    func undo(){
        
    }
    func getPlayers(){
        self.allPlayers = self.team.players()
        self.activePlayers = self.team.activePlayers()
    }
    func clear(){
        player=nil
        area=nil
        comment=nil
    }
    func saveImprove(){
        if (player != nil && area != nil){
            var c = self.comment?.comments ?? ""
            if (self.newComment != ""){
                c = self.newComment
            }
            let newImprove = Improve(player: self.player!, area: self.area!, comment: c, date: Date(), exercise: self.exercise)
            let imp = Improve.createImprove(improve: newImprove)
            if imp != nil {
                self.clear()
            }
        }
    }
    
}




