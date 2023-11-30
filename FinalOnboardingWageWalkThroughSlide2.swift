//
//  FinalOnboardingWageWalkThroughSlide2.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/28/23.
//

import SwiftUI
import Vin

extension CGPoint {
    func isInside(rect: CGRect) -> Bool {
        return rect.contains(self)
    }
}

#if canImport(UIKit)
    extension View {
        func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
#endif

// MARK: - FinalOnboardingWageWalkThroughSlide2

struct FinalOnboardingWageWalkThroughSlide2: View {
    
    @State private var amount: String = ""
    @State private var textFieldIsFocused = true
    @State private var textFieldFrame: CGRect = .zero
    @State private var tapLocation: CGPoint = .zero

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
        formatAsCurrency(string: amount)
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
            if amount.count < 10 { amount += "\(num)" }
        }

        , isNumber: true) } +
            // Non-numbers
            [Key(label: "multiply", action: { amount = "" }, isNumber: false),
             Key(label: "0", action: { amount += "0" }, isNumber: true),
             Key(label: "delete.left", action: {
                 if !amount.isEmpty {
                     amount.removeLast()
                 }

             }, isNumber: false)]
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                VStack(spacing: 30) {
                    Progress

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

                        ContinueButton
                            .padding(.horizontal, widthScaler(24, geo: geo))
                    }

                }

                
            }
        }

        .background {
            OnboardingBackground()
                .ignoresSafeArea()
        }
    }

    @ViewBuilder var Progress: some View {
        VStack(alignment: .leading, spacing: 20) {
            ProgressBar(percentage: 0.33,
                        height: 8,
                        color: Color.accentColor,
                        barBackgroundColor: UIColor.systemGray4.color,
                        showBackgroundBar: true)
            Text("STEP 1 OF 3")
                .font(.system(.title3, design: .rounded))
        }
    }

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(40, geo: geo)) {
            Text("Enter amount")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

//            VStack {
//                CurrencyTextField(value: $amount, isFocused: $textFieldIsFocused, characterLimit: 12) { field in
//                    field.font = .systemFont(ofSize: 40, weight: .bold)
//
//                }
//                .frame(height: 100)
//                .border(Color.black)
//                .getFrame(in: .global) { frame in
//                    textFieldFrame = frame
//                    print("Text field frame: \(textFieldFrame)")
//                }

//                Spacer()

//            }
        }
    }

    @ViewBuilder var ContinueButton: some View {
        Button {
        } label: {
            Text("Continue")
                .font(.system(.headline, design: .rounded, weight: .regular))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Color.accentColor
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
        }
    }
}

// MARK: - Key

struct Key: Identifiable {
    let id = UUID()
    let label: String
    let action: () -> Void
    let isNumber: Bool
}

struct KeyPadKey: ViewModifier {
    var key: Key
    let height: CGFloat
    func body(content: Content) -> some View {
        Button {
            key.action()
        } label: {
            content
                .font(.largeTitle, design: .rounded /* , weight: .heavy */ )
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: height)
        }
    }
}

// MARK: - SymbolKeyView

struct SymbolKeyView: View {
    let key: Key
    let height: CGFloat
    var body: some View {
        Image(systemName: key.label)
            .modifier(KeyPadKey(key: key, height: height))
    }
}

// MARK: - NumberKeyView

struct NumberKeyView: View {
    let key: Key
    let height: CGFloat
    var body: some View {
        Text(key.label)
            .modifier(KeyPadKey(key: key, height: height))
    }
}

struct KeypadView: View {
    // Define your keys and actions here
    let keyHeight: CGFloat
    var keys: [Key] =
        // Numbers
        (1 ... 9).map { num in Key(label: "\(num)", action: { print("\(num) pressed") }, isNumber: true) } +
        // Non-numbers
        [Key(label: "multiply", action: { print("x pressed") }, isNumber: false),
         Key(label: "0", action: { print("0 pressed") }, isNumber: true),
         Key(label: "delete.left", action: { print("del pressed") }, isNumber: false)]

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 10) {
            ForEach(keys) { key in
                if key.isNumber {
                    NumberKeyView(key: key, height: keyHeight)
                } else {
                    SymbolKeyView(key: key, height: keyHeight)
                }
            }
        }
        .padding(.horizontal)

//        .padding()
    }
}

#Preview {
    FinalOnboardingWageWalkThroughSlide2()
}
