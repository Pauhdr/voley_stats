import SwiftUI

struct SetTable: View {
    let labels: [String] = ["player".trad(), "total", "err"]
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
                var stat = stats.filter{s in return s.player == player.id && actions.contains(s.action)} + stats.filter{s in return s.setter?.id ?? 0 == player.id && actionsByType["attack"]!.contains(s.action)}
                
                //                let kills = stat.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
                let errors = stat.filter{s in return s.action==24}.count
                if (stat.count != 0){
                    HStack {
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                        //maybe add points won and lost with each setter
                    }.foregroundColor(.white).padding(3)
                }
            }
            var stat = stats.filter{s in return s.player != 0 && actions.contains(s.action)} + stats.filter{s in return s.setter?.id ?? 0 != 0 && actionsByType["attack"]!.contains(s.action)}
            
            //                let kills = stat.filter{s in return [9, 10, 11, 12].contains(s.action)}.count
            let errors = stat.filter{s in return s.action==24}.count
            if (stat.count != 0){
                HStack {
                    Text("total".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(stat.count)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(errors)").frame(maxWidth: .infinity, alignment: .leading)
                    //maybe add points won and lost with each setter
                }.foregroundColor(.white).padding(3)
            }
        }
    }
}
