//
//  StatsDataIntent.swift
//  StatsDataIntent
//
//  Created by Pau Hermosilla on 4/7/24.
//

import AppIntents

struct StatsDataIntent: AppIntent {
    static var title: LocalizedStringResource = "Get area stats"
    @Parameter(title: "Area", description: "Choose the are from wich you want to retrive the stats", default: ActionAreas.attack)
    var area:ActionAreas
    @Parameter(title:"Team") var team: TeamEntity
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let actions = Action.getByArea(area: area)
        let data = Team.find(id: team.dbID)!.historicalStats(actions: actions.map{$0.id}).map{"\($0.0):\($0.1)"}.joined(separator: ",")
        return .result(value:team.name)
    }
}

//struct GetTeamsIntent: AppIntent {
//    static var title: LocalizedStringResource = "Get all teams"
////    @Parameter(title: "Area", description: "Choose the are from wich you want to retrive the stats", default: ActionAreas.attack)
////    var area:ActionAreas
//    func perform() async throws -> some IntentResult & ReturnsValue {
////        let teams = Team.all()//.reduce(into: [Int: String]()){$0[$1.id]=$1.name}
//        return .result(value: Team.all().map{TeamEntity(id: UUID(), dbID: $0.id, name: $0.name)})
//    }
//}


