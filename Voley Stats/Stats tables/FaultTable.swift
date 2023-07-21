import SwiftUI
struct FaultTable: View {
    let labels: [String] = ["player".trad(),"total","net".trad(), "ball.handling".trad(), "out.rotation".trad(), "under".trad()]
    let actions: [Int]
    let players: [Player]
    let stats: [Stat]
    let historical: Bool
    var body: some View {
        VStack {
            HStack {
                ForEach(labels, id: \.self){label in
                    Text(label).bold().frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding(3)
            ForEach(players, id:\.id){player in
                let stat = stats.filter{s in return s.player == player.id && actions.contains(s.action)}
                if stat.count > 0{
                    HStack {
                        Text("\(player.name)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==28}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==29}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==33}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==30}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        //                    Text("\((kills/stat.count)*100)")
                    }.foregroundColor(.white).padding(3)
                }
            }
        }
//        BarView()
    }
    @ViewBuilder
    func BarView() -> some View {
        let total = stats.filter{s in return actions.contains(s.action) && s.player != 0}
        let net = total.filter{s in return s.action==28}
        let bh = total.filter{s in return s.action==29}
        let or = total.filter{s in return s.action==33}
        let under = total.filter{s in return s.action==30}
        if historical {
            let data = [
                "atts":Dictionary(grouping: total, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "net":Dictionary(grouping: net, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "ball handling":Dictionary(grouping: bh, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "out of rotation":Dictionary(grouping: or, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"}),
                "under": Dictionary(grouping: under, by: { "Set \(Set.find(id:$0.set)?.number ?? 0)"})
            ]
//            BarChart(title: "", historicalData: data, filters: labels, historical: true)
        }else{
            let data = [
                "atts": total,
                "net": net,
                "ball handling":bh,
                "out of rotation":or,
                "under":under
            ]
//            BarChart(title: "", data: data, filters: labels, labels: players)
        }
    }
}
