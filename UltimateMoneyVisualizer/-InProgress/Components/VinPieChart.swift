////
////  VinPieChart.swift
////  UltimateMoneyVisualizer
////
////  Created by Vincent DeAugustine on 6/6/23.
////
//
//import SwiftUI
//
//import SwiftUI
//
//struct PieChartView: View {
//    public let values: [Double]
//    public var colors: [Color]
//    public let names: [String]
//    
//    public var backgroundColor: Color
//    public var innerRadiusFraction: CGFloat
//    
//    var slices: [PieSliceData] {
//        let sum = values.reduce(0, +)
//        var endDeg: Double = 0
//        var tempSlices: [PieSliceData] = []
//        
//        for (i, value) in values.enumerated() {
//            let degrees: Double = value * 360 / sum
//            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
//            endDeg += degrees
//        }
//        return tempSlices
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack{
//                ZStack{
//                    ForEach(0..<self.values.count){ i in
//                        PieSliceView(pieSliceData: self.slices[i])
//                    }
//                    .frame(width: geometry.size.width, height: geometry.size.width)
//                    
//                    Circle()
//                        .fill(self.backgroundColor)
//                        .frame(width: geometry.size.width * innerRadiusFraction, height: geometry.size.width * innerRadiusFraction)
//                    
//                    VStack {
//                        Text("Total")
//                            .font(.title)
//                            .foregroundColor(Color.gray)
//                        Text(String(values.reduce(0, +)))
//                            .font(.title)
//                    }
//                }
//                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { String($0) }, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
//            }
//            .background(self.backgroundColor)
//            .foregroundColor(Color.white)
//        }
//    }
//}
//
//struct PieChartRows: View {
//    var colors: [Color]
//    var names: [String]
//    var values: [String]
//    var percents: [String]
//    
//    var body: some View {
//        VStack{
//            ForEach(0..<self.values.count){ i in
//                HStack {
//                    RoundedRectangle(cornerRadius: 5.0)
//                        .fill(self.colors[i])
//                        .frame(width: 20, height: 20)
//                    Text(self.names[i])
//                    Spacer()
//                    VStack(alignment: .trailing) {
//                        Text(self.values[i])
//                        Text(self.percents[i])
//                            .foregroundColor(Color.gray)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct PieChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartView(values: [1300, 500, 300], colors: [Color.blue, Color.green, Color.orange], names: ["Rent", "Transport", "Education"], backgroundColor: Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), innerRadiusFraction: 0.6)
//    }
//}
//
//struct VinPieChart: View {
//    var body: some View {
//        Canvas {
//            
//        }
//
//    }
//}
//
//struct VinPieChart_Previews: PreviewProvider {
//    static var previews: some View {
//        VinPieChart()
//    }
//}
