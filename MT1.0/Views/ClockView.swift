//
//  ClockView.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//

import SwiftUI
import RealmSwift

struct Clock: View {
    //JWD: Properties...
    var time: TimeInterval = 10
    var lapTime: TimeInterval?
    
    //TODO:  Add a placemat under the clock - mucgh like the clock widget on homescreen
    var body: some View {
        ZStack {
            Ticks()
            Labels()
                .offset(x:50, y: 50)
                .padding(90)
                .font(.subheadline)
            Text(time.formatted)
                .foregroundColor(.accentColor)
                .font(Font.system(size: 30,  weight:   .regular).monospacedDigit())
                .offset(y: 70)
            
            if lapTime != nil {
                Pointer()
                    .stroke(Color.green, lineWidth: 2)
                    .rotationEffect(Angle.degrees(Double(lapTime!) * 360/60))
            }
            Pointer()
                .stroke(Color.red, lineWidth: 2)
                .rotationEffect(Angle.degrees(Double(time) * 360/60))
            Color.clear
        }.aspectRatio(1, contentMode: .fit)
        
    }
}
struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        Clock()
    }
}
