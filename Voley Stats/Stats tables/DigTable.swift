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
                let errors = getErrors(stats: stat)
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
            let stat = getTotal(stats: stats)
            let total = stat.count
            let errors = getErrors(stats: stat)
            if total != 0 {
                HStack {
                    Text("total".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                }.foregroundColor(.white).padding(3)
            }
        }.frame(maxWidth: .infinity)
        
    }
    func getTotal(stats: [Stat], player: Player? = nil) -> [Stat] {
        if player != nil {
            return stats.filter{s in return s.player == player!.id && actions.contains(s.action)}
        } else {
            return stats.filter{s in return s.player != 0 && actions.contains(s.action)}
        }
    }
    func getErrors(stats: [Stat]) -> Int {
        return stats.filter{s in return [23, 25].contains(s.action)}.count
    }
}
