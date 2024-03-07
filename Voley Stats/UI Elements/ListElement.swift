import SwiftUI

struct ListElement: View{
    var team: Team
    var match: Match
    @ObservedObject var viewModel: ListTeamsModel
    @State var exportStats:Bool = false
    @State var clicked: Bool = false
    @State var deleting: Bool = false
    @State var activeRoot:Bool = false
    @State var subviewHeight : CGFloat = 0
    var action: () -> Void
    var body: some View{
        VStack{
            
            ZStack{
                RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
                HStack{
                    if viewModel.selectMatches {
                        if viewModel.reportMatches.contains(match) {
                            Image(systemName: "checkmark.square.fill").padding(.trailing).font(.title2)
                        }else{
                            Image(systemName: "square").padding(.trailing).font(.title2)
                        }
                        
                    }
                    VStack(alignment: .leading){
                        Text("\(match.opponent)")
                        Text("\(match.location) @ \(match.getDate())").font(.caption).foregroundColor(.gray)
                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    HStack{
                        ForEach(match.sets(), id:\.id){set in
                            ZStack{
                                Circle().fill(.white).frame(maxWidth: 60, maxHeight: 60)
                                if set.first_serve != 0{
                                    NavigationLink(destination: AnyView(StatsView(viewModel: StatsViewModel(team: team, match: match, set: set))))
                                    {
                                        
                                        Text("\(set.score_us)-\(set.score_them)").foregroundColor(.black).font(.custom("", size: 11))
                                    }
                                }else{
                                    
                                    NavigationLink(destination: AnyView(SetData(viewModel: SetDataModel(team: team, match: match, set: set))))
                                    {
                                        
                                        Image(systemName: "arrowtriangle.right.circle").foregroundColor(.black).font(.headline)
                                        
                                        
                                    }
                                }
                            }.frame(maxWidth: 60, maxHeight: 60)
                        }
                        
                    }.frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: clicked ? "chevron.down" : "chevron.right").padding(.horizontal).onTapGesture {
                        action()
                        withAnimation{
                            clicked.toggle()
                        }
                    }.foregroundColor(Color.swatch.cyan.base).frame(width: 40, height: 40)
                }
                .padding()
                .alert("match.delete".trad() + " vs " + match.opponent, isPresented: $deleting) {
                    Button("match.delete".trad(), role: .destructive) {
                        viewModel.deleteMatch(match: match)
                    }
                    Button("cancel".trad(), role: .cancel) { }
                } message: {
                    Text("match.delete.description".trad()).padding()
                }
//                .confirmationDialog("match.delete.description".trad(), isPresented: $deleting, titleVisibility: .visible){
//                    Button("match.delete".trad(), role: .destructive){
//                        viewModel.deleteMatch(match: match)
//                    }
//                }
            }
            .onTapGesture {
                action()
                if !viewModel.selectMatches{
                    clicked.toggle()
                }
            }
            .frame(height: 60)
            if clicked{
                VStack{
                    NavigationLink(destination: MatchStats(viewModel: MatchStatsModel(team: team, match: match))){
                        HStack{
                            Text("match.stats".trad()).frame(maxWidth: .infinity)
                        }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    NavigationLink(destination: MatchData(viewModel: MatchDataModel(team: team, match: match))){
                        Text("edit.match".trad()).frame(maxWidth: .infinity)
                    }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
//                    }
                    Button(action:{
                        viewModel.reportLang.toggle()
                    }){
                        Text("export.stats".trad()).frame(maxWidth: .infinity)
                    }.padding().background(.white.opacity(0.05)).clipShape(RoundedRectangle(cornerRadius: 8))
                    Button(action:{
                        deleting.toggle()
                    }){
                        HStack{
                            Image(systemName: "trash.fill")
                            Text("match.delete".trad())
                        }.foregroundStyle(.red).frame(maxWidth: .infinity)
                    }.padding().background(.red.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                    
                }.padding([.horizontal, .top]).frame(maxWidth: .infinity)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .foregroundColor(.white)
        
        .padding(.horizontal, 10)
        .padding(.vertical)
        
    }
    
}
