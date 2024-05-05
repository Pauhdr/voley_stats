import SQLite
import SwiftUI
import AppIntents
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class Team: Model, Equatable {
//    var id:Int;
    var name:String
    var orgnization:String
    var category:String
    var gender:String
    var color: Color
    var order: Int
    var code: String
    static func ==(lhs: Team, rhs: Team) -> Bool {
        return lhs.id == rhs.id
    }

    init(name:String, organization:String, category:String, gender:String, color:Color, order: Int, code: String? = nil, id:Int?){
        self.name=name
        self.orgnization=organization
        self.category=category
        self.gender=gender
        self.color = color
        self.order = order
        if code != nil{
            self.code = code!
        }else{
            self.code = "\(self.name.prefix(3))_\(self.orgnization.prefix(3))\(self.category.prefix(3))\(self.gender.prefix(3))".uppercased()
        }
        
        super.init(id: id ?? 0)
    }
    
    static func createTeam(team: Team)->Team?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if team.id != 0{
                try database.run(Table("team").insert(
                    Expression<String>("name") <- team.name,
                    Expression<String>("organization") <- team.orgnization,
                    Expression<String>("category") <- team.category,
                    Expression<String>("color") <- team.color.toHex() ?? "000000",
                    Expression<String>("gender") <- team.gender,
                    Expression<String>("code") <- team.code,
                    Expression<Int>("order") <- team.order,
                    Expression<Int>("id") <- team.id
                ))
            }else{
                let id = try database.run(Table("team").insert(
                    Expression<String>("name") <- team.name,
                    Expression<String>("organization") <- team.orgnization,
                    Expression<String>("category") <- team.category,
                    Expression<String>("color") <- team.color.toHex() ?? "000000",
                    Expression<String>("gender") <- team.gender,
                    Expression<String>("code") <- team.code,
                    Expression<Int>("order") <- team.order
                ))
                team.id = Int(id)
            }
            
            DB.saveToFirestore(collection: "teams", object: team)
            
            return team
        } catch {
            print("ERROR: \(error)")
        }
        return nil
    }
    func update() -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            let update = Table("team").filter(self.id == Expression<Int>("id")).update([
                Expression<String>("name") <- self.name,
                Expression<String>("organization") <- self.orgnization,
                Expression<String>("category") <- self.category,
                Expression<String>("color") <- self.color.toHex() ?? "000000",
                Expression<String>("gender") <- self.gender,
                Expression<String>("code") <- self.code,
                Expression<Int>("order") <- self.order,
            ])
            if try database.run(update) > 0 {
                DB.saveToFirestore(collection: "teams", object: self)
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    func delete() -> Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            self.tournaments().forEach({$0.delete()})
            self.matches().forEach({$0.delete()})
            self.players().forEach({$0.delete()})
            self.rotations().forEach({$0.delete()})
            let delete = Table("team").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            DB.deleteOnFirestore(collection: "teams", object: self)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    func matches(startDate: Date? = nil, endDate: Date? = nil) -> [Match]{
        var matches: [Match] = []
        do {
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            let df = DateFormatter()
//            df.dateFormat = "yyyy/MM/dd HH:mm"
            
            var query = Table("match").filter(Expression<Int>("team")==self.id)
            if startDate != nil {
//                let ini = Calendar.current.date(byAdding: .month, value: -interval!, to: Date()) ?? Date()
//                dump(ini)
                query = query.filter(startDate!...endDate! ~= Expression<Date>("date"))
            }
            
            for match in try database.prepare(query) {
                matches.append(Match(opponent: match[Expression<String>("opponent")], date: match[Expression<Date>("date")], location: match[Expression<String>("location")], home: match[Expression<Bool>("home")], n_sets: match[Expression<Int>("n_sets")], n_players: match[Expression<Int>("n_players")], team: match[Expression<Int>("team")], league: match[Expression<Bool>("league")], tournament: Tournament.find(id: match[Expression<Int>("tournament")]), id: match[Expression<Int>("id")]))
            }
            return matches.sorted{ a, b in a.date > b.date}
        }catch{
            print(error)
            return []
        }
    }
    func tournaments() -> [Tournament]{
        var tournaments: [Tournament] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for tournament in try database.prepare(Table("tournament").filter(Expression<Int>("team")==self.id).order(Expression<Date>("date_start").desc)) {
                tournaments.append(Tournament(
                    id: tournament[Expression<Int>("id")],
                    name: tournament[Expression<String>("name")],
                    team: Team.find(id: tournament[Expression<Int>("team")])!,
                    location: tournament[Expression<String>("location")],
                    startDate: tournament[Expression<Date>("date_start")],
                    endDate: tournament[Expression<Date>("date_end")]))
            }
            return tournaments
        } catch {
            print(error)
            return []
        }
    }
//    func scouts() -> [Scout]{
//        var scouts: [Scout] = []
//        do {
//            guard let database = DB.shared.db else {
//                print("no db")
//                return []
//            }
//            
//            var query = Table("scout").filter(Expression<Int>("team_related")==self.id).filter(Expression<String>("action") == "create")
//            
//            
//            for scout in try database.prepare(query) {
//                scouts.append(Scout(
//                    id: scout[Expression<Int>("id")],
//                    teamName: scout[Expression<String>("team_name")],
//                    teamRelated: Team.find(id: scout[Expression<Int>("team_related")]) ?? Team(name: "error", organization: "error", category: "error", gender: "error", color: .red, order = 0, id: 0),
//                    player: scout[Expression<Int>("player")],
//                    rotation: scout[Expression<String>("rotation")].components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil }.map{ Int($0)! },
//                    action: scout[Expression<String>("action")],
//                    difficulty: scout[Expression<Int>("difficulty")],
//                    from: scout[Expression<Int>("from")],
//                    to: scout[Expression<Int>("to")],
//                    date: scout[Expression<Date>("date")]
//                    ))
//            }
//            return scouts
//        }catch{
//            print(error)
//            return []
//        }
//    }
    func players() -> [Player]{
        var players: [Player] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for player in try database.prepare(Table("player").filter(Expression<Int>("team")==self.id)) {
                players.append(Player(name: player[Expression<String>("name")], number: player[Expression<Int>("number")], team: player[Expression<Int>("team")], active: player[Expression<Int>("active")], birthday: player[Expression<Date>("birthday")], position: PlayerPosition(rawValue: player[Expression<String>("position")])!, id: player[Expression<Int>("id")]))
            }
//            var ps: [Int] = []
            for p in try database.prepare(Table("player_teams").filter(Expression<Int>("team")==self.id)){
//                ps.append(p[Expression<Int>("player")])
                for player in try database.prepare(Table("player").filter(p[Expression<Int>("player")]==Expression<Int>("id"))) {
                    players.append(Player(name: player[Expression<String>("name")], number: p[Expression<Int>("number")], team: p[Expression<Int>("team")], active: p[Expression<Int>("active")], birthday: player[Expression<Date>("birthday")], position: PlayerPosition(rawValue: p[Expression<String>("position")])!, mainTeam: false, playerTeam: p[Expression<Int>("id")], id: p[Expression<Int>("player")]))
                }
            }
//            for player in try database.prepare(Table("player").filter(ps.contains(Expression<Int>("id")))) {
//                players.append(Player(name: player[Expression<String>("name")], number: player[Expression<Int>("number")], team: player[Expression<Int>("team")], active: player[Expression<Int>("active")], birthday: player[Expression<Date>("birthday")], position: PlayerPosition(rawValue: player[Expression<String>("position")])!, id: player[Expression<Int>("id")]))
//            }
            return players
        } catch {
            print(error)
            return []
        }
    }
    func activePlayers() -> [Player]{
            return self.players().filter{$0.active == 1}
    }
    static func all() -> [Team]{
        var teams: [Team] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for team in try database.prepare(Table("team").order(Expression<Int>("order"))) {
                teams.append(Team(name: team[Expression<String>("name")], organization: team[Expression<String>("organization")], category: team[Expression<String>("category")], gender: team[Expression<String>("gender")], color: Color(hex: team[Expression<String>("color")]) ?? .black, order: team[Expression<Int>("order")], code: team[Expression<String>("code")], id: team[Expression<Int>("id")]))
            }
            return teams
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Team?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let team = try database.pluck(Table("team").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Team(name: team[Expression<String>("name")], organization: team[Expression<String>("organization")], category: team[Expression<String>("category")], gender: team[Expression<String>("gender")], color: Color(hex: team[Expression<String>("color")]) ?? .black, order: team[Expression<Int>("order")], code: team[Expression<String>("code")], id: team[Expression<Int>("id")])
        } catch {
            print(error)
            return nil
        }
    }
    
    func rotations(match: Match? = nil) -> [Rotation]{
        var rotations: [Rotation] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("stat").select(distinct: Expression<Int>("rotation"))
            if match != nil {
                query = Table("stat").filter(Expression<Int>("match") == match!.id)//.select(distinct: Expression<Int>("rotation"))
            }else{
                query = query.filter(self.matches().map{$0.id}.contains(Expression<Int>("match")))
            }
            for stat in try database.prepare(query) {
                rotations.append(Rotation.find(id: stat[Expression<Int>("rotation")])!)
            }
            return rotations
        } catch {
            print(error)
            return []
        }
    }
    
    func rotationStats(rotation: Int)->(Int,Int){
        var result = (0, 0)
        do{
            guard let database = DB.shared.db else {
                return (0, 0)
            }
            let so = try database.scalar(Table("stat").filter(self.matches().map{$0.id}.contains(Expression<Int>("match")) && rotation == Expression<Int>("rotation") && Expression<Int>("server") == 0 && Expression<Int>("to") == 1 && Expression<Int>("stage") == 1 && Expression<Int>("player") != 0).count)
            let bp = try database.scalar(Table("stat").filter(self.matches().map{$0.id}.contains(Expression<Int>("match")) && rotation == Expression<Int>("rotation") && Expression<Int>("server") != 0 && Expression<Int>("to") == 1 && Expression<Int>("stage") == 0 && Expression<Int>("player") != 0).count)
            result = (Int(so), Int(bp))
            return result
        } catch {
            print(error)
            return (0, 0)
        }
    }
    
    func stats(startDate: Date? = nil, endDate: Date? = nil, matches: [Match] = [], tournaments: [Tournament] = [], player: Player? = nil) -> [Stat]{
        var stats: [Stat] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("stat")
            
            if !matches.isEmpty{
                query = query.filter(matches.map{$0.id}.contains(Expression<Int>("match")))
            } else if !tournaments.isEmpty {
                query = query.filter(tournaments.flatMap{$0.matches()}.map{$0.id}.contains(Expression<Int>("match")))
            }else if startDate != nil && endDate != nil{
                query = query.filter(self.matches(startDate: startDate, endDate: endDate).map{$0.id}.contains(Expression<Int>("match")))
            }
            if player != nil {
                query = query.filter(Expression<Int>("player") == player!.id || Expression<Int>("setter") == player!.id || Expression<Int>("server") == player!.id)
            }
            
            for stat in try database.prepare(query.order(Expression<Double>("order"))) {
                stats.append(Stat(
                    id: stat[Expression<Int>("id")],
                    match: stat[Expression<Int>("match")],
                    set: stat[Expression<Int>("set")],
                    player: stat[Expression<Int>("player")],
                    action: stat[Expression<Int>("action")],
                    rotation: Rotation.find(id: stat[Expression<Int>("rotation")]) ?? Rotation(),
                    rotationTurns: stat[Expression<Int>("rotation_turns")],
                    rotationCount: stat[Expression<Int>("rotation_count")],
                    score_us: stat[Expression<Int>("score_us")],
                    score_them: stat[Expression<Int>("score_them")],
                    to: stat[Expression<Int>("to")],
                    stage: stat[Expression<Int>("stage")],
                    server: stat[Expression<Int>("server")],
                    player_in: stat[Expression<Int?>("player_in")],
                    detail: stat[Expression<String>("detail")],
                    setter: Player.find(id: stat[Expression<Int>("setter")]),
                    date: nil,
                    order: stat[Expression<Double>("order")]
                ))
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
    
    func historicalStats(startDate: Date? = nil, endDate: Date? = nil, actions:[Int], matches: [Match] = [], tournaments: [Tournament] = [], player: Player? = nil)->[(Date, Double)]{
        var stats: [(Date, Double)] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("stat")
            if player != nil {
                query = query.filter(Expression<Int>("player") == player!.id)
            }
            if !matches.isEmpty{
                for match in (matches.sorted{$0.date < $1.date}){
                    query = query.filter(actions.contains(Expression<Int>("action")) && Expression<Int>("player") != 0 && Expression<Int>("match") == match.id)
                    let stat = try database.scalar(query.count)
                    stats.append((match.date, Double(stat)))
                }
            } else if !tournaments.isEmpty{
                for match in (tournaments.flatMap{$0.matches()}.sorted{$0.date < $1.date}){
                    query = query.filter(actions.contains(Expression<Int>("action")) && Expression<Int>("player") != 0 && Expression<Int>("match") == match.id)
                    let stat = try database.scalar(query.count)
                    stats.append((match.date, Double(stat)))
                }
            }else if startDate != nil && endDate != nil{
                for match in (self.matches(startDate: startDate, endDate: endDate).sorted{$0.date < $1.date}){
                    query = query.filter(actions.contains(Expression<Int>("action")) && Expression<Int>("player") != 0 && Expression<Int>("match") == match.id)
                    let stat = try database.scalar(query.count)
                    stats.append((match.date, Double(stat)))
                }
//                        let stat = try database.scalar(query)
//                        stats.append(Double(stat))
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
    
    func fullStats(startDate: Date? = nil, endDate: Date? = nil, matches: [Match] = [], tournaments: [Tournament] = [], player: Player? = nil)->Dictionary<String,Dictionary<String,Int>>{
        let stats = self.stats(startDate: startDate, endDate: endDate, matches: matches, tournaments: tournaments, player: player)
        
        let serve = stats.filter{s in return s.stage == 0 && actionsByType["serve"]!.contains(s.action)}
        let totalServes = serve.count //stats.filter{$0.server != 0 && $0.stage == 0 && $0.to != 0}.count
        let receive = stats.filter{actionsByType["receive"]!.contains($0.action)}
        let totalReceives = receive.count //stats.filter{s in return s.server == 0 && s.stage == 1 && s.to != 0}.count
        let block = stats.filter{actionsByType["block"]!.contains($0.action)}
        let dig = stats.filter{actionsByType["dig"]!.contains($0.action)}
        let set = stats.filter{actionsByType["set"]!.contains($0.action)}
        let attack = stats.filter{actionsByType["attack"]!.contains($0.action)}
//        var date:Date? = nil
//        if interval != nil {
//            date = Calendar.current.date(byAdding: .month, value: -interval!, to: Date()) ?? Date()
//        }
//        let statsImproves : [Action] = Improve.statsImproves(team: self, dateInterval: date).map{Action.find(id: Int($0.comment)!)!}
//        let serveImproves = statsImproves.filter{actionsByType["serve"]!.contains($0.id)}
//        let receiveImproves = statsImproves.filter{actionsByType["receive"]!.contains($0.id)}
//        let blockImproves = statsImproves.filter{actionsByType["block"]!.contains($0.id)}
//        let digImproves = statsImproves.filter{actionsByType["dig"]!.contains($0.id)}
//        let setImproves = statsImproves.filter{actionsByType["set"]!.contains($0.id)}
//        let attackImproves = statsImproves.filter{actionsByType["attack"]!.contains($0.id)}
        var blk = [
            "total":block.count,// + blockImproves.count,
            "earned":block.filter{$0.action==13}.count,// + blockImproves.filter{$0.type==1}.count,
            "error":block.filter{[20,31].contains($0.action)}.count,// + blockImproves.filter{$0.type==2}.count
        ]
        var srv = [
            "total":totalServes,// + serveImproves.count,
            "earned":serve.filter{$0.action==8}.count,// + serveImproves.filter{$0.type==1}.count,
            "error":serve.filter{[15, 32].contains($0.action)}.count,// + serveImproves.filter{$0.type==2}.count
        ]
        var dg = [
            "total":dig.count,// + digImproves.count,
            "earned":0,//digImproves.filter{$0.type==1}.count,
            "error":dig.filter{[23, 25].contains($0.action)}.count,// + digImproves.filter{$0.type==2}.count
        ]
        var rcv = [
            "total":totalReceives,// + receiveImproves.count,
            "earned":receive.filter{$0.action==4}.count,// + receiveImproves.filter{$0.id==4}.count,
            "error":receive.filter{$0.action==22}.count,// + receiveImproves.filter{$0.type==2}.count
        ]
        var atk = [
            "total":attack.count,// + attackImproves.count,
            "earned":attack.filter{[9, 10, 11, 12].contains($0.action)}.count,// + attackImproves.filter{$0.type==1}.count,
            "error":attack.filter{[16, 17, 18].contains($0.action)}.count,// + attackImproves.filter{$0.type==2}.count
        ]
        var st = [
            "total":set.count,// + setImproves.count,
            "earned":0,//setImproves.filter{$0.type==1}.count,
            "error":set.filter{$0.action==24}.count,// + setImproves.filter{$0.type==2}.count
        ]
        
        var fullStat =  [
            "block": blk,
            "serve":srv,
            "dig":dg,
            "receive":rcv,
            "attack":atk,
            "set": st,
        ]
        return fullStat
    }
    
    func addPlayer(player: Player) -> Bool{
        do {
            guard let database = DB.shared.db else {
                return false
            }
            let id = try database.run(Table("player_teams").insert(
                Expression<Int>("player") <- player.id,
                Expression<Int>("team") <- self.id,
                Expression<Int>("number") <- player.number,
                Expression<Int>("active") <- player.active,
                Expression<String>("position") <- player.position.rawValue
                
            ))
            DB.saveToFirestore(collection: "player_teams", object: [
                "id":id.description,
                "player":player.id,
                "team":self.id,
                "position":player.position.rawValue,
                "active":player.active,
                "number":player.number
            ])
//            DB.saveToFirestore(collection: "player_teams", object: player)
            return id < 0
        } catch {
            print(error)
        }
        return false
    }
    
    func deletePlayer(player: Player) -> Bool{
        do {
            guard let database = DB.shared.db else {
                return false
            }
            let delete = Table("player_teams").filter(self.id == Expression<Int>("team") && player.id == Expression<Int>("player")).delete()
            try database.run(delete)
            DB.deleteOnFirestore(collection: "player_teams", id: player.playerTeam)
//            DB.deleteOnFirestore(collection: "player_teams", id: )
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    static func truncate(){
        do{
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("team").delete())
        }catch{
            print("error truncating team")
            return
        }
    }
    
    override func toJSON()->Dictionary<String, Any>{
        return [
            "id":self.id,
            "name": self.name,
            "organization":self.orgnization,
            "category":self.category,
            "gender":self.gender,
            "color":self.color.toHex(),
            "order":self.order,
            "code":self.code
        ]
    }
}


