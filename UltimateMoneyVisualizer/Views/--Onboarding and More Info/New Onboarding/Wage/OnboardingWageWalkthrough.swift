//
//  OnboardingSecondView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/25/23.
//

import SwiftUI

// MARK: - OnboardingWageWalkthrough

struct OnboardingWageWalkthrough: View {
    @EnvironmentObject private var vm: OnboardingModel
    @State private var paymentType: WageType = .salary
    @State private var amount: Double = 110_000
    @State private var showNumberKeyboard = false
    @State private var showWageSheet = false

    var body: some View {
        VStack {
            headerLabel
                .padding(vm.padFromTop)

            Image("clockWithCoins")
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .frame(maxWidth: .infinity, maxHeight: vm.imageHeight)
//                .layoutPriority(2)

            Spacer()

            Text("By entering your wage, you'll gain a deeper understanding of your financial landscape with each passing minute.")
                .font(.title2, design: .rounded)
                .multilineTextAlignment(vm.textAlignment)
            Spacer()

            nextButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 30)
        .padding(.bottom, 50)
        .sheet(isPresented: $showNumberKeyboard, content: {
            EnterDouble(doubleToEdit: $amount)

        })

        .sheet(isPresented: $showWageSheet) {
            NewOnboardingWage()
        }
    }

    var headerLabel: some View {
        Text("Time is Money")
            .font(.system(.largeTitle, weight: .bold))
            .frame(maxWidth: vm.headerMaxWidth)
            .multilineTextAlignment(.center)
    }

    var moneyButton: some View {
        Button {
            showNumberKeyboard.toggle()
        } label: {
            HStack(spacing: 10) {
                Text(amount.money())
                    .font(.system(size: 50, weight: .semibold, design: .default).width(.expanded))
            }
            .foregroundStyle(Color.black)
            .padding()
            .background {
                Color.secondarySystemBackground
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }

    var perYear: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("per")

            Menu {
                Button {
                    paymentType = .salary
                } label: {
                    Label("Year", systemImage: "calendar")
                }

                Button {
                    paymentType = .hourly
                } label: {
                    Label("Hour", systemImage: "clock")
                }

            } label: {
                Text(paymentType == .salary ? "year" : "hour")
                    .padding(20, 5)
                    .background { Color.secondarySystemBackground.clipShape(RoundedRectangle(cornerRadius: 20)) }
            }
        }
        .font(.largeTitle)
    }

    var nextButton: some View {
        OnboardingButton(title: "Enter Wage") {
            showWageSheet.toggle()
        }
    }

    

    struct SizePreference: PreferenceKey {
        static var defaultValue: CGSize = .zero

        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            print("Size:", nextValue())
            value = nextValue()
        }
    }
}

struct EnterDouble: View {
    @Binding var doubleToEdit: Double
    @State private var enteredStr = ""
    @Environment(\.dismiss) private var dismiss
    
    var maxWidth: CGFloat = .infinity
    var maxHeight: CGFloat = .infinity
    var maxSpacerOnTop: CGFloat = 25

    func getWidth(geo: GeometryProxy) -> CGFloat {
        return geo.size.width * 100 / 375
    }

    func getHeight(geo: GeometryProxy) -> CGFloat {
        
        return 0.15 * geo.size.width
    }

    var formattedString: String {
        dubValue.money(trimZeroCents: false)
    }

    var dubValue: Double {
        guard let double = Double(enteredStr)
        else {
            return doubleToEdit
        }

        return double / 100
    }

    @State private var width: CGFloat = 300

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                Spacer()
                    .frame(maxHeight: maxSpacerOnTop)
                Menu {
                    Button {
                        let pasteboard = UIPasteboard.general
                        if let clipboardString = pasteboard.string,
                           let number = Double(clipboardString) {
                            enteredStr = "\(Int(number * 100))"
                            print(enteredStr)
                        }

                    } label: {
                        Label("Paste", systemImage: "doc.on.clipboard")
                    }
                } label: {
                    Text(formattedString)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 50, weight: .semibold, design: .default).width(.expanded))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                        .padding(.bottom)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal)
                }

                VStack {
                    LazyVGrid(columns: GridItem.fixedItems(3, size: getWidth(geo: geo)), spacing: 10) {
                        ForEach(1 ..< 10) { num in
                            Button {
                                enteredStr += "\(num)"
                            } label: {
                                Text("\(num)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: getHeight(geo: geo))
                                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                            }
                        }

                        Button {
                            enteredStr = ""
                        } label: {
                            Image(systemName: "clear")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: getHeight(geo: geo))
                                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                        }

                        Button {
                            enteredStr += "0"
                        } label: {
                            Text("0")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: getHeight(geo: geo))
                                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                        }

                        Button {
                            if !enteredStr.isEmpty {
                                enteredStr.removeLast()
                            }
                        } label: {
                            Image(systemName: "delete.left")
                                .font(.title)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height: getHeight(geo: geo))
                                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                        }
                    }
                    .foregroundStyle(Color.black)

                    Spacer()
                    
                    Button {
                        doubleToEdit = dubValue
                        dismiss()
                    } label: {
                        Text("Enter")
                            .font(.system(.callout, weight: .semibold))
                            .padding()
                            .frame(width: width)
                            .frame(height: 50)

                            .foregroundColor(.white)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.horizontal, 30)
                    }
                }
            }
            .padding(.bottom, geo.size.height * 0.04)
            .presentationDragIndicator(.visible)
        }
        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
        .clipped()
        .onChange(of: enteredStr) { newValue in
            if newValue.isEmpty {
                enteredStr = "0"
            }
        }
        .background { Color.white.modifier(ShadowForRect()) }
    }
}

// MARK: - OnboardingSecondView_Previews

struct OnboardingSecondView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWageWalkthrough()
            .environmentObject(OnboardingModel.shared)
    }
}
