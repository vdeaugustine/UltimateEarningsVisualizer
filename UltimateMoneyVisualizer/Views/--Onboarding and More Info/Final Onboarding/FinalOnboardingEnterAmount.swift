//
//  FinalOnboardingEnterAmount.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/1/23.
//

import SwiftUI

struct FinalOnboardingEnterAmount<B>: View where B: View {
    
    @Binding var amount: Double
    var format: Format = .plain
    @ViewBuilder var button: () -> B
    
    enum Format {
        case money
        case percent
        case plain
        
        func formatString(_ str: String) -> String {
            let string = str.isEmpty ? "0" : str
            switch self {
                case .money:
                    return formatAsCurrency(string: string)
                case .percent:
                    return formatAsPercent(string: string)
                case .plain:
                    return string
            }
        }
        
        func formatNum(_ str: String) -> Double {
            let double = Double(str.filter("0123456789".contains)) ?? 0
            switch self {
                case .money:
                    return double / 100
                case .percent:
                    return double / 100
                case .plain:
                    return double
            }
        }
        
        func formatAsPercent (string: String) -> String {
            let numeric = string.filter("0123456789".contains)
            let dub = Double(numeric) ?? 0
            return (dub / 100).simpleStr(2) + " %"
        }
        
        func formatAsCurrency(string: String) -> String {
            let numericString = string.filter("0123456789".contains)
            let intValue = Int(numericString) ?? 0
            let dollars = Double(intValue) / 100.0

            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"

            return formatter.string(from: NSNumber(value: dollars)) ?? "$0.00"
        }
    }
    
    @Environment (\.dismiss) private var dismiss
    @State private var amountStr: String = ""

    func formatAsCurrency(string: String) -> String {
        let numericString = string.filter("0123456789".contains)
        let intValue = Int(numericString) ?? 0
        let dollars = Double(intValue) / 100.0

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        return formatter.string(from: NSNumber(value: dollars)) ?? "$0.00"
    }

    var showingAmount: String {
        format.formatString(amountStr)
    }

    func widthScaler(_ width: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameWidth = geo.size.width
        let coefficient = frameWidth / 393
        return coefficient * width
    }

    func heightScaler(_ height: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameHeight = geo.size.height
        let coefficient = frameHeight / 852
        return coefficient * height
    }

    var keys: [Key] {
        (1 ... 9).map { num in Key(label: "\(num)", action: {
            if amountStr.count < 10 { amountStr += "\(num)" }
        }

        , isNumber: true) } +
            // Non-numbers
            [Key(label: "multiply", action: { amountStr = "" }, isNumber: false),
             Key(label: "0", action: { amountStr += "0" }, isNumber: true),
             Key(label: "delete.left", action: {
                 if !amountStr.isEmpty {
                     amountStr.removeLast()
                 }

             }, isNumber: false)]
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                VStack(spacing: 30) {

                    Spacer()
                        .frame(height: 30)
                    TitleAndContent(geo: geo)
                }
                .padding(.horizontal, widthScaler(24, geo: geo))

                Spacer()

                VStack(spacing: heightScaler(65, geo: geo)) {
                    Text(showingAmount)
                        .font(
                            .system(size: widthScaler(50, geo: geo),
                                    weight: .bold,
                                    design: .rounded)
                        )
                        
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(spacing: heightScaler(40, geo: geo)) {
                        KeypadView(keyHeight: heightScaler(90, geo: geo), keys: keys)

                        Button {
                            amount = format.formatNum(amountStr)
                            dismiss()
                        } label: {
                            button()
                        }
                        .buttonStyle(.plain)
                        
                    }

                }

                
            }
        }

        .background {
            OnboardingBackground()
                .ignoresSafeArea()
        }
        .fontDesign(.rounded)
    }

 

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(40, geo: geo)) {
            Text("Enter amount")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))
        }
    }

    

    
}

#Preview {
    FinalOnboardingEnterAmount(amount: .constant(123), format: .percent) {
        
    }
}
