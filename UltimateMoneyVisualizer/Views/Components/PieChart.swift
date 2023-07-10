//
//  PieChart.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI

struct PieChart<LegendAxis: View>: View {
    var title: String? = nil
    var data: [ChartData]
    var separatorColor: Color = .init(UIColor.systemBackground)
    var accentColors: [Color]
    var showTitle: Bool = false
    var showLegend: Bool = true
    var legendAxis: LegendAxis
    
    @State private var currentValue = ""
    @State private var currentLabel = ""
    @State private var touchLocation: CGPoint = .init(x: -1, y: -1)
    
    var pieSlices: [PieSlice] {
        var slices = [PieSlice]()
        data.enumerated().forEach { index, _ in
            let value = normalizedValue(index: index, data: self.data)
            let previousEndDegree = slices.last?.endDegree ?? 0
            slices.append((.init(startDegree: previousEndDegree, endDegree: value * 360 + previousEndDegree)))
        }
        return slices
    }

    var body: some View {
        VStack {
            if let title = title,
               showTitle {
                Text(title)
                    .bold()
                    .font(.largeTitle)
            }

            ZStack {
                GeometryReader { geometry in
                    ForEach(data.indices, id: \.self) { i in
                        PieChartSlice(center: geometry.frame(in: .local).midPoint, radius: geometry.frame(in: .local).width / 2, startDegree: pieSlices[i].startDegree, endDegree: pieSlices[i].endDegree, isTouched: sliceIsTouched(index: i, inPie: geometry.frame(in: .local)), accentColor: accentColors[i], separatorColor: separatorColor)
                    }
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { position in
                            touchLocation = position.location
                            updateCurrentValue(inPie: geometry.frame(in: .local))
                        }
                        .onEnded { _ in
                            resetValues()
                        }
                    )
                }
                .aspectRatio(contentMode: .fit)
                VStack {
                    if !currentLabel.isEmpty {
                        Text(currentLabel)
                            .captionStyle()
                            .background(.white, cornerRadius: 5)
                    }

                    if !currentValue.isEmpty {
                        Text("\(currentValue)")
                            .captionStyle()
                            .background(.white, cornerRadius: 5)
                    }
                }
                .padding()
            }
            if showLegend {
                legendAxis
            }
        }
        .padding()
    }
    
    func updateCurrentValue(inPie pieSize: CGRect) {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return }
        let currentIndex = pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) ?? -1

        currentLabel = data[currentIndex].label
        currentValue = "\(data[currentIndex].value)"
    }

    func resetValues() {
        currentValue = ""
        currentLabel = ""
        touchLocation = .init(x: -1, y: -1)
    }

    func sliceIsTouched(index: Int, inPie pieSize: CGRect) -> Bool {
        guard let angle = angleAtTouchLocation(inPie: pieSize, touchLocation: touchLocation) else { return false }
        return pieSlices.firstIndex(where: { $0.startDegree < angle && $0.endDegree > angle }) == index
    }
}

struct ChartData {
    var label: String
    var value: Double
}


let chartDataSet = [
     ChartData(label: "January 2021", value: 150.32),
     ChartData(label: "February 2021", value: 202.32),
     ChartData(label: "March 2021", value: 390.22),
     ChartData(label: "April 2021", value: 350.0),
     ChartData(label: "May 2021", value: 460.33),
     ChartData(label: "June 2021", value: 320.02),
     ChartData(label: "July 2021", value: 50.98)
]

extension Text {
    func captionStyle() -> some View {
        self
            .font(.caption)
            .bold()
            .foregroundColor(.black)
            .padding(5)
            .shadow(radius: 3)
    }
}



extension CGRect {
    var midPoint: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

let pieColors = [
     Color.init(hex: "#2f4b7c"),
     Color.init(hex: "#003f5c"),
     Color.init(hex: "#665191"),
     Color.init(hex: "#a05195"),
     Color.init(hex: "#d45087"),
     Color.init(hex: "#f95d6a"),
     Color.init(hex: "#ff7c43"),
     Color.init(hex: "#ffa600")
 ]

func normalizedValue(index: Int, data: [ChartData]) -> Double {
    var total = 0.0
    data.forEach { data in
        total += data.value
    }
    return (data[index].value/total).roundTo(places: 2)
}

struct PieSlice {
     var startDegree: Double
     var endDegree: Double
 }


func angleAtTouchLocation(inPie pieSize: CGRect, touchLocation: CGPoint) ->  Double?  {
     let dx = touchLocation.x - pieSize.midX
     let dy = touchLocation.y - pieSize.midY
     
     let distanceToCenter = (dx * dx + dy * dy).squareRoot()
     let radius = pieSize.width/2
     guard distanceToCenter <= radius else {
         return nil
     }
     let angleAtTouchLocation = Double(atan2(dy, dx) * (180 / .pi))
     if angleAtTouchLocation < 0 {
         return (180 + angleAtTouchLocation) + 180
     } else {
         return angleAtTouchLocation
     }
 }

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChart(title: "MyPieChart", data: chartDataSet, separatorColor: Color(UIColor.systemBackground), accentColors: pieColors, legendAxis: VStack(alignment: .leading, spacing: 2) {
            ForEach(chartDataSet.indices, id: \.self) { i in
                HStack {
                    pieColors[i]
                        .frame(width: 10, height: 10)
                        .aspectRatio(contentMode: .fit)
                        .padding(5)

                    Text(chartDataSet[i].label)
                        .font(.caption)
                        .bold()
                }
            }
        })
    }
}

struct PieChartSlice: View {
    
    var center: CGPoint
    var radius: CGFloat
    var startDegree: Double
    var endDegree: Double
    var isTouched:  Bool
    var accentColor:  Color
    var separatorColor: Color
    
    var path: Path {
        var path = Path()
        path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startDegree), endAngle: Angle(degrees: endDegree), clockwise: false)
        path.addLine(to: center)
        path.closeSubpath()
        return path
    }
    
    var body: some View {
        path
            .fill(accentColor)
            .overlay(path.stroke(separatorColor, lineWidth: 2))
            .scaleEffect(isTouched ? 1.05 : 1)
            .animation(Animation.spring(), value: path)
    }
}

//struct PieChartSlice_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartSlice(center: CGPoint(x: 100, y: 200), radius: 300, startDegree: 30, endDegree: 80, isTouched: true, accentColor: .orange, separatorColor: .black)
//    }
//}


