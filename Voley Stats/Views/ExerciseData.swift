import SwiftUI
import UIPilot

struct ExerciseData: View {
    @ObservedObject var viewModel: ExerciseDataModel
    var body: some View {
        VStack{
//            Text("exercise.new".trad()).font(.title)
            VStack {
                VStack{
                    VStack(alignment: .leading){
                        Text("name".trad()).font(.caption)
                        TextField("name".trad(), text: $viewModel.name).textFieldStyle(TextFieldDark())
                    }.padding(.bottom)
                    VStack(alignment: .leading){
                        Text("description".trad()).font(.caption)
                        TextField("description".trad(), text: $viewModel.description).textFieldStyle(TextFieldDark())
                    }.padding(.bottom)
                    HStack{
                        Text("area".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        Picker(selection: $viewModel.area, label: Text("area".trad())) {
                            Text("all".trad()).tag("all")
                            Text("block".trad()).tag("block")
                            Text("receive".trad()).tag("receive")
                            Text("serve".trad()).tag("serve")
                            Text("dig".trad()).tag("dig")
                            Text("set".trad()).tag("set")
                            Text("attack".trad()).tag("attack")
                        }
                    }.padding(.bottom)
                    VStack{
                        Text("capture.type".trad()).font(.caption).frame(maxWidth: .infinity, alignment: .leading)
                        Picker(selection: $viewModel.type, label: Text("capture.type".trad())) {
                            Text("count".trad()).tag("count")
                            Text("stats.like".trad()).tag("stats")
                            Text("quick.note".trad()).tag("improve")
                            Text("tabata".trad()).tag("tabata")
                        }.pickerStyle(.segmented)
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                Text("extra.options".trad().uppercased()).font(.caption).frame(maxWidth: .infinity, alignment: .leading).padding(.top)
                VStack{
                    HStack{
                        Text("max.reps".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        TextField("max.reps".trad(), value: $viewModel.maxReps, format: .number).textFieldStyle(TextFieldDark()).keyboardType(.numberPad)
                    }
                    HStack{
                        Text("series".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        TextField("series".trad(), value: $viewModel.series, format: .number).textFieldStyle(TextFieldDark()).keyboardType(.numberPad)
                    }
                    HStack{
//                        Text("strict".trad())
                        Toggle("strict".trad(), isOn: $viewModel.strict)
                    }
                    HStack{
//                        Text("strict".trad())
                        Toggle("individual".trad(), isOn: $viewModel.individual)
                    }
                    HStack{
                        Text("timer".trad()).frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Picker(selection: $viewModel.timer.0, label: Text("")) {
                                ForEach(0..<25){h in
                                    Text("\(h)").tag(h)
                                }
                            }.pickerStyle(.wheel)
                            Text(":")
                            Picker(selection: $viewModel.timer.1, label: Text("")) {
                                ForEach(0..<60){h in
                                    Text("\(h)").tag(h)
                                }
                            }.pickerStyle(.wheel)
                            Text(":")
                            Picker(selection: $viewModel.timer.2, label: Text("")) {
                                ForEach(0..<60){h in
                                    Text("\(h)").tag(h)
                                }
                            }.pickerStyle(.wheel)
                        }
                    }
                    VStack{
                        Text("subexercises".trad())
                        ForEach(viewModel.subexercises, id:\.self){ex in
                            HStack{
                                Text(ex)
                            }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
                        }
                        HStack{
                                TextField("write.a.comment.max.55".trad(), text: $viewModel.subexercise).textFieldStyle(TextFieldDark())
                                
                            
                            Button(action:{
                                viewModel.subexercises.append(viewModel.subexercise)
                                viewModel.subexercise = ""
                            }){
                                Image(systemName: "plus")
                            }
                            .frame(width: 40, height: 40).background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
                            .foregroundColor(.cyan)
                        }
                    }.padding().background(RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.1)))
                    HStack{
//                        Text("objective".trad())
//                        TextField("objective".trad(), value: $viewModel.maxReps, format: .number).textFieldStyle(TextFieldDark()).keyboardType(.numberPad)
                    }
                }.padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                Button(action:{viewModel.onAddButtonClick()}){
                    Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                }.disabled(viewModel.emptyFields()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan)
            }.padding()
        }
        .navigationTitle(viewModel.exercise == nil ? "exercise.new".trad() : "exercise.setup".trad())
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.swatch.dark.high).foregroundColor(.white)
    }
}

class ExerciseDataModel: ObservableObject{
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var area: String = ""
    @Published var type: String = ""
    @Published var maxReps: Int?
    @Published var series: Int?
    @Published var strict: Bool = false
    @Published var individual: Bool = false
    @Published var timer: (Int, Int, Int) = (0,0,0)
    @Published var objective: Dictionary<Action, Int>?
    @Published var exercise: Exercise? = nil
    @Published var subexercise: String = ""
    @Published var subexercises: [String]=[]
    
    private let appPilot: UIPilot<AppRoute>
    
    init(pilot: UIPilot<AppRoute>, exercise: Exercise?){
        self.appPilot=pilot
        self.exercise = exercise ?? nil
        name = exercise?.name ?? ""
        description = exercise?.description ?? ""
        area = exercise?.area ?? "all"
        type = exercise?.type ?? "count"
        maxReps = exercise?.maxReps
        series = exercise?.series
        strict = exercise?.strict ?? false
        individual = exercise?.individual ?? false
        timer = exercise?.getTimer() ?? (0,0,0)
        objective = exercise?.objective
        subexercises = exercise?.subexercises ?? []
    }
    func emptyFields()->Bool{
        return name == "" || area == "" || type == ""
    }
    func onAddButtonClick(){
        if self.exercise != nil {
            exercise?.name = name
            exercise?.description = description
            exercise?.area = area
            exercise?.type = type
            exercise?.maxReps = maxReps
            exercise?.series = series
            exercise?.strict = strict
            exercise?.individual = individual
            exercise?.timer = self.timer.0*3600+self.timer.1*60+self.timer.2
            exercise?.objective = objective
            exercise?.subexercises = subexercises
            let updated = exercise?.update()
            if updated ?? false {
                appPilot.pop()
            }
        }else{
            let newExercise = Exercise(name: name, description: description, area: area, type: type, maxReps: self.maxReps, series: self.series, strict: self.strict, individual: self.individual, timer: self.timer.0*3600+self.timer.1*60+self.timer.2, objective: self.objective, subexercises: subexercises)
            let id = Exercise.createExercise(exercise: newExercise)
            if id != nil {
                appPilot.pop()
            }
        }
        
        
    }
}



