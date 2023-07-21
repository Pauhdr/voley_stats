import SQLite
import SwiftUI

class Improve: Equatable, Identifiable {
    var id:Int=0
    var player:Player
    var area: String
    var comment: String
    var date:Date
    var exercise:Exercise
    
    init(player:Player, area:String, comment:String, date:Date, exercise:Exercise){
        self.player=player
        self.area = area
        self.comment = comment
        self.date = date
        self.exercise = exercise
    }
    init(id:Int, player:Player, area:String, comment:String, date:Date, exercise:Exercise){
        self.player=player
        self.area = area
        self.comment = comment
        self.date = date
        self.exercise = exercise
        self.id=id
    }
    static func ==(lhs: Improve, rhs: Improve) -> Bool {
        return lhs.id == rhs.id
    }
    static func createImprove(improve: Improve)->Improve?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd"
            if improve.id != 0 {
                try database.run(Table("improve").insert(
                    Expression<Int>("player") <- improve.player.id,
                    Expression<String>("area") <- improve.area,
                    Expression<String>("comment") <- improve.comment,
                    Expression<Date>("date") <- improve.date,
                    Expression<Int>("exercise") <- improve.exercise.id,
                    Expression<Int>("id") <- improve.id
                ))
            }else{
                let id = try database.run(Table("improve").insert(
                    Expression<Int>("player") <- improve.player.id,
                    Expression<String>("area") <- improve.area,
                    Expression<String>("comment") <- improve.comment,
                    Expression<Date>("date") <- improve.date,
                    Expression<Int>("exercise") <- improve.exercise.id
                ))
                improve.id = Int(id)
            }
            return improve
        } catch {
            print("ERROR: \(error)")
        }
        return nil
    }
    func update() -> Bool{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        guard let database = DB.shared.db else {
            print("no db")
            return false
        }
        do {
            let update = Table("improve").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("player") <- self.player.id,
                Expression<String>("area") <- self.area,
                Expression<String>("comment") <- self.comment,
                Expression<Date>("date") <- self.date,
                Expression<Int>("exercise") <- self.exercise.id,
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
            let delete = Table("improve").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    func getDateString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.date)
    }
    static func all() -> [Improve]{
        var improves: [Improve] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            for improve in try database.prepare(Table("improve")) {
                improves.append(Improve(
                    id: improve[Expression<Int>("id")],
                    player: Player.find(id: improve[Expression<Int>("player")]) ?? Player(name: "error", number: 0, team: 0, active:1, birthday: Date(), id: 0),
                    area: improve[Expression<String>("area")],
                    comment: improve[Expression<String>("comment")],
                    date: improve[Expression<Date>("date")],
                    exercise: Exercise.find(id:improve[Expression<Int>("exercise")]) ?? Exercise(name: "error", description: "", area: "", type: "", id: 0)
                    ))
            }
//            print(improves.map{$0.date})
            return improves
        } catch {
            print(error)
            return []
        }
    }
    static func playerImproves(player:Player, exercise:Exercise?, date:Date?)-> [Improve]{
        var improves: [Improve] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("improve").filter(player.id == Expression<Int>("player"))
            if exercise != nil{
                query = query.filter(exercise!.id == Expression<Int>("exercise"))
            }
            if (date != nil){
                query = query.filter(Expression<Date>("date") == date!)
            }
            for improve in try database.prepare(query) {
                improves.append(Improve(
                    id: improve[Expression<Int>("id")],
                    player: Player.find(id: improve[Expression<Int>("player")]) ?? Player(name: "error", number: 0, team: 0, active:1, birthday: Date(), id: 0),
                    area: improve[Expression<String>("area")],
                    comment: improve[Expression<String>("comment")],
                    date: improve[Expression<Date>("date")],
                    exercise: Exercise.find(id:improve[Expression<Int>("exercise")]) ?? Exercise(name: "error", description: "", area: "", type: "", id: 0)
                ))
            }
            return improves
        } catch {
            print(error)
            return []
        }
    }
    static func statsImproves(team: Team, date:Date? = nil, dateInterval:Date? = nil)-> [Improve]{
        var improves: [Improve] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("improve").join(Table("exercise"), on: Table("improve")[Expression<Int>("exercise")] == Table("exercise")[Expression<Int>("id")]).filter("stats"==Table("exercise")[Expression<String>("type")]).filter(team.players().map{$0.id}.contains(Expression<Int>("player")))
            
            if (date != nil){
                query = query.filter(Expression<Date>("date") == date!)
            }
            if (dateInterval != nil){
                query = query.filter(dateInterval!...Date() ~= Expression<Date>("date"))
            }
            for improve in try database.prepare(query) {
                improves.append(Improve(
                    id: improve[Table("improve")[Expression<Int>("id")]],
                    player: Player.find(id: improve[Expression<Int>("player")]) ?? Player(name: "error", number: 0, team: 0, active:1, birthday: Date(), id: 0),
                    area: improve[Table("improve")[Expression<String>("area")]],
                    comment: improve[Expression<String>("comment")],
                    date: improve[Expression<Date>("date")],
                    exercise: Exercise.find(id:improve[Expression<Int>("exercise")]) ?? Exercise(name: "error", description: "", area: "", type: "", id: 0)
                ))
            }
            return improves
        } catch {
            print(error)
            return []
        }
    }
    static func qnImproves(team:Team, date:Date?)-> [Improve]{
        var improves: [Improve] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("improve").join(Table("exercise"), on: Table("improve")[Expression<Int>("exercise")] == Table("exercise")[Expression<Int>("id")]).filter("improve"==Table("exercise")[Expression<String>("type")]).filter(team.players().map{$0.id}.contains(Expression<Int>("player")))
            
            if (date != nil){
                query = query.filter(Expression<Date>("date") == date!)
            }
            for improve in try database.prepare(query) {
                improves.append(Improve(
                    id: improve[Table("improve")[Expression<Int>("id")]],
                    player: Player.find(id: improve[Expression<Int>("player")]) ?? Player(name: "error", number: 0, team: 0, active:1, birthday: Date(), id: 0),
                    area: improve[Table("improve")[Expression<String>("area")]],
                    comment: improve[Expression<String>("comment")],
                    date: improve[Expression<Date>("date")],
                    exercise: Exercise.find(id:improve[Expression<Int>("exercise")]) ?? Exercise(name: "error", description: "", area: "", type: "", id: 0)
                ))
            }
            return improves
        } catch {
            print(error)
            return []
        }
    }
    static func countImproves(team:Team, date:Date?)-> [Improve]{
        var improves: [Improve] = []
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        do{
            guard let database = DB.shared.db else {
                return []
            }
            var query = Table("improve").join(Table("exercise"), on: Table("improve")[Expression<Int>("exercise")] == Table("exercise")[Expression<Int>("id")]).filter("count"==Table("exercise")[Expression<String>("type")]).filter(team.players().map{$0.id}.contains(Expression<Int>("player")))
            
            if (date != nil){
                query = query.filter(Expression<Date>("date") == date!)
            }
            for improve in try database.prepare(query) {
                improves.append(Improve(
                    id: improve[Table("improve")[Expression<Int>("id")]],
                    player: Player.find(id: improve[Expression<Int>("player")]) ?? Player(name: "error", number: 0, team: 0, active:1, birthday: Date(), id: 0),
                    area: improve[Table("improve")[Expression<String>("area")]],
                    comment: improve[Expression<String>("comment")],
                    date: improve[Expression<Date>("date")],
                    exercise: Exercise.find(id:improve[Expression<Int>("exercise")]) ?? Exercise(name: "error", description: "", area: "", type: "", id: 0)
                ))
            }
            return improves
        } catch {
            print(error)
            return []
        }
    }
    
    static func dates() -> [Date]{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        var dates: [Date] = []
        do{
            guard let database = DB.shared.db else {
                return []
                
            }
            let query = Table("improve").select(distinct: Expression<String>("date"))
            
            for date in try database.prepare(query) {
                let d = date[Expression<Date>("date")]
                if (d != nil) {
                    dates.append(d)
                }
                
            }
            print(dates)
            return dates
        } catch {
            print(error)
            return []
        }
    }
}





