import SwiftUI

struct SetTable: View {
    let labels: [String] = ["player".trad(),"err"]
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
                //                let kills = stat.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
                let errors = stat.filter{s in return s.action==24}.count
                if (errors != 0){
                    HStack {
                        Text("\(player.name)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                    }.foregroundColor(.white).padding(3)
                }
            }
        }
    }
}
