import SQLite
import SwiftUI

class Player: Equatable, Hashable {
    var id:Int;
    var number:Int
    var team:Int
    var name:String
    var active:Int
    var birthday: Date
    var position : PlayerPosition
    
    init(name:String, number:Int, team:Int, active:Int, birthday:Date, position: PlayerPosition =  .universal, id:Int?){
        self.name=name
        self.number=number
        self.team=team
        self.active=active
        self.birthday = birthday
        self.position = position
        self.id=id ?? 0
    }
    init(){
        self.name="their.player".trad()
        self.number=0
        self.team=0
        self.active=0
        self.birthday = .now
        self.position = .universal
        self.id=0
    }
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func createPlayer(player: Player)->Player?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if player.id != 0{
                try database.run(Table("player").insert(
                    Expression<String>("name") <- player.name,
                    Expression<Int>("number") <- player.number,
                    Expression<Int>("team") <- player.team,
                    Expression<Int>("active") <- player.active,
                    Expression<Date>("birthday") <- player.birthday,
                    Expression<Int>("id") <- player.id,
                    Expression<String>("position") <- player.position.rawValue
                ))
            }else{
                let id = try database.run(Table("player").insert(
                    Expression<String>("name") <- player.name,
                    Expression<Int>("number") <- player.number,
                    Expression<Int>("active") <- player.active,
                    Expression<Date>("birthday") <- player.birthday,
                    Expression<Int>("team") <- player.team,
                    Expression<String>("position") <- player.position.rawValue
                ))
                player.id = Int(id)
            }
            return player
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
            let update = Table("player").filter(self.id == Expression<Int>("id")).update([
                Expression<String>("name") <- self.name,
                Expression<Int>("number") <- self.number,
                Expression<Int>("active") <- self.active,
                Expression<Date>("birthday") <- self.birthday,
                Expression<Int>("team") <- self.team,
                Expression<String>("position") <- self.position.rawValue
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
            try database.run(Table("player_teams").filter(Expression<Int>("player") == self.id).delete())
            let delete = Table("player").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Player]{
        var players: [Player] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for player in try database.prepare(Table("player")) {
                players.append(Player(
                    name: player[Expression<String>("name")],
                    number: player[Expression<Int>("number")],
                    team: player[Expression<Int>("team")],
                    active: player[Expression<Int>("active")],
                    birthday: player[Expression<Date>("birthday")],
                    position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                    id: player[Expression<Int>("id")]))
            }
            return players
        } catch {
            print(error)
            return []
        }
    }
    static func allActive() -> [Player]{
        var players: [Player] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for player in try database.prepare(Table("player").filter(Expression<Int>("active") == 1)) {
                players.append(Player(
                    name: player[Expression<String>("name")],
                    number: player[Expression<Int>("number")],
                    team: player[Expression<Int>("team")],
                    active: player[Expression<Int>("active")],
                    birthday: player[Expression<Date>("birthday")],
                    position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                    id: player[Expression<Int>("id")]))
            }
            return players
            
        } catch {
            print(error)
            return []
        }
    }
    func getBirthDay() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.birthday)
    }
    static func deleted() -> [Player]{
        var players: [Player] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for player in try database.prepare(Table("player").filter(Expression<Int>("team")==0)) {
                players.append(Player(
                    name: player[Expression<String>("name")],
                    number: player[Expression<Int>("number")],
                    team: player[Expression<Int>("team")],
                    active: player[Expression<Int>("active")],
                    birthday: player[Expression<Date>("birthday")],
                    position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                    id: player[Expression<Int>("id")]))
            }
            return players
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Player?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let player = try database.pluck(Table("player").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Player(
                name: player[Expression<String>("name")],
                number: player[Expression<Int>("number")],
                team: player[Expression<Int>("team")],
                active: player[Expression<Int>("active")],
                birthday: player[Expression<Date>("birthday")],
                position: PlayerPosition(rawValue: player[Expression<String>("position")])!,
                id: player[Expression<Int>("id")])
        } catch {
            print(error)
            return nil
        }
    }
    func stats() -> [Stat] {
        var stats: [Stat] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for stat in try database.prepare(Table("stat").filter(Expression<Int>("player") == self.id || Expression<Int>("server") == self.id || Expression<Int>("setter") == self.id)) {
                stats.append(
                    Stat(
                        id: stat[Expression<Int>("id")],
                        match: stat[Expression<Int>("match")],
                        set: stat[Expression<Int>("set")],
                        player: stat[Expression<Int>("player")],
                        action: stat[Expression<Int>("action")],
                        rotation: Rotation.find(id: stat[Expression<Int>("rotation")])!,
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
                )
            }
            return stats
        } catch {
            print(error)
            return []
        }
    }
    func measurements() -> [PlayerMeasures] {
        var measures: [PlayerMeasures] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for measure in try database.prepare(Table("player_measures").filter(Expression<Int>("player") == self.id)) {
                measures.append(
                    PlayerMeasures(
                        id: measure[Expression<Int>("id")],
                        player: Player.find(id: measure[Expression<Int>("player")])!,
                        date:measure[Expression<Date>("date")],
                        height: measure[Expression<Int>("height")],
                        weight: measure[Expression<Double>("weight")],
                        oneHandReach: measure[Expression<Int>("one_hand_reach")],
                        twoHandReach: measure[Expression<Int>("two_hand_reach")],
                        attackReach: measure[Expression<Int>("attack_reach")],
                        blockReach: measure[Expression<Int>("block_reach")],
                        breadth: measure[Expression<Int>("breadth")])
                )
            }
            return measures
        } catch {
            print(error)
            return []
        }
    }
    static func truncate(){
        do{
            guard let database = DB.shared.db else {
                return
            }
            try database.run(Table("player").delete())
        }catch{
            print("error truncating player")
            return
        }
    }
    
    func toJSON()->Dictionary<String,Any>{
        return [
            "id":self.id,
            "name":self.name,
            "number":self.number,
            "team":self.team,
            "active":self.active,
            "birthday":self.birthday.timeIntervalSince1970,
            "position":self.position.rawValue
        ]
    }
    
    static func playerTeamsToJSON()->Array<Dictionary<String, Any>>{
        var result:Array<Dictionary<String, Any>> = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for pt in try database.prepare(Table("player_teams")){
                result.append(["id":pt[Expression<Int>("id")], "player":pt[Expression<Int>("player")], "team":pt[Expression<Int>("team")]])
            }
            return result
        }catch{
            print("error exporting player_teams")
            return []
        }
        
        
    }
    static func importTeams(id: Int, player: Int, team:Int)->Bool{
        do {
            guard let database = DB.shared.db else {
                return false
            }
            let id = try database.run(Table("player_teams").insert(
                Expression<Int>("player") <- player,
                Expression<Int>("team") <- team,
                Expression<Int>("id") <- id
            ))
            return id < 0
        } catch {
            print(error)
        }
        return false
    }
}

enum PlayerPosition:String{
    case setter
    case opposite
    case outside
    case midBlock
    case universal
    case libero
}




