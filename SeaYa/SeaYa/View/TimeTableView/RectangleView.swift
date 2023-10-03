//
//  RectangleView.swift
//  SeaYa
//
//  Created by Kihyun Roh on 2023/08/07.
//

import SwiftUI

struct RectangleView: View {
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    var xArray: [CGFloat]
    var yArray: [CGFloat]
    var width: CGFloat?
    var height: CGFloat?
    var isSelected: Bool?

    var body: some View {
        Canvas { context, _ in
            if let start = startPoint, let end = endPoint {
                let lineWidth = 4
                var startx = xArray.filter { $0 < (start.x) }.max() ?? 0
                var starty = yArray.filter { $0 < (start.y) }.max() ?? 0
                var endx = xArray.filter { $0 < (end.x) }.max() ?? 0
                var endy = yArray.filter { $0 < (end.y) }.max() ?? 0
                if endx >= startx {
                    endx += width ?? CGFloat(0)
                } else {
                    startx += width ?? CGFloat(0)
                }
                if endy >= starty {
                    endy += height ?? CGFloat(0)
                } else {
                    starty += height ?? CGFloat(0)
                }
                let rect = CGRect(
                    x: min(startx, endx) + CGFloat(lineWidth) / 2,
                    y: min(starty, endy) + CGFloat(lineWidth) / 2,
                    width: abs(endx - startx) - CGFloat(lineWidth),
                    height: abs(endy - starty) - CGFloat(lineWidth)
                )
                context.stroke(Path(rect), with: .color(.black), lineWidth: CGFloat(lineWidth))
                context.fill(Path(rect), with: .color(isSelected ?? true ? .whiteColor : .primary_selectedColor))
            }
        }
    }
}

struct RectangleTestView: View {
    @State private var startPoint: CGPoint? = nil
    @State private var endPoint: CGPoint? = nil
    var body: some View {
        VStack {
            RectangleView(startPoint: startPoint, endPoint: endPoint,
                          xArray: Array(stride(from: 0, to: 600, by: 20)),
                          yArray: Array(stride(from: 0, to: 600, by: 60)),
                          width: 20,
                          height: 60)
        }.gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    startPoint = value.startLocation
                    endPoint = value.location
                }
                .onEnded { _ in
                    startPoint = nil
                    endPoint = nil
                }
        )
    }
}

#Preview("Light Mode"){
    RectangleTestView()
}

#Preview("Dark Mode"){
    RectangleTestView()
        .preferredColorScheme(.dark)
}
