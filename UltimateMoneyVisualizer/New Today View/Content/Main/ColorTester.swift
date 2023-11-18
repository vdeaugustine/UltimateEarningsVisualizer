//
//  ColorTester.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/20/23.
//

import SwiftUI


struct ColorTester: View {
    @State private var baseColor = Color.red
    @State private var triadicColors: [(hue: Double, saturation: Double, brightness: Double)] = []
    
    var body: some View {
        VStack {
            Circle()
                .fill(baseColor)
                .frame(width: 100, height: 100)
                .padding()
                .onTapGesture {
                    withAnimation {
                        triadicColors = generateTriadicColors(baseColor: baseColor)
                    }
                    print(baseColor)
                }
            
            ColorPicker("", selection: $baseColor)
                .padding()
            
            HStack {
                ForEach(triadicColors.indices, id: \.self) { index in
                    let colorData = triadicColors[index]
                    let color = Color(hue: colorData.hue, saturation: colorData.saturation, brightness: colorData.brightness)
                    Circle()
                        .fill(color)
                        .frame(width: 60, height: 60)
                        .onAppear(perform: {
                            print(color)
                            print(baseColor)
                        })
                        .onTapGesture {
                            print(color)
                        }
                }
            }
        }
        .onAppear {
            triadicColors = generateTriadicColors(baseColor: baseColor)
        }
        .onChange(of: baseColor) { newValue in
            withAnimation {
                triadicColors = generateTriadicColors(baseColor: newValue)
            }
        }
    }
    
    func generateTriadicColors(baseColor: Color) -> [(hue: Double, saturation: Double, brightness: Double)] {
        let baseHSB = baseColor.hsb
        
        let lowerHue = (baseHSB.hue - (1.0/3.0) + 1).truncatingRemainder(dividingBy: 1)
        let higherHue = (baseHSB.hue + (1.0/3.0)).truncatingRemainder(dividingBy: 1)
        
        print(lowerHue)
        return [(lowerHue, baseHSB.saturation, baseHSB.brightness), (higherHue, baseHSB.saturation, baseHSB.brightness)]
    }
}

// Extension to extract HSB from Color
extension Color {
    var hsb: (hue: Double, saturation: Double, brightness: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var br: CGFloat = 0
        
        UIColor(red: r, green: g, blue: b, alpha: 1.0).getHue(&h, saturation: &s, brightness: &br, alpha: &a)
        
        return (hue: Double(h), saturation: Double(s), brightness: Double(br))
    }
}

struct ColorTester_Previews: PreviewProvider {
    static var previews: some View {
        ColorTester()
    }
}

