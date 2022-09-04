//
//  WorkoutsListView.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//

import SwiftUI
import RealmSwift



struct WorkoutsListView: View {
    //PROPERTIES:
    @ObservedResults(DailyWorkout.self) var workouts
    @State private var newWorkoutData = DailyWorkout.Data()
    @State private var currentWorkout = DailyWorkout()
    @State var isPresented = false
    
    
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
        ZStack {
            List {
                if let workouts = workouts {
                    ForEach(workouts) { workout in
                        NavigationLink(
                            destination: WorkoutDetailView(workout: DailyWorkout())) {
                                WorkoutCellView(workout: workout)
                            }
                    }
                }
              
            }
            
            .navigationTitle("Daily Workouts")
            .navigationBarItems(trailing: Button(action: {
                isPresented = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $isPresented) {
                NavigationView {
                    WorkoutEditView(workoutData: $newWorkoutData)
                        .navigationBarItems(leading: Button("Cancel"){
                            isPresented = false
                        }, trailing: Button("Save") {
                            let newWorkout = DailyWorkout(
                                title: newWorkoutData.title,
                                objective: newWorkoutData.objective,
                                type: newWorkoutData.type,
                                exercises: newWorkoutData.exercises)
                            $workouts.append(newWorkout)
                            isPresented = false
                        }
                            
                        )
                }
            }
        }
    }
}
struct WorkoutsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutsListView()
        }
    }
}


