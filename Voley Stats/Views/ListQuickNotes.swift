import SwiftUI
import UIPilot

struct ListQN: View {
    @ObservedObject var viewModel: ListQNModel
    var body: some View {
        VStack{
//            Text().font(.title.weight(.semibold))
            ScrollView{
                ForEach(viewModel.team.players(), id:\.id){player in
                    VStack(alignment: .leading){
                        Text(player.name).font(.title2.weight(.semibold))
                        let imp = viewModel.getPlayerImproves(player: player)
                        
                        ForEach(Array(actionsByType.keys), id:\.self){area in
                            
                            let areaImp = imp.filter{$0.area == area}
                            if (areaImp.count > 0){
                                VStack(alignment:.leading){
                                    Text(area).font(.title3)
//                                    VStack{
                                        ForEach(areaImp, id:\.id){improve in
                                        
                                            Text(improve.comment).foregroundColor(.gray)
                                        
                                        }
                                    //}.padding(.horizontal)
                                }.padding(.horizontal)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading).padding()
                }
            }.frame(maxHeight: .infinity, alignment: .top).frame(maxWidth: .infinity, alignment: .leading).padding()
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("areas.to.improve".trad())
    }
}
class ListQNModel: ObservableObject{
    
    private let appPilot: UIPilot<AppRoute>
    var team: Team
    
    init(pilot: UIPilot<AppRoute>, team: Team){
        self.appPilot=pilot
        self.team = team
    }
    
    func getPlayerImproves(player: Player)->[Improve]{
        let i = Improve.playerImproves(player: player, exercise: Exercise.find(id: 2), date: nil)
        return i
    }
    
    
}
