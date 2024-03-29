//
//  ListMatches.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 23/5/23.
//

import SwiftUI

struct ListMatches: View {
    @ObservedObject var viewModel: ListTeamsModel
    @State var selectMatches: Bool = false
//    @State var tournament: Tournament? = nil
    @State var tournamentMatches: Bool = false
    @State var deleting: Bool = false
    var body: some View {
        VStack{
            if !viewModel.allTeams.isEmpty && viewModel.selected < viewModel.allTeams.count{
                ZStack{
                    if viewModel.showTournaments{
                        Text(tournamentMatches ? "\(viewModel.tournament!.name)".trad() : "tournaments".trad()).font(.title).padding()
                    }else{
                        Text(viewModel.league ? "league.matches".trad() : "matches".trad()).font(.title).padding()
                    }
                    HStack{
                        if !viewModel.showTournaments || viewModel.tournament != nil{
                            
                                Button(action:{
                                    viewModel.selectMatches.toggle()
                                    viewModel.reportMatches = []
                                }){
                                    
                                    
                                    Text(viewModel.selectMatches ? "done".trad() : "select".trad()).font(.caption).foregroundColor(.white)
                                }.padding(10).background(.white.opacity(0.1)).clipShape(Capsule())//.frame(maxWidth: .infinity, alignment: .leading)
                                
                            
                            
                        }
                        if viewModel.selectMatches{
                            
                            NavigationLink(destination: MultiMatchStats(viewModel: MultiMatchStatsModel(team: viewModel.team(), matches: viewModel.reportMatches))){
                                Image(systemName: "chart.bar.fill")
                                    .font(.caption)
                                    .padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule())
                                    //.frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(viewModel.reportMatches.isEmpty ? .gray : .white)
                            }.disabled(viewModel.reportMatches.isEmpty)
                            Button(action:{
                                viewModel.statsFile = Report(team: viewModel.team(), matches: viewModel.reportMatches).generate()
                                //                            viewModel.export.toggle()
                            }){
//                                        Image(systemName: "square.and.arrow.up")
                                Text("PDF")
                                    .font(.caption)
                                    .padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule())
                                    .disabled(viewModel.reportMatches.isEmpty)//.frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(viewModel.reportMatches.isEmpty ? .gray : .white)
                            }
                        }else{
                            if viewModel.showTournaments{
                                NavigationLink(destination: tournamentMatches ? AnyView(MatchData(viewModel: MatchDataModel(team: viewModel.team(), match: nil, league: viewModel.league, tournament: viewModel.tournament))) : AnyView(TournamentData(viewModel: TournamentDataModel(team: viewModel.team(), tournament: nil)))){
                                    Image(systemName: "plus").font(.caption).padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule()).foregroundColor(viewModel.team().players().count < 3 ? .gray : .white)
                                }.disabled(viewModel.team().players().count < 3)
                            } else{
                                NavigationLink(destination: AnyView(MatchData(viewModel: MatchDataModel(team: viewModel.team(), match: nil, league: viewModel.league, tournament: viewModel.tournament)))){
                                    Image(systemName: "plus").font(.caption).padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule()).foregroundColor(viewModel.team().players().count < 3 ? .gray : .white)
                                }.disabled(viewModel.team().players().count < 3)
                            }
                        }
                        
                    }.padding().frame(maxWidth: .infinity, alignment: .trailing)
                    
                    if viewModel.league{
                        
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("matches".trad())
                        }.padding().frame(maxWidth: .infinity, alignment: .leading).onTapGesture{
                            viewModel.league.toggle()
                            viewModel.getMatchesElements(team: viewModel.team())
                        }.padding()
                        
                    }
                }
                ScrollView(.vertical, showsIndicators: false){
                    if !viewModel.showTournaments{
                        
//                        ZStack{
//                            //                                            Capsule()
//                            RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
//                            Button(action:{ viewModel.addMatch(team: viewModel.team())
//                            }){
//                                Image(systemName: "plus").foregroundColor(viewModel.team().players().count < 3 ? .gray : .white)
//                            }.padding().frame(maxWidth: .infinity).disabled(viewModel.team().players().count < 3).frame(maxWidth: .infinity, alignment: .trailing)
//                        }.foregroundColor(.white).padding()
                        if !viewModel.league{
                            ZStack{
                                //                                            Capsule()
                                RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
                                HStack{
                                    Image(systemName: "pin.fill").padding().rotationEffect(.degrees(45))
                                    Text("league".trad()).frame(maxWidth: .infinity, alignment: .leading)
                                    NavigationLink(destination: MultiMatchStats(viewModel: MultiMatchStatsModel(team: viewModel.team(), matches: viewModel.team().matches().filter({$0.league == true})))){
                                        Image(systemName: "chart.bar.fill")
                                    }.padding(.horizontal)
                                }.padding(.trailing)
                            }.foregroundColor(.white).frame(height: 65).padding(10).onTapGesture {
                                viewModel.league.toggle()
                                viewModel.getMatchesElements(team: viewModel.team())
                            }
                        }
                        ForEach(viewModel.matches, id:\.id){match in
                            
                            ListElement(team: viewModel.team(), match: match, viewModel: viewModel) {
                                if viewModel.selectMatches {
                                    if viewModel.reportMatches.contains(match){
                                        viewModel.reportMatches = viewModel.reportMatches.filter{$0.id != match.id}
                                    }else{
                                        viewModel.reportMatches.append(match)
                                    }
                                    
                                }else{
                                    viewModel.matchSelected = match
                                }
                                
                            }
                            
                        }
                    } else {
                        VStack{
                            
                            if tournamentMatches {
                                HStack{
                                    Image(systemName: "chevron.left")
                                    Text("tournaments".trad())
                                }.padding().frame(maxWidth: .infinity, alignment: .leading).onTapGesture{
                                    tournamentMatches.toggle()
                                    viewModel.tournament = nil
                                    viewModel.getMatchesElements(team: viewModel.team())
                                }
                            }
//                            ZStack{
//                                //                                            Capsule()
//                                RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
//                                NavigationLink(destination: tournamentMatches ? AnyView(MatchData(viewModel: MatchDataModel(pilot: viewModel.appPilot, team: viewModel.team(), match: nil))) : AnyView(TournamentData(viewModel: TournamentDataModel(pilot: viewModel.appPilot, team: viewModel.team(), tournament: nil)))){
//                                    Image(systemName: "plus").foregroundColor(viewModel.team().players().count < 3 ? .gray : .white)
//                                }.padding().frame(maxWidth: .infinity).frame(maxWidth: .infinity, alignment: .trailing).disabled(viewModel.team().players().count < 3)
//                            }.foregroundColor(.white).padding()
                            if tournamentMatches{
                                ForEach(viewModel.matches, id:\.id){match in
                                    
                                    ListElement(team: viewModel.team(), match: match, viewModel: viewModel) {
                                        if viewModel.selectMatches {
                                            if viewModel.reportMatches.contains(match){
                                                viewModel.reportMatches = viewModel.reportMatches.filter{$0.id != match.id}
                                            }else{
                                                viewModel.reportMatches.append(match)
                                            }
                                            
                                        }else{
                                            viewModel.matchSelected = match
                                        }
                                        
                                    }
                                    
                                }
                            }else{
                                ForEach(viewModel.tournaments, id:\.id){t in
                                    
                                    ZStack{
                                        //                                            Capsule()
                                        RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
                                        HStack{
                                            VStack(alignment: .leading){
                                                Text("\(t.name)".trad())
                                                HStack{
                                                    Image(systemName: "location.circle")
                                                    Text(t.location)
                                                }.foregroundColor(.gray).font(.caption)
                                                Text("\(t.getStartDateString())-\(t.getEndDateString())").foregroundColor(.gray).font(.caption)
                                            }.padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                            HStack{
                                                NavigationLink(destination: MultiMatchStats(viewModel: MultiMatchStatsModel(team: viewModel.team(), matches: t.matches()))){
                                                    Image(systemName: "chart.bar.fill").padding(.horizontal)
                                                }
                                                NavigationLink(destination: TournamentData(viewModel: TournamentDataModel( team: viewModel.team(), tournament: t))){
                                                    Image(systemName: "square.and.pencil").padding(.horizontal)
                                                }
                                                Image(systemName: "trash.fill").foregroundColor(.red).onTapGesture{
                                                    viewModel.tournament = t
                                                    deleting.toggle()
                                                }.padding(.horizontal)
                                            }
                                        }.padding()
                                    }.foregroundColor(.white).frame(height: 60).padding(10).onTapGesture {
                                        viewModel.matches = t.matches()
                                        viewModel.tournament = t
                                        tournamentMatches.toggle()
                                    }
                                    .confirmationDialog("tournament.delete.description".trad(), isPresented: $deleting, titleVisibility: .visible){
                                        Button("tournament.delete".trad(), role: .destructive){
                                            
                                            if viewModel.tournament?.delete() ?? false{
                                                viewModel.tournaments = viewModel.team().tournaments()
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(.white.opacity(0.1)))
    }
}
