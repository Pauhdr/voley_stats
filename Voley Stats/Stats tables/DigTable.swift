import SwiftUI

struct DigTable: View {
    let labels: [String] = ["total", "err"]
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
                let stat = getTotal(stats: stats, player: player)
                let total = stat.count
                //                let dig = stat.filter{s in return s.action==5}.count
                let errors = getErrors(stats: stat, player: player)
                if total != 0 {
                    HStack {
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        //                    Text("\(dig)")
                        Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                        //                    Text("\((kills/stat.count)*100)")
                    }.foregroundColor(.white).padding(3)
                }
            }
        }.frame(maxWidth: .infinity)
        
    }
    @ViewBuilder
    func BarView() -> some View {
        let total = stats.filter{s in return actions.contains(s.action)}
        let errors = total.filter{s in return [23, 25].contains(s.action)}
        
        if historical {
            let data = [
                "atts":Dictionary(grouping: total, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "err":Dictionary(grouping: errors, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"})
            ]
//            BarChart(title: "", historicalData: data, filters: labels, historical: true)
        }else{
            let data = [
                "atts": total,
                "err": errors
            ]
//            BarChart(title: "", data: data, filters: labels, labels: players)
        }
    }
    func getTotal(stats: [Stat], player: Player) -> [Stat] {
        return stats.filter{s in return s.player == player.id && actions.contains(s.action)}
    }
    func getErrors(stats: [Stat], player: Player) -> Int {
        return stats.filter{s in return [23, 25].contains(s.action)}.count
    }
}
