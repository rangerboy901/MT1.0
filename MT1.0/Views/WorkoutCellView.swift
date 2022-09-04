//
//  WorkoutCellView.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//

import SwiftUI
import RealmSwift

struct WorkoutCellView: View {
    
    let workout: DailyWorkout
    
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
            HStack {
                Circle()
                    .frame(width: 15, height: 15, alignment: .center)
                    .foregroundColor(self.colorize(type: workout.type ))
                Text(workout.title)
                    .fontWeight(.semibold)
                    .accessibilityAddTraits(.isHeader)
                    .foregroundColor(.primary)
            }
            Text(workout.objective)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(self.colorize(type: workout.type))
                .accessibilityLabel("\(workout.objective)Workout Description")
            
            HStack{
                Spacer()
                Text("\(workout.type)")
                    .foregroundColor(Color.primary)
                    .accessibilityLabel("\(workout.type) Workout type")
                    .font(.caption2)
                    .padding(3)
                    .overlay(
                        Capsule().stroke(self.colorize(type: workout.type ), lineWidth: 3.0)
                    )}
            .padding(.trailing, 15)
            .cornerRadius(10)
            
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerSize: .zero).stroke(self.colorize(type: workout.type ), lineWidth: 3.0)
        )
    }
       
}

struct WorkoutCellView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            WorkoutCellView(workout: DailyWorkout(title: "Dakota", objective: "complete as Rx'd", type: "HIIT", exercises: ["push-ups"]))
        }
    }
}
