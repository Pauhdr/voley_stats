//
//  SwiftUIView.swift
//
//
//  Created by Pau Hermosilla on 5/5/23.
//

import SwiftUI

struct DigScouting: View {
    @ObservedObject var viewModel: DigScoutingModel
    var body: some View {
        VStack{
            Image(systemName: "rotate.left").onTapGesture {
                withAnimation(.easeInOut){
                    viewModel.flip.wrappedValue.toggle()
                }
            }.frame(maxWidth: .infinity, alignment: .trailing).padding()
            VStack{
                ZStack{
                    Circle().fill(.black).frame(height: 25).frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle().fill(.black).frame(height: 7)
                    Circle().fill(.black).frame(height: 25).frame(maxWidth: .infinity, alignment: .trailing)
                }//.padding(.horizontal)
                VStack{
                    VStack{
                        
                        HStack{
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[4]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[4]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 4
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 4
                                viewModel.saveScout()
                            }
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[3]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[3]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 3
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 3
                                viewModel.saveScout()
                            }
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[2]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[2]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 2
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 2
                                viewModel.saveScout()
                            }
                        }
                        HStack{
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[7]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[7]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 7
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 7
                                viewModel.saveScout()
                            }
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[8]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[8]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 8
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 8
                                viewModel.saveScout()
                            }
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[9]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[9]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 9
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 9
                                viewModel.saveScout()
                            }
                        }
                        HStack{
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[5]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[5]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 5
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 5
                                viewModel.saveScout()
                            }
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[6]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[6]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 6
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 6
                                viewModel.saveScout()
                            }
                            ZStack{
                                Rectangle().fill(.orange)
                                if viewModel.showStats {
                                    let err = viewModel.scouts[1]!.filter{$0.difficulty == 5}.count
                                    let tot = viewModel.scouts[1]!.count
                                    Rectangle().fill(tot > 0 && err == 0 ? .green : .red.opacity(tot > 0 ? Double(err) / Double(tot) : 0))//.padding(5)
                                    Text("\(err)/\(tot)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.difficulty = 5
                                viewModel.to = 1
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 1
                                viewModel.saveScout()
                            }
                        }
                    }.padding(.horizontal)
                }.padding(.horizontal)
            }.rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? 180 : 0))
        }.padding().background(.cyan).padding(3)
    }
}
class DigScoutingModel: ObservableObject{
    @Published var to: Int = -1
    @Published var from: Int = 0
    @Published var player: Int = 0
    @Published var difficulty: Int = 2
    @Published var showStats: Bool = false
    @Published var maxScouts: Int = 0
    @Published var flip: Binding<Bool> 
    var rotation:[Int]
    var team: Team
    var scout:Scout
    @Published var scouts:Dictionary<Int, [Scout]> = [
        1: [],
        2: [],
        3: [],
        4: [],
        5: [],
        6: [],
        7: [],
        8: [],
        9: []
    ]
    init(team: Team, scout:Scout, rotation: [Int], player: Int, showStats: Bool, flip: Binding<Bool>){
        self.team = team
        self.scout = scout
        self.player=player
        self.rotation = rotation
        self.showStats = showStats
        self.flip = flip
        Scout.teamScouts(teamName: scout.teamName, related: team, action: "dig").forEach{s in
            if player == 0 {
                scouts[s.to]?.append(s)
            } else if player == s.player {
                scouts[s.to]?.append(s)
            }
        }
        self.maxScouts = scouts.reduce(0){ max($0, $1.1.count)}
    }
    func saveScout(){
        if from != -1 && to != -1 && player != 0 && !showStats{
            let sc = Scout(teamName: scout.teamName, teamRelated: team, player: self.player, rotation: self.rotation, action: "dig", difficulty: self.difficulty, from: from, to: to, date: Date())
            let newScout = Scout.create(scout: sc)
            if newScout != nil {
                scouts[to]?.append(newScout!)
                to = -1
                difficulty = 2
                self.maxScouts = scouts.reduce(0){ max($0, $1.1.count)}
            }
        }
    }
}
//struct DigScouting_Previews: PreviewProvider {
//    static var previews: some View {
//        let team = Team(name: "", organization: "", category: "", gender: "", color: .red, id: 0)
//        DigScouting(viewModel: DigScoutingModel(team: team, scout: Scout(teamName: "", teamRelated: team, player: 0, rotation: [0,0,0,0,0,0], action: "create", difficulty: 0, from: 0, to: 0, date: Date()), rotation: [0,0,0,0,0,0], player: 0, showStats: false))
//    }
//}
