import SwiftUI

struct TeamCard: View{
    
    var team: Team
    var deleteTap: ()->()
    @State var deleteDialog: Bool = false
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 15, style: .continuous).fill(team.color)
                .overlay(Image("Voleibol")
                    .opacity(0.4).scaleEffect(0.08).offset(x: 110, y: 70))
            
                
            VStack(alignment: .leading){
                VStack{
                    Text("\(team.name)").font(.title.smallCaps())
//                    Text("\(team.orgnization)").font(.caption)
                }.padding()
                VStack(spacing: 15){
                    HStack{
                        Image(systemName: "person.3.fill")
                        Text("\(team.players().count) "+"players".trad())
                    }
                    HStack{
                        Image("Match").resizable().aspectRatio(1, contentMode: .fit)
                        Text("\(team.matches().count) "+"matches".trad())
                    }
                }.padding().frame(alignment: .bottom)
            }.frame(maxWidth: .infinity, alignment: .leading).padding()
            
        }
        .clipped()
        .frame(width: 300, height: 200)
        .overlay(Image(systemName: "multiply").onTapGesture {
            deleteTap()
        }.padding(), alignment: .topTrailing)
        
        .padding()
        
        
    }
}

//struct TeamCard_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("no preview")
////        TeamCard(name:"alevin femenino", players: 11, matches: 6, color: .orange)
//    }
//}
