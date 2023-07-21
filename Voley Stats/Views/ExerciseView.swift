import SwiftUI
import UIPilot

struct ExerciseView: View {
    @ObservedObject var viewModel:ExerciseViewModel
    var body: some View {
        VStack{
            if viewModel.exercise.type == "count" {
                AnyView(CountExercise(viewModel: CountExerciseModel(pilot: viewModel.appPilot, team: viewModel.team, exercise: viewModel.exercise)))
            } else if viewModel.exercise.type == "stats" {
                AnyView(StatExercise(viewModel: StatExerciseModel(team: viewModel.team, exercise: viewModel.exercise)))
            }else{
                AnyView(QuickNoteExercise(viewModel: QuickNoteExerciseModel(pilot: viewModel.appPilot, team: viewModel.team, exercise: viewModel.exercise)))
            }
        }.background(Color.swatch.dark.high).foregroundColor(.white)
            .navigationTitle(viewModel.exercise.name.trad())
    }
    //#-learning-task(createDetailView)
}


class ExerciseViewModel: ObservableObject{
    @Published var selTab: Int = 1
        let appPilot: UIPilot<AppRoute>
    let team: Team
    let exercise: Exercise
    
    init(pilot: UIPilot<AppRoute>, team: Team, exercise: Exercise){
                self.appPilot=pilot
        self.team = team
        self.exercise = exercise
    }
}




