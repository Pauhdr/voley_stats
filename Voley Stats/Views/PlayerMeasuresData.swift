import SwiftUI
import UIPilot

struct PlayerMeasuresData: View {
    @ObservedObject var viewModel: PlayerMeasuresDataModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            VStack{
                Section{
                    VStack{
                        VStack(alignment: .leading){
                            Text("player".trad()).font(.caption)
                            TextField("player".trad(), text: $viewModel.player.name).textFieldStyle(TextFieldDark()).disabled(true)
                        }.padding(.bottom)
                        DatePicker("date".trad(), selection: $viewModel.date, displayedComponents: [.date]).padding(.vertical, 3)
                        VStack(alignment: .leading){
                            Text("height".trad()).font(.caption)
                            TextField("height".trad(), value: $viewModel.height, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("weight".trad()).font(.caption)
                            TextField("weight".trad(), value: $viewModel.weight, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("breadth".trad()).font(.caption)
                            TextField("breadth".trad(), value: $viewModel.breadth, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("oneHandReach".trad()).font(.caption)
                            TextField("oneHandReach".trad(), value: $viewModel.oneHandReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("twoHandReach".trad()).font(.caption)
                            TextField("twoHandReach".trad(), value: $viewModel.twoHandReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("attackReach".trad()).font(.caption)
                            TextField("attackReach".trad(), value: $viewModel.attackReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        VStack(alignment: .leading){
                            Text("blockReach".trad()).font(.caption)
                            TextField("blockReach".trad(), value: $viewModel.blockReach, format: .number).keyboardType(.numberPad).textFieldStyle(TextFieldDark())
                        }
                        
                    }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Button(action:{
                    viewModel.onAddButtonClick()
                    if viewModel.saved{
                        dismiss()
                    }
                }){
                    Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(.cyan)
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
        
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle("player.new".trad())
    }
}

class PlayerMeasuresDataModel: ObservableObject{
    @Published var height: Int = 0
    @Published var weight: Double = 0
    @Published var oneHandReach: Int = 0
    @Published var twoHandReach: Int = 0
    @Published var attackReach: Int = 0
    @Published var blockReach: Int = 0
    @Published var breadth: Int = 0
    @Published var date: Date = Date()
    @Published var saved: Bool = false
    
    var player: Player
    var playerMeasures: PlayerMeasures?
//    let appPilot: UIPilot<AppRoute>
    
    init(player: Player, measures: PlayerMeasures? = nil){
        self.playerMeasures = measures
        self.player = player
        
    }
    func onAddButtonClick(){
        if self.playerMeasures != nil {
            playerMeasures!.date = date
            playerMeasures!.height = height
            playerMeasures!.weight = weight
            playerMeasures!.breadth = breadth
            playerMeasures!.oneHandReach = oneHandReach
            playerMeasures!.twoHandReach = twoHandReach
            playerMeasures!.attackReach = attackReach
            playerMeasures!.blockReach = blockReach
            let updated = playerMeasures?.update()
            if updated ?? false {
                saved.toggle()
            }
        }else{
            let newPlayer = PlayerMeasures(player: player, date: date, height: height, weight: weight, oneHandReach: oneHandReach, twoHandReach: twoHandReach, attackReach: attackReach, blockReach: blockReach, breadth: breadth)
            let id = PlayerMeasures.create(measure: newPlayer)
            if id != nil {
                saved.toggle()
            }
        }
        
        
    }
}



