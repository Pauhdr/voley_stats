import SwiftUI
import UIPilot

struct StatsView: View {
    @ObservedObject var viewModel: StatsViewModel
//    @Binding var shouldPopToRoot: Bool
    @State var isDeep: Bool = true
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
            switch viewModel.selTab{
            case 1:
                AnyView(Capture(viewModel: CaptureModel(team: viewModel.team, match: viewModel.match, set: viewModel.set)))
            case 2:
                AnyView(SetStats(viewModel: SetStatsModel(team: viewModel.team, match: viewModel.match, set: viewModel.set)))
            case 3:
                AnyView(PointLog(viewModel: PointLogModel(set: viewModel.set)))
            default:
                fatalError()
            }
            ZStack{
                Capsule().fill(.white.opacity(0.1))
                    .frame(maxHeight: 60)
                HStack{
                    ZStack{
                        Circle().fill(viewModel.selTab == 1 ? Color.swatch.cyan.base : .clear).frame(maxHeight: 80)
                        Button(action:{
                            withAnimation(.easeInOut){
                                viewModel.selTab=1
                            }
                        }){
                            VStack{
                                Image(systemName: "hand.tap.fill")
                                if (viewModel.selTab != 1){
                                    Text("capture".trad())
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.foregroundColor(viewModel.selTab != 1 ? Color.swatch.cyan.base : .black)
                    ZStack{
                        Circle().fill(viewModel.selTab == 2 ? Color.swatch.cyan.base : .clear).frame(maxHeight: 80).transition(.scale)
                        Button(action:{
                            withAnimation(.easeInOut){
                                viewModel.selTab=2
                            }
                        }){
                            VStack{
                                Image(systemName: "chart.bar.fill")
                                if (viewModel.selTab != 2){
                                    Text("stats".trad())
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.foregroundColor(viewModel.selTab != 2 ? Color.swatch.cyan.base : .black)
                    ZStack{
                        Circle().fill(viewModel.selTab == 3 ? Color.swatch.cyan.base : .clear).frame(maxHeight: 80)
                        Button(action:{
                            withAnimation(.easeInOut){
                                viewModel.selTab=3
                            }
                        }){
                            VStack{
                                Image(systemName: "chart.bar.doc.horizontal")
                                if (viewModel.selTab != 3){
                                    Text("point.log".trad())
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }.foregroundColor(viewModel.selTab != 3 ? Color.swatch.cyan.base : .black)
                }.frame(maxWidth: .infinity).padding()
            }.padding(.horizontal)
        }
        .toolbar{
//            ToolbarItem(placement: .navigationBarLeading){
////                NavigationLink(destination: ListTeams(viewModel: ListTeamsModel(pilot: viewModel.appPilot))){
//                    Button(action: {
//                        
//                        sessionManager.isLoggedIn.toggle()
//                    }){
//                        Image(systemName: "chevron.backward")
//                        Text("your.teams".trad())
//                    }.font(.body.bold()).foregroundColor(.cyan)
////                }
//            }
            ToolbarItem(placement: .navigationBarTrailing){
                HStack{
                    NavigationLink(destination: FillStats(viewModel: FillStatsModel(team: viewModel.team, match: viewModel.match, set: viewModel.set))){
                        Image(systemName: "plus.square.fill.on.square.fill").font(.title3)
                    }
                    NavigationLink(destination: CaptureHelp()){
                        Image(systemName: "questionmark.circle").font(.title3)
                    }
                }
            }
        }
        .foregroundColor(.white)
        .background(Color.swatch.dark.high)
        
    }
    //#-learning-task(createDetailView)
}


class StatsViewModel: ObservableObject{
    @Published var selTab: Int = 1
    let team: Team
    let match: Match
    let set: Set
    
    init(team: Team, match: Match, set: Set){
        self.team = team
        self.match = match
        self.set = set
    }
}




