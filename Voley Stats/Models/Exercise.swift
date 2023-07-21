import SQLite
import SwiftUI

class Exercise: Equatable {
    var id:Int = 0
    var name:String
    var description:String
    var area:String
    var type:String
    var maxReps: Int?
    var series: Int?
    var strict: Bool?
    var individual: Bool?
    var timer: Int?
    var objective: Dictionary<Action, Int>?
    var subexercises: [String]?
    static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id
    }
    init(name:String, description:String, area:String, type:String, id:Int?){
        self.name=name
        self.description=description
        self.area=area
        self.type=type
        self.id=id ?? 0
    }
    init(name:String, description:String, area:String, type:String, maxReps:Int?, series:Int?, strict:Bool?, individual:Bool?, timer:Int?, objective: Dictionary<Action, Int>?, subexercises:[String]?){
        self.name=name
        self.description=description
        self.area=area
        self.type=type
        self.maxReps=maxReps
        self.series=series
        self.strict=strict
        self.individual=individual
        self.timer=timer
        self.objective=objective
        self.subexercises = subexercises
    }
    init(name:String, description:String, area:String, type:String, maxReps:Int?, series:Int?, strict:Bool?, individual:Bool?, timer:Int?, objective: Dictionary<Action, Int>?, subexercises:[String]?, id:Int){
        self.name=name
        self.description=description
        self.area=area
        self.type=type
        self.maxReps=maxReps
        self.series=series
        self.strict=strict
        self.individual=individual
        self.timer=timer
        self.objective=objective
        self.subexercises = subexercises
        self.id=id
    }
    
    static func createExercise(exercise: Exercise)->Exercise?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if exercise.id != 0{
                try database.run(Table("exercise").insert(
                    Expression<String>("name") <- exercise.name,
                    Expression<String>("description") <- exercise.description,
                    Expression<String>("area") <- exercise.area,
                    Expression<String>("type") <- exercise.type,
                    Expression<Int?>("max_reps") <- exercise.maxReps,
                    Expression<Int?>("series") <- exercise.series,
                    Expression<Bool?>("strict") <- exercise.strict,
                    Expression<Bool?>("individual") <- exercise.individual,
                    Expression<Int?>("timer") <- exercise.timer,
                    Expression<String?>("objective") <- exercise.objective?.description,
                    Expression<String?>("subexercises") <- exercise.subexercises?.description,
                    Expression<Int>("id") <- exercise.id
                ))
            }else{
                let id = try database.run(Table("exercise").insert(
                    Expression<String>("name") <- exercise.name,
                    Expression<String>("description") <- exercise.description,
                    Expression<String>("area") <- exercise.area,
                    Expression<String>("type") <- exercise.type,
                    Expression<Int?>("max_reps") <- exercise.maxReps,
                    Expression<Int?>("series") <- exercise.series,
                    Expression<Bool?>("strict") <- exercise.strict,
                    Expression<Bool?>("individual") <- exercise.individual,
                    Expression<Int?>("timer") <- exercise.timer,
                    Expression<String?>("objective") <- exercise.objective?.description,
                    Expression<String?>("subexercises") <- exercise.subexercises?.description
                ))
                exercise.id = Int(id)
            }
            return exercise
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
            let update = Table("exercise").filter(self.id == Expression<Int>("id")).update([
                Expression<String>("name") <- self.name,
                Expression<String>("description") <- self.description,
                Expression<String>("area") <- self.area,
                Expression<String>("type") <- self.type,
                Expression<Int?>("max_reps") <- self.maxReps,
                Expression<Int?>("series") <- self.series,
                Expression<Bool?>("strict") <- self.strict,
                Expression<Bool?>("individual") <- self.individual,
                Expression<Int?>("timer") <- self.timer,
                Expression<String?>("objective") <- self.objective?.description,
                Expression<String?>("subexercises") <- self.subexercises?.description
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
            let delete = Table("exercise").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    func objectiveToString() -> String? {
        var res:String = ""
        if objective != nil{
            objective?.forEach{k,v in
                res = res.appending("(\(k.id)-\(v))")
            }
            return res
        }
        return nil
    }
    static func objectiveFromString(objective: String?) -> Dictionary<Action, Int>?{
        var res:Dictionary<Action, Int>? = [:]
        if objective != nil{
            return res
        }
        return nil
    }
    func getTimer() -> (Int, Int, Int){
        var res = (0, 0, 0)
        if timer != nil {
            res.0 = self.timer! / 3600
            res.1 = (self.timer! - res.0*3600) / 60
            res.2 = self.timer! - res.0*3600 - res.1*60
        }
        return res
    }
    static func all() -> [Exercise]{
        var exercises: [Exercise] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for exercise in try database.prepare(Table("exercise")) {
                exercises.append(Exercise(
                    name: exercise[Expression<String>("name")],
                    description: exercise[Expression<String>("description")],
                    area: exercise[Expression<String>("area")],
                    type: exercise[Expression<String>("type")],
                    maxReps: exercise[Expression<Int?>("max_reps")],
                    series: exercise[Expression<Int?>("series")],
                    strict: exercise[Expression<Bool?>("strict")],
                    individual: exercise[Expression<Bool?>("individual")],
                    timer: exercise[Expression<Int?>("timer")],
                    objective: objectiveFromString(objective: exercise[Expression<String?>("objective")]),
                    subexercises: exercise[Expression<String?>("subexercises")]?.components(separatedBy: NSCharacterSet(charactersIn: "[,]") as CharacterSet).filter{ Int($0) != nil },
                    id: exercise[Expression<Int>("id")]))
            }
            return exercises
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Exercise?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let exercise = try database.pluck(Table("exercise").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Exercise(
                name: exercise[Expression<String>("name")],
                description: exercise[Expression<String>("description")],
                area: exercise[Expression<String>("area")],
                type: exercise[Expression<String>("type")],
                maxReps: exercise[Expression<Int?>("max_reps")],
                series: exercise[Expression<Int?>("series")],
                strict: exercise[Expression<Bool?>("strict")],
                individual: exercise[Expression<Bool?>("individual")],
                timer: exercise[Expression<Int?>("timer")],
                objective: objectiveFromString(objective: exercise[Expression<String?>("objective")]),
                subexercises: exercise[Expression<String?>("subexercises")]?.components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil },
                id: exercise[Expression<Int>("id")])
        } catch {
            print(error)
            return nil
        }
    }
}


