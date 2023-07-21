import SwiftUI

struct ListElement: View{
    var team: Team
    var match: Match
    @ObservedObject var viewModel: ListTeamsModel
    @State var exportStats:Bool = false
    @State var clicked: Bool = false
    @State var deleting: Bool = false
    var action: () -> Void
    var body: some View{
        ZStack{
//            Capsule().fill(.white.opacity(0.1))
            RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
            HStack{
                if viewModel.selectMatches {
                    if viewModel.reportMatches.contains(match) {
                        Image(systemName: "checkmark.circle.fill").padding(.horizontal).font(.title2)
                    }else{
                        Image(systemName: "circle").padding(.horizontal).font(.title2)
                    }
                    
                }
                VStack(alignment: .leading){
                    Text("\(match.opponent)")
                    Text("\(match.location) @ \(match.getDate())").font(.caption).foregroundColor(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                HStack{
                    ForEach(match.sets(), id:\.id){s in
                        ZStack{
                            Circle().fill(.white)
//                            Button(action:{
//                                if (s.first_serve != 0){
//                                    viewModel.captureStats(team: team, match: match, set: s)
//                                }else{
//                                    viewModel.setupSet(team: team, match: match, set: s)
//                                }
//                            })
                            NavigationLink(destination: s.first_serve != 0 ? AnyView(StatsView(viewModel: StatsViewModel(pilot: viewModel.appPilot, team: team, match: match, set: s))) : AnyView(SetData(viewModel: SetDataModel(pilot: viewModel.appPilot, team: team, match: match, set: s))))
                            {
                                if (s.score_us == 0 && s.score_them == 0 && s.first_serve == 0){
                                    Image(systemName: "arrowtriangle.right.circle").foregroundColor(.black).font(.headline)
                                }else{
                                    Text("\(s.score_us)-\(s.score_them)").foregroundColor(.black).font(.custom("", size: 11))
                                }
                                
                            }
                        }.clipped()
                    }
                    
                }.frame(maxWidth: .infinity, alignment: .trailing)
                Image(systemName: "chevron.right").padding(.horizontal).onTapGesture {
                    action()
                    clicked.toggle()
                }.foregroundColor(Color.swatch.cyan.base)
            }
            .padding()
                .actionSheet(isPresented: $clicked) {
                    ActionSheet(
                        title: Text("match.vs".trad()+" \(match.opponent)"),
                        buttons: [
                            .default(Text("match.stats".trad())){
                                viewModel.appPilot.push(.MatchStats(team: team, match: match))
                            },
                                .default(Text("edit.match".trad())){
                                    viewModel.editMatch(team: team, match: match)
                                },
                                .default(Text("export.stats".trad())){
                                    viewModel.statsFile = PDF().statsReport(team:team, match: match).generate()
//                                    viewModel.export.toggle()
                                },
                            .destructive(Text("match.delete".trad())){
                                deleting.toggle()
                            },
                            .cancel(){}
                        ])
                }
                .confirmationDialog("match.delete.description".trad(), isPresented: $deleting, titleVisibility: .visible){
                    Button("match.delete".trad(), role: .destructive){
                        viewModel.deleteMatch(match: match)
                    }
                }
//                .quickLookPreview($viewModel.statsFile)
        }
        .onTapGesture {
            action()
            if !viewModel.selectMatches{
                clicked.toggle()
            }
        }
        .foregroundColor(.white)
        .frame(height: 60)
        .padding(10)
        
    }
}

//struct ListElement_Previews: PreviewProvider {
//    static var previews: some View {
////        ListElement()
//        Text("no preview")
//    }
//}
