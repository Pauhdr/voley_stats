import SQLite
import SwiftUI

class Stat: Equatable, Identifiable {
    var id:Int;
    var set:Int
    var player:Int
    var match:Int
    var rotation:Rotation
    var rotationTurns:Int
    var action: Int
    var score_us: Int = 0
    var score_them: Int = 0
    var to: Int = 0
    var stage: Int
    var server: Int = 0
    var player_in: Int? = nil
    var detail: String = ""
    var rotationCount:Int
    var setter: Player?
    
    init(match:Int, set:Int, player:Int, action:Int, rotation:Rotation, rotationTurns: Int, rotationCount: Int, score_us:Int, score_them:Int, to:Int, stage:Int, server:Int, player_in:Int?, detail:String, setter: Player? = nil){
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
        self.rotationTurns = rotationTurns
        self.rotationCount = rotationCount
        self.setter = setter
    }
    init(id:Int, match:Int, set:Int, player:Int, action:Int, rotation:Rotation, rotationTurns: Int, rotationCount: Int, score_us:Int, score_them:Int, to:Int, stage:Int, server:Int, player_in:Int?, detail:String, setter: Player? = nil){
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
        self.rotationTurns = rotationTurns
        self.rotationCount = rotationCount
        self.setter = setter
        
    }
    static func ==(lhs: Stat, rhs: Stat) -> Bool {
        return lhs.id == rhs.id
    }
    var description : String {
//        var text: String = self.get(rotate: 0).filter{$0 != nil}.reduce("["){ $0 + $1!.name + ", " }
        return self.id.description
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
                    Expression<Int>("rotation") <- stat.rotation.id,
                    Expression<Int>("rotation_turns") <- stat.rotationTurns,
                    Expression<Int>("rotation_count") <- stat.rotationCount,
                    Expression<Int>("to") <- stat.to,
                    Expression<Int>("action") <- stat.action,
                    Expression<Int>("score_us") <- stat.score_us,
                    Expression<Int>("score_them") <- stat.score_them,
                    Expression<Int>("stage") <- stat.stage,
                    Expression<Int>("server") <- stat.server,
                    Expression<Int?>("player_in") <- stat.player_in,
                    Expression<String>("detail") <- stat.detail,
                    Expression<Int>("setter") <- stat.setter?.id ?? 0,
                    Expression<Int>("id") <- stat.id
                ))
            }else{
                let id = try database.run(Table("stat").insert(
                    Expression<Int>("player") <- stat.player,
                    Expression<Int>("set") <- stat.set,
                    Expression<Int>("match") <- stat.match,
                    Expression<Int>("rotation") <- stat.rotation.id,
                    Expression<Int>("rotation_turns") <- stat.rotationTurns,
                    Expression<Int>("rotation_count") <- stat.rotationCount,
                    Expression<Int>("to") <- stat.to,
                    Expression<Int>("action") <- stat.action,
                    Expression<Int>("score_us") <- stat.score_us,
                    Expression<Int>("score_them") <- stat.score_them,
                    Expression<Int>("stage") <- stat.stage,
                    Expression<Int>("server") <- stat.server,
                    Expression<String>("detail") <- stat.detail,
                    Expression<Int>("setter") <- stat.setter?.id ?? 0,
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
                Expression<Int>("rotation") <- self.rotation.id,
                Expression<Int>("rotation_turns") <- self.rotationTurns,
                Expression<Int>("rotation_count") <- self.rotationCount,
                Expression<Int>("to") <- self.to,
                Expression<Int>("action") <- self.action,
                Expression<Int>("score_us") <- self.score_us,
                Expression<Int>("score_them") <- self.score_them,
                Expression<Int>("stage") <- self.stage,
                Expression<Int>("server") <- self.server,
                Expression<String>("detail") <- self.detail,
                Expression<Int>("setter") <- self.setter?.id ?? 0,
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
                    setter: Player.find(id: stat[Expression<Int>("setter")])))
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Stat?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let stat = try database.pluck(Table("stat").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            print(stat[Expression<Int>("id")])
            return Stat(
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
                setter: Player.find(id: stat[Expression<Int>("setter")]))
        } catch {
            print(error)
            return nil
        }
    }
    static func truncate(){
        do{
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("stat").delete())
        }catch{
            print("error truncating stat")
            return
        }
    }
    
    func toJSON()->Dictionary<String,Any>{
        return [
            "id":self.id,
            "match":self.match,
            "set":self.set,
            "player":self.player,
            "rotation":self.rotation.id,
            "action":self.action,
            "score_us":self.score_us,
            "score_them":self.score_them,
            "to":self.to,
            "stage":self.stage,
            "server":self.server,
            "player_in":self.player_in,
            "detail":self.detail,
            "rotationTurns":self.rotationTurns,
            "rotationCount":self.rotationCount,
            "setter":self.setter?.id ?? 0
        ]
    }
}





