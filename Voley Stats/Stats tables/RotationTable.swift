import SwiftUI

struct RotationTable: View {
    let labels: [String] = ["rotation".trad(),"side.out".trad(), "break.point".trad()]
    let match: Match
    let rotations: [Rotation]
    init(match: Match){
        self.match = match
        rotations = match.rotations()
    }
    
    var body: some View {
        VStack {
            HStack {
//                ForEach(labels, id: \.self){label in
//                    Text(label).bold().frame(maxWidth: .infinity, alignment: .leading)
//                }
                Text("rotation".trad()).bold().frame(maxWidth: .infinity, alignment: .leading)
                Text("side.out".trad()).bold().frame(width: 100)
                Text("break.point".trad()).bold().frame(width: 100)
            }.padding(3)
            ForEach(rotations, id:\.id){rotation in
                let rotationStats = match.rotationStats(rotation: rotation.id)
                HStack{
//                    Court(rotation: rotation.get(rotate: 0))
                    Text(rotation.description).frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(rotationStats.0)").frame(width: 100)
                    Text("\(rotationStats.1)").frame(width: 100)
                }.foregroundColor(.white).padding(3)
            }
        }
    }
}
