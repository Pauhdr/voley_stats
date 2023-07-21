import SQLite
import SwiftUI

class Session: Equatable {
    var id:Int=0;
    var date:Date
    var team:Team
    var players: [Player]
    static func ==(lhs: Session, rhs: Session) -> Bool {
        return lhs.id == rhs.id
    }
    init(date:Date, team:Team, players:[Player]){
        self.date = date
        self.team = team
        self.players = players
    }
    init(id: Int, date:Date, team:Team, players: [Player]){
        self.date = date
        self.team = team
        self.players = players
        self.id = id
    }
    static func create(session: Session)->Session?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if session.id != 0{
                try database.run(Table("session").insert(
                    Expression<Int>("team") <- session.team.id,
                    Expression<Date>("date") <- session.date,
                    Expression<String>("players") <- session.players.map{$0.id}.description,
                    Expression<Int>("id") <- session.id
                ))
            }else{
                let id = try database.run(Table("session").insert(
                    Expression<Int>("team") <- session.team.id,
                    Expression<Date>("date") <- session.date,
                    Expression<String>("players") <- session.players.map{$0.id}.description
                ))
                session.id = Int(id)
            }
            
            
            return session
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
            let update = Table("session").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("team") <- self.team.id,
                Expression<Date>("date") <- self.date,
                Expression<String>("players") <- self.players.map{$0.id}.description
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
            let delete = Table("session").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Session]{
        var sessions: [Session] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for session in try database.prepare(Table("session")) {
                sessions.append(Session(
                    date: session[Expression<Date>("date")],
                    team: Team.find(id: session[Expression<Int>("team")])!,
                    players: session[Expression<String>("players")].components(separatedBy: NSCharacterSet(charactersIn: "[,]") as CharacterSet).filter{ Int($0) != nil}.map{Player.find(id: Int($0)!)!}
                ))
            }
            return sessions
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Session?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let session = try database.pluck(Table("session").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Session(
                date: session[Expression<Date>("date")],
                team: Team.find(id: session[Expression<Int>("team")])!,
                players: session[Expression<String>("players")].components(separatedBy: NSCharacterSet(charactersIn: "[,]") as CharacterSet).filter{ Int($0) != nil}.map{Player.find(id: Int($0)!)!}
            )
        } catch {
            print(error)
            return nil
        }
    }
    
    func exercises() -> [SessionExercise]{
        var sessions: [SessionExercise] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for session in try database.prepare(Table("session_exercise").filter(Expression<Int>("session") == self.id)) {
                sessions.append(SessionExercise(
                    id: session[Expression<Int>("id")],
                    sesion: Session.find(id: session[Expression<Int>("session")])!,
                    exercise: Exercise.find(id: session[Expression<Int>("exercise")])!,
                    order: session[Expression<Int>("order")],
                    maxReps: session[Expression<Int?>("order")],
                    series: session[Expression<Int?>("series")],
                    individual: session[Expression<Bool?>("individual")],
                    strict: session[Expression<Bool?>("strict")],
                    timer: session[Expression<Date?>("timer")],
                    objective: [:]
                ))
            }
            return sessions
        } catch {
            print(error)
            return []
        }
    }
}


