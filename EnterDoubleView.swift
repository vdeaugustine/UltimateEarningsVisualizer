//
//  EnterDoubleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/2/23.
//

import SwiftUI
import AlertToast

// MARK: - EnterDoubleView

struct EnterDoubleView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var dubToEdit: Double
    @State private var enteredStr: String = "0"
    @ObservedObject private var settings = User.main.getSettings()
    @State private var showErrorToast = false

    var format: DoubleType = .dollar

    enum DoubleType {
        case dollar, percent, plain
    }

    var width: CGFloat {
        100 / 375 * UIScreen.main.bounds.width
    }

    var height: CGFloat {
        75 / 375 * UIScreen.main.bounds.width
    }

    var dubValue: Double {
        guard let double = Double(enteredStr)
        else {
            showErrorToast.toggle()
            return dubToEdit
        }

        if format == .dollar {
            return double / 100
        }

        return double
    }

    var formattedString: String {
        switch format {
            case .dollar:
                return dubValue.formattedForMoney(trimZeroCents: false)
            case .percent:
                return enteredStr + "%"
            case .plain:
                return enteredStr
        }
    }

    func append(_ num: Int) {
        if enteredStr.count < 14 {
            enteredStr += "\(num)"
        }
    }

    let numbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    var title: String {
        switch format {
            case .dollar:
                return "Edit Money"
            case .percent:
                return "Edit Percent"
            case .plain:
                return "Edit Amount"
        }
    }

    var body: some View {
        VStack {
            Text(formattedString)
                .font(.system(size: 55))
                .fontWeight(.bold)
                .foregroundStyle(settings.getDefaultGradient())
                .padding(.bottom)
                .lineLimit(1)
                .minimumScaleFactor(0.06)
                .padding(.horizontal)

            ForEach(numbers, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { num in
                        Button {
                            if enteredStr == "0" {
                                enteredStr = ""
                            }
                            append(num)
                        } label: {
                            Text("\(num)")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: width, height: 75)
                                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                        }
                    }
                }
            }

            HStack {
                Button {
                    if formattedString.contains(".") {
                        enteredStr = ""
                    } else {
                        enteredStr += "."
                    }

                } label: {
                    if formattedString.contains(".") {
                        Image(systemName: "clear")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: width, height: 75)
                            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                    } else {
                        Text(".")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: width, height: 75)
                            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))

//                        Image(systemName: "circle.fill")
//                            .font(.system(size: 7))
//                            .fontWeight(.bold)
//                            .padding()
//                            .frame(width: width, height: 75)
//                            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                    }
                }

                Button {
                    enteredStr += "0"
                } label: {
                    Text("0")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: width, height: 75)
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                }

                Button {
                    _ = enteredStr.popLast()
                } label: {
                    Image(systemName: "delete.left")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: width, height: 75)
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                }
            }
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.listBackgroundColor
        }
        .foregroundStyle(settings.getDefaultGradient())
        .onChange(of: enteredStr) { newValue in
            if newValue.isEmpty {
                enteredStr = "0"
            }
        }
        .toast(isPresenting: $showErrorToast, alert: { .errorWith(message: "Error setting value") })
        .navigationTitle(title)
        .putInTemplate()
        .presentationDetents([.fraction(0.85)])
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .tint(Color.white)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    dubToEdit = dubValue
                    dismiss()
                }
                .tint(Color.white)
            }
        }
        .putInNavView(.inline)
    }
}

// MARK: - EnterDoubleView_Previews

struct EnterDoubleView_Previews: PreviewProvider {
    static var previews: some View {
        EnterDoubleView(dubToEdit: .constant(0), format: .dollar)
    }
}