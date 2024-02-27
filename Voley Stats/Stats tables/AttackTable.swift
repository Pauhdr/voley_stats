import SwiftUI

struct AttackTable: View {
    let labels: [String] = ["total", "kills".trad(), "err", "kills".trad()+" %"]
    let actions: [Int]
    let players: [Player]
    let stats: [Stat]
    let historical: Bool
    @State var isChart: Bool = true
    var body: some View {
        VStack{
                ChartView()
        }
        
    }
    @ViewBuilder
    func ChartView() -> some View {
        VStack{
            HStack {
                ForEach(["player".trad()]+labels, id: \.self){label in
                    Text(label).bold().frame(maxWidth: .infinity, alignment: .leading)
                }
            }.padding(3)
            ForEach(players, id:\.id){player in
                let stat = stats.filter{s in return s.player == player.id && actions.contains(s.action)}
                let kills = stat.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
                let errors = stat.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
                let total = stat.count
                if total != 0{
                    HStack {
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(kills)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(total == 0 ? "0" : String(format: "%.2f", (Float(kills)/Float(total))*100))").frame(maxWidth: .infinity, alignment: .leading)
                    }.foregroundColor(.white).padding(3)
                }
            }
            let stat = stats.filter{s in return s.player != 0 && actions.contains(s.action)}
            let kills = stat.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
            let errors = stat.filter{s in return [16, 17, 18, 19].contains(s.action)}.count
            let total = stat.count
            HStack {
                Text("total".trad()).font(.body.bold()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                Text("\(total)").frame(maxWidth: .infinity, alignment: .leading)
                Text("\(kills)").frame(maxWidth: .infinity, alignment: .leading)
                Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                Text("\(total == 0 ? "0" : String(format: "%.2f", (Float(kills)/Float(total))*100))").frame(maxWidth: .infinity, alignment: .leading)
            }.foregroundColor(.white).padding(3)
        }
    }
}







