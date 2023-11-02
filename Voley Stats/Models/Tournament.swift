import SQLite
import SwiftUI

class Tournament: Descriptable, Equatable {
    var id:Int;
    var name:String
    var team:Team
    var location:String
    var startDate:Date
    var endDate:Date
    static func ==(lhs: Tournament, rhs: Tournament) -> Bool {
        return lhs.id == rhs.id
    }
    init(name:String, team:Team, location:String, startDate: Date, endDate:Date){
        self.name=name
        self.team=team
        self.location=location
        self.startDate=startDate
        self.endDate=endDate
        self.id=0
    }
    
    init(id:Int, name:String, team:Team, location:String, startDate: Date, endDate:Date){
        self.name=name
        self.team=team
        self.location=location
        self.startDate=startDate
        self.endDate=endDate
        self.id=id
    }
    
    var description : String {
        return self.name
    }
    
    static func create(tournament: Tournament)->Tournament?{
        do {
            guard let database = DB.shared.db else {
                return nil
            }
            if tournament.id != 0{
                try database.run(Table("tournament").insert(
                    Expression<String>("name") <- tournament.name,
                    Expression<Int>("team") <- tournament.team.id,
                    Expression<String>("location") <- tournament.location,
                    Expression<Date>("start_date") <- tournament.startDate,
                    Expression<Date>("date_start") <- tournament.startDate,
                    Expression<Date>("date_end") <- tournament.endDate
                ))
            }else{
                let id = try database.run(Table("tournament").insert(
                    Expression<String>("name") <- tournament.name,
                    Expression<Int>("team") <- tournament.team.id,
                    Expression<String>("location") <- tournament.location,
                    Expression<Date>("date_start") <- tournament.startDate,
                    Expression<Date>("date_end") <- tournament.endDate
                ))
                tournament.id = Int(id)
            }
            return tournament
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
            let update = Table("tournament").filter(self.id == Expression<Int>("id")).update([
                Expression<String>("name") <- self.name,
                Expression<Int>("team") <- self.team.id,
                Expression<String>("location") <- self.location,
                Expression<Date>("date_start") <- self.startDate,
                Expression<Date>("date_end") <- self.endDate,
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
            let delete = Table("tournament").filter(self.id == Expression<Int>("id")).delete()
            try database.run(delete)
            return true
            
        } catch {
            print(error)
        }
        return false
    }
    static func all() -> [Tournament]{
        var tournaments: [Tournament] = []
        do{
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            for tournament in try database.prepare(Table("tournament")) {
                tournaments.append(Tournament(
                    id: tournament[Expression<Int>("id")],
                    name: tournament[Expression<String>("name")],
                    team: Team.find(id: tournament[Expression<Int>("team")])!,
                    location: tournament[Expression<String>("location")],
                    startDate: tournament[Expression<Date>("date_start")],
                    endDate: tournament[Expression<Date>("date_end")]))
            }
            return tournaments
        } catch {
            print(error)
            return []
        }
    }
    static func find(id: Int) -> Tournament?{
        do{
            guard let database = DB.shared.db else {
                return nil
            }
            guard let tournament = try database.pluck(Table("tournament").filter(Expression<Int>("id") == id)) else {
                return nil
            }
            return Tournament(
                id: tournament[Expression<Int>("id")],
                name: tournament[Expression<String>("name")],
                team: Team.find(id: tournament[Expression<Int>("team")])!,
                location: tournament[Expression<String>("location")],
                startDate: tournament[Expression<Date>("date_start")],
                endDate: tournament[Expression<Date>("date_end")])
        } catch {
            print(error)
            return nil
        }
    }
    func getStartDateString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.startDate)
    }
    func getEndDateString()->String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df.string(from: self.endDate)
    }
    func matches(interval: Int? = nil) -> [Match]{
        var matches: [Match] = []
        do {
            guard let database = DB.shared.db else {
                print("no db")
                return []
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd HH:mm"
            
            var query = Table("match").filter(Expression<Int>("tournament")==self.id)
            if interval != nil {
                let ini = Calendar.current.date(byAdding: .month, value: -interval!, to: Date()) ?? Date()
                query = query.filter(ini...Date() ~= Expression<Date>("date"))
            }
            
            for match in try database.prepare(query) {
                matches.append(Match(opponent: match[Expression<String>("opponent")], date: match[Expression<Date>("date")], location: match[Expression<String>("location")], home: match[Expression<Bool>("home")], n_sets: match[Expression<Int>("n_sets")], n_players: match[Expression<Int>("n_players")], team: match[Expression<Int>("team")], league: match[Expression<Bool>("league")], tournament: Tournament.find(id: match[Expression<Int>("tournament")]), id: match[Expression<Int>("id")]))
            }
            return matches.sorted{ a, b in a.date > b.date}
        }catch{
            print(error)
            return []
        }
    }
}


