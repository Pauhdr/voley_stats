import SQLite
import SwiftUI

class SessionExercise: Equatable {
    var id:Int=0;
    var session:Session
    var exercise:Exercise
    var order: Int
    var maxReps: Int?
    var series: Int?
    var strict: Bool?
    var timer: Date?
    var objective: Dictionary<Action, Int>?
    var individual: Bool?
    static func ==(lhs: SessionExercise, rhs: SessionExercise) -> Bool {
        return lhs.id == rhs.id
    }
    init(sesion:Session, exercise:Exercise, order:Int, maxReps: Int?, series: Int?, individual:Bool?, strict: Bool?, timer: Date?, objective: Dictionary<Action, Int>?){
        self.session = sesion
        self.exercise = exercise
        self.order = order
    }
    init(id: Int, sesion:Session, exercise:Exercise, order:Int, maxReps: Int?, series: Int?, individual:Bool?, strict: Bool?, timer: Date?, objective: Dictionary<Action, Int>?){
        self.session = sesion
        self.exercise = exercise
        self.order = order
        self.id = id
    }
    static func create(se: SessionExercise)->SessionExercise?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if se.id != 0{
                try database.run(Table("session_exercise").insert(
                    Expression<Int>("session") <- se.session.id,
                    Expression<Int>("exercise") <- se.exercise.id,
                    Expression<Int>("order") <- se.order,
                    Expression<Int?>("max_reps") <- se.maxReps,
                    Expression<Int?>("series") <- se.series,
                    Expression<Bool?>("strict") <- se.strict,
                    Expression<Bool?>("individual") <- se.individual,
                    Expression<Date?>("timer") <- se.timer,
                    Expression<String?>("objective") <- se.objective?.description,
                    Expression<Int>("id") <- se.id
                ))
            }else{
                let id = try database.run(Table("session_exercise").insert(
                    Expression<Int>("session") <- se.session.id,
                    Expression<Int>("exercise") <- se.exercise.id,
                    Expression<Int>("order") <- se.order,
                    Expression<Int?>("max_reps") <- se.maxReps,
                    Expression<Int?>("series") <- se.series,
                    Expression<Bool?>("strict") <- se.strict,
                    Expression<Bool?>("individual") <- se.individual,
                    Expression<Date?>("timer") <- se.timer,
                    Expression<String?>("objective") <- se.objective?.description
                ))
                se.id = Int(id)
            }
            
            
            return se
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
            let update = Table("session_exercise").filter(self.id == Expression<Int>("id")).update([
                Expression<Int>("session") <- self.session.id,
                Expression<Int>("exercise") <- self.exercise.id,
                Expression<Int>("order") <- self.order,
                Expression<Int?>("max_reps") <- self.maxReps,
                Expression<Int?>("series") <- self.series,
                Expression<Bool?>("strict") <- self.strict,
                Expression<Bool?>("individual") <- self.individual,
                Expression<Date?>("timer") <- self.timer,
                Expression<String?>("objective") <- self.objective?.description,
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
            let delete = Table("session_exercise").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    
    static func all() -> [SessionExercise]{
        var sessions: [SessionExercise] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for session in try database.prepare(Table("session_exercise")) {
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
    static func find(id: Int) -> SessionExercise?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let session = try database.pluck(Table("session_exercise").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return SessionExercise(
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
            )
        } catch {
            print(error)
            return nil
        }
    }
    
}


