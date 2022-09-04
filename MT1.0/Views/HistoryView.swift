//
//  HistoryView.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//

import SwiftUI
import RealmSwift



struct HistoryView: View {
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
    let history: History
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Exercises")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(history.exerciseString)
            }
        }
        .navigationTitle(Text(history.date ?? Date(), style: .date))
        .padding()
    }
}

extension History {
    var exerciseString: String {
        ListFormatter.localizedString(byJoining: exercises)
    }
}


