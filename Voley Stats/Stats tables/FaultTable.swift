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
                        Text("\(player.name)").fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==28}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==29}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==33}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(stat.filter{s in return s.action==30}.count)").frame(maxWidth: .infinity, alignment: .leading)
                        //                    Text("\((kills/stat.count)*100)")
                    }.foregroundColor(.white).padding(3)
                }
            }
            let stat = stats.filter{s in return s.player != 0 && actions.contains(s.action)}
            if stat.count > 0{
                HStack {
                    Text("total".trad()).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(stat.count)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(stat.filter{s in return s.action==28}.count)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(stat.filter{s in return s.action==29}.count)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(stat.filter{s in return s.action==33}.count)").frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(stat.filter{s in return s.action==30}.count)").frame(maxWidth: .infinity, alignment: .leading)
                    //                    Text("\((kills/stat.count)*100)")
                }.foregroundColor(.white).padding(3)
            }
        }
//        BarView()
    }
}
