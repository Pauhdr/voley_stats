import SwiftUI

struct ServeTable: View {
    let labels: [String] = ["total", "err", "aces".trad(), "P-G" ]
    let actions: [Int]
    let players: [Player]
    let stats: [Stat]
    let historical: Bool
    @State var isChart: Bool = true
    var body: some View {
        VStack{
//            Toggle(isOn: $isChart, label: {
//                Text("See chart")
//            })
            if isChart {
                ChartView()
            }else{
                BarView()
            }
        }
        
    }
    @ViewBuilder
    func ChartView() -> some View {
        VStack {
            HStack {
                ForEach(["player".trad()]+labels, id: \.self){label in
                    Text(label).bold().frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding(3)
            ForEach(players, id:\.id){player in
                let stat = stats.filter{s in return s.server == player.id && s.stage == 0 && s.to != 0}
                let total = stat.count
                let won = getWon(stat:stats, player:player)
                if total != 0 {
                    HStack{
                        Text("\(player.name)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(getErrors(stat:stat, player:player))").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(getAces(stat:stat, player:player))").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(won)").frame(maxWidth: .infinity, alignment: .leading)
//                        Text("\(total == 0 ? 0 : (Float(won)/Float(total))*100)").frame(maxWidth: .infinity, alignment: .leading)
                    }.foregroundColor(.white).padding(3)
                }
            }
            
        }
    }
    func getAces(stat: [Stat], player: Player) -> Int{
        return stat.filter{s in return s.action==8}.count
    }
    func getErrors(stat: [Stat], player: Player) -> Int{
        return stat.filter{s in return [15, 32].contains(s.action)}.count
    }
    func getWon(stat: [Stat], player: Player) -> Int{
        return stats.filter{s in return s.server == player.id && Action.find(id: s.action)?.type ?? 0 == 1}.count
    }
    
    @ViewBuilder
    func BarView() -> some View {
        let total = stats.filter{s in return s.server != 0 && s.to != 0}
        let error = total.filter{s in return [15, 32].contains(s.action)}
        let earned = total.filter{s in return s.action==8}
        let pg = total.filter{s in return Action.find(id: s.action)?.type ?? 0 == 1}
        if historical {
            let data = [
                "atts":Dictionary(grouping: total, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "err":Dictionary(grouping: error, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "aces":Dictionary(grouping: earned, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "P-G":Dictionary(grouping: pg, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"})
            ]
//            BarChart(title: "", historicalData: data, filters: labels, historical: true)
        }else{
            let data = [
                "atts":total,
                "err":error,
                "aces":earned,
                "P-G":pg
            ]
//            BarChart(title: "", data: data, filters: labels, labels: players)
        }
    }
}
