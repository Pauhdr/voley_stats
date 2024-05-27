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
    @State var matches:[Match] = []
    @State var tournaments:[Tournament] = []
    @State var player:Int = 0
    @State var match:Int = 0
    @State var tournament:Int = 0
    @State var showFilterbar: Bool = false
    @State var teamStats:Dictionary<String,Dictionary<String,Int>>=[:]
    @State var serveHistory: [(Color, [(Date, Double)], String)] = []
    @State var receiveHistory: [(Color, [(Date, Double)], String)] = []
    @State var attackHistory: [(Color, [(Date, Double)], String)] = []
    @State var loading: Bool = false
//    @State var

    
    init(team:Team){
        self.team = team
//        self._showFilterbar = showFilterbar
        self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? Date()
        self.endDate = .now
//        self.statsType = 1
//        self.teamStats = team.fullStats(startDate: self.startDate, endDate: self.endDate)
    }
    
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Image(systemName: showFilterbar ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        .font(.title3).frame(maxWidth: .infinity, alignment: .trailing).foregroundStyle(showFilterbar ? .cyan : .white)
                        .onTapGesture{
                            withAnimation{
                                showFilterbar.toggle()
                            }
                        }
                    if !showFilterbar{
                        Text("filter".trad())//.font(.caption)
                    }
                }.padding(.horizontal)
                if self.showFilterbar{
                    VStack{
                        HStack{
                            VStack(alignment: .leading){
                                Text("player".trad().uppercased()).font(.caption)
                                Picker("stats.by.type".trad(), selection: self.$player){
                                    Text("pick.one".trad()).tag(0)
                                    ForEach(team.players(), id: \.id){player in
                                        Text(player.name).tag(player.id)
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            }.padding().frame(maxWidth: .infinity, alignment: .leading)
                            VStack(alignment: .leading){
                                Text("match".trad().uppercased()).font(.caption)
                                Picker("stats.by.type".trad(), selection: self.$match){
                                    Text("pick.one".trad()).tag(0)
                                    ForEach(team.matches(), id: \.id){match in
                                        Text(match.opponent).tag(match.id)
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).disabled(self.tournament != 0)
                            }.padding().frame(maxWidth: .infinity, alignment: .leading)
                            VStack(alignment: .leading){
                                Text("tournament".trad().uppercased()).font(.caption)
                                Picker("stats.by.type".trad(), selection: self.$tournament){
                                    Text("pick.one".trad()).tag(0)
                                    ForEach(team.tournaments(), id: \.id){tournament in
                                        Text(tournament.name).tag(tournament.id)
                                    }
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).disabled(self.match != 0)
                            }.padding().frame(maxWidth: .infinity, alignment: .leading)
                        }
                        VStack(alignment: .leading){
                            Text("date.range".trad().uppercased()).font(.caption).padding(.horizontal)
                            HStack{
                                VStack(alignment: .leading){
                                    Text("start.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading)
                                    DatePicker("start.date".trad(), selection: self.$startDate, in: ...Date.now, displayedComponents: .date).labelsHidden().disabled(self.match != 0 || self.tournament != 0)
                                }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                                VStack(alignment: .leading){
                                    Text("end.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                                    DatePicker("end.date".trad(), selection: self.$endDate, in: ...Date.now, displayedComponents: .date).labelsHidden().disabled(self.match != 0 || self.tournament != 0)
                                }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.horizontal)
                        }
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8).stroke(.cyan, lineWidth: 1)
                                Text("reset".trad()).padding().frame(maxWidth: .infinity)
                            }.clipped().onTapGesture {
                                self.match = 0
                                self.tournament = 0
                                self.player = 0
                                self.startDate = Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? Date()
                                self.endDate = .now
                            }
                            Text("filter".trad()).padding().frame(maxWidth: .infinity).background(.cyan).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture {
                                self.loading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    loadData()
                                    withAnimation(.easeIn){
                                        self.showFilterbar.toggle()
                                    }
                                }
                            }
                        }.padding()
                    }
                }
            }.padding().background(showFilterbar ? .white.opacity(0.1) : .clear).clipShape(RoundedRectangle(cornerRadius: 8)).padding()
            
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
//                        if statsType != 0{
                            LineChartView(title:"serve.historical.stats", dataPoints: self.serveHistory)
                            
                            LineChartView(title: "receive.historical.stats", dataPoints: self.receiveHistory)
                            
                            LineChartView(title: "atk.historical.stats", dataPoints: self.attackHistory)
//                        }
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
        let player = Player.find(id: self.player)
        self.matches = self.match != 0 ? [Match.find(id: self.match)!] : []
        self.tournaments = self.tournament != 0 ? [Tournament.find(id: self.tournament)!] : []
        self.teamStats = team.fullStats(startDate: self.startDate, endDate: self.endDate, matches: self.matches, tournaments: self.tournaments, player: player)
        
        self.serveHistory = [(.blue, team.historicalStats(startDate: startDate, endDate: endDate, actions: [8]), "ace"), (.red, team.historicalStats(startDate: startDate, endDate: endDate, actions: [15], matches: self.matches, tournaments: self.tournaments, player: player), "errors")]
        
        let err = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [22], matches: self.matches, tournaments: self.tournaments, player: player)
        let rcv1 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [2], matches: self.matches, tournaments: self.tournaments, player: player)
        let rcv2 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [3], matches: self.matches, tournaments: self.tournaments, player: player)
        let rcv3 = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [4], matches: self.matches, tournaments: self.tournaments, player: player)
        self.receiveHistory = [(.red, err, "errors"), (.orange, rcv1, "1-"+"receive".trad()), (.yellow, rcv2, "2-"+"receive".trad()), (.green, rcv3, "3-"+"receive".trad())]
        
        let kills = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [6,9,10,11], matches: self.matches, tournaments: self.tournaments, player: player)
        let atkErr = team.historicalStats(startDate: startDate.startOfDay, endDate: endDate.endOfDay, actions: [16,17,18,34], matches: self.matches, tournaments: self.tournaments, player: player)
        self.attackHistory = [(.red, atkErr, "errors"), (.green, kills, "kills")]
        
        self.loading = false
    }
}
