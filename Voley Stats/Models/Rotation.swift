import SQLite
import SwiftUI

class Rotation: Equatable {
    var id:Int;
    var name:String?
    var team: Team
    var one:Player?
    var two:Player?
    var three:Player?
    var four: Player?
    var five: Player?
    var six:Player?
    static func ==(lhs: Rotation, rhs: Rotation) -> Bool {
        return lhs.id == rhs.id
    }
    init(team:Team, one:Player?, two:Player?, three: Player?, four:Player?, five:Player?, six: Player?){
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        self.four = four
        self.five = five
        self.six = six
        self.id=0
    }
    
    init(team:Team, rotationArray:[Player?]){
        self.team=team
        self.one = rotationArray[0]
        self.two = rotationArray[1]
        self.three = rotationArray[2]
        self.four = rotationArray[3]
        self.five = rotationArray[4]
        self.six = rotationArray[5]
        self.id=0
    }
    
    init(team:Team, one:Player, two:Player, three: Player, four:Player){
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        self.four = four
        self.id=0
    }
    
    init(team:Team, one:Player, two:Player, three: Player){
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        self.id=0
    }
    
    init(team:Team){
        self.team=team
        self.id=0
    }
    
    init(id:Int, name:String?, team:Team, one:Player?, two:Player?, three: Player?, four:Player?, five:Player?, six: Player?){
        self.name=name
        self.team=team
        self.one = one
        self.two = two
        self.three = three
        self.four = four
        self.five = five
        self.six = six
        self.id=id
    }
    
    static func create(rotation: Rotation)->Rotation?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            let exists = Rotation.exists(team: rotation.team, one: rotation.one, two: rotation.two, three: rotation.three, four: rotation.four, five: rotation.five, six: rotation.six)
            if exists != nil{
                print(Rotation.all().map{$0.id})
                return exists
            }else{
                if rotation.id != 0{
                    try database.run(Table("rotation").insert(
                        Expression<String?>("name") <- rotation.name,
                        Expression<Int>("team") <- rotation.team.id,
                        Expression<Int>("1") <- rotation.one?.id ?? 0,
                        Expression<Int>("2") <- rotation.two?.id ?? 0,
                        Expression<Int>("3") <- rotation.three?.id ?? 0,
                        Expression<Int>("4") <- rotation.four?.id ?? 0,
                        Expression<Int>("5") <- rotation.five?.id ?? 0,
                        Expression<Int>("6") <- rotation.six?.id ?? 0
                    ))
                }else{
                    let id = try database.run(Table("rotation").insert(
                        Expression<String?>("name") <- rotation.name,
                        Expression<Int>("team") <- rotation.team.id,
                        Expression<Int>("1") <- rotation.one?.id ?? 0,
                        Expression<Int>("2") <- rotation.two?.id ?? 0,
                        Expression<Int>("3") <- rotation.three?.id ?? 0,
                        Expression<Int>("4") <- rotation.four?.id ?? 0,
                        Expression<Int>("5") <- rotation.five?.id ?? 0,
                        Expression<Int>("6") <- rotation.six?.id ?? 0
                    ))
                    rotation.id = Int(id)
                }
            }
            return rotation
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
            
            let update = Table("rotation").filter(self.id == Expression<Int>("id")).update([
                Expression<String?>("name") <- self.name,
                Expression<Int>("team") <- self.team.id,
                Expression<Int>("1") <- self.one?.id ?? 0,
                Expression<Int>("2") <- self.two?.id ?? 0,
                Expression<Int>("3") <- self.three?.id ?? 0,
                Expression<Int>("4") <- self.four?.id ?? 0,
                Expression<Int>("5") <- self.five?.id ?? 0,
                Expression<Int>("6") <- self.six?.id ?? 0
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
            let delete = Table("rotation").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Rotation]{
        var rotations: [Rotation] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for rotation in try database.prepare(Table("rotation")) {
                rotations.append(Rotation(
                    id: rotation[Expression<Int>("id")],
                    name: rotation[Expression<String?>("name")],
                    team: Team.find(id: rotation[Expression<Int>("team")])!,
                    one: Player.find(id: rotation[Expression<Int>("1")]),
                    two: Player.find(id: rotation[Expression<Int>("2")]),
                    three: Player.find(id: rotation[Expression<Int>("3")]),
                    four: Player.find(id: rotation[Expression<Int>("4")]),
                    five: Player.find(id: rotation[Expression<Int>("5")]),
                    six: Player.find(id: rotation[Expression<Int>("6")])))
            }
            return rotations
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Rotation?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let rotation = try database.pluck(Table("rotation").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Rotation(
                    id: rotation[Expression<Int>("id")],
                    name: rotation[Expression<String?>("name")],
                    team: Team.find(id: rotation[Expression<Int>("team")])!,
                    one: Player.find(id: rotation[Expression<Int>("1")]),
                    two: Player.find(id: rotation[Expression<Int>("2")]),
                    three: Player.find(id: rotation[Expression<Int>("3")]),
                    four: Player.find(id: rotation[Expression<Int>("4")]),
                    five: Player.find(id: rotation[Expression<Int>("5")]),
                    six: Player.find(id: rotation[Expression<Int>("6")]))
        } catch {
            print(error)
            return nil
        }
    }
    func get(rotate: Int = 0) -> [Player?]{
        var rotation = [one, two, three, four, five, six]
        let count = rotation.filter{$0 != nil}.count
        for i in 0..<rotate {
            let tmp = rotation[0]
            for index in 1..<count{
                rotation[index - 1] = rotation[index]
            }
            rotation[count-1] = tmp
        }
        return rotation
    }
    func server(rotate: Int = 0) -> Player{
        return self.get(rotate: rotate)[0]!
    }
    static func exists(team:Team, one:Player?, two:Player?, three: Player?, four:Player?, five:Player?, six: Player?) -> Rotation?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let rotation = try database.pluck(Table("rotation").filter(Expression<Int>("1") == one?.id ?? 0 && Expression<Int>("2") == two?.id ?? 0 && Expression<Int>("3") == three?.id ?? 0 && Expression<Int>("4") == four?.id ?? 0 && Expression<Int>("5") == five?.id ?? 0 && Expression<Int>("6") == six?.id ?? 0 && Expression<Int>("team") == team.id)) else {
                return nil
            }
            return Rotation(
                    id: rotation[Expression<Int>("id")],
                    name: rotation[Expression<String?>("name")],
                    team: Team.find(id: rotation[Expression<Int>("team")])!,
                    one: Player.find(id: rotation[Expression<Int>("1")]),
                    two: Player.find(id: rotation[Expression<Int>("2")]),
                    three: Player.find(id: rotation[Expression<Int>("3")]),
                    four: Player.find(id: rotation[Expression<Int>("4")]),
                    five: Player.find(id: rotation[Expression<Int>("5")]),
                    six: Player.find(id: rotation[Expression<Int>("6")]))
        } catch {
            print(error)
            return nil
        }
    }
    func changePlayer(player: Player, change: Player)->Rotation{
        let newRotation = self;
        if newRotation.one == player{
            newRotation.one = change
        }
        if newRotation.two == player{
            newRotation.two = change
        }
        if newRotation.three == player{
            newRotation.three = change
        }
        if newRotation.four == player{
            newRotation.four = change
        }
        if newRotation.five == player{
            newRotation.five = change
        }
        if newRotation.six == player{
            newRotation.six = change
        }
        newRotation.id = 0
        newRotation.name = nil
        let exists = Rotation.exists(team: self.team, one: newRotation.one, two: newRotation.two, three: newRotation.three, four: newRotation.four, five: newRotation.five, six: newRotation.six)
        if exists != nil {
            return exists!
        }
        return Rotation.create(rotation: newRotation)!
    }
}
