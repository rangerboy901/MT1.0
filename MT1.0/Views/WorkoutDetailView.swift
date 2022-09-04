//
//  WorkoutDetailView.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//

import SwiftUI
import RealmSwift

struct WorkoutDetailView: View {
    //JWD:  PROPERTIES
    @State private var isPresented: Bool = false
    let workout: DailyWorkout
    @State private var data = DailyWorkout.Data()
    
   
   
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
                    NavigationLink(
                        destination:  TimerView()
                    ){
                        Label("Begin Workout", systemImage: "timer")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerSize: .zero).stroke(self.colorize(type: workout.type ), lineWidth: 3.0)
                    )
                VStack(alignment: .leading, spacing: 20) {
                    Section(header: Text("Workout Details")) {
                        
                            Text("\(workout.title)")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(Color(UIColor.tertiarySystemFill))
                                .cornerRadius(10)
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(self.colorize(type: workout.type ))
                                .accessibilityLabel("\(workout.title)Workout Name")
                        
                        Text("\(workout.objective)")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(Color(UIColor.tertiarySystemFill))
                                .cornerRadius(10)
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(self.colorize(type: workout.type ))
                                
                        
                        
                    Text("\(workout.type) type workout.")
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .background(Color(UIColor.tertiarySystemFill))
                                .cornerRadius(10)
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(self.colorize(type: workout.type ))
                                .accessibilityLabel("\(workout.type) Workout type")
                
                        .accessibilityElement(children: .ignore)
                        
                    }// #endOf Section
                    Section(header: Text("Exercises")) {
                        ForEach(workout.exercises, id: \.self) {
                            exercise in
                            Label(exercise, systemImage: "target")
                                .accessibilityLabel(Text("target"))
                                .accessibilityValue(Text(exercise))
                        }
                    }// #endOf Section
                    Section(header: Text("Past Workouts")) {
                        if workout.history.isEmpty {
                            Label("No completed workouts", systemImage: "calendar.badge.exclamationmark")
                        }
                        ForEach(workout.history) { history in
                            NavigationLink(destination:
                                            HistoryView(history: history)) {
                                HStack {
                                    Image(systemName: "calendar")
                                    if let date = history.date {
                                        Text(date, style: .date)
                                    } else {
                                        Text("Date is missing")
                                    }
                                }
                            }
                        }
                    }
                             
                        }
                        
                    }
               
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing: Button("Edit") {
                isPresented = true
                  data = workout.data
            })
            .navigationTitle(workout.title)
            .fullScreenCover(isPresented: $isPresented) {
                NavigationView {
                    WorkoutEditView(workoutData: $data)
                        .navigationTitle(workout.title)
                        .navigationBarItems(leading: Button("Cancel") {
                            isPresented = false
                        }, trailing: Button("Save Workout")
                            {
                            isPresented = false
                            do {
                                try Realm().write() {
                                    guard let thawedWorkout =
                                            workout.thaw() else {
                                        print("Unable to thaw workout")
                                        return
                                    }
                                    thawedWorkout.update(from: data)
                                }
                            }catch {
                                print("Failed to save workout: \(error.localizedDescription)")
                            }
                        }
                        .foregroundColor(self.colorize(type: workout.type)))
                }
            }
        }
     
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutDetailView(workout: DailyWorkout.data[0])
        }
    }
}

    
