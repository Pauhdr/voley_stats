import SQLite
import SwiftUI

class Stat: Equatable, Identifiable {
    var id:Int;
    var set:Int
    var player:Int
    var match:Int
    var rotation:Array<Int>
    var action: Int
    var score_us: Int = 0
    var score_them: Int = 0
    var to: Int = 0
    var stage: Int
    var server: Int = 0
    var player_in: Int? = nil
    var detail: String = ""
    
    init(match:Int, set:Int, player:Int, action:Int, rotation:Array<Int>, score_us:Int, score_them:Int, to:Int, stage:Int, server:Int, player_in:Int?, detail:String){
        self.match=match
        self.set=set
        self.player=player
        self.rotation=rotation
        self.action = action
        self.id = 0
        self.score_us = score_us
        self.score_them = score_them
        self.to = to
        self.stage = stage
        self.server = server
        self.player_in = player_in
        self.detail = detail
    }
    init(id:Int, match:Int, set:Int, player:Int, action:Int, rotation:Array<Int>, score_us:Int, score_them:Int, to:Int, stage:Int, server:Int, player_in:Int?, detail:String){
        self.match=match
        self.set=set
        self.player=player
        self.rotation=rotation
        self.action = action
        self.id = id
        self.score_us = score_us
        self.score_them = score_them
        self.to = to
        self.stage = stage
        self.server = server
        self.player_in = player_in
        self.detail = detail
    }
    static func ==(lhs: Stat, rhs: Stat) -> Bool {
        return lhs.id == rhs.id
    }
    static func createStat(stat: Stat)->Stat?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if stat.id != 0 {
                try database.run(Table("stat").insert(
                    Expression<Int>("player") <- stat.player,
                    Expression<Int>("set") <- stat.set,
                    Expression<Int>("match") <- stat.match,
                    Expression<String>("rotation") <- stat.rotation.description,
                    Expression<Int>("to") <- stat.to,
                    Expression<Int>("action") <- stat.action,
                    Expression<Int>("score_us") <- stat.score_us,
                    Expression<Int>("score_them") <- stat.score_them,
                    Expression<Int>("stage") <- stat.stage,
                    Expression<Int>("server") <- stat.server,
                    Expression<Int?>("player_in") <- stat.player_in,
                    Expression<String>("detail") <- stat.detail,
                    Expression<Int>("id") <- stat.id
                ))
            }else{
                let id = try database.run(Table("stat").insert(
                    Expression<Int>("player") <- stat.player,
                    Expression<Int>("set") <- stat.set,
                    Expression<Int>("match") <- stat.match,
                    Expression<String>("rotation") <- stat.rotation.description,
                    Expression<Int>("to") <- stat.to,
                    Expression<Int>("action") <- stat.action,
                    Expression<Int>("score_us") <- stat.score_us,
                    Expression<Int>("score_them") <- stat.score_them,
                    Expression<Int>("stage") <- stat.stage,
                    Expression<Int>("server") <- stat.server,
                    Expression<String>("detail") <- stat.detail,
                    Expression<Int?>("player_in") <- stat.player_in
                ))
                stat.id = Int(id)
            }
            return stat
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
            let update = Table("stat").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("player") <- self.player,
                Expression<Int>("set") <- self.set,
                Expression<Int>("match") <- self.match,
                Expression<String>("rotation") <- self.rotation.description,
                Expression<Int>("to") <- self.to,
                Expression<Int>("action") <- self.action,
                Expression<Int>("score_us") <- self.score_us,
                Expression<Int>("score_them") <- self.score_them,
                Expression<Int>("stage") <- self.stage,
                Expression<Int>("server") <- self.server,
                Expression<String>("detail") <- self.detail,
                Expression<Int?>("player_in") <- self.player_in
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
            let delete = Table("stat").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Stat]{
        var stats: [Stat] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for stat in try database.prepare(Table("stat")) {
                stats.append(Stat(
                    id: stat[Expression<Int>("id")],
                    match: stat[Expression<Int>("match")],
                    set: stat[Expression<Int>("set")],
                    player: stat[Expression<Int>("player")],
                    action: stat[Expression<Int>("action")],
                    rotation: stat[Expression<String>("rotation")].components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil }.map{ Int($0)! },
                    score_us: stat[Expression<Int>("score_us")],
                    score_them: stat[Expression<Int>("score_them")],
                    to: stat[Expression<Int>("to")],
                    stage: stat[Expression<Int>("stage")],
                server: stat[Expression<Int>("server")],
                player_in: stat[Expression<Int?>("player_in")], detail: stat[Expression<String>("detail")]))
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
}





