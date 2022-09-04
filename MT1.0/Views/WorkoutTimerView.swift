//
//  WorkoutTimerView.swift
//  MT1.0
//
//  Created by Joseph William DeWeese on 9/3/22.
//

import SwiftUI
import RealmSwift

struct  TimerView: View {
    @ObservedObject var stopwatch = Stopwatch()
   
    
    var body: some View {
        VStack {
            Clock(time: stopwatch.total, lapTime: stopwatch.laps.last?.0).frame(width: 300, height: 300, alignment: .center)
        }
        //            Text(stopwatch.total.formatted)
        //                .font(Font.system(size: 64, weight: .thin).monospacedDigit())
        HStack {
            ZStack {
                Spacer()
                //JWD:  STOP / START BUTTON
                Button(action: { self.stopwatch.stop() }) {
                    Text("Stop")
                }
                .foregroundColor(.red)
                .visible(stopwatch.isRunning)
                Button(action: { self.stopwatch.start() }) {
                    Text("Start")
                }
                .foregroundColor(.green)
                .visible(!stopwatch.isRunning)
            }
            Spacer()
            ZStack {
                //JWD:  NEXT / RESET BUTTON
                Button(action: { self.stopwatch.lap() }) {
                    Text("Next")
                }
                .foregroundColor(.gray)
                .visible(stopwatch.isRunning)
                Button(action: { self.stopwatch.reset() }) {
                    Text("Reset")
                }
                .foregroundColor(.gray)
                .visible(!stopwatch.isRunning)
            }
            Spacer()
            ZStack {
                
                //JWD:  FINISH BUTTON
                Button(action: { self.stopwatch.stop() }) {
                    Text("Finish")
                }
                .foregroundColor(.init( UIColor.systemBlue))
                Spacer()
            }
        }
        .padding(.horizontal)
        .equalSizes()
        .padding()
        .buttonStyle(CircleStyle())
        Spacer()
        List {
            ForEach(stopwatch.laps.enumerated().reversed(), id: \.offset) { value in
                HStack {
                    
                    Text("\(value.offset + 1)  ")
                    Text("Current Exercise Name")
                    Spacer()
                    Text(value.element.0.formatted)
                        .font(Font.body.monospacedDigit())
                }.foregroundColor(value.element.1.color)
                    .background()
            }
        }
    }
    
}


extension LapType {
    var color: Color {
        switch self {
        case .regular:
            return .primary
        case .shortest:
            return .green
        case .longest:
            return .red
        }
    }
}

final class Stopwatch: ObservableObject {
    @Published private var data = StopwatchData()
    private var timer: Timer?
    
    var total: TimeInterval {
        data.totalTime
    }
    
    var isRunning: Bool {
        data.absoluteStartTime != nil
    }
    
    var laps: [(TimeInterval, LapType)] { data.laps }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] timer in
            self.data.currentTime = Date().timeIntervalSinceReferenceDate
        })
        data.start(at: Date().timeIntervalSinceReferenceDate)
    }
    //TODO: Add "Finish" button function
    func stop() {
        timer?.invalidate()
        timer = nil
        data.stop()
    }
    
    func reset() {
        stop()
        data = StopwatchData()
    }
    
    func lap() {
        data.lap()
    }
    
    deinit {
        stop()
    }
}

enum LapType {
    case regular
    case shortest
    case longest
}
//JWD:  *STOPWATCH VARIABLES*
struct StopwatchData {
    var absoluteStartTime: TimeInterval?
    var currentTime: TimeInterval = 0
    var additionalTime: TimeInterval = 0
    var lastLapEnd: TimeInterval = 0
    var _laps: [(TimeInterval, LapType)] = []
    
    var laps: [(TimeInterval, LapType)] {
        guard totalTime > 0 else { return [] }
        return _laps + [(currentLapTime, .regular)]
    }
    
    var currentLapTime: TimeInterval {
        totalTime - lastLapEnd
    }
    
    var totalTime: TimeInterval {
        guard let start = absoluteStartTime else { return additionalTime }
        return additionalTime + currentTime - start
    }
    
    mutating func start(at time: TimeInterval) {
        currentTime = time
        absoluteStartTime = time
    }
    
    mutating func stop() {
        additionalTime = totalTime
        absoluteStartTime = nil
    }
    
    mutating func lap() {
        let lapTimes = _laps.map { $0.0 } + [currentLapTime]
        if let shortest = lapTimes.min(), let longest = lapTimes.max(), shortest != longest {
            _laps = lapTimes.map { ($0, $0 == shortest ? .shortest : ($0 == longest ? .longest : .regular ))}
        } else {
            _laps = lapTimes.map { ($0, .regular) }
        }
        lastLapEnd = totalTime
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
