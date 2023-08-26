import SQLite
import Foundation
import UniformTypeIdentifiers
import SwiftUI

class DB {
    var db: Connection? = nil
    static var shared = DB()
    private init() {
        if db == nil {
            if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let dirPath = docDir.appendingPathComponent("database")
                
                do {
                    try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                    let dbPath = dirPath.appendingPathComponent("db.sqlite").path
                    db = try Connection(dbPath)
                    initDatabase()
                    print("SQLiteDataStore init successfully at: \(dbPath) ")
                } catch {
                    db = nil
                    print("SQLiteDataStore init error: \(error)")
                }
            } else {
                db = nil
            }
        }
    }
    
    private func initDatabase(){
        guard let database = db else {
            return
        }
        do {
            try database.run(Table("team").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<String>("organization"))
                t.column(Expression<String>("category"))
                t.column(Expression<String>("gender"))
                t.column(Expression<String>("color"))
            })
        } catch {
            print("TEAM Error: \(error)")
        }
        do {
            try database.run(Table("player").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<Int>("number"))
                t.column(Expression<Int>("active"))
                t.column(Expression<Date>("birthday"))
                t.column(Expression<Int>("team"))
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
            })
        } catch {
            print("PLAYER Error: \(error)")
        }
        
        do {
            try database.run(Table("player_measures").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("player"))
                t.column(Expression<Date>("date"))
                t.column(Expression<Int>("height"))
                t.column(Expression<Double>("weight"))
                t.column(Expression<Int>("one_hand_reach"))
                t.column(Expression<Int>("two_hand_reach"))
                t.column(Expression<Int>("attack_reach"))
                t.column(Expression<Int>("block_reach"))
                t.column(Expression<Int>("breadth"))
            })
        } catch {
            print("PLAYER_MEASURES Error: \(error)")
        }
        
        do {
            try database.run(Table("tournament").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<Int>("team"))
                t.column(Expression<String>("location"))
                t.column(Expression<Date>("date_start"))
                t.column(Expression<Date>("date_end"))
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
            })
        } catch {
            print("TOURNAMENT Error: \(error)")
        }
        
        do {
            try database.run(Table("match").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("opponent"))
                t.column(Expression<String>("location"))
                t.column(Expression<Bool>("home"))
                t.column(Expression<Bool>("league"), defaultValue: false)
                t.column(Expression<Date>("date"))
                t.column(Expression<Int>("n_sets"))
                t.column(Expression<Int>("n_players"))
                t.column(Expression<Int>("team"))
                t.column(Expression<Int>("tournament"), defaultValue: 0)
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
//                t.foreignKey(Expression<Int>("tournament"), references: Table("tournament"), Expression<Int>("id"), update: .cascade, delete: .setDefault)
            })
        } catch {
            print("MATCH Error: \(error)")
        }
        do {
            try database.run(Table("rotation").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String?>("name"))
                t.column(Expression<Int>("1"))
                t.column(Expression<Int>("2"))
                t.column(Expression<Int>("3"))
                t.column(Expression<Int>("4"))
                t.column(Expression<Int>("5"))
                t.column(Expression<Int>("6"))
                t.column(Expression<Int>("team"))
                t.foreignKey(Expression<Int>("team"), references: Table("team"), Expression<Int>("id"), update: .cascade, delete: .cascade)
            })
        } catch {
            print("ROTATION Error: \(error)")
        }
        do {
            try database.run(Table("set").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("number"))
                t.column(Expression<Int>("first_serve"))
                t.column(Expression<Int>("match"))
                //                t.foreignKey(Expression<Int>("match"), references: Table("match"), Expression<Int>("id"), update: .cascade, delete: .cascade)
                t.column(Expression<Int>("rotation"))
                t.column(Expression<Int?>("libero1"))
                t.column(Expression<Int?>("libero2"))
                t.column(Expression<Int?>("result"), defaultValue: 0)
                t.column(Expression<Int?>("score_us"), defaultValue: 0)
                t.column(Expression<Int?>("score_them"), defaultValue: 0)
            })
        } catch {
            print("SET 1 Error: \(error)")
        }
        do {
            try database.run(Table("stat").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                
                t.column(Expression<Int>("match"))
                //                t.foreignKey(Expression<Int>("match"), references: Table("match"), Expression<Int>("id"), update: .cascade, delete: .cascade)
                
                t.column(Expression<Int>("set"))
                //                t.foreignKey(Expression<Int>("set"), references: Table("set"), Expression<Int>("id"), update: .cascade, delete: .cascade)
                
                t.column(Expression<Int>("player"))
                //                t.foreignKey(Expression<Int>("player"), references: Table("player"), Expression<Int>("id"), update: .cascade, delete: .cascade)
                
                t.column(Expression<Int>("rotation"))
                t.column(Expression<Int>("rotation_turns"))
                t.column(Expression<Int>("rotation_count"))
                t.column(Expression<Int>("server"))
                t.column(Expression<Int>("action"))
                t.column(Expression<Int?>("player_in"), defaultValue: nil)
                //                t.foreignKey(Expression<Int>("action"), references: Table("action"), Expression<Int>("id"), update: .cascade, delete: .cascade)
                
                t.column(Expression<Int?>("to"), defaultValue: 0)
                t.column(Expression<Int>("score_us"))
                t.column(Expression<Int>("score_them"))
                t.column(Expression<Int>("stage"))
                t.column(Expression<String>("detail"))
            })
            
            
        } catch {
            print("STAT Error: \(error)")
        }
        do {
            try database.run(Table("session").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("team"))
                t.column(Expression<Date>("date"))
                t.column(Expression<String>("players"))
            })
        } catch {
            print("SESION Error: \(error)")
        }
        do {
            try database.run(Table("exercise").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<String>("description"))
                t.column(Expression<String>("area"))
                t.column(Expression<String>("type"))
                t.column(Expression<Int?>("max_reps"))
                t.column(Expression<Int?>("series"))
                t.column(Expression<Bool?>("strict"))
                t.column(Expression<Bool?>("individual"))
                t.column(Expression<Int?>("timer"))
                t.column(Expression<String?>("objective"))
                t.column(Expression<String?>("subexercises"))
            })
            let c = try Array(database.prepare(Table("exercise"))).count;
            if c == 0 {
                var exercise = Exercise(name: "free.capture", description: "free.capture.description", area: "all", type: "stats", id: nil)
                try database.run(Table("exercise").insert(
                    Expression<String>("name") <- exercise.name,
                    Expression<String>("description") <- exercise.description,
                    Expression<String>("area") <- exercise.area,
                    Expression<String>("type") <- exercise.type
                ))
                exercise = Exercise(name: "quick.anotation", description: "quick.anotation.description", area: "all", type: "improve", id: nil)
                try database.run(Table("exercise").insert(
                    Expression<String>("name") <- exercise.name,
                    Expression<String>("description") <- exercise.description,
                    Expression<String>("area") <- exercise.area,
                    Expression<String>("type") <- exercise.type
                ))
            }
        } catch {
            print("EXERCISE Error: \(error)")
        }
        do {
            try database.run(Table("session_exercise").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("session"))
                t.column(Expression<Int>("exercise"))
                t.column(Expression<Int>("order"))
                t.column(Expression<Int?>("max_reps"))
                t.column(Expression<Int?>("series"))
                t.column(Expression<Bool?>("strict"))
                t.column(Expression<Bool?>("individual"))
                t.column(Expression<Int?>("timer"))
                t.column(Expression<String?>("objective"))
                t.column(Expression<String?>("subexercises"))
            })
        } catch {
            print("SESION EXERCISE Error: \(error)")
        }
        do {
            try database.run(Table("improve").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("player"))
                t.column(Expression<Int>("exercise"))
                t.column(Expression<String>("area"))
                t.column(Expression<String>("comment"))
                t.column(Expression<Date>("date"))
            })
        } catch {
            print("IMPROVE Error: \(error)")
        }
        
        do {
            try database.run(Table("scout").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("player"))
                t.column(Expression<Int>("team_related"))
                t.column(Expression<String>("team_name"))
                t.column(Expression<Int>("from"))
                t.column(Expression<Int>("to"))
                t.column(Expression<Int>("difficulty"))
                t.column(Expression<String>("action"))
                t.column(Expression<String>("rotation"))
                t.column(Expression<Date>("date"))
                t.column(Expression<String>("comment"))
            })
        } catch {
            print("SCOUT Error: \(error)")
        }
        
        do {
            try database.run(Table("player_teams").create(ifNotExists: true) {t in
                t.column(Expression<Int>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int>("player"))
                t.column(Expression<Int>("team"))
            })
        } catch {
            print("PLAYER_TEAMS Error: \(error)")
        }
        
    }
    
    static func createCSV() -> URL {
        var csvString = "id,name,organization,category,gender,color\n"
        for team in Team.all() {
            csvString = csvString.appending("\(team.id),\(team.name),\(team.orgnization),\(team.category),\(team.gender),\(team.color)\n")
        }
        csvString = csvString.appending(":\n id,name,number,active,team,birthday\n")
        for player in Player.all(){
            csvString = csvString.appending("\(player.id),\(player.name),\(player.number),\(player.active),\(player.team),\(player.getBirthDay())\n")
        }
        csvString = csvString.appending(":\n id,opponent,location,home,date,n_sets,n_players,team,league,tournament\n")
        for match in Match.all(){
            csvString = csvString.appending("\(match.id),\(match.opponent),\(match.location),\(match.home),\(match.getDate()),\(match.n_sets),\(match.n_players),\(match.team),\(match.league),\(match.tournament?.id ?? 0)\n")
        }
        csvString = csvString.appending(":\n id,number,first_serve,match,rotation,libero1,libero2,result,score_us,score_them\n")
        for set in Set.all(){
            csvString = csvString.appending("\(set.id),\(set.number),\(set.first_serve),\(set.match),\"\(set.rotation.id)\",\(set.liberos[0]),\(set.liberos[1]),\(set.result),\(set.score_us),\(set.score_them)\n")
        }
        csvString = csvString.appending(":\n id,match,set,player,rotation,server,action,player_in,to,score_us,score_them,stage,detail,rotation_turns,rotation_count\n")
        for stat in Stat.all(){
            csvString = csvString.appending("\(stat.id),\(stat.match),\(stat.set),\(stat.player),\"\(stat.rotation.id)\",\( stat.server),\(stat.action),\(stat.player_in),\(stat.to),\(stat.score_us),\(stat.score_them),\(stat.stage),\"\(stat.detail)\",\(stat.rotationTurns),\(stat.rotationCount)\n")
        }
        csvString = csvString.appending(":\n id,name,description,area,type\n")
        for exercise in Exercise.all(){
            if (exercise.id > 2){
                csvString = csvString.appending("\(exercise.id),\(exercise.name),\"\(exercise.description)\",\(exercise.area),\(exercise.type)\n")
            }
        }
        csvString = csvString.appending(":\n id,player,exercise,area,comment,date\n")
        for improve in Improve.all(){
            
            csvString = csvString.appending("\(improve.id),\(improve.player.id),\(improve.exercise.id),\(improve.area),\"\(improve.comment)\",\(improve.getDateString())\n")
            
        }
        csvString = csvString.appending(":\n id,player,team_related,team_name,from,to,difficulty,action,rotation,date,comment\n")
        for scout in Scout.all(){
            csvString = csvString.appending("\(scout.id),\(scout.player),\(scout.teamRelated.id),\(scout.teamName),\(scout.from),\(scout.to),\(scout.difficulty),\(scout.action),\"\(scout.rotation.description)\",\(scout.getDateString()),\"\(scout.comment)\"\n")
        }
        csvString = csvString.appending(":\n id,name,team,location,date_start,date_end\n")
        for tournament in Tournament.all(){
            
            csvString = csvString.appending("\(tournament.id),\(tournament.name),\(tournament.team.id),\(tournament.location),\(tournament.getStartDateString()),\(tournament.getEndDateString())\n")
            
        }
        guard let database = DB.shared.db else {
            fatalError("DB error")
        }
        do {
            csvString = csvString.appending(":\n id,player,team\n")
            for pt in try database.prepare(Table("player_teams")){
                csvString = csvString.appending("\(pt[Expression<Int>("id")]),\(pt[Expression<Int>("player")]),\(pt[Expression<Int>("team")])\n")
            }
        } catch {
            print("Exporting Error: \(error)")
        }
        guard let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("db.csv")
        else { fatalError("DB Destination URL not created") }
        do{
//            let path = try FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false).appendingPathComponent("db.csv")
            try csvString.write(to: path, atomically: true, encoding: .utf8)
            return path
        }catch{
            fatalError("error exporting db")
        }
    }
    static func fillFromCsv(csv:String){
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        //get all tables
        let tables = csv.split(separator: ":")
        //TEAMS id,name,organization,category,gender,color
        var teams = tables[0].split(separator: "\n")
        //remove header elements
        teams.removeFirst()
        for team in teams{
            let values = team.split(separator: ",")
            let t = Team(
                name: String(values[1]),
                organization: String(values[2]),
                category: String(values[3]),
                gender: String(values[4]),
                color: Color(hex: String(values[5])) ?? .orange,
                id: Int(values[0])
            )
            Team.createTeam(team: t)
        }
        //PLAYERS id,name,number,team
        var players = tables[1].split(separator: "\n")
        //remove header elements
        players.removeFirst()
        for player in players{
            let values = player.split(separator: ",")
            let p = Player(
                name: String(values[1]),
                number: Int(values[2])!,
                team: Int(values[4])!,
                active: Int(values[3])!,
                birthday: df.date(from: String(values[5])) ?? Date(),
                id: Int(values[0]))
            Player.createPlayer(player: p)
        }
        //MATCHES id,opponent,location,home,date,n_sets,n_players,team
        var matches = tables[2].split(separator: "\n")
        let mf = DateFormatter()
        mf.dateFormat = "dd/MM/yyyy HH.mm"
        //remove header elements
        matches.removeFirst()
        for match in matches{
            let values = match.split(separator: ",")
            let m = Match(
                opponent: String(values[1]),
                date: mf.date(from: String(values[4])) ?? Date(),
                location: String(values[2]),
                home: String(values[3]) == "true" ? true : false,
                n_sets: Int(values[5])!,
                n_players: Int(values[6])!,
                team: Int(values[7])!,
                league: String(values[8]) == "true" ? true : false,
                tournament: Tournament.find(id: Int(values[9]) ?? 0),
                id: Int(values[0]))
            Match.createMatch(match: m)
        }
        //SETS id,number,first_serve,match,rotation,libero1,libero2,result,score_us,score_them
        var sets = tables[3].split(separator: "\n")
        //remove header elements
        sets.removeFirst()
        for set in sets{
            let values = set.split(separator: ",")
//            print(values)
            let s = Set(
                id: Int(values[0])!,
                number: Int(values[1])!,
                first_serve: Int(values[2])!,
                match: Int(values[3])!,
                rotation: Rotation.find(id: Int(values[4])!)!,
                liberos: [Int(values[5]), Int(values[6])],
                result: Int(values[7]) ?? 0,
                score_us: Int(values[8]) ?? 0,
                score_them: Int(values[9]) ?? 0)
            Set.createSet(set: s)
        }
        //STATS id,match,set,player,rotation,server,action,player_in,to,score_us,score_them,stage,detail
        var stats = tables[4].split(separator: "\n")
        //remove header elements
        stats.removeFirst()
        for stat in stats{
            let values = stat.split(separator: ",")
            let s = Stat(
                id: Int(values[0])!,
                match: Int(values[1])!,
                set: Int(values[2])!,
                player: Int(values[3])!,
                action: Int(values[6])!,
                rotation: Rotation.find(id: Int(values[4])!)!,
                rotationTurns: Int(values[13])!,
                rotationCount: Int(values[14])!,
                score_us: Int(values[9])!,
                score_them: Int(values[10])!,
                to: Int(values[8]) ?? 0,
                stage: Int(values[11])!,
                server: Int(values[5])!,
                player_in: Int(values[7]),
                detail: String(values[12]))
            Stat.createStat(stat: s)
        }
        if tables.count > 5 {
            //EXERCISES id,name,description,area,type
            var exercises = tables[5].split(separator: "\n")
            //remove header elements
            exercises.removeFirst()
            for exercise in exercises{
                let values = exercise.split(separator: ",")
                let e = Exercise(
                    name: String(values[1]),
                    description: String(values[2]),
                    area: String(values[3]),
                    type: String(values[4]),
                    id: Int(values[0])
                )
                Exercise.createExercise(exercise: e)
            }
            
            //IMPROVES id,player,exercise,area,comment,date
            var improves = tables[6].split(separator: "\n")
            //remove header elements
            improves.removeFirst()
            for improve in improves{
                let values = improve.split(separator: ",")
                let i = Improve(
                    id: Int(values[0])!,
                    player: Player.find(id: Int(values[1])!)!,
                    area: String(values[3]),
                    comment: String(values[4]),
                    date: df.date(from: String(values[5]))!,
                    exercise: Exercise.find(id: Int(values[2])!)!
                )
                Improve.createImprove(improve: i)
            }
            
            var scouts = tables[7].split(separator: "\n")
            //remove header elements
            scouts.removeFirst()
            for scout in scouts{
                let values = scout.split(separator: ",")
                let s = Scout(
                    id: Int(values[0])!,
                    teamName: String(values[3]),
                    teamRelated: Team.find(id: Int(values[2])!)!,
                    player: Int(values[1])!,
                    rotation: String(values[8]+values[9]+values[10]+values[11]+values[12]+values[13]).components(separatedBy: NSCharacterSet(charactersIn: "[,] ") as CharacterSet).filter{ Int($0) != nil }.map{ Int($0)! },
                    action: String(values[7]),
                    difficulty: Int(values[6])!,
                    from: Int(values[4])!,
                    to: Int(values[5])!,
                    date: df.date(from: String(values[14]))!,
                    comment: String(values[15])
                )
                Scout.create(scout: s)
            }
            
            var tournaments = tables[8].split(separator: "\n")
            //remove header elements
            tournaments.removeFirst()
            for torunament in tournaments{
                let values = torunament.split(separator: ",")
                let t = Tournament(
                    id: Int(values[0])!,
                    name: String(values[1]),
                    team: Team.find(id: Int(values[2])!)!,
                    location: String(values[3]),
                    startDate: df.date(from: String(values[4]))!,
                    endDate: df.date(from: String(values[5]))!)
            }
            
            var pt = tables[9].split(separator: "\n")
            //remove header elements
            pt.removeFirst()
            for ptms in pt{
                let values = ptms.split(separator: ",")
                do {
                    guard let database = DB.shared.db else {
                        fatalError()
                    }
                    let id = try database.run(Table("player_teams").insert(
                        Expression<Int>("id") <- Int(values[0])!,
                        Expression<Int>("player") <- Int(values[1])!,
                        Expression<Int>("team") <- Int(values[2])!
                    ))
                } catch {
                    print(error)
                }
            }
        }
    }
}
