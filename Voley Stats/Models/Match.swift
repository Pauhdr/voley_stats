import SQLite
import SwiftUI

class Match: Equatable {
    var id:Int;
    var opponent:String
    var date:Date
    var n_sets:Int
    var n_players:Int
    var team:Int
    var location: String
    var home: Bool
    var league:Bool
    var tournament:Tournament?
    
    init(opponent:String, date:Date, location: String, home:Bool, n_sets:Int, n_players:Int, team:Int, league:Bool = false, tournament:Tournament?, id:Int?){
        self.opponent=opponent
        self.date=date
        self.n_sets=n_sets
        self.n_players=n_players
        self.team=team
        self.location = location
        self.home=home
        self.league=league
        self.tournament=tournament
        self.id=id ?? 0
    }
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    static func createMatch(match: Match)->Match?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            
            if match.id != 0 {
                try database.run(Table("match").insert(
                    Expression<String>("opponent") <- match.opponent,
                    Expression<Date>("date") <- match.date,
                    Expression<String>("location") <- match.location,
                    Expression<Bool>("home") <- match.home,
                    Expression<Int>("n_sets") <- match.n_sets,
                    Expression<Int>("n_players") <- match.n_players,
                    Expression<Int>("team") <- match.team,
                    Expression<Int>("tournament") <- match.tournament?.id ?? 0,
                    Expression<Bool>("league") <- match.league,
                    Expression<Int>("id") <- match.id
                ))
            }else{
                let id = try database.run(Table("match").insert(
                    Expression<String>("opponent") <- match.opponent,
                    Expression<Date>("date") <- match.date,
                    Expression<String>("location") <- match.location,
                    Expression<Bool>("home") <- match.home,
                    Expression<Int>("n_sets") <- match.n_sets,
                    Expression<Int>("n_players") <- match.n_players,
                    Expression<Int>("team") <- match.team,
                    Expression<Int>("tournament") <- match.tournament?.id ?? 0,
                    Expression<Bool>("league") <- match.league
                ))
                match.id = Int(id)
            }
            return match
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
            
            let update = Table("match").filter(self.id == Expression<Int>("id")).update([
                Expression<String>("opponent") <- self.opponent,
                Expression<Bool>("home") <- self.home,
                Expression<Date>("date") <- self.date,
                Expression<String>("location") <- self.location,
                Expression<Int>("n_sets") <- self.n_sets,
                Expression<Int>("n_players") <- self.n_players,
                Expression<Int>("tournament") <- self.tournament?.id ?? 0,
                Expression<Bool>("league") <- self.league,
                Expression<Int>("team") <- self.team
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
            let delete = Table("match").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    func sets() -> [Set]{
        var sets: [Set] = []
        do {
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for set in try database.prepare(Table("set").filter(Expression<Int>("match")==self.id)) {
                sets.append(Set(
                    id: set[Expression<Int>("id")],
                    number: set[Expression<Int>("number")],
                    first_serve: set[Expression<Int>("first_serve")],
                    match: set[Expression<Int>("match")],
                    rotation: Rotation.find(id: set[Expression<Int>("rotation")])!,
                    liberos: [set[Expression<Int?>("libero1")], set[Expression<Int?>("libero2")]],
                    result: set[Expression<Int>("result")],
                    score_us: set[Expression<Int>("score_us")],
                    score_them: set[Expression<Int>("score_them")]))
            }
            
            return sets
        }catch{
            print(error)
            return []
        }
    }
    func result() -> (Int, Int) {
        var result = (0, 0)
        var sets = self.sets()
        result.0 = sets.filter{$0.score_us > $0.score_them}.count
        result.1 = sets.filter{$0.score_us < $0.score_them}.count
        return result
    }
    static func all() -> [Match]{
        var matches: [Match] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for match in try database.prepare(Table("match")) {
                matches.append(Match(opponent: match[Expression<String>("opponent")], date: match[Expression<Date>("date")], location: match[Expression<String>("location")], home: match[Expression<Bool>("home")], n_sets: match[Expression<Int>("n_sets")], n_players: match[Expression<Int>("n_players")], team: match[Expression<Int>("team")], league: match[Expression<Bool>("league")], tournament: Tournament.find(id: match[Expression<Int>("tournament")]), id: match[Expression<Int>("id")]))
            }
            return matches
        } catch {
            print(error)
            return []
        }
    }
    func stats() -> [Stat]{
        var stats: [Stat] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for stat in try database.prepare(Table("stat").filter(Expression<Int>("match")==self.id)) {
                stats.append(Stat(
                    id: stat[Expression<Int>("id")],
                    match: stat[Expression<Int>("match")],
                    set: stat[Expression<Int>("set")],
                    player: stat[Expression<Int>("player")],
                    action: stat[Expression<Int>("action")],
                    rotation: Rotation.find(id: stat[Expression<Int>("rotation")])!,
                    rotationTurns: stat[Expression<Int>("rotation_turns")],
                    score_us: stat[Expression<Int>("score_us")],
                    score_them: stat[Expression<Int>("score_them")],
                    to: stat[Expression<Int>("to")],
                    stage: stat[Expression<Int>("stage")],
                    server: stat[Expression<Int>("server")],
                player_in: stat[Expression<Int?>("player_in")],
                                detail: stat[Expression<String>("detail")]))
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
    func rotations() -> [Int]{
        var rotations: [Int] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for stat in try database.prepare(Table("stat").filter(self.id == Expression<Int>("match")).select(distinct: Expression<Int>("rotation"))) {
                rotations.append(stat[Expression<Int>("rotation")])
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
            let so = try database.scalar(Table("stat").filter(self.id == Expression<Int>("match") && rotation == Expression<Int>("rotation") && Expression<Int>("server") == 0 && Expression<Int>("to") == 1 && Expression<Int>("stage") == 1 && Expression<Int>("player") != 0).count)
            let bp = try database.scalar(Table("stat").filter(self.id == Expression<Int>("match") && rotation == Expression<Int>("rotation") && Expression<Int>("server") != 0 && Expression<Int>("to") == 1 && Expression<Int>("stage") == 0 && Expression<Int>("player") != 0).count)
            result = (Int(so), Int(bp))
            return result
        } catch {
            print(error)
            return (0, 0)
        }
    }
    func getBests()->Dictionary<String,Player?>{
        var result: Dictionary<String,Player?> = [
            "attack": nil,
            "serve":nil,
            "block":nil,
            "receive":nil,
            "mvp":nil
        ]
        do{
            guard let database = DB.shared.db else {
                return result
            }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match = \(self.id) AND action = 8 AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["serve"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match = \(self.id) AND action in (9, 10, 11, 12) AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["attack"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match = \(self.id) AND action = 13 AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["block"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match = \(self.id) AND action in (3, 4) AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["receive"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
//            for r in  try database.prepare("SELECT player, stat.`to`, count(*) as aces FROM stat WHERE match = \(self.id) AND player != 0 AND stat.`to` = 1 GROUP BY player, stat.`to` ORDER BY aces DESC"){
////                result["receive"] = Player.find(id:Int(r[0] as! Int64))
//                print(r)
//
//                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match = \(self.id) AND player != 0 AND stat.`to` = 1 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["mvp"] = Player.find(id:Int(r[0] as! Int64))
//                print(r)

                }
            return result
        } catch {
            print(error)
            return result
        }
    }
    
    static func getBests(matches: [Match])->Dictionary<String,Player?>{
        var result: Dictionary<String,Player?> = [
            "attack": nil,
            "serve":nil,
            "block":nil,
            "receive":nil,
            "mvp":nil
        ]
        do{
            guard let database = DB.shared.db else {
                return result
            }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match IN (\(matches.map{String($0.id)}.joined(separator: ","))) AND action = 8 AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["serve"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match IN (\(matches.map{String($0.id)}.joined(separator: ","))) AND action in (9, 10, 11, 12) AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["attack"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match IN (\(matches.map{String($0.id)}.joined(separator: ","))) AND action = 13 AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["block"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match IN (\(matches.map{String($0.id)}.joined(separator: ","))) AND action in (3, 4) AND player != 0 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["receive"] = Player.find(id:Int(r[0] as! Int64))
                    
                }
//            for r in  try database.prepare("SELECT player, stat.`to`, count(*) as aces FROM stat WHERE match = \(self.id) AND player != 0 AND stat.`to` = 1 GROUP BY player, stat.`to` ORDER BY aces DESC"){
////                result["receive"] = Player.find(id:Int(r[0] as! Int64))
//                print(r)
//
//                }
            for r in  try database.prepare("SELECT player, count(*) as aces FROM stat WHERE match IN (\(matches.map{String($0.id)}.joined(separator: ","))) AND player != 0 AND stat.`to` = 1 GROUP BY player ORDER BY aces DESC LIMIT 1"){
                result["mvp"] = Player.find(id:Int(r[0] as! Int64))
//                print(r)

                }
            return result
        } catch {
            print(error)
            return result
        }
    }
    
    func exportStats() -> String {
        let team = Team.find(id: self.team)
        var csvString = "set,jugadora,saques,errores,directos,puntos ganados,% saque,bloqueos,puntos,errores,recepciones,errores,-,+,++,nota recepcion,ataques,puntos,errores,% puntos,defensas,errores,free,errores,-,+,++,nota free\n"
        for set in self.sets(){
            if set.first_serve != 0 {
                let stats = set.stats()
                for player in team!.players() {
                    csvString += self.getStatsString(set: set, player: player, stats: stats)
                }
                csvString += ":\n"
            }
        }
        for player in team!.players() {
            csvString += self.getStatsString(set: nil, player: player, stats: self.stats())
        }
        
        return csvString
    }
    static func find(id: Int) -> Match?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let match = try database.pluck(Table("match").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Match(opponent: match[Expression<String>("opponent")], date: match[Expression<Date>("date")], location: match[Expression<String>("location")], home: match[Expression<Bool>("home")], n_sets: match[Expression<Int>("n_sets")], n_players: match[Expression<Int>("n_players")], team: match[Expression<Int>("team")], league: match[Expression<Bool>("league")], tournament: Tournament.find(id: match[Expression<Int>("tournament")]), id: match[Expression<Int>("id")])
        } catch {
            print(error)
            return nil
        }
    }
    func getDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH.mm"
        return df.string(from: self.date)
    }
    func getStatsString(set: Set?, player: Player, stats: [Stat]) -> String {
        let ps = stats.filter{s in return s.player == player.id}
        //serve stats
        let serves = stats.filter{s in return s.server == player.id && s.stage == 0 && s.to != 0}
        let serveError = serves.filter{s in return [15, 32].contains(s.action)}.count
        let aces = serves.filter{s in return s.action==8}.count
        let pg = serves.filter{s in return s.to == 1}.count
        let servePerc = serves.count == 0 ? "0" : String(format: "%.2f", (Float(pg)/Float(serves.count))*100)
        
        //block stats
        let blocks = ps.filter{s in return [7, 13, 20, 31].contains(s.action)}
        let blocked = blocks.filter{s in return s.action==13}.count
        let blockError = blocks.filter{s in return [20,31].contains(s.action)}.count
        
        //receive stats
        let receives = ps.filter{s in return [1, 2, 3, 4, 22].contains(s.action)}
        let s1 = receives.filter{s in return s.action==2}.count
        let s2 = receives.filter{s in return s.action==3}.count
        let s3 = receives.filter{s in return s.action==4}.count
        let rcvErrors = receives.filter{s in return s.action==22}.count
        let rcvRate = receives.count == 0 ? "0" : String(format: "%.2f", Float(s1 + 2*s2 + 3*s3)/Float(receives.count))
        
        //Attack stats
        let attacks = ps.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action)}
        let kills = attacks.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
        let killErrors = attacks.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
        let killPerc = attacks.count == 0 ? "0" : String(format: "%.2f", (Float(kills)/Float(attacks.count))*100)
        
        //Dig stats
        let digs = ps.filter{s in return [23, 5, 21].contains(s.action)}
        let digError = digs.filter{s in return [23, 25].contains(s.action)}.count
        
        //Free stats
        let frees = ps.filter{s in return [25, 35, 36, 37].contains(s.action)}
        let freeError = frees.filter{s in return s.action == 25}.count
        let f1 = frees.filter{s in return s.action == 35}.count
        let f2 = frees.filter{s in return s.action == 36}.count
        let f3 = frees.filter{s in return s.action == 37}.count
        let freeRate = frees.count == 0 ? "0" : String(format: "%.2f", Float(f1 + 2*f2 + 3*f3)/Float(frees.count))
        return "\(set != nil ? String(set!.number) : "partido"),\(player.name),\(serves.count),\(serveError),\(aces),\(pg),\(servePerc),\(blocks.count),\(blocked),\(blockError),\(receives.count),\(rcvErrors),\(s1),\(s2),\(s3),\(rcvRate),\(attacks.count),\(kills),\(killErrors),\(killPerc),\(digs.count),\(digError),\(frees.count),\(freeError),\(f1),\(f2),\(f3),\(freeRate)\n"
    }
}

