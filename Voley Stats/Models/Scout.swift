import SQLite
import SwiftUI

class Scout: Equatable, Identifiable {
    var id:Int=0
    var player:Int
    var action: String
    var rotation: Array<Int>
    var date:Date
    var teamRelated: Team
    var from: Int
    var to: Int
    var difficulty: Int
    var teamName: String
    var comment: String
    
    init(teamName: String, teamRelated:Team, player:Int, rotation:Array<Int>, action:String, difficulty:Int, from:Int, to:Int, date:Date, comment:String = ""){
        self.player=player
        self.action = action
        self.teamName = teamName
        self.date = date
        self.teamRelated = teamRelated
        self.rotation=rotation
        self.difficulty=difficulty
        self.from=from
        self.to=to
        self.comment = comment
    }
    init(id:Int, teamName: String, teamRelated:Team, player:Int, rotation:Array<Int>, action:String, difficulty:Int, from:Int, to:Int, date:Date, comment:String = ""){
        self.player=player
        self.action = action
        self.teamName = teamName
        self.date = date
        self.teamRelated = teamRelated
        self.rotation=rotation
        self.difficulty=difficulty
        self.from=from
        self.to=to
        self.comment = comment
        self.id=id
    }
    static func ==(lhs: Scout, rhs: Scout) -> Bool {
        return lhs.id == rhs.id
    }
    static func create(scout: Scout)->Scout?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd"
            if scout.id != 0 {
                try database.run(Table("scout").insert(
                    Expression<Int>("player") <- scout.player,
                    Expression<String>("action") <- scout.action,
                    Expression<String>("rotation") <- scout.rotation.description,
                    Expression<String>("team_name") <- scout.teamName,
                    Expression<Date>("date") <- scout.date,
                    Expression<Int>("team_related") <- scout.teamRelated.id,
                    Expression<Int>("to") <- scout.to,
                    Expression<Int>("from") <- scout.from,
                    Expression<Int>("difficulty") <- scout.difficulty,
                    Expression<String>("comment") <- scout.comment,
                    Expression<Int>("id") <- scout.id
                ))
            }else{
                let id = try database.run(Table("scout").insert(
                    Expression<Int>("player") <- scout.player,
                    Expression<String>("action") <- scout.action,
                    Expression<String>("rotation") <- scout.rotation.description,
                    Expression<String>("team_name") <- scout.teamName,
                    Expression<Date>("date") <- scout.date,
                    Expression<Int>("team_related") <- scout.teamRelated.id,
                    Expression<Int>("to") <- scout.to,
                    Expression<Int>("from") <- scout.from,
                    Expression<String>("comment") <- scout.comment,
                    Expression<Int>("difficulty") <- scout.difficulty
                ))
                scout.id = Int(id)
            }
            return scout
        } catch {
            print("ERROR: \(error)")
        }
        return nil
    }
    func update() -> Bool{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            let update = Table("scout").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("player") <- self.player,
                Expression<String>("action") <- self.action,
                Expression<String>("rotation") <- self.rotation.description,
                Expression<String>("team_name") <- self.teamName,
                Expression<Date>("date") <- self.date,
                Expression<Int>("team_related") <- self.teamRelated.id,
                Expression<Int>("to") <- self.to,
                Expression<Int>("from") <- self.from,
                Expression<Int>("difficulty") <- self.difficulty,
                Expression<String>("comment") <- self.comment,
            ])
            if try database.run(update) > 0 {
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
            let delete = Table("scout").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    func getDateString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.date)
    }
    static func all() -> [Scout]{
        var scouts: [Scout] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for scout in try database.prepare(Table("scout")) {
                scouts.append(Scout(
                    id: scout[Expression<Int>("id")],
                    teamName: scout[Expression<String>("team_name")],
                    teamRelated: Team.find(id: scout[Expression<Int>("team_related")]) ?? Team(name: "error", organization: "error", category: "error", gender: "error", color: .red, id: 0),
                    player: scout[Expression<Int>("player")],
                    rotation: scout[Expression<String>("rotation")].components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil }.map{ Int($0)! },
                    action: scout[Expression<String>("action")],
                    difficulty: scout[Expression<Int>("difficulty")],
                    from: scout[Expression<Int>("from")],
                    to: scout[Expression<Int>("to")],
                    date: scout[Expression<Date>("date")],
                    comment: scout[Expression<String>("comment")]
                    ))
            }
            return scouts
        } catch {
            print(error)
            return []
        }
    }
    static func teamScouts(teamName: String, related: Team, action: String? = nil) -> [Scout]{
        var scouts: [Scout] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("scout").filter(Expression<String>("team_name") == teamName).filter(Expression<Int>("team_related") == related.id)
            if action != nil{
                query = query.filter(Expression<String>("action") == action!)
            }
            for scout in try database.prepare(query) {
                scouts.append(Scout(
                    id: scout[Expression<Int>("id")],
                    teamName: scout[Expression<String>("team_name")],
                    teamRelated: Team.find(id: scout[Expression<Int>("team_related")]) ?? Team(name: "error", organization: "error", category: "error", gender: "error", color: .red, id: 0),
                    player: scout[Expression<Int>("player")],
                    rotation: scout[Expression<String>("rotation")].components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil }.map{ Int($0)! },
                    action: scout[Expression<String>("action")],
                    difficulty: scout[Expression<Int>("difficulty")],
                    from: scout[Expression<Int>("from")],
                    to: scout[Expression<Int>("to")],
                    date: scout[Expression<Date>("date")],
                    comment: scout[Expression<String>("comment")]
                    ))
            }
            return scouts
        } catch {
            print(error)
            return []
        }
    }
    func comments() -> [Scout]{
        var scouts: [Scout] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("scout").filter(Expression<String>("team_name") == self.teamName).filter(Expression<Int>("team_related") == self.teamRelated.id).filter(Expression<String>("action") == "comment")
            
            for scout in try database.prepare(query) {
                scouts.append(Scout(
                    id: scout[Expression<Int>("id")],
                    teamName: scout[Expression<String>("team_name")],
                    teamRelated: Team.find(id: scout[Expression<Int>("team_related")]) ?? Team(name: "error", organization: "error", category: "error", gender: "error", color: .red, id: 0),
                    player: scout[Expression<Int>("player")],
                    rotation: scout[Expression<String>("rotation")].components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil }.map{ Int($0)! },
                    action: scout[Expression<String>("action")],
                    difficulty: scout[Expression<Int>("difficulty")],
                    from: scout[Expression<Int>("from")],
                    to: scout[Expression<Int>("to")],
                    date: scout[Expression<Date>("date")],
                    comment: scout[Expression<String>("comment")]
                    ))
            }
            return scouts
        } catch {
            print(error)
            return []
        }
    }
    func teamInfo() -> Dictionary<String, (Int, Int)>{
        var scouts: Dictionary<String, (Int, Int)> = [:]
        do{
            guard let database = DB.shared.db else {
                return [:]
            }
            var serveQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "serve")
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var aceQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "serve")
                .filter(Expression<Int>("difficulty") == 5)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var serveErrQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "serve")
                .filter(Expression<Int>("difficulty") == 0)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var srvs:[(Int,Int,Int,Int)] = []
            for srv in try database.prepare(serveQuery){
                srvs.append((srv[Expression<Int>("player")], srv[Expression<Int>("id").count], 0, 0))
            }
            for srv in try database.prepare(serveErrQuery){
                let i = srvs.firstIndex(where: {$0.0 == srv[Expression<Int>("player")]})
                if i != nil{
                    srvs[i!].2 = srv[Expression<Int>("id").count]
                }
            }
            for srv in try database.prepare(aceQuery){
                let i = srvs.firstIndex(where: {$0.0 == srv[Expression<Int>("player")]})
                if i != nil{
                    srvs[i!].3 = srv[Expression<Int>("id").count]
                }
            }
            
            var blockQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "block")
                .filter(Expression<Int>("difficulty") != 0)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var bestrcvQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "receive")
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var worstrcvQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "receive")
                .filter(Expression<Int>("difficulty") == 5)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var rcvs:[(Int,Int,Int,Int)] = []
            for rcv in try database.prepare(bestrcvQuery){
                rcvs.append((rcv[Expression<Int>("player")], rcv[Expression<Int>("id").count], 0, 0))
            }
            for rcv in try database.prepare(worstrcvQuery){
                let i = rcvs.firstIndex(where: {$0.0 == rcv[Expression<Int>("player")]})
                if i != nil{
                    rcvs[i!].2 = rcv[Expression<Int>("id").count]
                }
            }
            
            var bestatkQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "attack")
                .filter(Expression<Int>("difficulty") == 5)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var worstatkQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "attack")
                .filter(Expression<Int>("difficulty") == 0)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var atkQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "attack")
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var atks:[(Int,Int,Int,Int)] = []
            for atk in try database.prepare(atkQuery){
                atks.append((atk[Expression<Int>("player")], atk[Expression<Int>("id").count], 0, 0))
            }
            for atk in try database.prepare(worstatkQuery){
                let i = atks.firstIndex(where: {$0.0 == atk[Expression<Int>("player")]})
                if i != nil{
                    atks[i!].2 = atk[Expression<Int>("id").count]
                }
            }
            for atk in try database.prepare(bestatkQuery){
                let i = atks.firstIndex(where: {$0.0 == atk[Expression<Int>("player")]})
                if i != nil{
                    atks[i!].3 = atk[Expression<Int>("id").count]
                }
            }
            let server = srvs.map{$0.1 > 0 ? ($0.0, ($0.3 - $0.2) / $0.1) : ($0.0, 0)}.max(by:{$0.1>$1.1})
            let blocker = try database.pluck(blockQuery)
            let bestAtk = atks.map{$0.1 > 0 ? ($0.0, ($0.3 - $0.2) / $0.1) : ($0.0, 0)}
            let bestRcv = srvs.map{$0.1 > 0 ? ($0.0, ($0.1 - $0.2) / $0.1) : ($0.0, 0)}
            
            scouts["server"] = server ?? (0,0)
            scouts["blocker"] = (blocker?[Expression<Int>("player")] ?? 0, blocker?[Expression<Int>("id").count] ?? 0)
            scouts["bestAtk"] = bestAtk.max(by:{$0.1>$1.1}) ?? (0,0)
            scouts["bestRcv"] = bestRcv.max(by:{$0.1>$1.1}) ?? (0,0)
            scouts["worstAtk"] = bestAtk.min(by:{$0.1<$1.1}) ?? (0,0)
            scouts["worstRcv"] = bestRcv.min(by:{$0.1<$1.1}) ?? (0,0)

            return scouts
        } catch {
            print(error)
            return [:]
        }
    }
    func playersRank() -> Dictionary<String, [(Int, Float,Int,Int,Int)]>{
        var scouts: Dictionary<String, [(Int, Float,Int,Int,Int)]> = [:]
        do{
            guard let database = DB.shared.db else {
                return [:]
            }
            var serveQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "serve")
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var aceQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "serve")
                .filter(Expression<Int>("difficulty") == 5)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var serveErrQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "serve")
                .filter(Expression<Int>("difficulty") == 0)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var srvs:[(Int,Int,Int,Int)] = []
            for srv in try database.prepare(serveQuery){
                srvs.append((srv[Expression<Int>("player")], srv[Expression<Int>("id").count], 0, 0))
            }
            for srv in try database.prepare(serveErrQuery){
                let i = srvs.firstIndex(where: {$0.0 == srv[Expression<Int>("player")]})
                if i != nil{
                    srvs[i!].2 = srv[Expression<Int>("id").count]
                }
            }
            for srv in try database.prepare(aceQuery){
                let i = srvs.firstIndex(where: {$0.0 == srv[Expression<Int>("player")]})
                if i != nil{
                    srvs[i!].3 = srv[Expression<Int>("id").count]
                }
            }
            
            var blockQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "block")
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var blockErrQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "block")
                .filter(Expression<Int>("difficulty") != 0)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var blockptQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "block")
                .filter(Expression<Int>("difficulty") == 5)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var blks:[(Int,Int,Int,Int)] = []
            for blk in try database.prepare(blockQuery){
                blks.append((blk[Expression<Int>("player")], blk[Expression<Int>("id").count], 0, 0))
            }
            for blk in try database.prepare(blockErrQuery){
                let i = blks.firstIndex(where: {$0.0 == blk[Expression<Int>("player")]})
                if i != nil{
                    blks[i!].2 = blk[Expression<Int>("id").count]
                }
            }
            for blk in try database.prepare(blockptQuery){
                let i = blks.firstIndex(where: {$0.0 == blk[Expression<Int>("player")]})
                if i != nil{
                    blks[i!].3 = blk[Expression<Int>("id").count]
                }
            }
            
            var bestrcvQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "receive")
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var worstrcvQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "receive")
                .filter(Expression<Int>("difficulty") == 5)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var rcvs:[(Int,Int,Int,Int)] = []
            for rcv in try database.prepare(bestrcvQuery){
                rcvs.append((rcv[Expression<Int>("player")], rcv[Expression<Int>("id").count], 0, 0))
            }
            for rcv in try database.prepare(worstrcvQuery){
                let i = rcvs.firstIndex(where: {$0.0 == rcv[Expression<Int>("player")]})
                if i != nil{
                    rcvs[i!].2 = rcv[Expression<Int>("id").count]
                }
            }
            
            var bestatkQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "attack")
                .filter(Expression<Int>("difficulty") == 5)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var worstatkQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "attack")
                .filter(Expression<Int>("difficulty") == 0)
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var atkQuery = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<String>("action") == "attack")
                .group(Expression<Int>("player")).select([Expression<Int>("player"), Expression<Int>("id").count])
                .order(Expression<Int>("id").count)
            
            var atks:[(Int,Int,Int,Int)] = []
            for atk in try database.prepare(atkQuery){
                atks.append((atk[Expression<Int>("player")], atk[Expression<Int>("id").count], 0, 0))
            }
            for atk in try database.prepare(worstatkQuery){
                let i = atks.firstIndex(where: {$0.0 == atk[Expression<Int>("player")]})
                if i != nil{
                    atks[i!].2 = atk[Expression<Int>("id").count]
                }
            }
            for atk in try database.prepare(bestatkQuery){
                let i = atks.firstIndex(where: {$0.0 == atk[Expression<Int>("player")]})
                if i != nil{
                    atks[i!].3 = atk[Expression<Int>("id").count]
                }
            }
            let server = srvs.map{$0.1 > 0 ? ($0.0, Float($0.3 - $0.2) / Float($0.1), $0.1, $0.2, $0.3) : ($0.0, 0.0, 0,0,0)}.sorted(by:{$0.1>$1.1})
            let blocker = blks.map{$0.1 > 0 ? ($0.0, Float($0.1), $0.1, $0.2, $0.3) : ($0.0, 0.0, 0,0,0)}.sorted(by:{$0.1>$1.1})
            let bestAtk = atks.map{$0.1 > 0 ? ($0.0, Float($0.3 - $0.2) / Float($0.1), $0.1, $0.2, $0.3) : ($0.0, 0.0, 0,0,0)}
            let bestRcv = srvs.map{$0.1 > 0 ? ($0.0, Float($0.1 - $0.2) / Float($0.1), $0.1, $0.2, $0.3) : ($0.0, 0.0, 0,0,0)}
            
            scouts["serve"] = server
            scouts["block"] = blocker
            scouts["attack"] = bestAtk.sorted(by:{$0.1>$1.1})
            scouts["receive"] = bestRcv.sorted(by:{$0.1>$1.1})

            return scouts
        } catch {
            print(error)
            return [:]
        }
    }
    func bestRotation() -> ([Int], Int){
        var scouts: ([Int], Int) = ([], 0)
        do{
            guard let database = DB.shared.db else {
                return ([], 0)
            }
            var bestRot = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<Int>("difficulty") == 5)
                .filter(Expression<String>("action") == "attack" || Expression<String>("action") == "serve" || Expression<String>("action") == "block")
                .group(Expression<String>("rotation")).select([Expression<String>("rotation"), Expression<Int>("id").count])
            
            let rotation = try database.pluck(bestRot)
            scouts = (rotation?[Expression<String>("rotation")].components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil }.map{ Int($0)! } ?? [0,0,0,0,0,0], rotation?[Expression<Int>("id").count] ?? 0)
            return scouts
        } catch {
            print(error)
            return ([], 0)
        }
    }
    func rotationStats(rotation: [Int]) -> Dictionary<Int, [(String, Int)]>{
        var scouts: Dictionary<Int, [(String, Int)]> = [:
        ]
        do{
            guard let database = DB.shared.db else {
                return [:]
            }
            var bestRot = Table("scout")
                .filter(Expression<String>("team_name") == self.teamName)
                .filter(Expression<Int>("team_related") == self.teamRelated.id)
                .filter(Expression<Int>("difficulty") == 5)
                .filter(Expression<String>("rotation") == rotation.description)
                .filter(Expression<String>("action") == "attack" || Expression<String>("action") == "serve" || Expression<String>("action") == "block")
                .group(Expression<String>("action"))
                .group(Expression<Int>("player")).select([Expression<String>("action"), Expression<Int>("player"), Expression<Int>("id").count])
            
            for rotation in try database.prepare(bestRot){
                if scouts.keys.contains(rotation[Expression<Int>("player")]){
                    scouts[rotation[Expression<Int>("player")]]?.append((rotation[Expression<String>("action")], rotation[Expression<Int>("id").count]))
                }else{
                    scouts[rotation[Expression<Int>("player")]] = [(rotation[Expression<String>("action")], rotation[Expression<Int>("id").count])]
                }
                
            }
            
            return scouts
        } catch {
            print(error)
            return [:]
        }
    }
    
    func getPlayers() -> [Int]{
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var players: [Int] = []
            for player in try database.prepare(Table("scout").filter(Expression<String>("team_name") == self.teamName).select(distinct: Expression<Int>("player"))){
                let p = player[Expression<Int>("player")]
                if p != 0 {
                    players.append(p)
                }
            }
            return players
        } catch {
            print(error)
            return []
        }
    }
    
    func updateName(name: String)->Bool{
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            let update = Table("scout").filter(Expression<String>("team_name") == self.teamName).update([
                Expression<String>("team_name") <- name
            ])
            if try database.run(update) > 0 {
                return true
            }
        } catch {
            print(error)
        }
        return false
    }
    static func dates() -> [Date]{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        var dates: [Date] = []
        do{
            guard let database = DB.shared.db else {
                return []
                
            }
            let query = Table("scout").select(distinct: Expression<String>("date"))
            
            for date in try database.prepare(query) {
                let d = date[Expression<Date>("date")]
                if (d != nil) {
                    dates.append(d)
                }
                
            }
            return dates
        } catch {
            print(error)
            return []
        }
    }
}





