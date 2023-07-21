import SwiftUI
import UIPilot

struct CountExercise: View {
    @ObservedObject var viewModel: CountExerciseModel
    var body: some View {
        VStack{
//            Text(viewModel.exercise.name).font(.title)
            Text(viewModel.exercise.description).font(.subheadline).foregroundColor(.gray)
            ScrollView{
                //            Button("Edit", action: {viewModel.editing.toggle()})
                ForEach(viewModel.team.players(), id: \.id) {player in
                    let data = viewModel.getData(player: player)
                    HStack {
                        //red: worse, yellow: low than max, green: new max
                        HStack{
                            if(data[1] < data[0]){
                                Image(systemName: "arrow.down.circle.fill").foregroundColor(.red).font(.title)
                            } else if (data[1] > data[0]) {
                                Image(systemName: "arrow.up.circle.fill").foregroundColor(.green)
                            } else {
                                Image(systemName: "equal.circle.fill").foregroundColor(.gray)
                            }
                        }.font(.custom("", size: 42)).padding(.horizontal, 40)
                        Text(player.name)
                        HStack{
                            Text(String(data[0]))
                            Text(String(data[1]))
                        }.frame(maxWidth:.infinity, alignment: .trailing)
                        HStack{
                            TextField("", value: $viewModel.count[player.id], format: .number).textFieldStyle(.roundedBorder).frame(maxWidth:35).keyboardType(.numberPad)
                            //                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.clear).frame(width: 30, height: 30, alignment: .center).border(.gray, width: 1).cornerRadius(3)
                        }.frame(maxWidth:.infinity, alignment: .trailing).padding(.horizontal, 40)
                    }
                    Divider().overlay(.white.opacity(0.3)).padding()
                }
            }.padding().frame(maxWidth:.infinity, alignment: .leading)
            Button(action:{viewModel.saveCount()}){
                Text("save".trad())
            }.disabled(viewModel.count.filter{c in return c != nil}.isEmpty).padding()
        }.background(Color.swatch.dark.high)
    }
    //#-learning-task(createDetailView)
}


class CountExerciseModel: ObservableObject{
    @Published var count: Dictionary<Int,Int> = [:]
    let appPilot: UIPilot<AppRoute>
    let team: Team
    let exercise: Exercise
    
    
    init(pilot: UIPilot<AppRoute>, team: Team, exercise: Exercise){
        self.appPilot=pilot
        self.team = team
        self.exercise = exercise
        team.players().forEach{
            self.count[$0.id]=nil
        }
    }
    func saveCount(){
        for (id, c) in self.count{
            if (c != nil){
                let newImprove = Improve(player: Player.find(id: id) ?? Player(name: "", number: 0, team: 0, active:1, birthday: Date(), id: 0), area: self.exercise.area, comment: String(c), date: Date(), exercise: self.exercise)
                let imp = Improve.createImprove(improve: newImprove)
                if imp != nil {
                    self.count[id]=nil
                }
            }
        }
    }
    func getData(player: Player)->[Int]{
        let imp = Improve.playerImproves(player: player, exercise: exercise, date: nil).sorted(by: {$0.date > $1.date})
        var prev = 0
        var current = 0
        if (imp.isEmpty){
            prev = 0
            current = 0
        }else if (imp.count == 1) {
            prev = 0
            current = Int(imp[0].comment)!
        } else {
            prev = Int(imp[1].comment)!
            current = Int(imp[0].comment)!
        }
        return [prev, current]
    }
}




