import SwiftUI

struct ServeTable: View {
    let labels: [String] = ["total", "err", "-", "+", "++", "aces", "%", "P-G" ]
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
                let stat = stats.filter{s in return s.server == player.id && s.stage == 0 && [8,12,15,32,39,40,41].contains(s.action)}
                let total = stats.filter{s in return s.server == player.id && s.stage == 0 && s.to != 0}.count
                let won = getWon(stat:stats, player:player)
                let pts = getTotals(stat: stat)
                if total != 0 {
                    HStack{
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(getErrors(stat:stat, player:player))").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.0)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.1)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.2)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(pts.3)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(String(format: "%.2f", pts.4))").frame(maxWidth: .infinity, alignment: .leading)
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
    func getTotals(stat: [Stat])->(Int, Int, Int, Int, Float){
        let s2 = stat.filter{s in return s.action==39}.count
        let s1 = stat.filter{s in return s.action==40}.count
        let op = stat.filter{s in return s.action==41}.count
        let s3 = stat.filter{s in return s.action==8}.count
        let total = stat.count
        let mk = total > 0 ? Float(op/2 + s1 + 2*s2 + 3*s3)/Float(total) : 0
        return (op, s1, s2, s3, mk)
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
