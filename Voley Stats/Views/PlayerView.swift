import SwiftUI
import UIPilot

struct PlayerView: View {
    @ObservedObject var viewModel: PlayerViewModel
    var body: some View {
        VStack {
            Section{
                HStack{
                    VStack{
                        ZStack{
                            Image(systemName: "tshirt").font(.system(size: 120))
                            Text("\(viewModel.player.number)").font(.system(size: 40))
                        }
                        Text(viewModel.player.name).font(.system(size: 30))
                    }.padding().frame(maxWidth: .infinity).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                    VStack{
                        Text("coming.soon".trad())
                    }.padding().frame(maxWidth: .infinity).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                }.frame(maxWidth: .infinity)
            }.padding()
            Section(){
                Text("player.measures".trad()).font(.title2)
                VStack{
                    NavigationLink(destination: PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player))){
                        ZStack{
                            RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(dash: [5]))
                            Image(systemName: "plus")
                        }.foregroundColor(.white).frame(height: 60).padding(.bottom)
                    }
                    
                    ScrollView{
                        ForEach(viewModel.measurements, id:\.id){measures in
                            VStack{
                                ZStack{
                                    Text("\(viewModel.df.string(from: measures.date))").font(.title.weight(.bold)).padding().frame(maxWidth: .infinity, alignment: .leading)
                                    NavigationLink(destination: PlayerMeasuresData(viewModel: PlayerMeasuresDataModel(player: viewModel.player, measures: measures)), label: {Label("", systemImage: "square.and.pencil").frame(maxWidth: .infinity, alignment: .trailing)})
                                }
                                Text("height".trad()+": \(measures.height) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("weight".trad()+": \(String(format: "%.1f", measures.weight)) kg").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("breadth".trad()+": \(measures.breadth) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("one.hand.reach".trad()+": \(measures.oneHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("two.hand.reach".trad()+": \(measures.twoHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("attack.reach".trad()+": \(measures.attackReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("block.reach".trad()+": \(measures.blockReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("attack.junp".trad()+": \(measures.attackReach - measures.oneHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                                Text("block.jump".trad()+": \(measures.blockReach - measures.twoHandReach) cm").padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                            }.padding().frame(maxWidth: .infinity, alignment: .leading).background(RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1)))
                        }
                    }
                }
                
            }.padding()
        }
        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: PlayerData(viewModel: PlayerDataModel(team: Team.find(id: viewModel.player.team), player: viewModel.player)), label: {Label("", systemImage: "square.and.pencil")})
            }
        }
        .onAppear{
            viewModel.measurements = viewModel.player.measurements()
        }
        .padding()
            .background(Color.swatch.dark.high)
            .navigationTitle("player.data".trad())
            .foregroundColor(.white)
            .frame(maxHeight: .infinity)
    }
}
class PlayerViewModel: ObservableObject{
    @Published var measurements: [PlayerMeasures]
    var player: Player
    let df = DateFormatter()
    
    init(player: Player){
        self.player = player
        measurements = player.measurements()
        df.dateFormat = "dd/MM/yyyy"
    }
}


