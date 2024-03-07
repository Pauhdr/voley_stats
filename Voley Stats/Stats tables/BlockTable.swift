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
                let blocks = getBlocks(stats: stat)
                let errors = getErrors(stats: stat)
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
            let stat = getTotal(stats: stats)
            let total = stat.count
            let blocks = getBlocks(stats: stat)
            let errors = getErrors(stats: stat)
            if total != 0 {
                HStack {
                    Text("total".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(blocks)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                    //                    Text("\((kills/stat.count)*100)")
                }.foregroundColor(.white).padding(3)
            }
        }
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
    func getTotal(stats: [Stat], player: Player? = nil) -> [Stat] {
        if player != nil {
            return stats.filter{s in return s.player == player!.id && actions.contains(s.action)}
        } else {
            return stats.filter{s in return s.player != 0 && actions.contains(s.action)}
        }
    }
    func getErrors(stats: [Stat]) -> Int {
        return stats.filter{s in return [20,31].contains(s.action)}.count
    }
    func getBlocks(stats: [Stat]) -> Int {
        return stats.filter{s in return s.action==13}.count
    }
}
