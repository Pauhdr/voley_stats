import SQLite
import SwiftUI

class Set: Model, Equatable {
//    var id:Int;
    var number:Int
    var first_serve:Int
    var match:Int
    var rotation:Rotation
    var result: Int = 0
    var score_us: Int = 0
    var score_them: Int = 0
    var liberos: [Int?]
    var gameMode: String = "6-6"
    
    init(number:Int, first_serve:Int, match:Int, rotation:Rotation, liberos:[Int?], gameMode:String = "6-6"){
        self.number=number
        self.first_serve=first_serve
        self.match=match
        self.rotation=rotation
//        self.id = 0
        self.liberos = liberos
        self.gameMode = gameMode
        super.init(id: 0)
    }
    init(id:Int, number:Int, first_serve:Int, match:Int, rotation:Rotation, liberos:[Int?], result: Int, score_us:Int, score_them:Int, gameMode:String = "6-6"){
        self.number=number
        self.first_serve=first_serve
        self.match=match
        self.rotation=rotation
//        self.id=id
        self.result = result
        self.score_us = score_us
        self.score_them = score_them
        self.liberos = liberos
        self.gameMode = gameMode
        super.init(id: id)
    }
    static func ==(lhs: Set, rhs: Set) -> Bool {
        return lhs.id == rhs.id
    }
    
    override func toJSON()->Dictionary<String,Any>{
        return [
            "id":self.id,
            "number":self.number,
            "first_serve":self.first_serve,
            "match":self.match,
            "rotation":self.rotation.id,
            "result":self.result,
            "score_us":self.score_us,
            "score_them":self.score_them,
            "liberos":self.liberos,
            "gameMode":self.gameMode
        ]
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
                    Expression<String>("game_mode") <- set.gameMode,
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
                    Expression<Int>("score_them") <- set.score_them,
                    Expression<String>("game_mode") <- set.gameMode
                ))
                set.id = Int(id)
            }
            DB.saveToFirestore(collection: "sets", object: set)
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
                Expression<Int>("score_them") <- self.score_them,
                Expression<String>("game_mode") <- self.gameMode
            ])
            if try database.run(update) > 0 {
                DB.saveToFirestore(collection: "sets", object: self)
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
            self.stats().forEach({$0.delete()})
            let delete = Table("set").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            DB.deleteOnFirestore(collection: "sets", object: self)
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
                    rotation: Rotation.find(id: set[Expression<Int>("rotation")]) ?? Rotation(),
                    liberos: [set[Expression<Int?>("libero1")], set[Expression<Int?>("libero2")]],
                    result: set[Expression<Int>("result")],
                    score_us: set[Expression<Int>("score_us")],
                    score_them: set[Expression<Int>("score_them")],
                    gameMode: set[Expression<String>("game_mode")]))
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
            for stat in try database.prepare(Table("stat").filter(Expression<Int>("set")==self.id).order(Expression<Double>("order"))) {
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
    func timeOuts()->(Int, Int){
        var result = (0,0)
        do{
            guard let database = DB.shared.db else {
                return (0,0)
            }
            let us = try database.scalar(Table("stat").filter(self.id == Expression<Int>("set") && Expression<Int>("action")==0 && Expression<Int>("to") == 1).count)
            let them = try database.scalar(Table("stat").filter(self.id == Expression<Int>("set") && Expression<Int>("action")==0 && Expression<Int>("to") == 2).count)
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
                score_them: set[Expression<Int>("score_them")],
                gameMode: set[Expression<String>("game_mode")])
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
            try database.run(Table("set").delete())
        }catch{
            print("error truncating set")
            return
        }
    }
    func summary()->Dictionary<String, Dictionary<String, Int>>{
        let stats = self.stats()
        let atk = stats.filter{s in return s.player != 0 && actionsByType["attack"]!.contains(s.action)}
        let blk = stats.filter{s in return s.player != 0 && actionsByType["block"]!.contains(s.action)}
        let rcv = stats.filter{s in return s.player != 0 && actionsByType["receive"]!.contains(s.action)}
        let srv = stats.filter{s in return s.server != 0 && s.stage == 0 && [8,12,15,32,39,40,41].contains(s.action)}
        let op = rcv.filter{s in return s.action==1}.count
        let r1 = rcv.filter{s in return s.action==2}.count
        let r2 = rcv.filter{s in return s.action==3}.count
        let r3 = rcv.filter{s in return s.action==4}.count
        let rerrors = rcv.filter{s in return s.action==22}.count
        let rtotal = rcv.count
        let rcvmk = Float(op/2 + r1 + 2*r2 + 3*r3)/Float(rtotal)
        let s2 = srv.filter{s in return s.action==39}.count
        let s1 = srv.filter{s in return s.action==40}.count
        let sop = srv.filter{s in return s.action==41}.count
        let s3 = srv.filter{s in return s.action==8}.count
        let stotal = srv.count
        let srvmk = stotal > 0 ? Float(sop/2 + s1 + 2*s2 + 3*s3)/Float(stotal) : 0
        let changes = stats.filter{s in s.action==99}.count
        let laststat = stats.sorted(by: {$0.id>$1.id}).last
        var server = laststat!.server
        if server == 0 && laststat!.to == 1{
            server = laststat!.rotation.get(rotate: laststat!.rotationTurns+1)[0]!.id
        } else if server != 0 && laststat!.to == 2{
            server = 0
        }
        var result: Dictionary<String, Dictionary<String, Int>> = [
            "header":[
                "changes":changes,
                "serving":server,
                "score_us":laststat!.score_us,
                "score_them":laststat!.score_them
            ],
            "attack":[
                "total": atk.count,
                "kills": atk.filter{s in return [9, 10, 11, 12].contains(s.action)}.count,
                "error": atk.filter{s in return [16, 17, 18, 19].contains(s.action)}.count,
            ],
            "receive":[
                "total":rtotal,
                "error":rerrors,
                "mark":Int(rcvmk*100)
            ],
            "serve":[
                "total":stotal,
                "error":srv.filter{s in return [15, 32].contains(s.action)}.count,
                "mark":Int(srvmk*100)
            ],
            "block":[
                "total":blk.count,
                "blocks":blk.filter{s in return s.action == 13}.count,
                "error":blk.filter{s in return [20, 31].contains(s.action)}.count,
            ],
        ]
        return result
    }
}



