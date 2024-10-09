import SwiftUI

struct ArcJoin: Shape {
    let cornerRadius: CGFloat = 4
    func path(in rect: CGRect) -> Path {
        var path = Path()
        var x = rect.midX - cornerRadius
        var y = rect.minY
        path.move(to: CGPoint(x: x, y: y))
        y += cornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .zero,
            clockwise: false
        )
        y = rect.maxY - cornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: cornerRadius,
            startAngle: .zero,
            endAngle: .degrees(90),
            clockwise: false
        )
        x = rect.midX + cornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        y = rect.minY + cornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}
