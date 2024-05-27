//
//  EnterDoubleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/15/23.
//

import SwiftUI

// MARK: - EnterMoneyView

struct EnterMoneyView: View {
    
    @Environment (\.dismiss) private var dismiss
    
    @Binding var dubToEdit: Double
    @State private var enteredStr: String = "0"
    @ObservedObject private var settings = User.main.getSettings()
    
    var width: CGFloat {
        100 / 375 * UIScreen.main.bounds.width
    }
    
    var height: CGFloat {
        75 / 375 * UIScreen.main.bounds.width
    }

    var dubValue: Double {
        guard let double = Double(enteredStr) else { return dubToEdit }
        return double / 100
    }

    var moneyString: String {
        return dubValue.money(trimZeroCents: false)

    }
    
    func append(_ num: Int) {
        if enteredStr.count < 14 {
            enteredStr += "\(num)"
        }
    }

    var body: some View {
        VStack {
            Text(moneyString)
                .font(.system(size: 55))
                .fontWeight(.bold)
                .foregroundStyle(settings.getDefaultGradient())
                .padding(.bottom)
                .lineLimit(1)
                .minimumScaleFactor(0.06)
                .padding(.horizontal)

            HStack {
                ForEach (1 ... 3, id: \.self) { num in
                    Button {
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

            HStack {
                ForEach (4 ... 6, id: \.self) { num in
                    Button {
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

            HStack {
                ForEach (7 ... 9, id: \.self) { num in
                    Button {
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

            HStack {
                Button {
                    enteredStr = ""
                } label: {
                    Image(systemName: "clear")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: width, height: 75)
                        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
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
            Color.secondarySystemBackground
        }
        .foregroundStyle(settings.getDefaultGradient())
        .onChange(of: enteredStr) { newValue in
            if newValue.isEmpty {
                enteredStr = "0"
            }
        }
        .toolbarSave {
            dubToEdit = dubValue
            dismiss()

        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        
        .navigationTitle("Edit Amount")
        .putInTemplate()
        .putInNavView(.inline)
        .presentationDetents([.fraction(0.85)])
        
    }
}

// MARK: - EnterMoneyView_Previews

struct EnterMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        EnterMoneyView(dubToEdit: .constant(19))
//            .putInNavView(.inline)
    }
}
