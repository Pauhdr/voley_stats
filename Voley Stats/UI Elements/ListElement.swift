import SwiftUI

struct ListElement: View{
    var team: Team
    var match: Match
    @ObservedObject var viewModel: ListTeamsModel
    @State var exportStats:Bool = false
    @State var clicked: Bool = false
    @State var deleting: Bool = false
    @State var activeRoot:Bool = false
    
//    @State var reportLang: Bool = false
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
                            Circle().fill(.white).frame(maxWidth: 60, maxHeight: 60)
                            if s.first_serve != 0{
                                NavigationLink(destination: AnyView(StatsView(viewModel: StatsViewModel(pilot: viewModel.appPilot, team: team, match: match, set: s))))
                                {
                                    
                                    Text("\(s.score_us)-\(s.score_them)").foregroundColor(.black).font(.custom("", size: 11))
                                }.environmentObject(viewModel.sessionManager)
                            }else{
                                
                                NavigationLink(destination: AnyView(SetData(viewModel: SetDataModel(pilot: viewModel.appPilot, team: team, match: match, set: s))))
                                {
                                    
                                    Image(systemName: "arrowtriangle.right.circle").foregroundColor(.black).font(.headline)
                                    
                                    
                                }.environmentObject(viewModel.sessionManager)
                            }
                        }.frame(maxWidth: 60, maxHeight: 60)
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
                                    viewModel.reportLang.toggle()
//                                    viewModel.statsFile = PDF().statsReport(team:team, match: match).generate()
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
//        .overlay(reportLang ? langChooseModal() : nil)
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
