import SwiftUI

struct Court: View{
    var rotation: [Player]? = nil
    var numberPlayers: Int = 6
    var width: CGFloat = 300
    var height: CGFloat = 350
    var stats: (Int, Int)
    var rect: some View = Rectangle().fill(.orange)
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1))
            HStack{
                VStack{
                    if numberPlayers <= 4 {
                        VStack{
                            HStack{
                                rect.overlay(Text(rotation != nil ? "\(rotation![2].name)" : ""))
                            }.background(.red).frame(width: width, height: height/4)
                            HStack{
                                VStack{
                                    rect.overlay(Text(rotation != nil ? "\(rotation![3].name)" : ""))
                                }
                                VStack{
                                    rect.overlay(Text(rotation != nil ? "\(rotation![1].name)" : ""))
                                }
                            }.frame(width: width, height: height/2)
                            HStack{
                                rect.overlay(Text(rotation != nil ? "\(rotation![0].name)" : ""))
                            }.background(.red).frame(width: width, height: height/4)
                        }.frame(width: width, height: height).padding()
                    } else if numberPlayers > 6{
                        VStack{
                            HStack{
                                rect.overlay(Text(rotation != nil ? "\(rotation![1].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![2].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![2].name)" : ""))
                            }
                            HStack{
                                rect.overlay(Text(rotation != nil ? "\(rotation![2].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![2].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![2].name)" : ""))
                            }
                            HStack{
                                rect
                                rect
                                rect
                            }
                        }.frame(width: width, height: height).padding()
                    } else {
                        VStack{
                            HStack{
                                rect.overlay(Text(rotation != nil ? "\(rotation![3].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![2].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![1].name)" : ""))
                            }
                            HStack{
                                rect.overlay(Text(rotation != nil ? "\(rotation![4].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![5].name)" : ""))
                                rect.overlay(Text(rotation != nil ? "\(rotation![0].name)" : ""))
                            }
                        }.frame(width: width, height: height).padding()
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.gray)
                        VStack{
                            Text("\(stats.0)").font(.title)
                            Text("side.out".trad())
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.gray)
                        VStack{
                            Text("\(stats.1)").font(.title)
                            Text("break.point".trad())
                        }
                    }
                }.padding()
            }.padding()
        }.padding()
    }
}

//struct Court_Previews: PreviewProvider {
//    static var previews: some View {
//        Court(rotation: [
//            Player(name: "Prueba adios", number: 1, team: 0, active: 1, id: 1),
//            Player(name: "Prueba2", number: 2, team: 0, active: 1, id: 2),
//            Player(name: "Prueba3", number: 3, team: 0, active: 1, id: 3),
//            Player(name: "Prueba4", number: 4, team: 0, active: 1, id: 4),
//            Player(name: "Prueba5", number: 5, team: 0, active: 1, id: 5),
//            Player(name: "Prueba6", number: 6, team: 0, active: 1, id: 6),
//        ])
//    }
//}
