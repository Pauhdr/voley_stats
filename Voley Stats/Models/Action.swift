import SQLite
import SwiftUI

class Action: Equatable, Hashable {
    var id:Int;
    var name:String
    var type:Int
    
    init(name:String, type:Int, id:Int){
        self.name=name
        self.type=type
        self.id=id
    }
    static func ==(lhs: Action, rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func all() -> [[Action]]{
        return buttons
    }
    func color() -> Color {
        switch self.type {
        case 0:
            return .gray
        case 1:
            return Color(hex: "6ECB63") ?? .green
        case 2:
            return Color(hex: "f2ac0a") ?? .yellow
        case 3:
            return Color(hex: "DC3535") ?? .red
        default:
            return .gray
        }
    }
    func getArea()->String{
        for (area, actions) in actionsByType{
            for a in actions{
                if (self.id == a){
                    return area
                }
            }
        }
        return ""
    }
    func getType()->String{
        switch self.type {
        case 0:
            return "in.play"
        case 1:
            return "earn"
        case 2:
            return "error"
        case 3:
            return "fault"
        default:
            return "in.play"
        }
    }
    static func find(id: Int) -> Action?{
        for actions in buttons {
            for action in actions {
                if action.id == id {
                    return action
                }
            }
        }
        return nil
    }
}

let buttons = [
    [
        Action(name:"serve.in.play", type: 0, id: 38),
        Action(name:"dig", type: 0, id: 5),
        Action(name:"1-free ball", type: 0, id: 35),
        Action(name:"2-free ball", type: 0, id: 36),
        Action(name:"3-free ball", type: 0, id: 37),
        Action(name:"block.in.play", type: 0, id: 7)

    ],
    [
        Action(name:"over.pass.in.play", type: 0, id: 1),
        Action(name:"1-"+"receive".trad(), type: 0, id: 2),
        Action(name:"2-"+"receive".trad(), type: 0, id: 3),
        Action(name:"3-"+"receive".trad(), type: 0, id: 4),
        Action(name:"1-"+"serve".trad(), type: 0, id: 39),
        Action(name:"2-"+"serve".trad(), type: 0, id: 40),
        Action(name:"3-"+"serve".trad(), type: 0, id: 41),
        Action(name:"hit.in.play", type: 0, id: 6),
        Action(name:"downhit.in.play", type: 0, id: 14),
        
    ],
    [
        
        Action(name:"ace", type: 1, id: 8),
        Action(name:"spike", type: 1, id: 9),
        Action(name:"tip", type: 1, id: 10),
        Action(name:"dump", type: 1, id: 11),
        Action(name:"downhit", type: 1, id: 12),
        Action(name:"block", type: 1, id: 13),
    ],
    [
        Action(name:"serve", type: 2, id: 15),
        Action(name:"receive", type: 2, id: 22),
        Action(name:"dig", type: 2, id: 23),
        Action(name:"spike", type: 2, id: 16),
        Action(name:"tip", type: 2, id: 17),
        Action(name:"dump", type: 2, id: 18),
        Action(name:"downhit", type: 2, id: 19),
        Action(name:"block", type: 2, id: 20),
        Action(name:"set", type: 2, id: 24),
        Action(name:"free ball", type: 2, id: 25),
        Action(name:"whose.ball", type: 2, id: 21),
    ],
    [
        Action(name:"net", type: 3, id: 28),
        Action(name:"ball.handling", type: 3, id: 29),
        Action(name:"under", type: 3, id: 30),
        Action(name:"over.the.net", type: 3, id: 31),
        Action(name:"foot", type: 3, id: 32),
        Action(name:"out.rotation", type: 3, id: 33),
        Action(name:"backrow.attack", type: 3, id: 34)
    ]
]
let actionsByType = [
    "block": [7, 13, 20, 31],
    "serve":[15, 8, 32, 38],
    "dig":[23, 5, 21],
    "receive":[1, 2, 3, 4, 22],
    "fault":[28, 29, 30, 31, 32, 33, 34],
    "attack":[6, 9, 10, 11, 16, 17, 18, 34],
    "set": [24],
    "free": [25, 35, 36, 37],
    "downhit": [12, 14, 19]
]



