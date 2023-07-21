import SQLite
import SwiftUI

class Player: Equatable, Hashable {
    var id:Int;
    var number:Int
    var team:Int
    var name:String
    var active:Int
    var birthday: Date
    
    init(name:String, number:Int, team:Int, active:Int, birthday:Date, id:Int?){
        self.name=name
        self.number=number
        self.team=team
        self.active=active
        self.birthday = birthday
        self.id=id ?? 0
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
                    Expression<Int>("id") <- player.id
                ))
            }else{
                let id = try database.run(Table("player").insert(
                    Expression<String>("name") <- player.name,
                    Expression<Int>("number") <- player.number,
                    Expression<Int>("active") <- player.active,
                    Expression<Date>("birthday") <- player.birthday,
                    Expression<Int>("team") <- player.team
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
                players.append(Player(name: player[Expression<String>("name")], number: player[Expression<Int>("number")], team: player[Expression<Int>("team")], active: player[Expression<Int>("active")], birthday: player[Expression<Date>("birthday")], id: player[Expression<Int>("id")]))
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
                players.append(Player(name: player[Expression<String>("name")], number: player[Expression<Int>("number")], team: player[Expression<Int>("team")], active: player[Expression<Int>("active")], birthday: player[Expression<Date>("birthday")], id: player[Expression<Int>("id")]))
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
                players.append(Player(name: player[Expression<String>("name")], number: player[Expression<Int>("number")], team: player[Expression<Int>("team")], active: player[Expression<Int>("active")], birthday: player[Expression<Date>("birthday")], id: player[Expression<Int>("id")]))
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
            return Player(name: player[Expression<String>("name")], number: player[Expression<Int>("number")], team: player[Expression<Int>("team")], active: player[Expression<Int>("active")], birthday: player[Expression<Date>("birthday")], id: player[Expression<Int>("id")])
        } catch {
            print(error)
            return nil
        }
    }
}





