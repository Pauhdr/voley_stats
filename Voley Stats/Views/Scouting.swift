import SwiftUI
import UIPilot

struct Scouting: View {
    @ObservedObject var viewModel: ScoutingModel
    var sq: CGFloat = 90
    let statb = RoundedRectangle(cornerRadius: 10.0, style: .continuous)
    var body: some View {
        VStack{
//            HStack {
//                ZStack{
//                    VStack (spacing: 5){
//                        Text("rotation".trad()).font(.body)
//                        if (viewModel.rotation.filter{$0 != .zero}.count==4){
//                            VStack{
//                                ZStack{
//                                    statb.fill(.gray)
//                                    Text("\(viewModel.rotation[2])")
//                                }
//                                HStack {
//                                    ZStack{
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[3])")
//                                    }
//                                    ZStack{
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[1])")
//                                    }
//                                }
//                                ZStack {
//                                    statb.fill(.gray)
//                                    Text("\(viewModel.rotation[0])")
//                                }
//                            }
//                        } else {
//                            VStack {
//                                HStack{
//                                    ZStack {
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[3])")
//                                    }
//                                    ZStack {
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[2])")
//                                    }
//                                    ZStack {
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[1])")
//                                    }
//                                    
//                                }
//                                HStack{
//                                    ZStack {
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[4])")
//                                    }
//                                    ZStack {
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[5])")
//                                    }
//                                    ZStack {
//                                        statb.fill(.gray)
//                                        Text("\(viewModel.rotation[0])")
//                                    }
//                                    
//                                }
//                            }
//                        }
//                    }
//                }.onTapGesture {
//                    viewModel.showRotation.toggle()
//                }
//                ZStack{
//                    statb.fill(.gray)
//                    Text("rotate".trad())
//                }.clipped().onTapGesture {
//                    viewModel.rotate()
//                }
//                
//                ZStack{
//                    statb.fill(.pink)
//                    Text("clear".trad()).foregroundColor(.white)
//                    
//                }.clipped().onTapGesture {
//                    
//                }
//                ZStack{
//                    statb.fill(.pink)
//                    Text("undo".trad()).foregroundColor(.white)
//                    
//                }.clipped().onTapGesture {
//                    viewModel.undo()
//                }
//                ZStack{
//                    statb.fill(.gray)
//                    Text(viewModel.showStats ? "capture".trad() : "show.stats".trad()).foregroundColor(.white)
//                    
//                }.clipped().onTapGesture {
//                    viewModel.showStats.toggle()
//                }
//                
//            }.frame(maxHeight: sq).padding(.horizontal)
//            HStack{
//                ForEach(viewModel.showStats ? viewModel.scout.getPlayers() : viewModel.lineup(), id:\.self){p in
//                    if p != 0 {
//                        ZStack{
//                            statb.stroke(viewModel.player == p ? .white : .clear, lineWidth: 7).background(statb.fill(.blue))
//                            Text("#\(p)").foregroundColor(.white)
//                        }.onTapGesture {
//                            
//                            if viewModel.player != p{
//                                viewModel.player = p
//                            }else{
//                                viewModel.player = 0
//                            }
//        //                        showChange.toggle()
//                        }
//                    }
//                }
//            }.frame(maxHeight: sq).padding()
//            HStack{
//                VStack{
//                    ZStack{
//                        statb.stroke(viewModel.area == "attack" ? .white : .clear, lineWidth: 7).background(statb.fill(.gray))
//                        Text("attack".trad().capitalized).foregroundColor(.white)
//                    }.onTapGesture {
//                        viewModel.area = "attack"
//                    }
////                    ZStack{
////                        statb.stroke(viewModel.area == "dig" ? .white : .clear, lineWidth: 7).background(statb.fill(.gray))
////                        Text("dig".trad().capitalized).foregroundColor(.white)
////                    }.onTapGesture {
////                        viewModel.area = "dig"
////                    }
//                    ZStack{
//                        statb.stroke(viewModel.area == "block" ? .white : .clear, lineWidth: 7).background(statb.fill(.gray))
//                        Text("block".trad().capitalized).foregroundColor(.white)
//                    }.onTapGesture {
//                        viewModel.area = "block"
//                    }
//                    ZStack{
//                        statb.stroke(viewModel.area == "serve" ? .white : .clear, lineWidth: 7).background(statb.fill(.gray))
//                        Text("serve".trad().capitalized).foregroundColor(.white)
//                    }.onTapGesture {
//                        viewModel.area = "serve"
//                    }
//                    ZStack{
//                        statb.stroke(viewModel.area == "receive" ? .white : .clear, lineWidth: 7).background(statb.fill(.gray))
//                        Text("receive".trad().capitalized).foregroundColor(.white)
//                    }.onTapGesture {
//                        viewModel.area = "receive"
//                    }
//                    
//                }.frame(width: 100).padding()
//                VStack{
//                    if viewModel.area == "attack"{
//                        
//                        AttackScouting(viewModel: AttackScoutingModel(team: viewModel.team, scout: viewModel.scout, rotation: viewModel.rotation, player: viewModel.player, showStats: viewModel.showStats, flip: $viewModel.flip))
//                        
//                    } else if viewModel.area == "serve"{
//                        ServeScouting(viewModel: ServeScoutingModel(team: viewModel.team, scout: viewModel.scout, player: viewModel.player, rotation: viewModel.rotation, showStats: viewModel.showStats, flip: $viewModel.flip))
//                        
//                    }else if viewModel.area == "dig"{
//                        DigScouting(viewModel: DigScoutingModel(team: viewModel.team, scout: viewModel.scout, rotation: viewModel.rotation, player: viewModel.player, showStats: viewModel.showStats, flip: $viewModel.flip))
//                        
//                    }else if viewModel.area == "receive"{
//                        ReceiveScouting(viewModel: ReceiveScoutingModel(team: viewModel.team, scout: viewModel.scout, rotation: viewModel.rotation, player: viewModel.player, showStats: viewModel.showStats, flip: $viewModel.flip))
//                        
//                    }else if viewModel.area == "block"{
//                        VStack{
//                            if viewModel.showStats {
//                                let blocks = viewModel.getBlocks()
//                                ZStack{
//                                    statb.fill(.gray)
//                                    Text("blocks".trad() + " \(blocks.count)").foregroundColor(.white)
//                                }
//                                ZStack{
//                                    statb.fill(.red)
//                                    Text("errors".trad() + " \(blocks.filter{$0.difficulty == 5}.count)").foregroundColor(.white)
//                                }
//                                ZStack{
//                                    statb.fill(.green)
//                                    Text("earned".trad() + " \(blocks.filter{$0.difficulty == 0}.count)").foregroundColor(.white)
//                                }
//                            }else{
//                                ZStack{
//                                    statb.fill(.green)
//                                    Text("earned".trad()).foregroundColor(.white)
//                                }.onTapGesture {
//                                    viewModel.saveScout(action: "block", difficulty: 0)
//                                }
//                                ZStack{
//                                    statb.fill(.red)
//                                    Text("error".trad()).foregroundColor(.white)
//                                }.onTapGesture {
//                                    viewModel.saveScout(action: "block", difficulty: 5)
//                                }
//                                ZStack{
//                                    statb.fill(.gray)
//                                    Text("block.in.play".trad()).foregroundColor(.white)
//                                }.onTapGesture {
//                                    viewModel.saveScout(action: "block", difficulty: 2)
//                                }
//                            }
//                        }.padding()
//                    }
//                }
////                ScoutingCourt(viewModel: ScoutingCourtModel(team: viewModel.team, scout: viewModel.scout, rotation: viewModel.rotation, action: viewModel.area, showStats: viewModel.showStats))
//            }.frame(maxWidth: .infinity, alignment: .leading)

        }
        .overlay(viewModel.exportScout ? exportModal() : nil)
        .sheet(isPresented: $viewModel.showRotation){
            VStack{
//                HStack{
//                    Button(action:{
//                        viewModel.showRotation.toggle()
//                        
//                    }){
//                        Image(systemName: "multiply").font(.title2)
//                    }
//                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
//                
//                
//                
//                ZStack{
//                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white.opacity(0.1))
//                    VStack{
//                        Text("modify.rotation".trad()).font(.title).padding()
//                        Spacer()
//                        ForEach(0..<viewModel.n_players, id:\.self){index in
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white.opacity(0.1))
//                                HStack{
//                                    Text("\(index+1):").font(.body).frame(maxWidth: .infinity, alignment: .leading)
//                                    TextField("\(index+1):", value: $viewModel.rotation[index], format: .number).textFieldStyle(TextFieldDark()).keyboardType(.numberPad)
//                                }.padding()
//                            }.frame(maxHeight: 70).padding()
//                        }
//                        Button(action:{
//                            viewModel.rotate()
//                        }){
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 3)
//                                HStack{
//                                    Text("rotate".trad()).font(.body).foregroundColor(.white)
//                                    Image(systemName: "arrow.triangle.2.circlepath")
//                                }
//                            }
//                        }.frame(height: 50).padding()
//                        Spacer()
//                    }
//                }.padding()
//                Spacer()
//                ZStack{
//                    statb.fill(.blue)
//                    Text("save".trad()).foregroundColor(.white).font(.body)
//                    
//                }.clipped().onTapGesture {
//                    viewModel.updateRotation()
//                    viewModel.showRotation.toggle()
//                }.frame(maxHeight: 100).padding()
//                Spacer()
            }.padding().background(Color.swatch.dark.high).frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $viewModel.showInfo){
            VStack{
//                HStack{
//                    Button(action:{
//                        viewModel.showInfo.toggle()
//                        
//                    }){
//                        Image(systemName: "multiply").font(.title2)
//                    }
//                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
//                Text("useful.info".trad()).font(.title).padding()
//                let info = viewModel.scout.teamInfo()
//                ScrollView{
//                    VStack{
//                        HStack{
//                            Text("initial.rotation".trad()).frame(maxWidth: .infinity, alignment: .leading)
//                            VStack (spacing: 5){
//                                if (viewModel.scout.rotation.filter{$0 != .zero}.count==4){
//                                    VStack{
//                                        ZStack{
//                                            statb.fill(.orange)
//                                            Text("\(viewModel.scout.rotation[2])")
//                                        }
//                                        HStack {
//                                            ZStack{
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[3])")
//                                            }
//                                            ZStack{
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[1])")
//                                            }
//                                        }
//                                        ZStack {
//                                            statb.fill(.orange)
//                                            Text("\(viewModel.scout.rotation[0])")
//                                        }
//                                    }
//                                } else {
//                                    VStack {
//                                        HStack{
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[3])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[2])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[1])")
//                                            }
//                                            
//                                        }
//                                        HStack{
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[4])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[5])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(viewModel.scout.rotation[0])")
//                                            }
//                                            
//                                        }
//                                    }
//                                }
//                            }.frame(maxHeight:90)
//                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
//                        playerRanks()
////                        HStack{
////                            Text("best.attack".trad())
////                            Text("#\(info["bestAtk"]?.0 ?? 0) (\(info["bestAtk"]?.1 ?? 0))").frame(maxWidth: .infinity, alignment: .trailing)
////                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
////                        HStack{
////                            Text("worst.attack".trad())
////                            Text("#\(info["worstAtk"]?.0 ?? 0) (\(info["worstAtk"]?.1 ?? 0))").frame(maxWidth: .infinity, alignment: .trailing)
////                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
////                        HStack{
////                            Text("best.receiver".trad())
////                            Text("#\(info["bestRcv"]?.0 ?? 0) (\(info["bestRcv"]?.1 ?? 0))").frame(maxWidth: .infinity, alignment: .trailing)
////                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
////                        HStack{
////                            Text("worst.receiver".trad())
////                            Text("#\(info["worstRcv"]?.0 ?? 0) (\(info["worstRcv"]?.1 ?? 0))").frame(maxWidth: .infinity, alignment: .trailing)
////                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
////                        HStack{
////                            Text("best.block".trad())
////                            Text("#\(info["blocker"]?.0 ?? 0) (\(info["blocker"]?.1 ?? 0))").frame(maxWidth: .infinity, alignment: .trailing)
////                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
////                        HStack{
////                            Text("best.serve".trad())
////                            Text("#\(info["server"]?.0 ?? 0) (\(info["server"]?.1 ?? 0))").frame(maxWidth: .infinity, alignment: .trailing)
////                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
//                        let bestRot = viewModel.scout.bestRotation()
//                        let rotStats = viewModel.scout.rotationStats(rotation: bestRot.0)
//                        VStack{
//                            Text("best.rotation.stats".trad()).font(.title2)
//                            HStack{
//                                if (bestRot.0.filter{$0 != .zero}.count==4){
//                                    VStack{
//                                        ZStack{
//                                            statb.fill(.orange)
//                                            Text("\(bestRot.0[2])")
//                                        }
//                                        HStack {
//                                            ZStack{
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[3])")
//                                            }
//                                            ZStack{
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[1])")
//                                            }
//                                        }
//                                        ZStack {
//                                            statb.fill(.orange)
//                                            Text("\(bestRot.0[0])")
//                                        }
//                                    }
//                                } else {
//                                    VStack {
//                                        HStack{
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[3])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[2])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[1])")
//                                            }
//                                            
//                                        }
//                                        HStack{
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[4])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[5])")
//                                            }
//                                            ZStack {
//                                                statb.fill(.orange)
//                                                Text("\(bestRot.0[0])")
//                                            }
//                                            
//                                        }
//                                    }
//                                }
//                                VStack{
//                                    Text("total.points".trad()+": \(bestRot.1)").font(.headline).padding()
//                                    ForEach(Array(rotStats.keys.sorted(by: {$0 < $1})), id:\.self){player in
//                                        VStack{
//                                            Text("player #\(player):")
//                                            ForEach(0..<rotStats[player]!.count, id:\.self){i in
//                                                let action = rotStats[player]![i]
//                                                Text("\(action.0.trad().capitalized): \(action.1)")
//                                            }
//                                        }.padding()
//                                        
//                                    }
//                                }.frame(maxWidth:.infinity, alignment: .leading).frame(maxHeight:.infinity, alignment: .top)
//                            }
//                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
//                            .frame(minHeight:375)
//                        VStack{
//                            Text("comments".trad()).font(.headline)
//                            ForEach(viewModel.scout.comments(), id:\.id){s in
//                                Text("\(s.comment)").frame(maxWidth: .infinity, alignment: .leading).padding(3)
//                            }
//                            if !viewModel.showStats{
//                                HStack{
//                                    ZStack{
//                                        TextField("write.a.comment.max.55".trad(), text: $viewModel.comment.max(55)).textFieldStyle(TextFieldDark())
//                                        if viewModel.comment.isEmpty {
////                                            Text("write.a.comment.max.55".trad()).font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
//                                        }
//                                    }
//                                    
//                                    Button(action:{
//                                        viewModel.saveScout(action: "comment")
//                                    }){
//                                        Image(systemName: "plus")
//                                    }
//                                    .frame(width: 40, height: 40).background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
//                                    .foregroundColor(.cyan)
//                                    .disabled(viewModel.comment.isEmpty)
//                                }.padding(.vertical)
//                            }
//                        }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
//                    }.padding()
//                }
            }.frame(maxHeight: .infinity, alignment: .top).background(Color.swatch.dark.high).foregroundColor(.white)
        }
//        .overlay(viewModel.exportScout ? exportModal() : nil)
        .background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("scouting".trad()+" "+viewModel.scout.teamName)
            .toolbar{
                ToolbarItem(placement: .primaryAction) {
                    HStack{
                        Button(action:{
                            viewModel.showInfo.toggle()
                        }){
                            Image(systemName: "info.circle").font(.title2)
                        }.padding(.trailing)
                        Button(action:{
                            viewModel.exportScout.toggle()
                        }){
                            Text("PDF")
                        }.padding(.trailing)
                            .quickLookPreview($viewModel.scoutFile)
                    }.foregroundColor(.white)
                }
            }
    }
    
    @ViewBuilder
    func exportModal() -> some View {
            VStack{
                HStack{
                    Button(action:{
                        viewModel.exportScout.toggle()
                    }){
                        Image(systemName: "multiply").font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .trailing).padding([.top, .trailing])
                Text("report.type".trad()).font(.title2).padding([.bottom, .horizontal])
                HStack{
                    ZStack{
                        statb.fill(.blue)
                        Text("full.report".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.scoutFile = PDF().fullScoutingReport(scout: viewModel.scout).generate()
                    }
                    ZStack{
                        statb.fill(.pink)
                        Text("general.report".trad()).foregroundColor(.white).padding(5)
                    }.clipped().onTapGesture {
                        viewModel.scoutFile = PDF().scoutingReport(scout: viewModel.scout).generate()
                    }
                    
                }.padding()
            }
            .background(.black.opacity(0.9))
            .frame(width:500, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    @ViewBuilder
    func playerRanks()->some View {
        let info = viewModel.scout.playersRank()
        VStack{
            CollapsibleListElement(title: "attack".trad().capitalized){
                VStack{
                    HStack{
                        Text("player".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Text("tot").frame(maxWidth: .infinity, alignment: .center)
                        Text("err").frame(maxWidth: .infinity, alignment: .center)
                        Text("pts").frame(maxWidth: .infinity, alignment: .center)
                    }
                    ForEach(1..<info["attack"]!.count){p in
                        let player = info["attack"]![p]
                        HStack{
                            Text("#\(player.0)").frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(player.2)").frame(maxWidth: .infinity, alignment: .center)
                            Text("\(player.3)").frame(maxWidth: .infinity, alignment: .center)
                            Text("\(player.4)").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
//                            ForEach(info["bestAtk"]!, id:\.0){p in
//                                HStack{
//                                    Text("#\(p.0)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.2)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.3)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.4)").frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                            }
            }
            CollapsibleListElement(title: "serve".trad().capitalized){
                VStack{
                    HStack{
                        Text("player".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Text("tot").frame(maxWidth: .infinity, alignment: .center)
                        Text("err").frame(maxWidth: .infinity, alignment: .center)
                        Text("pts").frame(maxWidth: .infinity, alignment: .center)
                    }
                    ForEach(1..<info["serve"]!.count){p in
                        let player = info["serve"]![p]
                        HStack{
                            Text("#\(player.0)").frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(player.2)").frame(maxWidth: .infinity, alignment: .center)
                            Text("\(player.3)").frame(maxWidth: .infinity, alignment: .center)
                            Text("\(player.4)").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
//                            ForEach(info["bestAtk"]!, id:\.0){p in
//                                HStack{
//                                    Text("#\(p.0)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.2)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.3)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.4)").frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                            }
            }
            CollapsibleListElement(title: "block".trad().capitalized){
                VStack{
                    HStack{
                        Text("player".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Text("tot").frame(maxWidth: .infinity, alignment: .center)
                        Text("err").frame(maxWidth: .infinity, alignment: .center)
                        Text("pts").frame(maxWidth: .infinity, alignment: .center)
                    }
                    ForEach(1..<info["block"]!.count){p in
                        let player = info["block"]![p]
                        HStack{
                            Text("#\(player.0)").frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(player.2)").frame(maxWidth: .infinity, alignment: .center)
                            Text("\(player.3)").frame(maxWidth: .infinity, alignment: .center)
                            Text("\(player.4)").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
//                            ForEach(info["bestAtk"]!, id:\.0){p in
//                                HStack{
//                                    Text("#\(p.0)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.2)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.3)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.4)").frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                            }
            }
            CollapsibleListElement(title: "receive".trad().capitalized){
                VStack{
                    HStack{
                        Text("player".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Text("tot").frame(maxWidth: .infinity, alignment: .center)
                        Text("err").frame(maxWidth: .infinity, alignment: .center)
                    }
                    ForEach(1..<info["receive"]!.count){p in
                        let player = info["receive"]![p]
                        HStack{
                            Text("#\(player.0)").frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(player.2)").frame(maxWidth: .infinity, alignment: .center)
                            Text("\(player.3)").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
//                            ForEach(info["bestAtk"]!, id:\.0){p in
//                                HStack{
//                                    Text("#\(p.0)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.2)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.3)").frame(maxWidth: .infinity, alignment: .leading)
//                                    Text("\(p.4)").frame(maxWidth: .infinity, alignment: .leading)
//                                }
//                            }
            }
        }
    }
}

class ScoutingModel: ObservableObject{
    @Published var player: Int = 0
    @Published var showRotation:Bool = false
    @Published var rotation: Array<Int> = [.zero, .zero, .zero, .zero, .zero, .zero]
    @Published var showStats: Bool = false
    @Published var showInfo: Bool = false
    @Published var exportScout: Bool = false
    @Published var comment: String = ""
    @Published var area:String = ""
    @Published var scoutFile: URL? = nil
    @Published var flip: Bool = false
    var team: Team
    var scout:Scout
    var n_players: Int = 6
    
    init(team: Team, scout:Scout){
        self.team = team
        self.scout = scout
        self.rotation = team.scouts().last?.rotation ??  scout.rotation
        self.showRotation = self.rotation.allSatisfy({$0 == .zero})
        self.n_players = ["Benjamin", "Alevin"].contains(team.category) ? 4 : 6
    }
    func updateRotation(){
        if self.scout.rotation.allSatisfy({$0 == .zero}){
            self.scout.rotation = self.rotation
            self.scout.update()
        }
    }
    func rotate(){
        let tmp = rotation[0]
        for index in 1..<self.n_players{
            rotation[index - 1] = rotation[index]
        }
        rotation[self.n_players-1] = tmp
    }
    func saveScout(action: String, difficulty: Int = 0){
        if player != 0 || (action == "comment" && comment != ""){
            let sc = Scout(teamName: scout.teamName, teamRelated: team, player: self.player, rotation: self.rotation, action: action, difficulty: difficulty, from: 0, to: 0, date: Date(), comment: comment)
            let newScout = Scout.create(scout: sc)
            if newScout != nil {
                player = 0
                comment=""
            }
        }
    }
    func lineup() -> [Int]{
        return self.rotation.filter{$0 > 0}.sorted(by: { $0 < $1 })
    }
    func undo(){
        var scouts = Scout.teamScouts(teamName: self.scout.teamName, related: self.team)
        scouts.last?.delete()
    }
    func getBlocks() -> [Scout]{
        if (player != 0){
            return Scout.teamScouts(teamName: scout.teamName, related: team).filter{$0.action == "block" && $0.player == player}
        }
        return Scout.teamScouts(teamName: scout.teamName, related: team).filter{$0.action == "block"}
    }
}



