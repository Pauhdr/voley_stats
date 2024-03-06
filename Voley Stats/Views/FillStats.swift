import SwiftUI
import UIPilot

struct FillStats: View {
    @ObservedObject var viewModel: FillStatsModel
    var sq: CGFloat = 90
//    let actions: Dictionary<Int, Array<Action>> = Dictionary(grouping:  Action.getByType(type: 0), by: {$0.area.rawValue})
    let actions: [[Action]] = inGameActions
    let statb = RoundedRectangle(cornerRadius: 15, style: .continuous)
    var body: some View {
        VStack {
            HStack{
                VStack{
                    Text("last.point".trad()).font(.body)
                    if viewModel.lastPoint != nil{
                        HStack{
                            ZStack{
                                let lastPlayer = Player.find(id: viewModel.lastPoint?.player ?? 0)
                                statb.fill(viewModel.lastPoint?.player == nil ? .black.opacity(0.4) : viewModel.lastPoint?.player == 0 ? .pink : .blue)
                                HStack{
                                    if (lastPlayer != nil && lastPlayer?.id != 0){
                                        Text("\(lastPlayer?.number ?? 0)")
                                    }
                                    Text(" \(lastPlayer == nil ? (viewModel.lastPoint?.player == 0 ? "their.player".trad() : "player".trad()) : lastPlayer!.name)")
                                }
                                
                            }
                            let lastAction = Action.find(id: viewModel.lastPoint?.action ?? 0)
                            ZStack{
                                statb.fill(lastAction?.color() ?? .black.opacity(0.4))
                                Text("\(lastAction?.name.trad().capitalized ?? "action".trad())")
                            }
                            ZStack{
                                statb.fill(viewModel.lastPoint?.to == 1 ? .blue : viewModel.lastPoint?.to == 2 ? .pink : .black.opacity(0.4))
                                if viewModel.lastPoint?.to == 1 {
                                    Text("\("us".trad())")
                                } else if viewModel.lastPoint?.to == 2 {
                                    Text("\("them".trad())")
                                } else {
                                    Text("\("to".trad())")
                                }
                                
                            }
                        }
                        HStack{
                            ZStack{
                                statb.fill(.blue)
                                HStack{
                                    Image(systemName: "chevron.left")
                                    Text("previous").font(Font.body)
                                }
                            }.onTapGesture{
                                viewModel.nextPoint = viewModel.lastPoint
                                viewModel.lastPoint = viewModel.getPreviousPoint()
                                viewModel.lastStat = nil
                                viewModel.nextStat = viewModel.getNextAction()
                            }
                            HStack {
                                ZStack{
                                    statb.stroke(.blue, lineWidth: 3)
                                    Text("\(viewModel.lastPoint?.score_us ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.lastPoint?.stage==0 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.0, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                                ZStack{
                                    statb.stroke(.pink, lineWidth: 3)
                                    Text("\(viewModel.lastPoint?.score_them ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.lastPoint?.stage==1 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.1, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                            }
                        }
                    } else{
                        VStack{
                            Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3)
                            Text("no.data".trad()).foregroundStyle(.gray)
                        }.font(.body).frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity).frame(height: sq*2)
                VStack{
                    Text("next.point".trad()).font(.body)
                    if viewModel.nextPoint != nil{
                        HStack{
                            ZStack{
                                statb.fill(viewModel.nextPoint?.player == nil ? .black.opacity(0.4) : viewModel.nextPoint?.player == 0 ? .pink : .blue)
                                HStack{
                                    let nextPlayer = Player.find(id: viewModel.nextPoint?.player ?? 0)
                                    if (nextPlayer != nil && nextPlayer?.id != 0){
                                        Text("\(nextPlayer?.number ?? 0)")
                                    }
                                    Text(" \(nextPlayer == nil ? (viewModel.nextPoint?.player == 0 ? "their.player".trad() : "player".trad()) : nextPlayer!.name)")
//                                    Text(" \(nextPlayer?.name ?? "player".trad())")
                                }
                                
                            }
                            ZStack{
                                let nextAction = Action.find(id: viewModel.nextPoint?.action ?? 0)
                                statb.fill(nextAction?.color() ?? .black.opacity(0.4))
                                Text("\(nextAction?.name.trad().capitalized ?? "action".trad())")
                            }
                            ZStack{
                                statb.fill(viewModel.nextPoint?.to == 1 ? .blue : viewModel.nextPoint?.to == 2 ? .pink : .black.opacity(0.4))
                                if viewModel.nextPoint?.to == 1 {
                                    Text("\("us".trad())")
                                } else if viewModel.nextPoint?.to == 2 {
                                    Text("\("them".trad())")
                                } else {
                                    Text("\("to".trad())")
                                }
                            }
                        }
                        HStack{
                            HStack {
                                ZStack{
                                    statb.stroke(.blue, lineWidth: 3)
                                    Text("\(viewModel.nextPoint?.score_us ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.nextPoint?.stage == 0 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.0, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                                ZStack{
                                    statb.stroke(.pink, lineWidth: 3)
                                    Text("\(viewModel.nextPoint?.score_them ?? 0)").font(Font.body)
                                }.overlay(Image("Voleibol").scaleEffect(0.007, anchor: .center).opacity(viewModel.nextPoint?.stage==1 ? 1 : 0).padding().offset(x: 20.0, y: -15.0))
                                    .overlay{
                                        HStack{
                                            ForEach(0..<viewModel.timeOuts.1, id:\.self){t in
                                                Image(systemName: "t.circle.fill")
                                            }
                                        }.frame(maxHeight: 20).offset(x: -30, y: 23)
                                    }
                            }
                            ZStack{
                                statb.fill(.blue)
                                HStack{
                                    
                                    Text("next").font(Font.body)
                                    Image(systemName: "chevron.right")
                                }
                            }.onTapGesture{
                                viewModel.lastPoint = viewModel.nextPoint
                                viewModel.nextPoint = viewModel.getNextPoint()
                                viewModel.lastStat = nil
                                viewModel.nextStat = viewModel.getNextAction()
                            }
                        }
                    } else{
                        VStack{
                            Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3)
                            Text("no.data".trad()).foregroundStyle(.gray)
                        }.font(.body).frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity).frame(height: sq*2)
            }.padding(.horizontal)
//            HStack {
//                ZStack{
//                    statb.fill(.gray)
//                    Text("time.out".trad()).foregroundColor(.white)
//                    
//                }.onTapGesture {
//                    viewModel.showTimeout.toggle()
//                }
//                
//                    VStack {
//                        Court(rotation: $viewModel.rotationArray, numberPlayers: viewModel.match.n_players, width: 90, height: 70)
//                    }
//            }.frame(maxHeight: sq).padding(.horizontal)
            ZStack{
                HStack (alignment: .top) {
                    VStack {
                        Text("current.lineup".trad()).font(.title3)
                        //                    Divider().overlay(.white).padding(.bottom)
                        ForEach(viewModel.lineupPlayers.sorted(by: { $0.number < $1.number }), id:\.id){player in
                            ZStack{
                                statb.stroke(viewModel.player?.id == player.id ? .white : .clear, lineWidth: 3).background(statb.fill(.blue))
                                VStack {
                                    Text("\(player.number)")
                                    Text("\(player.name)")
                                    
                                }.foregroundColor(.white).font(Font.body)
                            }.onTapGesture {
                                viewModel.player = player
                            }
                            .overlay(Image("Voleibol").scaleEffect(0.01, anchor: .center).opacity(player.id == viewModel.lastStat?.server ? 1 : 0).padding().offset(x: 40.0, y: -20.0))
                        }
                    }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2))).padding(.trailing, 5).frame(maxWidth: sq*2)
                    VStack{
                        VStack{
                            Text("in.game.actions".trad()).font(.title3)
                            HStack{
                                VStack{
                                    HStack{
                                        Text("last.action".trad()).font(.body)
                                        if viewModel.lastStat != nil{
                                            Image(systemName: "trash.fill").foregroundStyle(.red).onTapGesture{
                                                let tmp = viewModel.getPreviousAction()
                                                if viewModel.lastStat!.delete(){
                                                    viewModel.lastStat = tmp
                                                }
                                            }
                                        }
                                        
                                    }
                                    if viewModel.lastStat != nil{
                                        HStack{
                                            ZStack{
                                                let lastPlayer = Player.find(id: viewModel.lastStat?.player ?? 0)
                                                statb.fill(viewModel.lastStat?.player == nil ? .black.opacity(0.4) : viewModel.lastStat?.player == 0 ? .pink : .blue)
                                                HStack{
                                                    if (lastPlayer != nil && lastPlayer?.id != 0){
                                                        Text("\(lastPlayer?.number ?? 0)")
                                                    }
                                                    Text(" \(lastPlayer == nil ? (viewModel.lastStat?.player == 0 ? "their.player".trad() : "player".trad()) : lastPlayer!.name)")
                                                }.padding()
                                                
                                            }
                                            let lastAction = Action.find(id: viewModel.lastStat?.action ?? 0)
                                            ZStack{
                                                statb.fill(lastAction?.color() ?? .black.opacity(0.4))
                                                Text("\(lastAction?.name.trad().capitalized ?? "action".trad())").padding()
                                            }
                                            
                                        }
                                        ZStack{
                                            statb.fill(.blue)
                                            HStack{
                                                Image(systemName: "chevron.left")
                                                Text("previous".trad()).font(Font.body)
                                            }
                                        }.onTapGesture{
                                            viewModel.nextStat = viewModel.lastStat
                                            viewModel.lastStat = viewModel.getPreviousAction()
                                        }
                                    } else{
                                        VStack{
                                            Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3)
                                            Text("no.data".trad()).foregroundStyle(.gray)
                                        }.frame(maxWidth: .infinity, maxHeight: .infinity).font(.body)
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity).frame(height: sq*2)
                                VStack{
                                    HStack{
                                        Text("next.action".trad()).font(.body)
                                        if viewModel.nextStat != nil{
                                            Image(systemName: "trash.fill").foregroundStyle(.red).onTapGesture{
                                                let tmp = viewModel.getNextAction()
                                                if viewModel.nextStat!.delete(){
                                                    viewModel.nextStat = tmp
                                                }
                                            }
                                        }
                                        
                                    }
                                    if viewModel.nextStat != nil{
                                        HStack{
                                            ZStack{
                                                statb.fill(viewModel.nextStat?.player == nil ? .black.opacity(0.4) : viewModel.nextStat?.player == 0 ? .pink : .blue)
                                                HStack{
                                                    let nextPlayer = Player.find(id: viewModel.nextStat?.player ?? 0)
                                                    if (nextPlayer != nil && nextPlayer?.id != 0){
                                                        Text("\(nextPlayer?.number ?? 0)")
                                                    }
                                                    Text(" \(nextPlayer == nil ? (viewModel.nextStat?.player == 0 ? "their.player".trad() : "player".trad()) : nextPlayer!.name)")
                                                    //                                    Text(" \(nextPlayer?.name ?? "player".trad())")
                                                }.padding()
                                                
                                            }
                                            ZStack{
                                                let nextAction = Action.find(id: viewModel.nextStat?.action ?? 0)
                                                statb.fill(nextAction?.color() ?? .black.opacity(0.4))
                                                Text("\(nextAction?.name.trad().capitalized ?? "action".trad())").padding()
                                            }
                                            
                                        }
                                        ZStack{
                                            statb.fill(.blue)
                                            HStack{
                                                Text("next".trad()).font(.body)
                                                Image(systemName: "chevron.right")
                                            }.padding()
                                        }.onTapGesture{
                                            viewModel.lastStat = viewModel.nextStat
                                            viewModel.nextStat = viewModel.getNextAction()
                                        }
                                    } else{
                                        VStack{
                                            Image(systemName: "hand.tap.fill").foregroundStyle(.cyan).font(.title3)
                                            Text("no.data".trad()).foregroundStyle(.gray)
                                        }.frame(maxWidth: .infinity, maxHeight: .infinity).font(.body)
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).frame(maxWidth: .infinity).frame(height: sq*2)
                            }
                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))
                        VStack {
                            
                            Text("actions".trad()).font(.title3)
                            //                    Divider().overlay(.white).padding(.bottom)
                            VStack {
                                //                            ForEach(actions.sorted(by: {$0.key < $1.key}), id:\.key){key, sub in
                                ForEach(actions, id:\.self){sub in
                                    HStack{
                                        ForEach(sub, id:\.id){action in
                                            //                                        if action.id != 38 && action.type == 0 {
                                            ZStack{
                                                statb.stroke(viewModel.action?.id == action.id ? .white : .clear, lineWidth: 3).background(statb.fill(action.color()))
                                                Text("\(action.name.trad().capitalized)").foregroundColor(.white).padding(5)
                                            }.onTapGesture {
                                                viewModel.actionTap(action: action)
                                            }
                                            //                                        }
                                        }
                                    }
                                }
                            }
                            
                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.2)))
                    }
                }.padding()
                if !viewModel.checkAvailableInGame(){
                    Rectangle().fill(.black.opacity(0.4))
                }
            }
        }
        .navigationTitle("fill.stats".trad())
        .background(Color.swatch.dark.high).foregroundColor(.white)
//        .navigationBarBackButtonHidden(true)
        .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.type, message: viewModel.message))
        .frame(maxHeight: .infinity)
        .overlay(viewModel.showTimeout ? timeOutModal() : nil)
        .font(.custom("stats", size: 12))
        .onDisappear(perform: {
            //here re-rank the order values back to int
        })
        .onAppear(perform: {
            viewModel.players()
        })
        
        
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
//                        viewModel.timeOuts.0 += 1
                        viewModel.showTimeout.toggle()
                    }.padding().disabled(viewModel.timeOuts.0 == 2)
                    ZStack{
                        statb.fill(viewModel.timeOuts.1 == 2 ? .gray : .pink)
                        Text("time.out".trad()+" "+"them".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.timeOut(to: 2)
//                        viewModel.timeOuts.1 += 1
                        viewModel.showTimeout.toggle()
                    }.padding().disabled(viewModel.timeOuts.1 == 2)
                }
                
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

class FillStatsModel: ObservableObject{
    @Published var action: Action? = nil
    @Published var player: Player? = nil
    @Published var timeOuts: (Int, Int) = (0,0)
    @Published var lineupPlayers: [Player] = []
    @Published var showTimeout: Bool = false
    @Published var rotationArray:[Player?]=[nil, nil, nil, nil, nil, nil]
    @Published var message: String = ""
    @Published var type: ToastType = .info
    @Published var showToast: Bool = false
    @Published var lastPoint: Stat? = nil
    @Published var nextPoint: Stat? = nil
    var order: Double = 0
    @Published var lastStat: Stat? = nil
    @Published var nextStat: Stat? = nil
    let team: Team
    let match: Match
    var set: Set
    init(team: Team, match: Match, set: Set){
        self.match = match
        self.team = team
        self.set = set
        let fullStats = set.stats()
        let stats = fullStats.filter{s in return s.to != 0}
        let inGame = fullStats.filter{s in nextPoint?.order ?? 0 > s.order && s.to == 0}
        if (!stats.isEmpty){
            nextPoint = stats.first
            lastPoint = nil
            lastStat = inGame.first
            nextStat = inGame.count > 1 ? inGame[1] : nil
            let prevOrd = lastStat != nil ? lastStat!.order : 0
            let nextOrd = nextStat != nil ? nextStat!.order : nextPoint?.order ?? 0
            order = ( prevOrd + nextOrd)/2
        }
//        rotationArray = rotation.get(rotate: rotationTurns)
        players()
        self.timeOuts = set.timeOuts()
    }
    func checkAvailableInGame()->Bool{
        if self.nextPoint != nil{
            return ![.serve, .receive].contains(Action.find(id: self.nextPoint!.action)?.area)
        }
        return false
    }
    func getNextPoint()->Stat?{
        return self.set.stats().filter{s in s.to != 0 && s.order > self.nextPoint?.order ?? 0}.first
    }
    func getPreviousPoint()->Stat?{
        return self.set.stats().filter{s in s.to != 0 && s.order < self.lastPoint?.order ?? 0}.last
    }
    func getNextAction()->Stat?{
        return self.set.stats().filter{s in s.to == 0 && s.order > self.nextStat?.order ?? 0 && s.order < self.nextPoint?.order ?? 0}.first
    }
    func getPreviousAction()->Stat?{
        return self.set.stats().filter{s in s.to == 0 && s.order < self.lastStat?.order ?? 0 && s.order > self.lastPoint?.order ?? 0}.last
    }
    func checkSetters()->Bool{
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            ref = nextPoint
        }
        let rotation = ref!.rotation.get(rotate: ref!.rotationTurns)
        let front = [rotation[1],rotation[2],rotation[3]].filter{$0?.position == .setter}.count
        let back = [rotation[0],rotation[4],rotation[5]].filter{$0?.position == .setter}.count
        if self.set.gameMode == "5-1"{
            return front+back >= 1
        }else if self.set.gameMode == "6-2" || self.set.gameMode == "4-2"{
            return back == 1 && front == 1
        }else{
            return true
        }
    }
    func makeToast(type: ToastType, message: String){
        self.message = message
        self.type = type
        self.showToast = true
    }
    func calculateOrder(){
        var orderP = lastStat?.order ?? 0
        if lastStat == nil{
            orderP = lastPoint?.order ?? 0
        }
        var orderN = nextStat?.order ?? 0
        if nextStat == nil{
            orderN = nextPoint?.order ?? 0
        }
        self.order = (orderP+orderN)/2
    }
    func timeOut(to: Int){
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            ref = nextPoint
        }
        if ref == nil{
            self.makeToast(type: .warning, message: "no.next.point".trad())
        }else{
            calculateOrder()
            let stat = Stat.createStat(stat: Stat(
                                    match: self.match.id,
                                    set: self.set.id,
                                    player: 0,
                                    action: 0,
                                    rotation: ref!.rotation,
                                    rotationTurns: ref!.rotationTurns,
                                    rotationCount: ref!.rotationCount,
                                    score_us: ref!.to == 1 ? ref!.score_us - 1 : ref!.score_us,
                                    score_them: ref!.to == 2 ? ref!.score_them - 1 : ref!.score_them,
                                    to: to,
                                    stage: ref!.stage,
                                    server: ref!.server,
                                    player_in: nil,
                                    detail: "",
                                    order: self.order))
            
            if stat != nil {
                lastStat = stat
                self.timeOuts = set.timeOuts()
                self.order += 1
                //            self.showSummary.toggle()
            }
        }
    }
    
    func actionTap(action: Action){
        self.action = action
        if (action.type == 0 && self.player != nil){
            self.saveAction()
        }
    }
    func clear(){
        self.action = nil
        self.player = nil
    }
    func undo(){
//        var stats = self.set.stats()
//        if !stats.isEmpty {
//            var removed = stats.removeLast()
//            lastStat = stats.last
//            if lastStat != nil{
//                point_us = removed.to == 1 ? removed.score_us - 1 : removed.score_us
//                point_them = removed.to == 2 ? removed.score_them - 1 : removed.score_them
//                rotation = removed.rotation
//                self.server = removed.server
//                serve = server == 0 ? 2 : 1
//                stage = serve == 1 ? 0 : 1
//                rotationCount = removed.rotationCount
//                rotationTurns = removed.rotationTurns
//                self.action = Action.find(id: removed.action)
//                self.player = Player.find(id: removed.player)
//                lineupPlayers = self.players()
//                setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
//                self.order = lastStat!.order + 1
//            }else if stats.isEmpty {
//                point_us = 0
//                point_them = 0
//                rotation = self.set.rotation
//                rotationCount = 1
//                rotationTurns = 0
//                self.server = self.set.first_serve == 1 ? rotation.server(rotate: rotationTurns).id : 0
//                serve = self.set.first_serve
//                stage = serve == 1 ? 0 : 1
//                self.action = Action.find(id: removed.action)
//                self.player = removed.player == 0 ? Player(name: "Their player", number: 0, team: 0, active:1, birthday: Date(), id: 0) : Player.find(id: removed.player)
//                lineupPlayers = self.players()
//                setter = rotation.getSetter(gameMode: set.gameMode, rotationTurns: rotationTurns)
//                self.order = 0
//            }
//            rotationArray = rotation.get(rotate: rotationTurns)
//            removed.delete()
//            self.timeOuts = set.timeOuts()
//        }
    }
    
    func players() -> [Player]{
        var players: [Player] = []
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            ref = nextPoint
        }
        for p in ref!.rotation.get(){
//            let p = Player.find(id: n)
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
    
//    func lineup() -> [Player]{
//        var players: [Player] = []
//        for p in self.lastStat!.rotation.get(rotate: self.lastStat!.rotationTurns){
////            let p = Player.find(id: n)
//            if (p != nil){
//                players.append(p!)
//            }
//        }
////        print(players.map{$0.number})
//        return players
//    }
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
        var ref = lastStat
        if lastStat == nil || lastStat?.action == 0{
            ref = nextPoint
        }
        if ref == nil{
            self.makeToast(type: .warning, message: "no.next.point".trad())
        }else{
            if (player != nil && action != nil && checkAvailableInGame()){
                calculateOrder()
                print(self.lastStat?.order, self.nextPoint?.order, self.order)
                let stat = Stat.createStat(stat: Stat(
                                                    match: match.id,
                                                    set: set.id,
                                                    player: player?.id ?? 0,
                                                    action: action?.id ?? 0,
                                                    rotation: ref!.rotation,
                                                    rotationTurns: ref!.rotationTurns,
                                                    rotationCount: ref!.rotationCount,
                                                    score_us: ref!.to == 1 ? ref!.score_us - 1 : ref!.score_us,
                                                    score_them: ref!.to == 2 ? ref!.score_them - 1 : ref!.score_them,
                                                    to: 0,
                                                    stage: ref!.stage,
                                                    server: ref!.server,
                                                    player_in: nil,
                                                    detail: "",
                                                    setter: ref!.setter,
                                                    order: self.order))
                if stat != nil {
                    lastStat = stat
                    self.order += 1
                }
                clear()
            }
        }
    }
}





