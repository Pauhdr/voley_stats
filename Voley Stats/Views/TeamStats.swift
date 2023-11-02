//
//  ListMatches.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 23/5/23.
//

import SwiftUI

struct TeamStats: View {
    var team:Team
    @Binding var startDate:Date
    @Binding var endDate:Date
    @Binding var matches:[Match]
    @Binding var tournaments:[Tournament]
//    var teamStats:Dictionary<String,Dictionary<String,Int>>=[:]
    
//    init(team:Team, startDate:Date, endDate:Date, matches:[Match], tournaments:[Tournament]){
//        self.team = team
//        self.startDate = startDate
//        self.endDate = endDate
//        self.matches = matches
//        self.tournaments = tournaments
//        self.teamStats = team.fullStats(startDate: startDate, endDate: endDate)
//    }
    
    
    var body: some View {
        VStack{
            ScrollView{
                VStack{
                    
                    LazyVGrid(columns:[GridItem(.adaptive(minimum: 250))], spacing: 20){
                        let teamStats = team.fullStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay)
                        ForEach(Array(teamStats.keys.sorted()), id:\.self){area in
                            let data = teamStats[area]!
                            PieChart(title: area.trad().capitalized, total: data["total"]!, error: data["error"]!, earned: data["earned"]!, size: 175)
                        }
                    }
                    LineChartView(title:"serve.historical.stats", dataPoints: [(.blue, team.historicalStats(startDate: startDate, endDate: endDate, actions: [8]), "ace"), (.red, team.historicalStats(startDate: startDate, endDate: endDate, actions: [15]), "errors")])
                    let err = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [22])
                    let rcv1 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [2])
                    let rcv2 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [3])
                    let rcv3 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [4])
                    LineChartView(title: "receive.historical.stats", dataPoints: [(.red, err, "errors"), (.orange, rcv1, "1-"+"receive".trad()), (.yellow, rcv2, "2-"+"receive".trad()), (.green, rcv3, "3-"+"receive".trad())])
                    let kills = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [6,9,10,11])
                    let atkErr = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [16,17,18,34])
                    LineChartView(title: "atk.historical.stats", dataPoints: [(.red, atkErr, "errors"), (.green, kills, "kills")])
                }.frame(maxWidth: .infinity, alignment: .center)
                    
            }
        }//.background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(.white.opacity(0.1)))
    }
}
