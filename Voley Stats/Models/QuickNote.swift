import SwiftUI

class QuickNote: Equatable, Hashable {
    var id:Int;
    var area:String
    var comments:String
    
    init(area:String, comments:String, id:Int){
        self.area=area
        self.comments=comments
        self.id=id
    }
    static func ==(lhs: QuickNote, rhs: QuickNote) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    static func all() -> [String:[QuickNote]]{
        return qns
    }
    static func areaQuickNotes(area:String)->[QuickNote]?{
        return qns[area]
    }
    static func find(id: Int) -> QuickNote?{
        for (area, notes) in qns {
            for qn in notes {
                if qn.id == id {
                    return qn
                }
            }
        }
        return nil
    }
}

let qns=[
    "block":[
        QuickNote(area: "block", comments: "toque de red", id: 0),
        QuickNote(area: "block", comments: "llega tarde", id: 1),
        QuickNote(area: "block", comments: "Mala posicion", id: 2),
    ],
    "set":[
        QuickNote(area: "set", comments: "falta altura", id: 3),
        QuickNote(area: "set", comments: "direccion del pase", id: 4),
    ],
    "serve":[
        QuickNote(area: "serve", comments: "fallo en la rutina", id: 5),
        QuickNote(area: "serve", comments: "mal lanzamiento", id: 6),
        QuickNote(area: "serve", comments: "mala posicion", id: 7),
        QuickNote(area: "serve", comments: "mal golpeo", id: 8),
    ],
    "dig":[
        QuickNote(area: "dig", comments: "falta movilidad", id: 9),
        QuickNote(area: "dig", comments: "mala posicion", id: 10),
        QuickNote(area: "dig", comments: "falta altura", id: 11),
        QuickNote(area: "dig", comments: "falta control", id: 12),
    ],
    "attack":[
        QuickNote(area: "attack", comments: "batida", id: 13),
        QuickNote(area: "attack", comments: "armado", id: 14),
        QuickNote(area: "attack", comments: "gesto de golpeo", id: 15),
        QuickNote(area: "attack", comments: "dominio linea", id: 16),
        QuickNote(area: "attack", comments: "dominio diagonal", id: 17),
        QuickNote(area: "attack", comments: "dominio finta", id: 18),
    ],
    "receive":[
        QuickNote(area: "receive", comments: "movilidad", id: 19),
        QuickNote(area: "receive", comments: "comunicacion", id: 20),
        QuickNote(area: "receive", comments: "dedos", id: 21),
        QuickNote(area: "receive", comments: "antebrazos", id: 22),
    ]
]
