//
//  ClockViewModel.swift
//  MT1.0
//
//  Created by Joseph Wil;liam DeWeese on 9/3/22.
//

import SwiftUI


struct SizeKey: PreferenceKey {
    static let defaultValue: [CGSize] = []
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}
struct ButtonCircle: ViewModifier {
    let isPressed: Bool
    
    func body(content: Content) -> some View {
        let background = Circle()
            .fill()
            .overlay(
                Circle()
                    .fill(Color.white)
                    .opacity(isPressed ? 0.3 : 0)
            )
            .overlay(
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.white)
                    .padding(4)
            )
        let foreground = content
            .fixedSize()
            .padding(15)
            .equalSize()
            .foregroundColor(.white)
        return foreground
            .background(background)
    }
}
struct SizeEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGSize? = nil
}
extension EnvironmentValues {
    var size: CGSize? {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
}
fileprivate struct EqualSize: ViewModifier {
    @Environment(\.size) private var size
    
    func body(content: Content) -> some View {
        content.overlay(GeometryReader { proxy in
            Color.clear.preference(key: SizeKey.self, value: [proxy.size])
        })
        .frame(width: size?.width, height: size?.width)
    }
}
fileprivate struct EqualSizes: ViewModifier {
    @State var width: CGFloat?
    func body(content: Content) -> some View {
        content.onPreferenceChange(SizeKey.self, perform: { sizes in
            self.width = sizes.map { $0.width }.max()
        }).environment(\.size, width.map { CGSize(width: $0, height: $0) })
    }
}

extension View {
    func equalSize() -> some View {
        self.modifier(EqualSize())
    }
    
    func equalSizes() -> some View {
        self.modifier(EqualSizes())
    }
}

struct CircleStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label.modifier(ButtonCircle(isPressed: configuration.isPressed))
    }
}

let formatter: DateComponentsFormatter = {
    let f = DateComponentsFormatter()
    f.allowedUnits = [.minute, .second]
    f.zeroFormattingBehavior = .pad
    return f
}()
let numberFormatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    f.maximumIntegerDigits  = 0
    f.alwaysShowsDecimalSeparator = true
    return f
}()

extension TimeInterval {
    var formatted: String {
        let ms = self.truncatingRemainder(dividingBy: 1)
        return formatter.string(from: self)! + numberFormatter.string(from: NSNumber(value: ms))!
    }
}

extension View {
    func visible(_ v: Bool) -> some View {
        self.opacity(v ? 1 : 0)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    init(center: CGPoint, radius: CGFloat) {
        self = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
    }
}

struct Pointer: Shape {
    var circleRadius: CGFloat = 3
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - circleRadius))
            p.addEllipse(in: CGRect(center: rect.center, radius: circleRadius))
            p.move(to: CGPoint(x: rect.midX, y: rect.midY + circleRadius))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY + rect.height / 5))
        }
    }
}
extension CGPoint {
    init(angle: Angle, distance: CGFloat) {
        self = CGPoint(x:  CGFloat(cos(angle.radians)) * distance, y: CGFloat(sin(angle.radians)) * distance)
    }
    var size: CGSize {
        CGSize(width: x, height: y)
    }
}
struct Labels: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                ForEach(0..<12) { idx in
                    Text("\(idx ==  0  ? 60 :  idx  * 5)")
                        .offset(CGPoint(angle: Angle.degrees(360 * Double(idx)/12-92),
                                        distance:  proxy.size.width).size)
                }
            }
        }
    }
}
struct Ticks: View {
    func tick(at tick: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color.primary)
                .opacity(tick % 20 == 0 ? 1 : 0.4)
                .frame(width: 2, height: tick % 4 == 0 ? 15 : 7)
            Spacer()
        }.rotationEffect(Angle.degrees(Double(tick)/240 * 360))
    }
    var body: some View {
        ForEach(0..<60*4) { tick in
            self.tick(at: tick)
        }
    }
}

