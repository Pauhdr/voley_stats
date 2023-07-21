import SwiftUI
import UIPilot

struct TrainStats: View {
    @ObservedObject var viewModel: TrainStatsModel
    @Namespace var animation
    var body: some View {
        
        VStack {
//            Text("train.stats".trad()).font(.title.bold())
            HStack{
                TabButton(selection: $viewModel.tab, title: "day".trad(), animation: animation, action:{})
                TabButton(selection: $viewModel.tab, title: "month".trad(), animation: animation, action:{})
            }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 7)).padding()
            HStack{
                Picker(selection: $viewModel.date, label: Text("stats.date".trad())) {
                    Text("all".trad()).tag("")
                    ForEach(viewModel.dates, id:\.self){d in
                        let f = viewModel.tab == "day".trad() ? viewModel.df.string(from: d) : viewModel.mf.string(from: d)
                        Text("\(f)").tag(f)
                    }
                }
                //                .pickerStyle(.wheel)
                //                .background(.black)
                //                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                Button(action:{
                    viewModel.getStatsImproves()
                    viewModel.getQnImproves()
                }){
                    Text("apply".trad())
                }.frame(maxWidth: .infinity, alignment: .center)
            }
//            ZStack{
                //dropdown for days in improves or months
            ScrollView{
                VStack{
                    Text("areas.to.improve".trad()).font(.title2.weight(.semibold)).padding()
                    ForEach(Array(viewModel.qnData.sorted{$0.1 > $1.1}.map{$0.0}), id:\.self){area in
                        let data = viewModel.qnData[area]!
                        HStack{
                            Text("\(area.trad().capitalized)")
                            Text("\(data)").frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.init(top: 3, leading: 30, bottom: 3, trailing: 30)).font(.title2)
                    }
                    HStack{}.padding()
                }.background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))).frame(maxWidth: .infinity, alignment: .leading).padding()
                    .onTapGesture {
                        viewModel.showQn()
                    }
                VStack{
                    Text("stats.by.area".trad()).font(.title2.weight(.semibold))
                
                    LazyVGrid(columns:[GridItem(.adaptive(minimum: 250))], spacing: 20){
                        ForEach(Array(viewModel.chartsData.keys.sorted()), id:\.self){area in
                            let data = viewModel.chartsData[area]!
                            VStack{
                                PieChart(title: area.trad().capitalized, total: data["total"]!, error: data["error"]!, earned: data["earned"]!, size: 175, action:{
                                    viewModel.area = area
                                    viewModel.showByPlayer.toggle()
                                })
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                if viewModel.tab == "month".trad(){
                    VStack{
                        Text("month.bests".trad()).font(.title).padding()
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                                VStack{
                                    
                                    Text("serve".trad()).font(.title)
                                    //                                Text("\(bests["serve"]??.name ?? "None")")
                                }.padding()
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                                VStack{
                                    Text("receive".trad()).font(.title)
                                    //                                Text("\(bests["receive"]!?.name ?? "None")")
                                }.padding()
                            }
                        }.foregroundColor(.yellow)
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                                VStack{
                                    Text("attack".trad()).font(.title)
                                    //                                Text("\(bests["attack"]!?.name ?? "None")")
                                }.padding()
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.black.opacity(0.3))
                                VStack{
                                    Text("block".trad()).font(.title)
                                    //                                Text("\(bests["block"]!?.name ?? "None")")
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
                                        //                                    Text("\(bests["mvp"]!?.name ?? "None")")
                                    }.padding()
                                    Image(systemName: "crown.fill").frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                        }.foregroundColor(.yellow)
                    }.padding()
                }
            }.frame(maxWidth: .infinity, alignment: .center)
        }
        
        .background(Color.swatch.dark.high)
        .foregroundColor(.white)
        .frame(maxHeight:.infinity, alignment:.top)
        .navigationTitle("train.stats".trad())
        .onAppear{
            viewModel.getDates()
        }.sheet(isPresented: $viewModel.showByPlayer){
            areaInsights()
        }
        
        //#-learning-task(createDetailView)
    }
    
    @ViewBuilder
    func areaInsights()->some View{
        VStack{
            Button(action:{
                viewModel.showByPlayer.toggle()
                viewModel.area = ""
            }){
                Image(systemName: "multiply").font(.title2)
            }.frame(maxWidth: .infinity, alignment: .trailing).padding()
            
            Text("\(viewModel.area.trad().capitalized)").font(.title)
            
                ScrollView{
                    LazyVGrid(columns:[GridItem(.adaptive(minimum: 250))], spacing: 20){
                    ForEach(viewModel.team.players(), id:\.id){player in
                        let data = viewModel.actionsData(data: viewModel.actions, player: player)[viewModel.area]!
                        PieChart(title: player.name, total: data["total"]!, error: data["error"]!, earned: data["earned"]!, size: 125, action: {})
                    }
                }
            }
        }.background(.black.opacity(0.9)).foregroundColor(.white)
//            .frame(width:500, height: 350)
//            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}


class TrainStatsModel: ObservableObject{
    @Published var tab: String = "day".trad()
    @Published var dates: [Date]=[]
    @Published var date: String = ""
    var area: String = ""
    @Published var showByPlayer = false
    let df = DateFormatter()
    let mf = DateFormatter()
    var team: Team
    var statsImproves: [Improve] = []
    var countImproves: [Improve] = []
    var qnImproves: [Improve] = []
    private let appPilot: UIPilot<AppRoute>
    @Published var chartsData:Dictionary<String,Dictionary<String,Int>> = [:]
    @Published var qnData:Dictionary<String, Int> = [:]
    var actions: [(Player, Action)] = []
    
    init(pilot:UIPilot<AppRoute>, team: Team){
        self.appPilot=pilot
        self.team = team
        getStatsImproves()
        getQnImproves()
        df.dateFormat = "dd/MM/yyyy"
        mf.dateFormat = "MMMM yyyy"
    }
    func showModal()->Bool{
        return self.area != ""
    }
    func getCountImproves(){
        self.countImproves = Improve.countImproves(team: team, date: formatDate())
    }
    func getQnImproves(){
        self.qnImproves = Improve.qnImproves(team: team, date: formatDate())
        qns.keys.forEach{area in
            qnData[area] = qnImproves.filter{$0.area==area}.count
        }
    }
    func getDates(){
        self.dates = Improve.dates()
    }
    func showQn(){
        appPilot.push(.ShowQn(team: self.team))
    }
    func getStatsImproves(){
        self.statsImproves = Improve.statsImproves(team: self.team, date: formatDate())
        self.actions = self.statsImproves.map{($0.player, Action.find(id: Int($0.comment)!)!)}
        self.chartsData=actionsData(
            data: self.actions
        )
    }
    func formatDate()->Date?{
        if (date != ""){
            return tab == "Day" ? df.date(from: date) : mf.date(from: date)
//            return of.string(from: tmp!)
        }
        return nil
    }
    func actionsData(data: [(Player, Action)], player: Player? = nil)->Dictionary<String,Dictionary<String,Int>>{
        var actions = data
        if player != nil {
            actions = data.filter{$0.0.id == player?.id}
        }
        let serve = actions.filter{actionsByType["serve"]!.contains($0.1.id)}
        let receive = actions.filter{actionsByType["receive"]!.contains($0.1.id)}
        let block = actions.filter{actionsByType["block"]!.contains($0.1.id)}
        let dig = actions.filter{actionsByType["dig"]!.contains($0.1.id)}
        let set = actions.filter{actionsByType["set"]!.contains($0.1.id)}
        let attack = actions.filter{actionsByType["attack"]!.contains($0.1.id)}
        
        return [
            "block": [
                "total":block.count,
                "earned":block.filter{$0.1.type==1}.count,
                "error":block.filter{$0.1.type==2}.count
            ],
            "serve":[
                "total":serve.count,
                "earned":serve.filter{$0.1.type==1}.count,
                "error":serve.filter{$0.1.type==2}.count
            ],
            "dig":[
                "total":dig.count,
                "earned":dig.filter{$0.1.type==1}.count,
                "error":dig.filter{$0.1.type==2}.count
            ],
            "receive":[
                "total":receive.count,
                "earned":receive.filter{$0.1.id==4}.count,
                "error":receive.filter{$0.1.type==2}.count
            ],
            "attack":[
                "total":attack.count,
                "earned":attack.filter{$0.1.type==1}.count,
                "error":attack.filter{$0.1.type==2}.count
            ],
            "set": [
                "total":set.count,
                "earned":set.filter{$0.1.type==1}.count,
                "error":set.filter{$0.1.type==2}.count
            ],
        ]
    }
}
