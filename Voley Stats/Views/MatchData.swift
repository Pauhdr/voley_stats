import SwiftUI
import FirebaseAuth
import UniformTypeIdentifiers

struct MatchData: View {
    @ObservedObject var viewModel: MatchDataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
            VStack{
//                Text("match.settings".trad()).font(.title)
                ScrollView{
                    VStack {
                        Section{
                            VStack{
                                VStack(alignment: .leading){
                                    Text("team".trad()).font(.caption)
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.05)).frame(height: 45)
                                        Text(viewModel.team.name).foregroundStyle(.gray).padding().frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }.padding(.bottom)
                                VStack(alignment: .leading){
                                    Text("opponent".trad()).font(.caption)
                                    TextField("opponent".trad(), text: $viewModel.opponent).textFieldStyle(TextFieldDark())
                                }.padding(.bottom)
                                VStack(alignment: .leading){
                                    Text("location.court".trad()).font(.caption)
                                    TextField("location.court".trad(), text: $viewModel.location).textFieldStyle(TextFieldDark())
                                }.padding(.bottom)
                                VStack(alignment: .leading){
                                    Text("home.away".trad()).font(.caption)
                                    Picker(selection: $viewModel.home, label: Text("home.away".trad())) {
                                        Text("home".trad()).tag(true)
                                        Text("away".trad()).tag(false)
                                    }.pickerStyle(.segmented)
                                }.padding(.bottom)
                                VStack(alignment: .leading){
                                    Text("league".trad()).font(.caption)
                                    Picker(selection: $viewModel.league, label: Text("league".trad())) {
                                        Text("league".trad()).tag(true)
                                        Text("non.league".trad()).tag(false)
                                    }.pickerStyle(.segmented)
                                }.padding(.bottom)
                                if !viewModel.league{
                                    HStack{
                                        HStack{
                                            Text("tournament".trad()).frame(maxWidth: .infinity, alignment: .leading).padding(.vertical)
                                            if viewModel.tournaments.isEmpty {
                                                Text("empty.tournaments".trad()).foregroundColor(.gray).padding(.trailing)
                                            }else{
                                                Picker(selection: $viewModel.tournament, label: Text("tournament".trad())) {
                                                    Text("no.tournament".trad()).tag(0)
                                                    ForEach(viewModel.tournaments, id:\.id){t in
                                                        Text(t.name).tag(t.id)
                                                    }
                                                }.disabled(viewModel.tournaments.isEmpty).padding(.trailing)
                                            }
                                        }.padding(.trailing)
                                        NavigationLink(destination: TournamentData(viewModel: TournamentDataModel(team: viewModel.team, tournament: nil))){
                                            Image(systemName: "plus").padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
                                        }
                                    }.padding(.bottom)
                                }
                                DatePicker("date".trad(), selection: $viewModel.date).padding(.vertical, 3)
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Spacer()
                        Section(header: VStack{
                            Text("match.settings".trad().uppercased()).font(.caption).foregroundColor(.gray).padding(.horizontal)
                        }.frame(maxWidth: .infinity, alignment: .leading)){
                            VStack{
                                VStack(alignment: .leading){
                                    Text("number.sets".trad()).font(.caption)
                                    Picker(selection: $viewModel.n_sets, label: Text("number.sets".trad())) {
                                        Text("1").tag(1)
                                        Text("2").tag(2)
                                        Text("3").tag(3)
                                        Text("4").tag(4)
                                        Text("5").tag(5)
                                    }.pickerStyle(.segmented)
                                }.padding(.bottom)
                                VStack(alignment: .leading){
                                    Text("number.players".trad()).font(.caption)
                                    Picker(selection: $viewModel.n_players, label: Text("number.players".trad())) {
                                        Text("3").tag(3)
                                        Text("4").tag(4)
                                        Text("6").tag(6)
                                    }.pickerStyle(.segmented)
                                }
                                if Auth.auth().currentUser != nil{
                                    VStack(alignment: .leading){
                                        Text("share.live".trad()).font(.caption)
                                        HStack{
                                            Switch(isOn: $viewModel.live, isOnIcon: Image(systemName: "dot.radiowaves.left.and.right"), isOffIcon: Image(systemName: "network.slash"), buttonColor: .cyan, backgroundColor: .white.opacity(0.1))
                                            //                                        Text(viewModel.live ? "live".trad() : "offline.stats".trad()).frame(maxWidth: .infinity, alignment: .leading)
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                    }.padding(.vertical)
                                    if viewModel.live && viewModel.match?.code ?? "" != ""{
                                        VStack(alignment: .leading){
                                            Text("live.link".trad()).font(.caption)
                                            HStack{
                                                Text("https://voleystats-live.vercel.app/\(viewModel.match!.code)").frame(maxWidth: .infinity, alignment: .leading)
                                                Image(systemName: "square.on.square").padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).onTapGesture{
                                                    UIPasteboard.general.setValue("\(viewModel.match!.code)",
                                                                                  forPasteboardType: UTType.plainText.identifier)
                                                    viewModel.showToast = true
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Spacer()
                        if viewModel.match != nil{
                            Section(header: VStack{
                                Text("set.management".trad().uppercased()).font(.caption).foregroundColor(.gray).padding(.horizontal)
                            }.frame(maxWidth: .infinity, alignment: .leading)){
                                HStack{
                                    HStack{
                                        ForEach(viewModel.match!.sets(), id:\.id){set in
                                            VStack{
                                                Image(systemName: "arrow.clockwise").foregroundStyle(set.first_serve != 0 ? .cyan : .gray).padding(.bottom)
                                                Text("\("reset".trad()) Set \(set.number)").foregroundStyle(set.first_serve != 0 ? .white : .gray)
                                            }.padding().background( set.first_serve != 0 ? .white.opacity(0.1) : .gray.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                                                .onTapGesture{
                                                    if set.first_serve != 0 {
                                                        set.reset()
                                                    }
                                                }
                                        }
                                    }.frame(maxWidth: .infinity)
                                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        Button(action:{
                            viewModel.onAddButtonClick()
                            if viewModel.saved {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }){
                            Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                        }.disabled(viewModel.emptyFields()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    
                    .alert(isPresented:$viewModel.showAlert) {
                        Alert(
                            title: Text("error".trad()),
                            message: Text("less.player.required".trad())
                        )
                    }
                }
            }.padding()
        }
        .toast(show: $viewModel.showToast, Toast(show: $viewModel.showToast, type: viewModel.type, message: viewModel.message))
        .navigationTitle("match.settings".trad()).frame(maxHeight: .infinity, alignment: .top).background(Color.swatch.dark.high).foregroundColor(.white)
        .onAppear{
            viewModel.tournaments = viewModel.team.tournaments()
        }
    }
}

class MatchDataModel: ObservableObject{
    @Published var opponent: String = ""
    @Published var date: Date = Date()
    @Published var team: Team
    @Published var n_sets: Int = 3
    @Published var n_players: Int = 4
    @Published var showAlert: Bool = false
    @Published var location: String = ""
    @Published var home: Bool = true
    @Published var league: Bool = true
    @Published var tournament: Int = 0
    @Published var saved:Bool = false
    @Published var showToast: Bool = false
    @Published var type: ToastType = .success
    @Published var message: String = "copied.to.clipboard".trad()
    var match: Match? = nil
    @Published var tournaments: [Tournament] = []
    @Published var live: Bool = false
//    var code: String
    
    init(team: Team, match: Match?, league: Bool = false, tournament: Tournament? = nil){
        self.team = team
        opponent = match?.opponent ?? ""
        date = match?.date ?? Date()
        n_sets = match?.n_sets ?? 3
        n_players = match?.n_players ?? 4
        self.tournament=match == nil ? tournament?.id ?? 0 : match?.tournament?.id ?? 0
        self.league = match != nil ? match!.league : league
        self.tournaments = team.tournaments()
        self.match = match ?? nil
        self.location = match?.location ?? ""
        self.home = match?.home ?? true
        self.live = match?.live ?? false
    }
    func emptyFields()->Bool{
        return opponent.isEmpty
    }
    func onAddButtonClick(){
        if(team.players().count < n_players){
            showAlert = true
        }else{
            if (self.match != nil){
                match?.opponent=opponent
                match?.date=date
                match?.n_sets=n_sets
                match?.n_players=n_players
                match?.location = self.location
                match?.league = league
                match?.tournament = Tournament.find(id: self.tournament)
                match?.live = live
                let updated = match?.update()
                if updated ?? false{
                    saved = true
                }
            }else {
                let match = Match(opponent: opponent, date: date, location: location, home: home, n_sets: n_sets, n_players: n_players, team: team.id, league: self.league, code: "", live: self.live, tournament: Tournament.find(id: self.tournament), id: nil)
                guard let match = Match.createMatch(match: match) else {
                    return
                }
                if live{
                    match.shareLive()
                }
                for index in 1...n_sets {
                    let s = Set.createSet(set: Set(number: index, first_serve: 0, match: match.id, rotation: Rotation(team: self.team), liberos: [nil, nil], rotationTurns: 0))
                }
                saved = true
            }
        }
    }
}
