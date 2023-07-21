//
//  SwiftUIView.swift
//
//
//  Created by Pau Hermosilla on 4/5/23.
//

import SwiftUI

struct AttackScouting: View {
    @ObservedObject var viewModel: AttackScoutingModel
    let statb = RoundedRectangle(cornerRadius: 10.0, style: .continuous)
    var body: some View {
        VStack{
            if viewModel.showStats{
                let allsc = viewModel.allScouts()
                HStack{
                    ZStack{
                        statb.fill(.red)
                        HStack{
                            Text("net".trad()).foregroundColor(.white)
                            Text(" \(allsc.filter{$0.to==10}.count)")
                        }
                    }
                    ZStack{
                        statb.fill(.red)
                        HStack{
                            Text("blocked".trad()).foregroundColor(.white)
                            Text(" \(allsc.filter{$0.to==11}.count)")
                        }
                    }
                    
                    ZStack{
                        statb.fill(.green)
                        HStack{
                            Text("block.out".trad()).foregroundColor(.white)
                            Text(" \(allsc.filter{$0.to==12}.count)")
                        }
                    }
                    ZStack{
                        statb.fill(.red)
                        HStack{
                            Text("out".trad()).foregroundColor(.white)
                            Text(" \(allsc.filter{$0.to==0}.count)")
                        }
                    }
                }.frame(height: 50)
            } else {
                HStack{
                    ZStack{
                        statb.fill(.red)
                        Text("net".trad()).foregroundColor(.white)
                    }.onTapGesture {
                        viewModel.to = 10
                        viewModel.difficulty = 0
                        viewModel.saveScout()
                    }
                    ZStack{
                        statb.fill(.red)
                        Text("blocked".trad()).foregroundColor(.white)
                    }.onTapGesture {
                        viewModel.to = 11
                        viewModel.difficulty = 0
                        viewModel.saveScout()
                    }
                    
                    ZStack{
                        statb.fill(.green)
                        Text("block.out".trad()).foregroundColor(.white)
                    }.onTapGesture {
                        viewModel.to = 12
                        viewModel.difficulty = 5
                        viewModel.saveScout()
                    }
                    ZStack{
                        statb.fill(.red)
                        Text("out".trad()).foregroundColor(.white)
                    }.onTapGesture {
                        viewModel.to = 0
                        viewModel.difficulty = 0
                        viewModel.saveScout()
                    }
                }.frame(height: 50)
            }
            VStack{
                Image(systemName: "rotate.left").onTapGesture {
                    withAnimation(.easeInOut){
                        viewModel.flip.wrappedValue.toggle()
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding()
                
                VStack{
                    VStack{
                        VStack{
                            HStack{
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 1 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 1, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 1
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 1
                                    viewModel.saveScout()
                                }
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 6 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 6, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 6
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 6
                                    viewModel.saveScout()
                                }
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 5 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 5, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 5
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 5
                                    viewModel.saveScout()
                                }
                            }.padding(.horizontal)
                            
                            
                            HStack{
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 9 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 9, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 9
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 9
                                    viewModel.saveScout()
                                }
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 8 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 8, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 8
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 8
                                    viewModel.saveScout()
                                }
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 7 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 7, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 7
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 7
                                    viewModel.saveScout()
                                }
                            }.padding(.horizontal)
                            HStack{
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 2 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 2, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 2
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 2
                                    viewModel.saveScout()
                                }
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 3 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 3, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 3
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 3
                                    viewModel.saveScout()
                                }
                                ZStack{
                                    Rectangle().stroke(viewModel.to == 4 ? .white : .clear, lineWidth: 4).background(Rectangle().fill( .orange))
                                    if viewModel.showStats{
                                        fromCount(viewModel: viewModel, to: 4, category: viewModel.team.category)
                                    }
                                }.gesture(TapGesture(count: 2).onEnded{
                                    viewModel.to = 4
                                    viewModel.difficulty = 5
                                    viewModel.saveScout()
                                }).onTapGesture {
                                    viewModel.to = 4
                                    viewModel.saveScout()
                                }
                            }.padding(.horizontal)
                            
                        }.padding(.horizontal)//.padding(.horizontal, 50)
                    }.frame(maxHeight: .infinity)
                    ZStack{
                        Circle().fill(.black).frame(height: 25).frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle().fill(.black).frame(height: 7)
                        Circle().fill(.black).frame(height: 25).frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    VStack{
                        VStack{
                            if ["Benjamin", "Alevin"].contains(viewModel.team.category){
                                VStack{
                                    Rectangle().stroke(viewModel.from == 3 ? .white : .clear, lineWidth: 4)
                                        .background(Rectangle().fill(viewModel.showStats ? .yellow : .orange)).onTapGesture {
                                            viewModel.from = 3
                                            viewModel.saveScout()
                                        }.padding(.horizontal)
                                    HStack{
                                        Rectangle().stroke(viewModel.from == 4 ? .white : .clear, lineWidth: 4).background(
                                            Rectangle().fill(viewModel.showStats ? .pink : .orange)).onTapGesture {
                                                viewModel.from = 4
                                                viewModel.saveScout()
                                            }
                                        Rectangle().stroke(viewModel.from == 2 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(viewModel.showStats ? .blue : .orange)).onTapGesture {
                                            viewModel.from = 2
                                            viewModel.saveScout()
                                        }
                                        
                                    }.padding(.horizontal)
                                    Rectangle().stroke(viewModel.from == 1 ? .white : .clear, lineWidth: 4).background(
                                        Rectangle().fill(viewModel.showStats ? .purple :.orange)).onTapGesture {
                                            viewModel.from = 1
                                            viewModel.saveScout()
                                        }.padding(.horizontal)
                                }
                            }else{
                                HStack{
                                    Rectangle().stroke(viewModel.from == 4 ? .white : .clear, lineWidth: 4).background(
                                        Rectangle().fill(viewModel.showStats ? .pink :.orange)).onTapGesture {
                                            viewModel.from = 4
                                            viewModel.saveScout()
                                        }
                                    Rectangle().stroke(viewModel.from == 3 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(viewModel.showStats ? .yellow :.orange)).onTapGesture {
                                        viewModel.from = 3
                                        viewModel.saveScout()
                                    }
                                    Rectangle().stroke(viewModel.from == 2 ? .white : .clear, lineWidth: 4).background(
                                        Rectangle().fill(viewModel.showStats ? .blue : .orange)).onTapGesture {
                                            viewModel.from = 2
                                            viewModel.saveScout()
                                        }
                                }.padding(.horizontal)
                                HStack{
                                    Rectangle().stroke(viewModel.from == 5 ? .white : .clear, lineWidth: 4).background(
                                        Rectangle().fill(viewModel.showStats ? .gray : .orange)).onTapGesture {
                                            viewModel.from = 5
                                            viewModel.saveScout()
                                        }
                                    Rectangle().stroke(viewModel.from == 6 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(viewModel.showStats ? .green :.orange)).onTapGesture {
                                        viewModel.from = 6
                                        viewModel.saveScout()
                                    }
                                    Rectangle().stroke(viewModel.from == 1 ? .white : .clear, lineWidth: 4).background(
                                        Rectangle().fill(viewModel.showStats ? .purple :.orange)).onTapGesture {
                                            viewModel.from = 1
                                            viewModel.saveScout()
                                        }
                                }.padding(.horizontal)
                            }
                            
                        }.padding(.horizontal)//.padding(.horizontal, 50)
                    }.frame(maxHeight: .infinity)
                }.rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? 180 : 0))
            }.padding().background(.cyan).padding(3)
        }
//            .onTapGesture {
//                viewModel.difficulty = 0
//                viewModel.to = 0
//                viewModel.saveScout()
//            }
            
        
    }
    @ViewBuilder
    func fromCount(viewModel: AttackScoutingModel, to: Int, category: String)->some View{
        let players = ["Alevin", "Benjamin"].contains(category) ? 4 : 6
        HStack{
            ForEach(1...players, id:\.self){from in
                if viewModel.scouts[from]?[to]?.count ?? 0 > 0{
                    ZStack{
                        Rectangle().fill(viewModel.colors[from-1])
                        Text("\(viewModel.scouts[from]?[to]?.count ?? 0)").rotationEffect(Angle(degrees: viewModel.flip.wrappedValue ? -180 : 0))
                    }
                }
            }
        }
    }
    
}

class AttackScoutingModel: ObservableObject{
    @Published var to: Int = -1
    @Published var from: Int = -1
    @Published var player: Int = 0
    @Published var difficulty: Int = 2
    @Published var showStats: Bool = false
    @Published var flip: Binding<Bool>
    var colors: Array<Color> = [.purple, .blue, .yellow, .pink, .gray, .green]
    var rotation:[Int]
    var team: Team
    var scout:Scout
    @Published var scouts:Dictionary<Int, Dictionary<Int, [Scout]>> = [
        1: [
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
            6: [],
            7: [],
            8: [],
            9: []
        ],
        2: [
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
            6: [],
            7: [],
            8: [],
            9: []
        ],
        3: [
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
            6: [],
            7: [],
            8: [],
            9: []
        ],
        4: [
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
            6: [],
            7: [],
            8: [],
            9: []
        ],
        5: [
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
            6: [],
            7: [],
            8: [],
            9: []
        ],
        6: [
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
    ]
    init(team: Team, scout:Scout, rotation: [Int], player: Int, showStats: Bool, flip: Binding<Bool>){
        self.team = team
        self.scout = scout
        self.player = player
        self.rotation = rotation
        self.showStats = showStats
        self.flip = flip
        Scout.teamScouts(teamName: scout.teamName, related: team, action: "attack").forEach{s in
            if player == 0 {
                scouts[s.from]?[s.to]?.append(s)
            } else if player == s.player {
                scouts[s.from]?[s.to]?.append(s)
            }
        }
    }
    func allScouts()->[Scout]{
        var sc:[Scout]=[]
        self.scouts.values.forEach{zone in
            zone.values.forEach{scout in
                sc+=scout
            }
        }
        return sc
    }
    func saveScout(){
        if from != -1 && to != -1 && player != 0 && !showStats{
            let sc = Scout(teamName: scout.teamName, teamRelated: team, player: self.player, rotation: self.rotation, action: "attack", difficulty: self.difficulty, from: from, to: to, date: Date())
            let newScout = Scout.create(scout: sc)
            if newScout != nil {
                scouts[from]?[to]?.append(newScout!)
                from = -1
                to = -1
                difficulty = 2
            }
        }
    }
}

//struct AttackScouting_Previews: PreviewProvider {
//    static var previews: some View {
//        let team = Team(name: "", organization: "", category: "", gender: "", color: .red, id: 0)
//        AttackScouting(viewModel: AttackScoutingModel(team: team, scout: Scout(teamName: "", teamRelated: team, player: 0, rotation: [0,0,0,0,0,0], action: "create", difficulty: 0, from: 0, to: 0, date: Date()), rotation: [0,0,0,0,0,0], player: 0, showStats: false))
//    }
//}
