//
//  GPTPieChart.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/8/23.
//

import SwiftUI

// MARK: - GPTPieChart

struct GPTPieChart: View {
    var pieChartData: [PieSliceData]
    func percentage(for datum: PieSliceData) -> Double {
        let total = pieChartData.reduce(Double.zero) { $0 + $1.amount }
        return datum.amount / total
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 20) {
                ZStack {
                    ForEach(self.pieChartData.indices, id: \.self) { index in

                        if let datum = pieChartData.safeGet(at: index) {
                            let startAngle = self.angle(for: self.startPercentage(at: index))
                            let endAngle = self.angle(for: self.endPercentage(at: index))
                            PieSliceView(pieSliceData: datum,
                                         startAngle: startAngle,
                                         endAngle: endAngle,
                                         color: datum.color)
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                LegendView(pieChartData: pieChartData, width: geo.size.width)
            }
        }
    }

    func startPercentage(at index: Int) -> Double {
        if index == 0 {
            return 0
        }

        var total = 0.0
        for i in 0 ..< index {
            total += percentage(for: pieChartData[i])
        }

        return total
    }

    func endPercentage(at index: Int) -> Double {
        return startPercentage(at: index) + percentage(for: pieChartData[index])
    }

    func angle(for percentage: Double) -> Angle {
        Angle(degrees: 360 * percentage - 90)
    }

    struct LegendView: View {
        var pieChartData: [PieSliceData]
        let width: CGFloat
        let columns = [GridItem(.adaptive(minimum: 100))]

        var body: some View {
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach(pieChartData.indices, id: \.self) { index in
                    if let datum = pieChartData.safeGet(at: index) {
                        HStack {
                            Circle()
                                .fill(datum.color)
                                .frame(width: width / 20,
                                       height: width / 20)
                            Text(datum.name).minimumScaleFactor(0.05)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    struct PieSliceView: View {
        var pieSliceData: PieSliceData
        var startAngle: Angle
        var endAngle: Angle
        let color: Color

        var body: some View {
            GeometryReader { geometry in
                Path { path in
                    let width: CGFloat = min(geometry.size.width,
                                             geometry.size.height)
                    let height = width
                    let center = CGPoint(x: width / 2,
                                         y: height / 2)
                    let radius = min(width,
                                     height) / 2

                    path.addArc(center: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: false)
                    path.addLine(to: center)
                }
                .fill(color)
            }
        }
    }

    struct PieSliceData: Identifiable {
        let id = UUID()
        var color: Color
        var name: String
        var amount: Double

        init(color: Color, name: String, amount: Double) {
            self.color = color
            self.name = name
            self.amount = amount
        }

        init(name: String, amount: Double) {
            self.color = .defaultColorOptions.randomElement()!
            self.name = name
            self.amount = amount
        }
    }
}

// MARK: - GPTPieChart_Previews

struct GPTPieChart_Previews: PreviewProvider {
    static var previews: some View {
        GPTPieChart(
            pieChartData: [.init(color: .defaultColorOptions[0],
                                 name: "First",
                                 amount: 500),
                           .init(color: .defaultColorOptions[1],
                                 name: "Second",
                                 amount: 90),
                           .init(color: .defaultColorOptions[4],
                                 name: "Third",
                                 amount: 83),
                           .init(color: .defaultColorOptions[3],
                                 name: "Fourth",
                                 amount: 120)]
        )
        .frame(height: 250)
    }
}
