import SwiftUI
import UIPilot

struct SessionData: View {
    @ObservedObject var viewModel: SessionDataModel
    var body: some View {
        VStack{
//            Text("exercise.new".trad()).font(.title)
            VStack {
                VStack{
                    DatePicker("date", selection: $viewModel.date, displayedComponents: [.date]).padding()
                }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).padding(.vertical)
                VStack{
                    Text("assistance".trad().uppercased()).font(.caption).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    VStack{
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(viewModel.team.players(), id:\.id){player in
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8).fill(viewModel.players.contains(player) ? .blue : .gray)
                                        HStack{
                                            if viewModel.players.contains(player) {
                                                Image(systemName: "checkmark.circle").foregroundColor(.white)//.frame(maxWidth: .infinity, alignment: .leading)
                                            }else {
                                                Image(systemName: "multiply.circle").foregroundColor(.white)//.frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            Text(player.name)
                                        }.padding()
                                    }.frame(maxHeight: 90).padding().onTapGesture {
                                        if (viewModel.players.contains(player)){
                                            viewModel.players.remove(at: viewModel.players.firstIndex(of: player)!)
                                        }else{
                                            viewModel.players.append(player)
                                        }
                                    }
                                }
                            }
                        }
                    }.background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                }.padding(.vertical)
                VStack{
                    Text("exercises".trad())
                    
                    ForEach(viewModel.exercises, id: \.id){exercise in
                        HStack{
                            Image(systemName: "list.bullet").padding(.horizontal)
                            Divider().overlay(.white)
                            Text(exercise.name).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                            Image(systemName: "minus.circle").padding(.horizontal).tint(.red).onTapGesture{
                                viewModel.exercises = viewModel.exercises.filter{ $0.id != exercise.id}
                            }
                        }.frame(maxHeight: 60).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                viewModel.exercise = exercise
                                viewModel.showExerciseDetail.toggle()
                            }
                    }
                    Spacer()
                    Button(action:{
                        viewModel.showExercises.toggle()
                    }){
                        HStack{
                            Image(systemName: "plus")
                            Text("add exercise")
                        }
                    }
                }.padding(.vertical).frame(maxWidth: .infinity).background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                
                Button(action:{viewModel.onAddButtonClick()}){
                    Text("save".trad()).frame(maxWidth: .infinity, alignment: .center)
                }.disabled(viewModel.emptyFields()).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8)).foregroundColor(viewModel.emptyFields() ? .gray : .cyan)
            }.padding()
        }
        .sheet(isPresented: $viewModel.showExercises){
            VStack{
                Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).padding().onTapGesture {
                    viewModel.showExercises.toggle()
                }
                ForEach(Exercise.all(), id:\.id){exercise in
                    HStack{
                        Text(exercise.name)
                    }.padding().frame(maxWidth: .infinity, alignment: .leading).padding().background(.white.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            
                            viewModel.exercises.append(exercise)
                            viewModel.showExercises.toggle()
                        }
                }
            }.background(Color.swatch.dark.high).foregroundColor(.white).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .sheet(isPresented: $viewModel.showExerciseDetail){
            
            VStack{
                Image(systemName: "multiply").frame(maxWidth: .infinity, alignment: .trailing).padding().onTapGesture {
                    viewModel.showExercises.toggle()
                }
                Text("extra.options".trad().uppercased()).font(.caption).frame(maxWidth: .infinity, alignment: .leading).padding(.top)
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
            }.background(Color.swatch.dark.high).foregroundColor(.white).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle(viewModel.exercise == nil ? "session.new".trad() : "session.setup".trad())
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.swatch.dark.high).foregroundColor(.white)
    }
}

class SessionDataModel: ObservableObject{
    @Published var date: Date = Date()
    @Published var maxReps: Int?
    @Published var series: Int?
    @Published var strict: Bool = false
    @Published var individual: Bool = false
    @Published var timer: (Int, Int, Int) = (0,0,0)
    @Published var objective: Dictionary<Action, Int>?
    @Published var exercise: Exercise? = nil
    @Published var exercises: [Exercise] = []
    @Published var subexercise: String = ""
    @Published var subexercises: [String]=[]
    @Published var showExercises:Bool = false
    @Published var showExerciseDetail:Bool = false
    @Published var players:[Player]=[]
    var session:Session?=nil
    var team:Team
    
    private let appPilot: UIPilot<AppRoute>
    
    init(pilot: UIPilot<AppRoute>, team:Team, session: Session?){
        self.appPilot=pilot
        self.team = team
    }
    func emptyFields()->Bool{
        return false
    }
    func onAddButtonClick(){
        if self.session != nil {
            let updated = session?.update()
            if updated ?? false {
                appPilot.pop()
            }
        }else{
            let newSession = Session(date: self.date, team: self.team, players: players)
            let id = Session.create(session: newSession)
            if id != nil {
                appPilot.pop()
            }
        }
        
        
    }
}



