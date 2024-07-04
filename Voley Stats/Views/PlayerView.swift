import SwiftUI

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    @State var fetched : Bool
    @State var data:[(String, Float)] = []
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        self.fetched = false
        UITextView.appearance().backgroundColor = .clear
        
    }
    var body: some View {
        VStack {
            HStack{
                Text("PDF").foregroundStyle(self.fetched ? .white : .gray).onTapGesture{
                    if self.fetched{
                        viewModel.generateReport.toggle()
                        viewModel.playerData = viewModel.player.report()
                    }
                }.padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule())
                NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: Team.find(id: viewModel.player.team), player: viewModel.player))){
                    Image(systemName: "square.and.pencil")
                }.padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule())
            }.frame(maxWidth: .infinity, alignment: .trailing)
            HStack{
                    VStack{
                        ZStack{
                            Image(systemName: "tshirt").font(.system(size: 120))
                            Text("\(viewModel.player.number)").font(.system(size: 40))
                            
                        }
                        Text(viewModel.player.name).font(.system(size: 30))
                        Text(viewModel.player.position.rawValue.trad())
                    }.padding().frame(maxWidth: .infinity, maxHeight: 300).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                    VStack{
//                        if self.fetched{
//                            ForEach(viewModel.player.report(), id: \.key){data in
//                                VStack{
//                                    Text(data.key)
//                                    ZStack{
//                                        RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
//                                        RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.5)).frame(width: (1.3*300)/3)
//                                    }.frame(width: 300, height: 25)
//                                }
//                            }
//                        }else{
//                            Text("coming.soon".trad())
//                        }
//
                        if self.fetched{
                            
                            RadarChartView(maxValue: 3, dataPoints: $data, size: 300)
                        } else{
                            VStack{
                                ProgressView().tint(.white)
                                Text("LOADING...").font(.caption).padding()
                            }.frame(maxHeight: .infinity)
                        }
//                        else{
//                            Text("coming.soon".trad())
////                            ProgressView().tint(.cyan).onTapGesture(perform: {
////                                print("tap")
////                                viewModel.fetched.toggle()})
//                        }
                        
                    }.padding().frame(maxWidth: .infinity, maxHeight: 300).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                }.frame(maxWidth: .infinity).padding()
//            Section(){
                
            VStack{
                ZStack(alignment: .top){
                    Text("player.measures".trad()).font(.title2).padding()//.frame(maxHeight: .infinity, alignment: .top)
                    VStack{
                        HStack{
                            if !viewModel.addMeasure && !viewModel.measurements.isEmpty{
                                Image(systemName: "square.and.pencil").padding(10).padding(.horizontal).background(.white.opacity(0.1)).clipShape(Capsule()).onTapGesture{
                                    viewModel.selectedMeasure = viewModel.measurements.first
                                    viewModel.addMeasure.toggle()
                                }
                            }
                            Image(systemName: viewModel.addMeasure ? "multiply" : "plus").padding(10).padding(.horizontal).background(viewModel.addMeasure ? Color.clear : .white.opacity(0.1)).clipShape(Capsule())
                                .onTapGesture {
                                    withAnimation{
                                        viewModel.addMeasure.toggle()
                                    }
                                }
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                        if viewModel.addMeasure{
                            ScrollView{
                                PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player, measures: viewModel.selectedMeasure), measureAdded: $viewModel.addMeasure).onDisappear{
                                    viewModel.measurements = viewModel.player.measurements()
                                }
                            }
                        }
                    }.padding().background(viewModel.addMeasure ? .white.opacity(0.1) : Color.clear ).clipShape(RoundedRectangle(cornerRadius: 15))
                }//.ignoresSafeArea(.keyboard, edges: .bottom)
//                    NavigationLink(destination: PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player))){
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
//                            Image(systemName: "plus")
//                        }.foregroundColor(.white).frame(height: 60).padding(.bottom)
//                    }
                if !viewModel.addMeasure{
                    VStack{
                        HStack{
                            VStack{
                                Text("height".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("height").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text("\(viewModel.measurements.first?.height.description ?? "-") cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack{
                                Text("weight".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("weight").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text("\(viewModel.measurements.first?.weight != nil ? String(format: "%.2f", viewModel.measurements.first?.weight ?? 0) : "-") kg")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack{
                                Text("breadth".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("breadth").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text("\(viewModel.measurements.first?.breadth.description ?? "-") cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        HStack{
                            VStack{
                                Text("one.hand.reach".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("oneHand").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text("\(viewModel.measurements.first?.oneHandReach.description ?? "-") cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack{
                                Text("attack.reach".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("attackReach").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text("\(viewModel.measurements.first?.attackReach.description ?? "-") cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack{
                                Text("attack.jump".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("attackJump").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text(viewModel.measurements.first != nil ? "\(viewModel.measurements.first!.attackReach - viewModel.measurements.first!.oneHandReach ) cm" : "- cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        HStack{
                            VStack{
                                Text("two.hand.reach".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("twoHand").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text("\(viewModel.measurements.first?.twoHandReach.description ?? "-") cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack{
                                Text("block.reach".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("blockReach").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text("\(viewModel.measurements.first?.blockReach.description ?? "-") cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack{
                                Text("block.jump".trad()).font(.headline.bold())
                                Divider().overlay(.gray)
                                Image("blockJump").resizable().scaledToFit().frame(maxWidth: .infinity)
                                Text(viewModel.measurements.first != nil ? "\(viewModel.measurements.first!.blockReach - viewModel.measurements.first!.twoHandReach ) cm" : "- cm")
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
//                    ScrollView{
//                        ForEach(viewModel.measurements, id:\.id){measures in
//                            VStack{
//                                ZStack{
//                                    Text("\(viewModel.df.string(from: measures.date))").font(.title3.weight(.bold)).padding().frame(maxWidth: .infinity, alignment: .leading)
//                                    HStack{
////                                            NavigationLink(destination: PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player, measures: measures))){
//                                        Image(systemName: "square.and.pencil").onTapGesture{
//                                            viewModel.selectedMeasure = measures
//                                            viewModel.addMeasure.toggle()
//                                        }
////                                            }
//                                        Image(systemName: "trash.fill").foregroundStyle(.red).onTapGesture{
//                                            if measures.delete(){
//                                                viewModel.measurements = viewModel.player.measurements()
//                                            }
//                                        }
//                                    }.frame(maxWidth: .infinity, alignment: .trailing)
//                                        
//                                }
//                                
//                                Text("height".trad()+": \(measures.height) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("weight".trad()+": \(String(format: "%.1f", measures.weight)) kg").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("breadth".trad()+": \(measures.breadth) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("one.hand.reach".trad()+": \(measures.oneHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("two.hand.reach".trad()+": \(measures.twoHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("attack.reach".trad()+": \(measures.attackReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("block.reach".trad()+": \(measures.blockReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("attack.jump".trad()+": \(measures.attackReach - measures.oneHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                                Text("block.jump".trad()+": \(measures.blockReach - measures.twoHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
//                            }.padding().frame(maxWidth: .infinity, alignment: .leading).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
//                        }
//                    }
                }
            
            }.padding().frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("player.data".trad())
        .quickLookPreview($viewModel.report)
        .overlay(viewModel.generateReport ? reportModal() : nil)
        .padding()
            .background(Color.swatch.dark.high)
            .foregroundColor(.white)
//            .frame(maxHeight: .infinity)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.playerData = viewModel.player.report()
                    self.data = viewModel.playerData.filter{$0.key != "general"}.map{ ($0.key, $0.value["mark"]!)}.sorted(by: {$0.0 > $1.0})
//                    print(viewModel.radarData)
                    self.fetched = true
                }
//                print(rd)
                
                
//                print(viewModel.radarData)
                
            }
            
            
    }
    
    @ViewBuilder
    func reportModal() -> some View{
        VStack{
            ZStack{
                HStack{
                    Image(systemName: "multiply").font(.title2).onTapGesture {
                        viewModel.generateReport.toggle()
                    }.padding()
                }.frame(maxWidth: .infinity, alignment: .trailing)
                Text("customize.report".trad()).font(.title2)
            }
            Spacer()
            Text("languaje".trad().uppercased()).font(.caption).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
            HStack{
                VStack{
                    Text("spanish".trad().uppercased())
                }.frame(maxWidth: .infinity, alignment: .center).padding().background(viewModel.reportLang == "es" ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).onTapGesture {
                    viewModel.reportLang = "es"
                }
                VStack{
                    Text("english".trad().uppercased())
                }.frame(maxWidth: .infinity, alignment: .center).padding().background(viewModel.reportLang == "en" ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).onTapGesture {
                    viewModel.reportLang = "en"
                }
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal)
            Spacer()
            Text("pick.data.source".trad().uppercased()).font(.caption).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
            VStack{
                Picker("data.range", selection: $viewModel.dataRange){
                    Text("all".trad()).tag(2)
                    Text("league".trad()).tag(0)
                    Text("tournament".trad()).tag(1)
                    Text("date.range".trad()).tag(3)
                    Text("match".trad()).tag(4)
                }.pickerStyle(.segmented).padding()
                if (viewModel.dataRange == 3){
                    HStack{
                        VStack{
                            Text("start.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading)
                            DatePicker("start.date".trad(), selection: $viewModel.startDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                        }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                        VStack{
                            Text("end.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                            DatePicker("end.date".trad(), selection: $viewModel.endDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                        }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                    }
                }
                if (viewModel.dataRange == 1){
                    HStack{
                        Text("tournament".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Picker("data.tournament", selection: $viewModel.tournament){
                            Text("pick.one".trad()).tag(0)
                            ForEach(viewModel.team.tournaments(), id: \.id){tournament in
                                Text(tournament.name).tag(tournament.id)
                            }
                            
                        }
                    }.padding()
                }
                if (viewModel.dataRange == 4){
                    HStack{
                        Text("match".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Picker("data.match", selection: $viewModel.match){
                            Text("pick.one".trad()).tag(0)
                            ForEach(viewModel.team.matches(), id: \.id){match in
                                Text("\(match.opponent) (\( match.getDate() ))").tag(match.id)
                            }
                        }
                    }.padding()
                }
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal)
            Spacer()
//            Text("stats".trad().uppercased()).font(.caption).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
//            ScrollView{
//                VStack{
//                    //                HStack{
//                    VStack{
//                        HStack{
//                            Text("serve".trad()).frame(maxWidth: .infinity, alignment: .leading)
//                            Text("\(String(format: "%.2f", viewModel.playerData["serve"]!["mark"]!))")
//                        }
//                        HStack{
//                            VStack{
//                                Text("total".trad())
//                                Text("\(Int(viewModel.playerData["serve"]!["total"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("ace.short".trad())
//                                Text("\(Int(viewModel.playerData["serve"]!["ace"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("++".trad())
//                                Text("\(Int(viewModel.playerData["serve"]!["++"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("-".trad())
//                                Text("\(Int(viewModel.playerData["serve"]!["-"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("error".trad())
//                                Text("\(Int(viewModel.playerData["serve"]!["error"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                        }
//                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                    VStack{
//                        HStack{
//                            Text("receive".trad()).frame(maxWidth: .infinity, alignment: .leading)
//                            Text("\(String(format: "%.2f", viewModel.playerData["receive"]!["mark"]!))")
//                        }
//                        HStack{
//                            VStack{
//                                Text("total".trad())
//                                Text("\(Int(viewModel.playerData["receive"]!["total"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("++".trad())
//                                Text("\(Int(viewModel.playerData["receive"]!["++"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("+".trad())
//                                Text("\(Int(viewModel.playerData["receive"]!["+"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("-".trad())
//                                Text("\(Int(viewModel.playerData["receive"]!["-"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("error".trad())
//                                Text("\(Int(viewModel.playerData["receive"]!["error"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                        }
//                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                    //                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                    //                HStack{
//                    VStack{
//                        HStack{
//                            Text("attack".trad()).frame(maxWidth: .infinity, alignment: .leading)
//                            Text("\(String(format: "%.2f", viewModel.playerData["attack"]!["mark"]!))")
//                        }
//                        HStack{
//                            VStack{
//                                Text("total".trad())
//                                Text("\(Int(viewModel.playerData["attack"]!["total"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("kill".trad())
//                                Text("\(Int(viewModel.playerData["attack"]!["kill"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("block".trad())
//                                Text("\(Int(viewModel.playerData["attack"]!["block"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("error".trad())
//                                Text("\(Int(viewModel.playerData["attack"]!["error"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                        }
//                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                    VStack{
//                        HStack{
//                            Text("block".trad()).frame(maxWidth: .infinity, alignment: .leading)
//                            Text("\(String(format: "%.2f",viewModel.playerData["block"]!["mark"]! ))")
//                        }
//                        HStack{
//                            VStack{
//                                Text("total".trad())
//                                Text("\(Int(viewModel.playerData["block"]!["total"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("point".trad())
//                                Text("\(Int(viewModel.playerData["block"]!["points"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("error".trad())
//                                Text("\(Int(viewModel.playerData["block"]!["error"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                        }
//                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                    VStack{
//                        HStack{
//                            Text("dig".trad()).frame(maxWidth: .infinity, alignment: .leading)
//                            Text("\(String(format: "%.2f", viewModel.playerData["dig"]!["mark"]!))")
//                        }
//                        HStack{
//                            VStack{
//                                Text("total".trad())
//                                Text("\(Int(viewModel.playerData["dig"]!["total"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                            VStack{
//                                Text("error".trad())
//                                Text("\(Int(viewModel.playerData["dig"]!["error"]!))")
//                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                        }
//                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                    //                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15))
//                }
//            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal)
            Text("sections".trad().uppercased()).font(.caption).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
            HStack{
                VStack{
                    Image(systemName: "lines.measurement.vertical").font(.largeTitle).foregroundStyle(!viewModel.showMeasures ? .cyan : .white).padding()
                    Text("player.measures".trad())
                }.padding().background(viewModel.showMeasures ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal).onTapGesture {
                    viewModel.showMeasures.toggle()
                }
                VStack{
                    Image(systemName: "text.bubble").font(.largeTitle).foregroundStyle(!viewModel.addFeedback ? .cyan : .white).padding()
                    Text("feedback".trad())
                }.padding().background(viewModel.addFeedback ? .cyan : .white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal).onTapGesture {
                    withAnimation(.easeInOut){
                        viewModel.addFeedback.toggle()
                    }
                }
            }.padding().frame(maxWidth: .infinity, alignment: .leading).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal)
            if (viewModel.addFeedback){
                Text("add.feedback".trad().uppercased()).font(.caption).foregroundStyle(.gray).padding([.top, .horizontal]).frame(maxWidth: .infinity, alignment: .leading)
                ZStack{
                    TextEditor(text: $viewModel.feedBack).customBackground(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal)
                    if viewModel.feedBack == ""{
                        Text("add.feedback".trad()).foregroundStyle(.gray).frame(maxHeight: .infinity, alignment: .top).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal).padding()
                    }
                }
            }
            Spacer()
            ZStack{
                RoundedRectangle(cornerRadius: 15).fill(.cyan)
                if viewModel.loading{
                    ProgressView().tint(.white)
                }else{
                    Text("generate".trad())
                }
            }.clipped().padding()
            .frame(maxWidth: .infinity, maxHeight: 100).padding().onTapGesture{
                viewModel.loading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UserDefaults.standard.set(viewModel.reportLang, forKey: "locale")
                    //                viewModel.report = PDF().playerReport(player: viewModel.player, data: viewModel.playerData, startDate: viewModel.startDate, endDate: viewModel.endDate, feedBack: viewModel.feedBack).generate()
                    
                    var sections:[ReportSections] = []
                    if viewModel.addFeedback{
                        sections.append(ReportSections.feedback)
                    }
                    if viewModel.showMeasures{
                        sections.append(ReportSections.playerMeasures)
                    }
                    var match = Match.find(id: viewModel.match)
                    if match != nil{
                        viewModel.startDate = match!.date
                        viewModel.endDate = match!.date
                    }
                    var tournament = Tournament.find(id: viewModel.tournament)
                    if tournament != nil{
                        viewModel.startDate = tournament!.startDate
                        viewModel.endDate = tournament!.endDate
                    }
                    var dateRange = viewModel.dataRange == 3 ? (viewModel.startDate, viewModel.endDate) : nil
                    viewModel.report = Report(player: viewModel.player, data: viewModel.player.report(match: match, tournament: tournament, dateRange: dateRange), startDate: viewModel.startDate, endDate: viewModel.endDate, feedback: viewModel.feedBack, sections: sections).generate()
                    
                    viewModel.loading = false
                    UserDefaults.standard.set(viewModel.lang, forKey: "locale")
                    viewModel.generateReport.toggle()
                }
            }
        }.padding(3).background(.black).clipShape(RoundedRectangle(cornerRadius: 15)).foregroundStyle(.white)
    }
}
class PlayerViewModel: ObservableObject{
    @Published var measurements: [PlayerMeasures]=[]
    @Published var addMeasure: Bool = false
    @Published var selectedMeasure:PlayerMeasures? = nil
    @Published var report: URL? = nil
    @Published var feedBack: String = ""
    @Published var generateReport: Bool = false
    @Published var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? .now
    @Published var endDate: Date = .now
    @Published var reportLang:String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    @Published var dataRange: Int = 0
    @Published var match: Int = 0
    @Published var tournament: Int = 0
    @Published var addFeedback: Bool = false
    @Published var showMeasures: Bool = false
    @Published var loading: Bool = false
    var lang:String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    var player: Player
    let team: Team
    @Published var playerData: Dictionary<String,Dictionary<String,Float>> = [:]
    @Published var radarData: [(String, Float)] = []
    @Published var fetched: Bool = false
    let df = DateFormatter()
    
    init(player: Player){
        self.player = player
        df.dateFormat = "dd/MM/yyyy"
        self.measurements = self.player.measurements()
        self.team = Team.find(id: player.team)!
//        self.playerData=[:]
//        self.radarData=[]
//        self.playerData = self.player.report()
    }
}


