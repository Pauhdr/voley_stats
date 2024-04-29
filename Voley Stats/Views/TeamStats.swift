//
//  ListMatches.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 23/5/23.
//

import SwiftUI
import Charts

struct TeamStats: View {
    var team:Team
    @State var startDate:Date
    @State var endDate:Date
    @Binding var matches:[Match]
    @Binding var tournaments:[Tournament]
    @State var statsType:Int
    @Binding var showFilterbar: Bool
    @State var teamStats:Dictionary<String,Dictionary<String,Int>>=[:]
    @State var serveHistory: [(Color, [(Date, Double)], String)] = []
    @State var receiveHistory: [(Color, [(Date, Double)], String)] = []
    @State var attackHistory: [(Color, [(Date, Double)], String)] = []
    @State var loading: Bool = false
//    @State var
    
    init(team:Team, matches:Binding<[Match]>, tournaments:Binding<[Tournament]>, showFilterbar: Binding<Bool>){
        self.team = team
        self._matches = matches
        self._tournaments = tournaments
        self._showFilterbar = showFilterbar
        self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? Date()
        self.endDate = .now
        self.statsType = 1
//        self.teamStats = team.fullStats(startDate: self.startDate, endDate: self.endDate)
    }
    
    
    var body: some View {
        VStack{
            if self.showFilterbar{
                VStack{
                    
                    HStack{
                        VStack{
                            Text("start.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading)
                            DatePicker("start.date".trad(), selection: self.$startDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                        }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                        VStack{
                            Text("end.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                            DatePicker("end.date".trad(), selection: self.$endDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                        }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                    }.padding(.vertical)
                    VStack{
                        Text("stats.by.type".trad().uppercased()).font(.caption).frame(maxWidth: .infinity, alignment: .leading)
                        Picker("stats.by.type".trad(), selection: self.$statsType){
                            Text("full.stats".trad()).tag(0)
                            Text("matches".trad()).tag(1)
                            Text("training".trad()).tag(2)
                        }.pickerStyle(.segmented)//.disabled(true)
                    }.padding()
                    Text("filter".trad()).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                        
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
            }
            if loading{
                VStack{
                    ProgressView().tint(.white)
                    Text("LOADING...").font(.caption).padding()
                }.frame(maxHeight: .infinity)
            } else{
                ScrollView{
                    LazyVStack{
                        
                        LazyVGrid(columns:[GridItem(.adaptive(minimum: 250))], spacing: 20){
                            //                        let teamStats = team.fullStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, statsType: statsType)
                            ForEach(Array(self.teamStats.keys.sorted()), id:\.self){area in
                                let data = self.teamStats[area]!
                                PieChart(title: area.trad().capitalized, total: data["total"]!, error: data["error"]!, earned: data["earned"]!, size: 175)
                            }
                        }
                        if statsType != 0{
                            LineChartView(title:"serve.historical.stats", dataPoints: self.serveHistory)
                            
                            LineChartView(title: "receive.historical.stats", dataPoints: self.receiveHistory)
                            
                            LineChartView(title: "atk.historical.stats", dataPoints: self.attackHistory)
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                    
                }
            }
        }.onAppear{
            self.loading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                loadData()
            }
        }
        //.background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(.white.opacity(0.1)))
    }
    
    func loadData() {
        self.teamStats = team.fullStats(startDate: self.startDate, endDate: self.endDate)
        
        self.serveHistory = [(.blue, team.historicalStats(startDate: startDate, endDate: endDate, actions: [8]), "ace"), (.red, team.historicalStats(startDate: startDate, endDate: endDate, actions: [15], statsType: statsType), "errors")]
        
        let err = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [22], statsType: statsType)
        let rcv1 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [2], statsType: statsType)
        let rcv2 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [3], statsType: statsType)
        let rcv3 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [4], statsType: statsType)
        self.receiveHistory = [(.red, err, "errors"), (.orange, rcv1, "1-"+"receive".trad()), (.yellow, rcv2, "2-"+"receive".trad()), (.green, rcv3, "3-"+"receive".trad())]
        
        let kills = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [6,9,10,11], statsType: statsType)
        let atkErr = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [16,17,18,34], statsType: statsType)
        self.attackHistory = [(.red, atkErr, "errors"), (.green, kills, "kills")]
        
        self.loading = false
    }
}
