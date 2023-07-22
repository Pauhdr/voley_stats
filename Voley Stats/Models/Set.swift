import SQLite
import SwiftUI

class Set: Equatable {
    var id:Int;
    var number:Int
    var first_serve:Int
    var match:Int
    var rotation:Rotation
    var result: Int = 0
    var score_us: Int = 0
    var score_them: Int = 0
    var liberos: [Int?]
    
    init(number:Int, first_serve:Int, match:Int, rotation:Rotation, liberos:[Int?]){
        self.number=number
        self.first_serve=first_serve
        self.match=match
        self.rotation=rotation
        self.id = 0
        self.liberos = liberos
    }
    init(id:Int, number:Int, first_serve:Int, match:Int, rotation:Rotation, liberos:[Int?], result: Int, score_us:Int, score_them:Int){
        self.number=number
        self.first_serve=first_serve
        self.match=match
        self.rotation=rotation
        self.id=id
        self.result = result
        self.score_us = score_us
        self.score_them = score_them
        self.liberos = liberos
    }
    static func ==(lhs: Set, rhs: Set) -> Bool {
        return lhs.id == rhs.id
    }
    static func createSet(set: Set)->Set?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if set.id != 0{
                try database.run(Table("set").insert(
                    Expression<Int>("number") <- set.number,
                    Expression<Int>("first_serve") <- set.first_serve,
                    Expression<Int>("match") <- set.match,
                    Expression<Int>("rotation") <- set.rotation.id,
                    Expression<Int?>("libero1") <- set.liberos[0],
                    Expression<Int?>("libero2") <- set.liberos[1],
                    Expression<Int>("result") <- set.result,
                    Expression<Int>("score_us") <- set.score_us,
                    Expression<Int>("score_them") <- set.score_them,
                    Expression<Int>("id") <- set.id
                ))
            }else{
                let id = try database.run(Table("set").insert(
                    Expression<Int>("number") <- set.number,
                    Expression<Int>("first_serve") <- set.first_serve,
                    Expression<Int>("match") <- set.match,
                    Expression<Int>("rotation") <- set.rotation.id,
                    Expression<Int?>("libero1") <- set.liberos[0],
                    Expression<Int?>("libero2") <- set.liberos[1],
                    Expression<Int>("result") <- set.result,
                    Expression<Int>("score_us") <- set.score_us,
                    Expression<Int>("score_them") <- set.score_them
                ))
                set.id = Int(id)
            }
            return set
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
            let update = Table("set").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("number") <- self.number,
                Expression<Int>("first_serve") <- self.first_serve,
                Expression<Int>("match") <- self.match,
                Expression<Int>("rotation") <- self.rotation.id,
                Expression<Int?>("libero1") <- self.liberos[0],
                Expression<Int?>("libero2") <- self.liberos[1],
                Expression<Int>("result") <- self.result,
                Expression<Int>("score_us") <- self.score_us,
                Expression<Int>("score_them") <- self.score_them
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
            let delete = Table("set").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Set]{
        var sets: [Set] = []
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for set in try database.prepare(Table("set")) {
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
            for stat in try database.prepare(Table("stat").filter(Expression<Int>("set")==self.id)) {
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
    func timeOuts()->(Int, Int){
        var result = (0,0)
        do{
            guard let database = DB.shared.db else {
                return (0,0)
            }
            let us = try database.scalar(Table("stat").filter(self.id == Expression<Int>("set") && Expression<Int>("action")==0 && Expression<Int>("to") == 1).count)
            let them = try database.scalar(Table("stat").filter(self.id == Expression<Int>("match") && Expression<Int>("action")==0 && Expression<Int>("to") == 2).count)
            result = (us, them)
            return result
        } catch {
            print(error)
            return (0,0)
        }
    }
    static func find(id: Int) -> Set?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let set = try database.pluck(Table("set").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Set(
                id: set[Expression<Int>("id")],
                number: set[Expression<Int>("number")],
                first_serve: set[Expression<Int>("first_serve")],
                match: set[Expression<Int>("match")],
                rotation: Rotation.find(id: set[Expression<Int>("rotation")])!,
                liberos: [set[Expression<Int?>("libero1")], set[Expression<Int?>("libero2")]],
                result: set[Expression<Int>("result")],
                score_us: set[Expression<Int>("score_us")],
                score_them: set[Expression<Int>("score_them")])
        } catch {
            print(error)
            return nil
        }
    }
}



