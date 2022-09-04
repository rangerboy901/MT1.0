//
//  WorkoutEditView.swift
//  MT1.0
//
//  Created by Joseph William DeWeese on 9/3/22.
//

import SwiftUI
import RealmSwift


struct WorkoutEditView: View {
    //JWD:  PROPERTIES
    @Binding var workoutData: DailyWorkout.Data
    @State private var newExercise = ""
    
    let types = ["HIIT", "Cardio", "Strength", "Power"]
    
    func colorize(type: String) -> Color {
        switch type {
        case "HIIT":
            return .blue
        case "Strength":
            return .orange
        case "Cardio":
            return .pink
        case "Power":
            return .green
        default:
            return .gray
            
        }
    }
    
    var body: some View {
        VStack (alignment:.leading){
            List {
                
                Section(header: Text("Workout Details")) {
                    
                    TextField("Enter workout name...", text: $workoutData.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerSize: .zero).stroke(self.colorize(type: workoutData.type ), lineWidth: 3.0))
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(self.colorize(type: workoutData.type ))
                    
                    TextField("Enter workout objective...", text: $workoutData.objective)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerSize: .zero).stroke(self.colorize(type: workoutData.type ), lineWidth: 3.0))
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(self.colorize(type: workoutData.type ))
                        .accessibilityLabel("\(workoutData.objective)Workout Description")
                    
                    Text("Workout Type:")
                    Picker("Workout Type:", selection: $workoutData.type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .overlay(
                        RoundedRectangle(cornerSize: .zero).stroke(self.colorize(type: workoutData.type ), lineWidth: 3.0))
                    
                    Section(header: Text("Exercises")) {
                        ForEach(workoutData.exercises, id: \.self) { exercise in
                            Text(exercise)
                        }
                        .onDelete { indices in
                            workoutData.exercises.remove(atOffsets: indices)
                        }
                        HStack {
                            TextField("Enter new exercise...", text: $newExercise)
                            Button(action: {
                                withAnimation {
                                    workoutData.exercises.append(newExercise)
                                    newExercise = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .accessibilityLabel(Text("Add exercise"))
                            }
                            .disabled(newExercise.isEmpty)
                        }
                    }//: #endOf Section
                
                }//: #endOf List
                .listStyle(InsetGroupedListStyle())
            }
        }
        
    }
}

                       
struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutEditView(workoutData: .constant(DailyWorkout.data[0].data))
    }
}
