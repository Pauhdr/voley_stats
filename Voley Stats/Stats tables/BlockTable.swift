import SwiftUI

struct BlockTable: View {
    let labels: [String] = ["total","blocks".trad(), "err"]
    let actions: [Int]
    let players: [Player]
    let stats: [Stat]
    let historical: Bool
    @State var isChart: Bool = true
    @State var filter: String = "atts"
    var body: some View {
        VStack{
//            Toggle(isOn: $isChart, label: {
//                Text("See chart")
//            })
            if isChart {
                ChartView()
            }else{
                BarView()
//                BarView()
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
                let blocks = getBlocks(stats: stat, player: player)
                let errors = getErrors(stats: stat, player: player)
                if total != 0 {
                    HStack {
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(blocks)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                        //                    Text("\((kills/stat.count)*100)")
                    }.foregroundColor(.white).padding(3)
                }
            }
        }
    }
    @ViewBuilder
    func BarView() -> some View {
        let total = stats.filter{s in return actions.contains(s.action)}
        let blocks = total.filter{s in return s.action==13}
        let errors = total.filter{s in return [20,31].contains(s.action)}
        
        if historical {
            let hData = [
                "atts": Dictionary(grouping: total, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "blocks": Dictionary(grouping: blocks, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "err": Dictionary(grouping: errors, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"})
            ]
//            BarChart(title: "", historicalData: hData, filters: labels, historical: true)
        }else{
            let data = [
                "atts": total,
                "blocks": blocks,
                "err": errors
            ]
            
//            BarChartView(data: ChartData(values: getData(stats: data[filter] ?? [], players: players)), title: "", style: Styles.barChartStyleOrangeLight, form: ChartForm.extraLarge, valueSpecifier: "%.0f" )
//            BarChart(title: "", data: data, filters: labels, labels: players)
        }
        Picker(selection: $filter, label: Text("Filter")) {
            ForEach(labels, id:\.self){f in
                Text(f).tag(f)
            }
        }.pickerStyle(.segmented)
    }
    func getData(stats: [Stat], players: [Player]) -> [(String, Int)] {
        var dataset:[(String, Int)] = []
        for player in players{
            let d = stats.filter{s in return s.player == player.id}.count
            if d != 0 {
                dataset.append((player.name, d))
            }
        }
        return dataset
//        return stats.filter{s in return s.player == player.id && actions.contains(s.action)}
    }
    func getTotal(stats: [Stat], player: Player) -> [Stat] {
        return stats.filter{s in return s.player == player.id && actions.contains(s.action)}
    }
    func getErrors(stats: [Stat], player: Player) -> Int {
        return stats.filter{s in return [20,31].contains(s.action)}.count
    }
    func getBlocks(stats: [Stat], player: Player) -> Int {
        return stats.filter{s in return s.action==13}.count
    }
}
