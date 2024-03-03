import SwiftUI
import Charts

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
                        HStack{
                            VStack{
                                Text("\(serve.filter{s in s.detail == "Net"}.count)").font(.headline)
                                Text("net".trad())
                            }.padding(.horizontal)
                            VStack{
                                Text("\(serve.filter{s in s.detail == "Out"}.count)").font(.headline)
                                Text("out".trad())
                            }.padding(.horizontal)
                        }
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
//                let receivePerc: Float = getReceivePerc()
//                let killPerc: Float = getKillPerc()
                VStack{
//                    CircleGraph(title: "\(String(format: "%.2f", receivePerc)) "+"receive.rating".trad(), percentage: receivePerc != 0 ? Double(receivePerc/3) : 0, color: .red, size: 120 )
                    Text("attack".trad().capitalized).font(.title).frame(maxWidth: .infinity, alignment: .center)
                    Divider().overlay(.gray)
                    Chart{
                        ForEach(getKillData(), id: \.self){data in
                            BarMark(x: .value("type", data["label"]!), y: .value("count", Int(data["value"]!)!))
                                .foregroundStyle(Color(hex: data["color"]!)!)
                                .annotation(position: .top, alignment: .top, spacing: 5){
                                    if (data["value"] != "0"){
                                        Text(data["value"]!).foregroundStyle(.white)
                                    }
                                }
                                .cornerRadius(8)
                        }
                    }.foregroundStyle(.white)
                        .chartYAxis(.hidden)
                        .chartXAxis{
                            AxisMarks{ val in
                                AxisValueLabel("\(val.as(String.self)!)".trad()).foregroundStyle(.white)
                            }
                        }
                        .padding()
                        
                }.padding()
                    .background(.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.horizontal)
                VStack{
//                    CircleGraph(title: "\(String(format: "%.2f", receivePerc)) "+"receive.rating".trad(), percentage: receivePerc != 0 ? Double(receivePerc/3) : 0, color: .red, size: 120 )
                    Text("receive".trad().capitalized).font(.title).frame(maxWidth: .infinity, alignment: .center)
                    Divider().overlay(.gray)
                    Chart{
                        ForEach(getReceiveData(), id: \.self){data in
                            BarMark(x: .value("type", data["type"]!), y: .value("count", Int(data["value"]!)!))
                                .foregroundStyle(Color(hex: data["color"]!)!)
//                                .foregroundStyle(by: .value("type", data["type"]!))
                                .annotation(position: .top, alignment: .top, spacing: 5){
                                    if (data["value"] != "0"){
                                        Text(data["value"]!).foregroundStyle(.white)
                                    }
                                }
                            
                                .cornerRadius(8)
                        }
                    }.foregroundStyle(.white)
                        .chartYAxis(.hidden)
                        .chartXAxis{
                            AxisMarks{ val in
                                AxisValueLabel("\(val.as(String.self)!)".trad()).foregroundStyle(.white)
                            }
                        }
                        .padding()
                        
                }.padding()
                    .background(.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(maxWidth: .infinity, alignment: .center)
//                    .padding(.horizontal)
//                HStack{
//                    CircleGraph(title: "kill.percentage".trad(), percentage:killPerc != 0 ? Double(killPerc) : 0, color:.red, size: 120)
//                }.frame(maxWidth: .infinity, alignment: .center)
            }.frame(maxWidth: .infinity, maxHeight: 200).padding()
            if bests {
                VStack{
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
                                }.padding(.horizontal)
                                Image(systemName: "crown.fill").frame(maxWidth: .infinity, alignment: .center)
                            }.padding()
                        }
                    }.foregroundColor(.yellow)
                }.padding(.top)
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
    func getKillData()->[Dictionary<String, String>]{
        let atts = stats.filter{s in return [6, 9, 10, 11, 16, 17, 18, 34].contains(s.action) && s.player != 0}.count
        let errs = stats.filter{s in return [16, 17, 18].contains(s.action) && s.player != 0}
        let kills = stats.filter{s in return [9, 10, 11].contains(s.action) && s.player != 0}.count
//        print(atts, errs, kills)
        return [
            [
                "type": "total",
                "value": atts.description,
                "label":"total",
                "color": Color.gray.toHex() ?? "ffffff"
            ],
            [
                "type": "kills",
                "value": kills.description,
                "label":"kills",
                "color": Color.green.toHex() ?? "ffffff"
            ],
            [
                "type": "error",
                "value": errs.filter{s in s.detail == "Blocked"}.count.description,
                "label":"blocked",
                "color": Color.yellow.toHex() ?? "ffffff"
            ],
            [
                "type": "error",
                "value": errs.filter{s in s.detail == "Out"}.count.description,
                "label":"out",
                "color": Color.orange.toHex() ?? "ffffff"
            ],
            [
                "type": "error",
                "value": errs.filter{s in s.detail == "Net"}.count.description,
                "label":"net",
                "color": Color.red.toHex() ?? "ffffff"
            ],
            
        ]
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
    func getReceiveData() -> [Dictionary<String, String>]{
        let stat = stats.filter{s in return actionsByType["receive"]?.contains(s.action) ?? false && s.player != 0}
        
        let total = stat.count
        let s1 = stat.filter{s in return s.action==2}.count
        let s2 = stat.filter{s in return s.action==3}.count
        let s3 = stat.filter{s in return s.action==4}.count
        let errors = stat.filter{s in return s.action==22}.count
//        let p = Float(s1 + 2*s2 + 3*s3)/Float(total)
        return [
            [
                "type": "total",
                "value": total.description,
                "label":"total",
                "color": Color.gray.toHex() ?? "ffffff"
            ],
            [
                "type": "error",
                "value": errors.description,
                "label":"error",
                "color": Color.red.toHex() ?? "ffffff"
            ],
            [
                "type": "-",
                "value": s1.description,
                "label":"receive",
                "color": Color.yellow.toHex() ?? "ffffff"
            ],
            [
                "type": "+",
                "value": s2.description,
                "label":"receive",
                "color": Color.orange.toHex() ?? "ffffff"
            ],
            [
                "type": "#",
                "value": s3.description,
                "label":"receive",
                "color": Color.green.toHex() ?? "ffffff"
            ]
        ]
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







