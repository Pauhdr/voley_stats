//
//  SwiftUIView.swift
//
//
//  Created by Pau Hermosilla on 4/5/23.
//

import SwiftUI

struct ScoutingCourt: View {
    @ObservedObject var viewModel: ScoutingCourtModel
    var body: some View {

            VStack{
                VStack{
                    VStack{
                        HStack{
                            ZStack{
                                Rectangle().stroke(viewModel.to == 1 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                if viewModel.showStats{
                                    HStack{
                                        if viewModel.scouts[5]?[1]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[1]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[1]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[1]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[1]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[1]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
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
                                    HStack{
                                        if viewModel.scouts[5]?[6]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[6]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[6]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[6]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[6]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[6]?.count ?? 0)")
                                            }
                                        }
                                        
                                    }.padding(3)
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
                                    HStack{
                                        if viewModel.scouts[5]?[5]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[5]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[5]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[5]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[5]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[5]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
                                }
                            }
                            .gesture(TapGesture(count: 2).onEnded{
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
                                Rectangle().stroke(viewModel.to == 7 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                if viewModel.showStats{
                                    HStack{
                                        if viewModel.scouts[5]?[7]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[7]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[7]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[7]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[7]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[7]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.to = 7
                                viewModel.difficulty = 5
                                viewModel.saveScout()
                            }).onTapGesture {
                                viewModel.to = 7
                                viewModel.saveScout()
                            }
                            ZStack{
                                Rectangle().stroke(viewModel.to == 8 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                if viewModel.showStats{
                                    HStack{
                                        if viewModel.scouts[5]?[8]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[8]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[8]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[8]?.count ?? 0)")
                                            }
                                            
                                        }
                                        if viewModel.scouts[1]?[8]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[8]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
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
                                Rectangle().stroke(viewModel.to == 9 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                if viewModel.showStats{
                                    HStack{
                                        if viewModel.scouts[5]?[9]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[9]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[9]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[9]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[9]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[9]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
                                }
                            }.gesture(TapGesture(count: 2).onEnded{
                                viewModel.to = 9
                                viewModel.difficulty = 5
                                viewModel.saveScout()
                            }).onTapGesture {
                                viewModel.to = 9
                                viewModel.saveScout()
                            }
                        }.padding(.horizontal)
                        
                        HStack{
                            ZStack{
                                Rectangle().stroke(viewModel.to == 2 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                if viewModel.showStats{
                                    HStack{
                                        if viewModel.scouts[5]?[2]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[2]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[2]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[2]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[2]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[2]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
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
                                    HStack{
                                        if viewModel.scouts[5]?[3]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[3]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[3]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[3]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[3]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[3]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
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
                                Rectangle().stroke(viewModel.to == 4 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(.orange))
                                if viewModel.showStats{
                                    HStack{
                                        if viewModel.scouts[5]?[4]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.cyan)
                                                Text("\(viewModel.scouts[5]?[4]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[6]?[4]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.yellow)
                                                Text("\(viewModel.scouts[6]?[4]?.count ?? 0)")
                                            }
                                        }
                                        if viewModel.scouts[1]?[4]?.count ?? 0 > 0{
                                            ZStack{
                                                Circle().fill(.indigo)
                                                Text("\(viewModel.scouts[1]?[4]?.count ?? 0)")
                                            }
                                        }
                                    }.padding(3)
                                }
                            }
                            .gesture(TapGesture(count: 2).onEnded{
                                viewModel.to = 4
                                viewModel.difficulty = 5
                                viewModel.saveScout()
                            })
                            .onTapGesture {
                                viewModel.to = 4
                                viewModel.saveScout()
                            }
                        }.padding(.horizontal)
                    }.padding(.horizontal)
                }.frame(maxHeight: .infinity)
                ZStack{
                    Circle().fill(.black).frame(height: 25).frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle().fill(.black).frame(height: 7)
                    Circle().fill(.black).frame(height: 25).frame(maxWidth: .infinity, alignment: .trailing)
                }
                VStack{
                    VStack{
                        HStack{
                            Rectangle().fill(.orange)
                            Rectangle().fill(.orange)
                            Rectangle().fill(.orange)
                        }.padding(.horizontal)
                        HStack{
                            Rectangle().fill(.orange)
                            Rectangle().fill(.orange)
                            Rectangle().fill(.orange)
                        }.padding(.horizontal)
                        HStack{
                            Rectangle().stroke(viewModel.from == 5 ? .white : .clear, lineWidth: 4).background(
                                Rectangle().fill(viewModel.showStats ? .blue : .black.opacity(0.6))).onTapGesture {
                                    viewModel.from = 5
                                    viewModel.saveScout()
                                }
                            Rectangle().stroke(viewModel.from == 6 ? .white : .clear, lineWidth: 4).background(Rectangle().fill(viewModel.showStats ? .yellow : .black.opacity(0.6))).onTapGesture {
                                viewModel.from = 6
                                viewModel.saveScout()
                            }
                            Rectangle().stroke(viewModel.from == 1 ? .white : .clear, lineWidth: 4).background(
                                Rectangle().fill(viewModel.showStats ? .indigo : .black.opacity(0.6))).onTapGesture {
                                    viewModel.from = 1
                                    viewModel.saveScout()
                                }
                        }.padding(.horizontal)
                    }.padding(.horizontal)
                }.frame(maxHeight: .infinity)
            }.padding().background(.cyan).padding(3).onTapGesture {
                viewModel.difficulty = 0
                viewModel.to = 0
                viewModel.saveScout()
            }
            
        
    }
    
}

class ScoutingCourtModel: ObservableObject{
    @Published var to: Int = -1
    @Published var from: Int = -1
    @Published var server: Int = 0
    @Published var difficulty: Int = 2
    @Published var showStats: Bool = false
    var action:String = ""
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
    init(team: Team, scout:Scout, rotation: [Int], action:String, showStats: Bool){
        self.team = team
        self.scout = scout
        self.server=rotation[0]
        self.rotation = rotation
        self.showStats = showStats
        self.action = action
        Scout.teamScouts(teamName: scout.teamName, related: team, action: action).forEach{s in
            scouts[s.from]?[s.to]?.append(s)
        }
    }
    func saveScout(){
        if from != -1 && to != -1 && server != 0 && !showStats{
            let sc = Scout(teamName: scout.teamName, teamRelated: team, player: self.server, rotation: self.rotation, action: self.action, difficulty: self.difficulty, from: from, to: to, date: Date())
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

//struct ScoutingCourt_Previews: PreviewProvider {
//    static var previews: some View {
//        let team = Team(name: "", organization: "", category: "", gender: "", color: .red, id: 0)
//        ScoutingCourt(viewModel: ScoutingCourtModel(team: team, scout: Scout(teamName: "", teamRelated: team, player: 0, rotation: [0,0,0,0,0,0], action: "create", difficulty: 0, from: 0, to: 0, date: Date()), rotation: [0,0,0,0,0,0], action:"serve", showStats: false))
//    }
//}
