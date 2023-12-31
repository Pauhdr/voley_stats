import SQLite
import SwiftUI

class PlayerMeasures: Equatable {
    var id:Int=0;
    var player: Player
    var height: Int
    var weight: Double
    var oneHandReach: Int
    var twoHandReach: Int
    var attackReach: Int
    var blockReach:Int
    var breadth: Int
    static func ==(lhs: PlayerMeasures, rhs: PlayerMeasures) -> Bool {
        return lhs.id == rhs.id
    }
    init(player: Player, height: Int, weight: Double, oneHandReach:Int, twoHandReach: Int, attackReach: Int, blockReach: Int, breadth: Int){
        self.player =  player
        self.height =  height
        self.weight =  weight
        self.oneHandReach =  oneHandReach
        self.twoHandReach =  twoHandReach
        self.attackReach =  attackReach
        self.blockReach = blockReach
        self.breadth =  breadth
    }
    init(id: Int, player: Player, height: Int, weight: Double, oneHandReach:Int, twoHandReach: Int, attackReach: Int, blockReach: Int, breadth: Int){
        self.player =  player
        self.height =  height
        self.weight =  weight
        self.oneHandReach =  oneHandReach
        self.twoHandReach =  twoHandReach
        self.attackReach =  attackReach
        self.blockReach = blockReach
        self.breadth =  breadth
        self.id = id
    }
    static func create(measure: PlayerMeasures)->PlayerMeasures?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if measure.id != 0{
                try database.run(Table("player_measures").insert(
                    Expression<Int>("player") <- measure.player.id,
                    Expression<Int>("height") <- measure.height,
                    Expression<Double>("weight") <- measure.weight,
                    Expression<Int>("oneHandReach") <- measure.oneHandReach,
                    Expression<Int>("twoHandReach") <- measure.twoHandReach,
                    Expression<Int>("attackReach") <- measure.attackReach,
                    Expression<Int>("blockReach") <- measure.blockReach,
                    Expression<Int>("breadth") <- measure.breadth,
                    Expression<Int>("id") <- measure.id
                ))
            }else{
                let id = try database.run(Table("player_measures").insert(
                    Expression<Int>("player") <- measure.player.id,
                    Expression<Int>("height") <- measure.height,
                    Expression<Double>("weight") <- measure.weight,
                    Expression<Int>("oneHandReach") <- measure.oneHandReach,
                    Expression<Int>("twoHandReach") <- measure.twoHandReach,
                    Expression<Int>("attackReach") <- measure.attackReach,
                    Expression<Int>("blockReach") <- measure.blockReach,
                    Expression<Int>("breadth") <- measure.breadth
                ))
                measure.id = Int(id)
            }
            
            
            return measure
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
            let update = Table("player_measures").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("player") <- self.player.id,
                Expression<Int>("height") <- self.height,
                Expression<Double>("weight") <- self.weight,
                Expression<Int>("oneHandReach") <- self.oneHandReach,
                Expression<Int>("twoHandReach") <- self.twoHandReach,
                Expression<Int>("attackReach") <- self.attackReach,
                Expression<Int>("blockReach") <- self.blockReach,
                Expression<Int>("breadth") <- self.breadth
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
            let delete = Table("player_measures").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    
    static func all() -> [PlayerMeasures]{
        var measures: [PlayerMeasures] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for measure in try database.prepare(Table("player_measures")) {
                measures.append(
                    PlayerMeasures(
                        id: measure[Expression<Int>("id")],
                        player: Player.find(id: measure[Expression<Int>("player")])!,
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
    static func find(id: Int) -> PlayerMeasures?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let measure = try database.pluck(Table("player_measures").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return PlayerMeasures(
                id: measure[Expression<Int>("id")],
                player: Player.find(id: measure[Expression<Int>("player")])!,
                height: measure[Expression<Int>("height")],
                weight: measure[Expression<Double>("weight")],
                oneHandReach: measure[Expression<Int>("one_hand_reach")],
                twoHandReach: measure[Expression<Int>("two_hand_reach")],
                attackReach: measure[Expression<Int>("attack_reach")],
                blockReach: measure[Expression<Int>("block_reach")],
                breadth: measure[Expression<Int>("breadth")])
        } catch {
            print(error)
            return nil
        }
    }
    
}


