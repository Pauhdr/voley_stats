import SwiftUI

struct GeneralTable: View {
    let stats: [Stat]
    let bests: Bool
    var body: some View {
        let serve = stats.filter{s in return [15, 32].contains(s.action) && s.player != 0}
        VStack{
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.pink)
                    VStack{
                        Text("\(getTheirErrors())").font(.title)
                        Text("their.errors".trad())
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.yellow)
                    VStack{
                        Text("\(serve.count)").font(.title)
                        Text("serve.errors".trad())
                    }
                }
            }.padding().frame(height: 150)
            HStack{
                let receivePerPoint: [Float] = getReceivesPerPoint()
                let servesPerPoint: [Float] = getServesPerPoint()
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.gray)
                    VStack{
                        Text("\(Int(receivePerPoint[0]))/\(Int(receivePerPoint[1]))")
                        Text("\(String(format: "%.2f",receivePerPoint[1] != 0 ? receivePerPoint[0]/receivePerPoint[1] : 0))").font(.title)
                        Text("receives.per.point".trad())
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.gray)
                    VStack{
                        Text("\(Int(servesPerPoint[0]))/\(Int(servesPerPoint[1]))")
                        Text("\(String(format: "%.2f",servesPerPoint[1] != 0 ? servesPerPoint[0]/servesPerPoint[1] : 0))").font(.title)
                        Text("serves.per.point".trad())
                    }
                }
            }.padding().frame(height: 150)
            //anyadir errores bloqueos %ptos y total pts despues de rece + - y k
            HStack{
                let receivePerc: Float = getReceivePerc()
                let killPerc: Float = getKillPerc()
                CircleGraph(title: "\(String(format: "%.2f", receivePerc)) "+"receive.rating".trad(), percentage: receivePerc != 0 ? Double(receivePerc/3) : 0, color: .red, size: 120 )
                CircleGraph(title: "kill.percentage".trad(), percentage:killPerc != 0 ? Double(killPerc) : 0, color:.red, size: 120)
            }.frame(maxWidth: .infinity, maxHeight: 200).padding(.vertical)
            if bests {
                Text("match.bests".trad()).font(.title.weight(.bold)).frame(maxWidth: .infinity)
                let bests = getBests()
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                        VStack{
                            
                            Text("serve".trad().capitalized).font(.title)
                            Text("\(bests["serve"]??.name ?? "None")")
                        }.padding()
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                        VStack{
                            Text("receive".trad().capitalized).font(.title)
                            Text("\(bests["receive"]!?.name ?? "None")")
                        }.padding()
                    }
                }.foregroundColor(.yellow)
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                        VStack{
                            Text("attack".trad().capitalized).font(.title)
                            Text("\(bests["attack"]!?.name ?? "None")")
                        }.padding()
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                        VStack{
                            Text("block".trad().capitalized).font(.title)
                            Text("\(bests["block"]!?.name ?? "None")")
                        }.padding()
                    }
                }.foregroundColor(.yellow)
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                        HStack{
                            Image(systemName: "crown.fill").frame(maxWidth: .infinity, alignment: .center)
                            VStack{
                                Text("MVP").font(.title)
                                Text("\(bests["mvp"]!?.name ?? "None")")
                            }.padding()
                            Image(systemName: "crown.fill").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }.foregroundColor(.yellow)
            }else{
                Spacer()
            }
        }.frame(maxWidth: .infinity)
    }
    func getKillPerc() -> Float{
        let atts = stats.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action) && s.player != 0}.count
        
        let kills = stats.filter{s in return [9, 10, 11].contains(s.action) && s.player != 0}.count
        return atts == 0 ? 0 : Float(kills)/Float(atts)
    }
    func getReceivePerc() -> Float{
        let stat = stats.filter{s in return actionsByType["receive"]?.contains(s.action) ?? false && s.player != 0}
        
        let total = stat.count
        let s1 = stat.filter{s in return s.action==2}.count
        let s2 = stat.filter{s in return s.action==3}.count
        let s3 = stat.filter{s in return s.action==4}.count
        let p = Float(s1 + 2*s2 + 3*s3)/Float(total)
        return total == 0 ? 0 : p
    }
    func getTheirErrors() -> Int{
        return stats.filter{s in return s.player == 0 && s.to == 1}.count
    }
    func getReceivesPerPoint() -> [Float]{
        //numero de recepciones entre numero de puntos ganados en rece
        let total = stats.filter{s in return s.stage == 1 && s.server == 0 && s.to != 0}.count
        let won = stats.filter{s in return s.server == 0 && s.to == 1 && s.stage == 1}.count
        return [Float(total),Float(won)]
    }
    func getServesPerPoint() -> [Float]{
        //numero de saques entre puntos ganados despues del saque
        let total = stats.filter{s in return s.server != 0 && s.stage == 0 && s.to != 0}.count
        let won = stats.filter{s in return s.server != 0 && s.to == 1 && s.stage == 0 && s.player != 0}.count
        return [Float(total),Float(won)]
    }
    func getBests()->Dictionary<String,Player?>{
        var b: Dictionary<String,Player?> = [
            "attack": nil,
            "serve":nil,
            "block":nil,
            "receive":nil,
            "mvp":nil
        ]
        if !stats.isEmpty{
             b = Match.find(id: stats.first!.match)!.getBests()
            
        }
        return b
    }
}







