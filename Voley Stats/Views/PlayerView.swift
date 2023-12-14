import SwiftUI
import UIPilot

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    init(viewModel: PlayerViewModel) {
        self.viewModel = viewModel
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        VStack {
            HStack{
                Text("PDF").onTapGesture{
                    viewModel.generateReport.toggle()
                }.padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule())
                NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: Team.find(id: viewModel.player.team), player: viewModel.player))){
                    Image(systemName: "square.and.pencil")
                }.padding(.vertical,10).padding(.horizontal, 20).background(.white.opacity(0.1)).clipShape(Capsule())
            }.frame(maxWidth: .infinity, alignment: .trailing)
            Section{
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
                        Text("coming.soon".trad())
                    }.padding().frame(maxWidth: .infinity, maxHeight: 300).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                }.frame(maxWidth: .infinity)
            }.padding()
//            Section(){
                
            VStack{
                ZStack(alignment: .top){
                    Text("player.measures".trad()).font(.title2).padding()//.frame(maxHeight: .infinity, alignment: .top)
                    VStack{
                        HStack{
                            Image(systemName: viewModel.addMeasure ? "multiply" : "plus").padding(10).padding(.horizontal).background(viewModel.addMeasure ? Color.clear : .white.opacity(0.1)).clipShape(Capsule())
                                .onTapGesture {
                                    withAnimation{
                                        viewModel.addMeasure.toggle()
                                    }
                                }
                        }.frame(maxWidth: .infinity, alignment: .trailing)
                        if viewModel.addMeasure{
                            PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player, measures: viewModel.selectedMeasure), measureAdded: $viewModel.addMeasure).onDisappear{
                                viewModel.measurements = viewModel.player.measurements()
                            }
                        }
                    }.padding().background(viewModel.addMeasure ? .white.opacity(0.1) : Color.clear ).clipShape(RoundedRectangle(cornerRadius: 15))
                }
//                    NavigationLink(destination: PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player))){
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
//                            Image(systemName: "plus")
//                        }.foregroundColor(.white).frame(height: 60).padding(.bottom)
//                    }
                if !viewModel.addMeasure{
                    ScrollView{
                        ForEach(viewModel.measurements, id:\.id){measures in
                            VStack{
                                ZStack{
                                    Text("\(viewModel.df.string(from: measures.date))").font(.title3.weight(.bold)).padding().frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
//                                            NavigationLink(destination: PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player, measures: measures))){
                                        Image(systemName: "square.and.pencil").onTapGesture{
                                            viewModel.selectedMeasure = measures
                                            viewModel.addMeasure.toggle()
                                        }
//                                            }
                                        Image(systemName: "trash.fill").foregroundStyle(.red).onTapGesture{
                                            if measures.delete(){
                                                viewModel.measurements = viewModel.player.measurements()
                                            }
                                        }
                                    }.frame(maxWidth: .infinity, alignment: .trailing)
                                        
                                }
                                Text("height".trad()+": \(measures.height) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("weight".trad()+": \(String(format: "%.1f", measures.weight)) kg").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("breadth".trad()+": \(measures.breadth) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("one.hand.reach".trad()+": \(measures.oneHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("two.hand.reach".trad()+": \(measures.twoHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("attack.reach".trad()+": \(measures.attackReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("block.reach".trad()+": \(measures.blockReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("attack.jump".trad()+": \(measures.attackReach - measures.oneHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("block.jump".trad()+": \(measures.blockReach - measures.twoHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                            }.padding().frame(maxWidth: .infinity, alignment: .leading).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                        }
                    }
                }
            
            }.padding().frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationTitle("player.data".trad())
        .quickLookPreview($viewModel.report)
        .overlay(viewModel.generateReport ? reportModal() : nil)
        .padding()
            .background(Color.swatch.dark.high)
            .foregroundColor(.white)
            .frame(maxHeight: .infinity)
            
            
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
            Text("pick.date.range".trad().uppercased()).font(.caption).foregroundStyle(.gray).frame(maxWidth: .infinity, alignment: .leading).padding([.horizontal, .top])
            HStack{
                VStack{
                    Text("start.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading)
                    DatePicker("start.date".trad(), selection: $viewModel.startDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
                VStack{
                    Text("end.date".trad().uppercased()).font(.caption)//.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    DatePicker("end.date".trad(), selection: $viewModel.endDate, in: ...Date.now, displayedComponents: .date).labelsHidden()
                }.frame(maxWidth: .infinity, alignment: .center).padding(.horizontal)
            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal)
            Text("add.feedback".trad().uppercased()).font(.caption).foregroundStyle(.gray).padding([.top, .horizontal]).frame(maxWidth: .infinity, alignment: .leading)
            ZStack{
                TextEditor(text: $viewModel.feedBack).customBackground(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 15)).padding(.horizontal)
                if viewModel.feedBack == ""{
                    Text("add.feedback".trad()).foregroundStyle(.gray).frame(maxHeight: .infinity, alignment: .top).frame(maxWidth: .infinity, alignment: .leading).padding().padding()
                }
            }
            Text("generate".trad()).frame(maxWidth: .infinity).padding().background(.cyan).clipShape(RoundedRectangle(cornerRadius: 15)).padding().onTapGesture{
                UserDefaults.standard.set(viewModel.reportLang, forKey: "locale")
                viewModel.report = PDF().playerReport(player: viewModel.player, startDate: viewModel.startDate, endDate: viewModel.endDate, feedBack: viewModel.feedBack).generate()
                viewModel.generateReport.toggle()
                UserDefaults.standard.set(viewModel.lang, forKey: "locale")
            }
        }.padding().background(.black).clipShape(RoundedRectangle(cornerRadius: 15)).padding().foregroundStyle(.white)
    }
}
class PlayerViewModel: ObservableObject{
    @Published var measurements: [PlayerMeasures]
    @Published var addMeasure: Bool = false
    @Published var selectedMeasure:PlayerMeasures? = nil
    @Published var report: URL? = nil
    @Published var feedBack: String = ""
    @Published var generateReport: Bool = false
    @Published var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? .now
    @Published var endDate: Date = .now
    @Published var reportLang:String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    var lang:String = UserDefaults.standard.string(forKey: "locale") ?? "en"
    var player: Player
    let df = DateFormatter()
    
    init(player: Player){
        self.player = player
        measurements = player.measurements()
        df.dateFormat = "dd/MM/yyyy"
        self.measurements = self.player.measurements()
    }
}


