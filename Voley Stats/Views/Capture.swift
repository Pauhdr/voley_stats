import SwiftUI
import UIPilot

struct Capture: View {
    @ObservedObject var viewModel: CaptureModel
    var sq: CGFloat = 90
    let actions: [[Action]] = Action.all()
    let statb = RoundedRectangle(cornerRadius: 10.0, style: .continuous)
    @State var showChange = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            HStack {
                ZStack{
                    statb.fill(.blue)
                    Text("\(viewModel.point_us)")
                }.overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(viewModel.serve==1 ? 1 : 0).padding().offset(x: 23.0, y: -23.0))
                    .overlay{
                        HStack{
                            ForEach(0..<viewModel.timeOuts.0, id:\.self){t in
                                Image(systemName: "t.circle.fill")
                            }
                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                    }
                    .onTapGesture{
                        viewModel.adjust.toggle()
                    }
                ZStack{
                    statb.fill(.pink)
                    Text("\(viewModel.point_them)")
                }.clipped().overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(viewModel.serve==2 ? 1 : 0).padding().offset(x: 20.0, y: -20.0))
                    .overlay{
                        HStack{
                            ForEach(0..<viewModel.timeOuts.1, id:\.self){t in
                                Image(systemName: "t.circle.fill")
                            }
                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                    }
                    .onTapGesture{
                        viewModel.adjust.toggle()
                    }
                ZStack{
                    statb.fill(.gray)
                    Text("time.out".trad())
                }.clipped().onTapGesture {
                    viewModel.showTimeout.toggle()
                }
                ZStack{
                    statb.fill(.blue)
                    Text("change.player".trad()).foregroundColor(.white)
                    
                }.clipped().onTapGesture {
                    if (viewModel.player != nil && viewModel.lastStat != nil){
//                        print(viewModel.nonLineup())
                        showChange.toggle()
                    } else {
                        viewModel.cantChange.toggle()
                    }
                }.alert(isPresented: $viewModel.cantChange){
                    Alert(title: Text("select.player".trad()))
                }
                ZStack{
                    statb.fill(.pink)
                    Text("their.player".trad()).foregroundColor(.white)
                    
                }.clipped().onTapGesture {
                    viewModel.player = Player(name: "their.player".trad(), number: 0, team: 0,active:1, birthday: Date(), id: 0)
                }
                ZStack{
                    VStack (spacing: 5){
                        Text("rotation".trad()).font(.body)
                        let players = viewModel.lineup()
                        if (viewModel.match.n_players==4){
                            VStack{
                                ZStack{
                                    statb.fill(.gray)
                                    Text("\(players[2].number)")
                                }
                                HStack {
                                    ZStack{
                                        statb.fill(.gray)
                                        Text("\(players[3].number)")
                                    }
                                    ZStack{
                                        statb.fill(.gray)
                                        Text("\(players[1].number)")
                                    }
                                }
                                ZStack {
                                    statb.fill(.gray)
                                    Text("\(players[0].number)")
                                }
                            }
                        } else {
                            VStack {
                                HStack{
                                    ZStack {
                                        statb.fill(.gray)
                                        Text("\(players[3].number)")
                                    }
                                    ZStack {
                                        statb.fill(.gray)
                                        Text("\(players[2].number)")
                                    }
                                    ZStack {
                                        statb.fill(.gray)
                                        Text("\(players[1].number)")
                                    }
                                    
                                }
                                HStack{
                                    ZStack {
                                        statb.fill(.gray)
                                        Text("\(players[4].number)")
                                    }
                                    ZStack {
                                        statb.fill(.gray)
                                        Text("\(players[5].number)")
                                    }
                                    ZStack {
                                        statb.fill(.gray)
                                        Text("\(players[0].number)")
                                    }
                                    
                                }
                            }
                        }
                    }
//                    Rectangle().fill(.clear)
                }.onTapGesture {
                    viewModel.showRotation.toggle()
                }
            }.frame(maxHeight: sq).padding(.horizontal)
            HStack {
                ZStack{
                    statb.fill(.gray)
                    HStack{
                        ZStack{
                            statb.fill(viewModel.player?.id == nil ? .black.opacity(0.4) : viewModel.player?.id == 0 ? .pink : .blue)
                            HStack{
                                if (viewModel.player != nil && viewModel.player?.id != 0){
                                    Text("\(viewModel.player?.number ?? 0)")
                                }
                                Text(" \(viewModel.player?.name ?? "player".trad())")
                            }
                            
                        }
                        ZStack{
                            statb.fill(viewModel.action?.color() ?? .black.opacity(0.4))
                            Text("\(viewModel.action?.name.trad().capitalized ?? "action".trad())")
                        }
                        ZStack{
                            statb.fill(viewModel.pointTo()?.1 == 1 ? .blue : viewModel.pointTo()?.1 == 2 ? .pink : .black.opacity(0.4))
                            Text("\(viewModel.pointTo()?.0.trad() ?? "to".trad())")
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
                VStack {
                    Text("current.lineup".trad()).font(.title3)
                    ForEach(viewModel.lineupPlayers.sorted(by: { $0.number < $1.number }), id:\.id){player in
                        ZStack{
                            statb.stroke(viewModel.player?.id == player.id ? .white : .clear, lineWidth: 3).background(statb.fill(.blue))
                            VStack {
                                Text("\(player.number)")
                                Text("\(player.name)")
                            }.foregroundColor(.white)
                        }.onTapGesture {
                            viewModel.player = player
                        }
                        .overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(player.id == viewModel.server ? 1 : 0).padding().offset(x: 40.0, y: -20.0))
                    }
                }.frame(maxWidth: sq*2)
                VStack {
                    Text("actions".trad()).font(.title3)
                    HStack {
                        ForEach(actions, id:\.self){sub in
                            VStack{
                                ForEach(sub, id:\.id){action in
                                    if action.id != 38{
                                        ZStack{
                                            statb.stroke(viewModel.action?.id == action.id ? .white : .clear, lineWidth: 3).background(statb.fill(action.color()))
                                            Text("\(action.name.trad().capitalized)").foregroundColor(.white).padding(5)
                                        }.onTapGesture {
                                            viewModel.actionTap(action: action)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }.padding()
        }
        .navigationTitle("capture".trad())
        .background(Color.swatch.dark.high).foregroundColor(.white)
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
//                NavigationLink(destination: ListTeams(viewModel: ListTeamsModel(pilot: viewModel.appPilot))){
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }){
                        Image(systemName: "chevron.backward")
                        Text("your.teams".trad())
                    }.font(.body.bold()).foregroundColor(.cyan)
//                }
            }
        }
        .frame(maxHeight: .infinity)
        .sheet(isPresented: $showChange){
            HStack{
                Button(action:{
                    showChange.toggle()
                    viewModel.clear()
                }){
                    Image(systemName: "multiply")
                }.padding().font(.title)
            }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(.blue)
            Text("pick.change".trad()).font(.title)
            ScrollView(.vertical){
                let p = viewModel.nonLineup()
                HStack{
                    let pr = p.count % 2 == 0 ? p.count : p.count + 1
                    VStack{
                        ForEach(p.prefix(pr/2), id:\.id){player in
                            ZStack{
                                statb.fill(.blue)
                                Text("\(player.name)").foregroundColor(.white)
                            }.onTapGesture {
//                                viewModel.showChange = false
                                showChange.toggle()
                                viewModel.changePlayer(change: player)
                                
                            }.frame(height: sq*2)
                        }
                    }.frame(maxHeight: .infinity, alignment: .top)
                    VStack{
                        ForEach(p.suffix(p.count/2), id:\.id){player in
                            
                            ZStack{
                                statb.fill(.blue)
                                Text("\(player.name)").foregroundColor(.white)
                            }.onTapGesture {
                                showChange = false
                                viewModel.changePlayer(change: player)

                            }.frame(height: sq*2)
                        }
                    }.frame(maxHeight: .infinity, alignment: .top)
                    
                }.padding(.vertical).frame(maxWidth: .infinity)
            }.padding().frame(maxWidth: .infinity)
            //#-learning-task(createDetailView)
        }
        .sheet(isPresented: $viewModel.showRotation){
            VStack{
                HStack{
                    Button(action:{
                        viewModel.rotation = viewModel.lastStat?.rotation ?? viewModel.set.rotation
                        viewModel.showRotation.toggle()
                        
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                
                
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white.opacity(0.1))
                    VStack{
                        Text("modify.rotation".trad()).font(.title).padding()
                        Spacer()
                        ForEach(0..<viewModel.match.n_players, id:\.self){index in
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white.opacity(0.1))
                                HStack{
                                    Text("\(index+1):").font(.body).frame(maxWidth: .infinity, alignment: .leading)
                                    Picker(selection: $viewModel.rotation[index], label: Text("\(index+1):").font(.body)) {
                                        ForEach(viewModel.team.players(), id:\.id){player in
                                            Text("\(player.name)").tag(player.id)
                                        }
                                    }
                                }.padding()
                            }.padding().frame(maxHeight: 70)
                        }
                        Button(action:{
                            viewModel.rotate()
                        }){
                            HStack{
                                Text("rotate".trad()).font(.body).foregroundColor(.white)
                                Image(systemName: "arrow.triangle.2.circlepath")
                            }.padding()
                        }.border(.white, width: 3).padding()
                        Spacer()
                    }
                }.padding()
                Spacer()
                ZStack{
                    statb.fill(.blue)
                    Text("save".trad()).foregroundColor(.white).font(.body)
                    
                }.clipped().onTapGesture {
                    viewModel.server = viewModel.rotation[0]
                    viewModel.saveAdjust()
                }.frame(maxHeight: 100).padding()
                Spacer()
            }.padding().background(Color.swatch.dark.high).frame(maxHeight: .infinity)
            //#-learning-task(createDetailView)
        }
        .overlay(viewModel.hasActionDetail() ? detailModal() : nil)
        .overlay(viewModel.adjust ? adjustmentModal() : nil)
        .overlay(viewModel.showTimeout ? timeOutModal() : nil)
        .font(.custom("stats", size: 12))
        .onDisappear(perform: {
            viewModel.updateSet()
        })
        .onAppear(perform: {
            viewModel.players()
        })
        
    }
    @ViewBuilder
    func detailModal() -> some View {
            VStack{
                HStack{
                    Button(action:{viewModel.clear()}){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("detail.title".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    ZStack{
                        statb.fill(.blue)
                        Text("net".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.detail = "Net"
                        viewModel.saveAction()
                    }
                    ZStack{
                        statb.fill(viewModel.action?.id==15 ? .gray : .blue)
                        Text("blocked".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.detail = "Blocked"
                        viewModel.saveAction()
                    }.disabled(viewModel.action?.id==15)
                    ZStack{
                        statb.fill(.blue)
                        Text("out".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.detail = "Out"
                        viewModel.saveAction()
                    }
                }.padding()
                ZStack{
                    statb.fill(.pink)
                    Text("not.specify".trad()).foregroundColor(.white).padding(5)
                }.clipped().onTapGesture {
                    viewModel.saveAction()
                }.padding()
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    @ViewBuilder
    func adjustmentModal() -> some View {
            VStack{
                HStack{
                    Button(action:{
                        viewModel.point_us = viewModel.lastStat?.score_us ?? 0
                        viewModel.point_them = viewModel.lastStat?.score_them ?? 0
                        viewModel.server = viewModel.lastStat?.server ?? 0
                        viewModel.serve = viewModel.lastStat?.stage ?? 0 == 0 ? 1 : 2
                        viewModel.adjust.toggle()
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("adjust.score".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    VStack{
                        Text("us".trad()).font(.title3)
                        HStack{
                            ZStack{
                                statb.fill(.blue)
                                Text("+").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_us += 1
                            }
                            ZStack{
                                statb.fill(.blue)
                                Text("-").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_us -= 1
                            }
                        }
                        ZStack{
                            statb.fill(.blue)
                            Text("serve".trad()).foregroundColor(.white).padding(5)
                        }.clipped().onTapGesture {
                            viewModel.serve = 1
                            viewModel.server = viewModel.rotation[0]
                        }
                    }
                    VStack{
                        Text("them".trad()).font(.title3)
                        HStack{
                            ZStack{
                                statb.fill(.pink)
                                Text("+").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_them += 1
                            }
                            ZStack{
                                statb.fill(.pink)
                                Text("-").foregroundColor(.white).padding(5)
                            }.clipped().onTapGesture {
                                viewModel.point_them -= 1
                            }
                        }
                        ZStack{
                            statb.fill(.pink)
                            Text("serve".trad()).foregroundColor(.white).padding(5)
                        }.clipped().onTapGesture {
                            viewModel.serve = 2
                            viewModel.server = 0
                        }
                    }
                }.padding().frame(maxHeight: .infinity)
                ZStack{
                    statb.fill(.blue)
                    Text("save".trad()).foregroundColor(.white).padding(5)
                }.clipped().onTapGesture {
                    viewModel.saveAdjust()
                }.padding().frame(maxHeight: 100)
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    @ViewBuilder
    func timeOutModal() -> some View {
            VStack{
                HStack{
                    Button(action:{
                        viewModel.showTimeout.toggle()
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("anotate.time.out".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    ZStack{
                        statb.fill(viewModel.timeOuts.0 == 2 ? .gray : .blue)
                        Text("time.out".trad()+" "+"us".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.timeOut(to: 1)
                        viewModel.timeOuts.0 += 1
                        viewModel.showTimeout.toggle()
                    }.padding().disabled(viewModel.timeOuts.0 == 2)
                    ZStack{
                        statb.fill(viewModel.timeOuts.1 == 2 ? .gray : .pink)
                        Text("time.out".trad()+" "+"them".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.timeOut(to: 2)
                        viewModel.timeOuts.1 += 1
                        viewModel.showTimeout.toggle()
                    }.padding().disabled(viewModel.timeOuts.1 == 2)
                }
                
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

class CaptureModel: ObservableObject{
    @Published var point_us: Int = 0
    @Published var point_them: Int = 0
    @Published var action: Action? = nil
    @Published var player: Player? = nil
    @Published var rotation: Array<Int>
    @Published var serve: Int
    @Published var server: Int = 0
    @Published var detail: String = ""
    @Published var timeOuts: (Int, Int) = (0,0)
//    @Published var showChange: Bool = false
    @Published var showRotation: Bool = false
    @Published var lineupPlayers: [Player] = []
    @Published var cantChange: Bool = false
    @Published var adjust: Bool = false
    @Published var showTimeout: Bool = false
    var lastStat: Stat?
    let team: Team
    let match: Match
    var set: Set
        let appPilot: UIPilot<AppRoute>
    init(pilot: UIPilot<AppRoute>, team: Team, match: Match, set: Set){
        self.match = match
        self.team = team
        self.set = set
        self.appPilot = pilot
        let stats = set.stats().filter{s in return s.action != 0}
        if (stats.isEmpty){
            rotation = set.rotation
            serve = set.first_serve
            server = set.first_serve == 1 ? set.rotation[0] : 0
        }else{
            lastStat = stats.last
            rotation = lastStat?.rotation ?? []
            point_us = lastStat?.score_us ?? 0
            point_them = lastStat?.score_them ?? 0
            if lastStat?.stage == 0 {
                if lastStat?.to == 2 {
                    serve = 2
                    server = 0
                }else{
                    serve = 1
                    server = lastStat?.server ?? 0
                }
            } else {
                if lastStat?.to == 1 {
                    serve = 1
                    rotate()
                    server = rotation[0]
                }else{
                    serve = 2
                    server = 0
                }
            }
            self.timeOuts = set.timeOuts()
            
        }
    }
    func updateSet(){
        set.score_us = point_us
        set.score_them = point_them
        let id = set.update()
        if id {
            //            print("updated")
        }
    }
    func nonLineup() -> [Player]{
        return team.activePlayers().filter{p in return !rotation.contains(p.id) && !set.liberos.contains(p.id)}
    }
    func timeOut(to: Int){
        let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: 0, action: 0, rotation: rotation, score_us: point_us, score_them: point_them, to: to, stage: serve == 1 ? 0 : 1, server: server, player_in: nil, detail: ""))
        if stat != nil {
            lastStat = stat
        }
    }
    func saveAdjust(){
        let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: 0, action: 98, rotation: rotation, score_us: point_us, score_them: point_them, to: 0, stage: serve == 1 ? 0 : 1, server: server, player_in: nil, detail: ""))
        if stat != nil {
            lastStat = stat
            adjust = false
            showRotation = false
        }
    }
    func changePlayer(change: Player){
        let idx = self.rotation.firstIndex(of: self.player?.id ?? 0)
        print(change.id)
        let stat = Stat.createStat(stat: Stat(match: self.match.id, set: self.set.id, player: self.player?.id ?? 0, action: 99, rotation: rotation, score_us: point_us, score_them: point_them, to: 0, stage: serve == 1 ? 0 : 1, server: server, player_in: change.id, detail: ""))
        if stat != nil {
            if self.server == self.player?.id ?? 0 && self.server != 0 {
                server=change.id
            }
            self.rotation[idx!] = change.id
            lastStat = stat
            lineupPlayers = players()
            self.clear()
            
//            self.showChange.toggle()
        }
        
    }
    func hasActionDetail()->Bool{
        if self.player != nil && self.action != nil {
            return [15, 16, 17, 18, 19].contains(self.action!.id)
        }
        return false
    }
    func rotate(){
        let tmp = rotation[0]
        for index in 1..<match.n_players{
            rotation[index - 1] = rotation[index]
        }
        rotation[match.n_players-1] = tmp
    }
    func actionTap(action: Action){
        self.action = action
    }
    func clear(){
        self.action = nil
        self.player = nil
    }
    func undo(){
        var stats = self.set.stats()
        if !stats.isEmpty {
            var removed = stats.removeLast()
            lastStat = stats.last
            if lastStat != nil{
                point_us = removed.score_us
                point_them = removed.score_them
                rotation = removed.rotation
                self.server = removed.server
                serve = server == 0 ? 2 : 1
                self.action = Action.find(id: removed.action)
                self.player = Player.find(id: removed.player)
                lineupPlayers = self.players()
            }else if stats.isEmpty {
                point_us = 0
                point_them = 0
                rotation = self.set.rotation
                self.server = self.set.first_serve == 1 ? rotation[0] : 0
                serve = self.set.first_serve
                self.action = Action.find(id: removed.action)
                self.player = removed.player == 0 ? Player(name: "Their player", number: 0, team: 0, active:1, birthday: Date(), id: 0) : Player.find(id: removed.player)
                lineupPlayers = self.players()
            }
            removed.delete()
            self.timeOuts = set.timeOuts()
        }
    }
    func players() -> [Player]{
        var players: [Player] = []
        for n in rotation{
            let p = Player.find(id: n)
            if (p != nil){
                players.append(p!)
            }
        }
        set.liberos.forEach {
            if $0 != nil {
                let p = Player.find(id: $0!)
                if (p != nil){
                    players.append(p!)
                }
            }
        }
        lineupPlayers = players
        return players
    }
    func lineup() -> [Player]{
        var players: [Player] = []
        for n in rotation{
            let p = Player.find(id: n)
            if (p != nil){
                players.append(p!)
            }
        }
        return players
    }
    func pointTo() -> (String, Int)?{
        if [2,3].contains(action?.type ?? nil) {
            if player?.id == 0 {
                return ("us", 1)
            }else{
                return ("them",2)
            }
        }else if action?.type ?? nil == 1 {
            if player?.id == 0 {
                return ("them", 2)
            }else{
                return ("us", 1)
            }
        }else if action?.type == 0{
            return ("none", 0)
        }else {
            return nil
        }
    }
    func saveAction() {
        if (player != nil && action != nil && pointTo() != nil){
            let (_, to)=pointTo() ?? ("", 0)
            if (to == 1) {
                point_us+=1
            }else if(to == 2){
                point_them+=1
            }
            let stat = Stat.createStat(stat: Stat(match: match.id, set: set.id, player: player?.id ?? 0, action: action?.id ?? 0, rotation: rotation, score_us: point_us, score_them: point_them, to: to, stage: serve == 1 ? 0 : 1, server: server, player_in: nil, detail: detail))
            if stat != nil {
                lastStat = stat
                detail=""
            }
            if(to != 0 && to != serve){
                if(serve == 1){
                    serve = 2
                    server = 0
                }else if (serve == 2){
                    serve = 1
                    rotate()
                    server = rotation[0]
                }
            }
            clear()
        }
    }
}





