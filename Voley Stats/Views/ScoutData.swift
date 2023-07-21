import SwiftUI
import UIPilot

struct ScoutData: View {
    @ObservedObject var viewModel: ScoutDataModel
    var body: some View {
        VStack{
//            Text("scout.new".trad()).font(.title)
            VStack{
                Section{
                    VStack{
                        VStack(alignment: .leading){
                            Text("name".trad()).font(.caption)
                            TextField("name".trad(), text: $viewModel.name).textFieldStyle(TextFieldDark())
                        }
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Spacer()
                Button(action:{viewModel.onAddButtonClick()}){
                    Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                }.disabled(viewModel.name.isEmpty).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor((viewModel.name.isEmpty) ? .gray : .cyan)
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .alert(isPresented: $viewModel.teamExists){
                Alert(title: Text("Duplicated team"), message: Text("you should assign a new name to the team or use the one already created"))
            }
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle(viewModel.scout == nil ? "scout.new".trad() : "scout.edit".trad())
    }
}

class ScoutDataModel: ObservableObject{
    @Published var name: String = ""
    @Published var teamExists = false
    var team: Team
    var scout:Scout?
    var names: [String] = []
    
    let appPilot: UIPilot<AppRoute>
    
    init(pilot: UIPilot<AppRoute>, team: Team, scout:Scout?){
        self.appPilot=pilot
        self.team = team
        self.scout = scout
        self.names = team.scouts().map{$0.teamName.lowercased()}
    }
    
    func onAddButtonClick(){
        if !names.contains(self.name.lowercased()){
            if self.scout != nil {
                let updated = scout?.updateName(name: self.name)
                if updated ?? false {
                    appPilot.pop()
                }
            }else{
                let newScout = Scout(teamName: self.name, teamRelated: self.team, player: 0, rotation: [.zero, .zero, .zero, .zero, .zero, .zero], action: "create", difficulty: 0, from: 0, to: 0, date: Date())
                let id = Scout.create(scout: newScout)
                if id != nil {
                    appPilot.pop()
                }
            }
        }else{
            self.teamExists = true
        }
        
    }
}



