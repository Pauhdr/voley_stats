import SwiftUI

struct ExerciseListElement: View{
    var team: Team
    var exercise: Exercise
    var viewModel: ListTeamsModel
    @State var clicked: Bool = false
    @State var showDeleteExercise: Bool = false
    var action: () -> Void
    var body: some View{
        ZStack{
//            Capsule().fill(.white.opacity(0.1))
//                .shadow(color: .black.opacity(0.2), radius: 3, x: 3, y: 3)
            RoundedRectangle(cornerRadius: 15).fill(.white.opacity(0.1))
            HStack{
                VStack(alignment: .leading){
                    Text("\(exercise.name.trad())").fontWeight(.bold)
                    Text(exercise.description.trad()).font(.caption).foregroundColor(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                Button(action:{viewModel.startExercise(team: team, exercise: exercise)}){
                    Image(systemName: "chevron.right").padding(.horizontal)
                }
                
            }.frame(maxWidth: .infinity, alignment: .trailing).padding()
        }
        .onTapGesture {
            viewModel.startExercise(team: team, exercise: exercise)
        }
        .contextMenu((exercise.id != 1 && exercise.id != 2) ? ContextMenu(menuItems: {
            Button(action:{
                viewModel.editExercise(exercise: exercise)
            }){
                Image(systemName: "square.and.pencil")
                Text("exercise.edit".trad())
            }
            Button(role: .destructive, action:{showDeleteExercise.toggle()}){
                Image(systemName: "trash")
                Text("exercise.delete".trad())
            }.foregroundColor(.red)
        }) : nil)
        .confirmationDialog("action.not.undo".trad(), isPresented: $showDeleteExercise, titleVisibility: .visible){
            Button("exercise.delete".trad(), role: .destructive){
                    if exercise.delete(){
                        viewModel.getAllExercises()
                    }
                }
        }
        
    }
}

//struct ListElement_Previews: PreviewProvider {
//    static var previews: some View {
////        ListElement()
//        Text("no preview")
//    }
//}
