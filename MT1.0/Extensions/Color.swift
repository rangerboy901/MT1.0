//
//  Color.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//


import SwiftUI

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
