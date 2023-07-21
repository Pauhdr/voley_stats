import SwiftUI
struct DownBallTable: View {
    let labels: [String] = ["player".trad(),"total", "err", "-", "+", "++", "%"]
    let actions: [Int]
    let players: [Player]
    let stats: [Stat]
    let historical: Bool
    var body: some View {
        VStack{
            let stat = stats.filter{s in return actions.contains(s.action)}
            let total = stat.count
            ZStack{
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.gray)
                VStack{
                    Text("\(total)").font(.title)
                    Text("attempts".trad())
                }
            }
            HStack{
                
                let errors = stat.filter{s in return s.action==19}.count
                let earned = stat.filter{s in return s.action==12}.count
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.pink)
                    VStack{
                        Text("\(errors)").font(.title)
                        Text("errors".trad())
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.green)
                    VStack{
                        Text("\(earned)").font(.title)
                        Text("earned".trad())
                    }
                }
            }
        }
    }
}
