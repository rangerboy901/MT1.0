//
//  DailyWorkout.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//

import RealmSwift
import SwiftUI



class DailyWorkout: Object, ObjectKeyIdentifiable {
    @Persisted var title = ""
    @Persisted var objective = ""
    @Persisted var type = "HIIT"
    @Persisted var exerciseList = RealmSwift.List<String>()
    @Persisted var historyList = RealmSwift.List<History>()
    
    var exercises: [String] { Array(exerciseList) }
    var history: [History] { Array(historyList) }
   
    convenience init(title: String,objective: String,type: String, exercises: [String], history: [History] = []) {
        self.init()
        self.title = title
        self.objective = objective
        self.type = type
        exerciseList.append(objectsIn: exercises)
        for entry in history {
            self.historyList.insert(entry, at: 0)
        }
    }
}
extension DailyWorkout {
    static var data: [DailyWorkout] {
        [
            DailyWorkout(title: "Dakota", objective: "Complete for Time.", type: "HIIT", exercises: ["Run 1 Mile","100 Push-Ups", "100 Pull-ups", "100 Sit-ups"]),
            DailyWorkout(title: "Remington", objective: "Complete for Time.", type: "Power", exercises: ["Run 1 Mile","100 Push-Ups", "100 Pull-ups", "100 Sit-ups"]),
            DailyWorkout(title: "Montana", objective: "Complete for Time.", type: "Strength", exercises:[ "Run 1 Mile","100 Push-Ups", "100 Pull-ups", "100 Sit-ups"]),
            DailyWorkout(title: "Cooper", objective: "Complete for Time.", type: "Cardio", exercises: ["Run 1 Mile","100 Push-Ups", "100 Pull-ups", "100 Sit-ups"]),
        ]
    }
}
extension DailyWorkout {
    struct Data {
        var title: String = ""
        var objective: String = ""
        var type: String = ""
        var exercises: [String] = []
       
    }
    var data: Data {
        return Data(title: title, objective: objective, type: type, exercises: exercises)
    }
    
    func update(from data: Data) {
        title = data.title
        objective = data.objective
        type = data.type
        for exercise in data.exercises {
            if !exercises.contains(exercise) {
                self.exerciseList.append(exercise)
            }
        }
        
     
    }
}
