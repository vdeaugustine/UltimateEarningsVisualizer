//
//  AddAllocationForExpenseView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/10/23.
//

import SwiftUI
import AlertToast

// MARK: - AddAllocationForExpenseView

struct AddAllocationForExpenseView: View {
    let expense: Expense

    @State private var selectedSource: String = "shifts"

    @ObservedObject private var user: User = .main
    
    @State private var showShiftSheet = false
    @State var selectedIndex: Int = 0
    

    var body: some View {
        Form {
            if selectedSource == "shifts" {
                ForEach(user.getShifts().filter { $0.totalAvailable >= 0.01 }) { shift in

                    NavigationLink {
                        ShiftAllocSheet(shift: shift, expense: expense)
                    } label: {
                        HStack {
                            DateCircle(date: shift.start, height: 35)

                            VStack(alignment: .leading) {
                                Text(shift.duration.formatForTime() + " shift")
                                    .foregroundColor(.primary)
                            }
                            Spacer()

                            Text(shift.totalAvailable.formattedForMoney())
                                .fontWeight(.semibold)

                                .foregroundStyle(user.getSettings().getDefaultGradient())
                        }
                        
                    }
                    .allPartsTappable()
                    
                }
            }

            if selectedSource == "saved" {
                ForEach(user.getSaved().filter { $0.totalAvailable >= 0.01 }) { saved in

                    NavigationLink {
                        SavedAllocSheet(saved: saved, expense: expense)
                    } label: {
                        HStack {
                            DateCircle(date: saved.getDate(), height: 35)

                            VStack(alignment: .leading) {
                                Text(saved.getTitle())
                                    .foregroundColor(.primary)
                            }
                            Spacer()

                            Text(saved.totalAvailable.formattedForMoney())
                                .fontWeight(.semibold)

                                .foregroundStyle(user.getSettings().getDefaultGradient())
                        }
                    }
                    .allPartsTappable()
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Allocate Money")
        .safeAreaInset(edge: .top) {
            Picker("Source", selection: $selectedSource) {
                Text("Shifts").tag("shifts")
                Text("Saved Items").tag("saved")

            }.pickerStyle(.segmented).padding([.horizontal, .top])
                .background(Color.listBackgroundColor)
        }
        
    }

    struct ShiftAllocSheet: View {
        @ObservedObject private var user = User.main
        @ObservedObject private var settings = User.main.getSettings()
        @State private var amount: Double = 0
        let shift: Shift
        let expense: Expense
        
        var range: ClosedRange<Double> {
            0.01 ... min(shift.totalAvailable, expense.amountRemainingToPayOff)
        }
        
        @State private var showToast = false
        @State private var toastConfig: AlertToast = .errorWith(message: "")
        @Environment (\.dismiss) private var dismiss

        var body: some View {
            VStack {
                
                
                
                HStack {
                    VStack {
                        Text("Available")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(shift.totalAvailable.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                    
                    Divider().padding(.vertical)
                    
                    VStack {
                        Text("Remaining")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(expense.amountRemainingToPayOff.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                    
                    Divider().padding(.vertical)
                    
                    VStack {
                        Text("Allocate")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(amount.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                }
                .frame(height: 80)
        
                
                if  expense.amountRemainingToPayOff.roundTo(places: 2) >= 0.01,
                    shift.totalAvailable.roundTo(places: 2) >= 0.01 {
                    Slider(value: $amount, in: range, step: 0.01) {
                        Text("Set Amount")
                    } minimumValueLabel: {
                        Text(range.lowerBound.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                    } maximumValueLabel: {
                        Text(range.upperBound.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                    } 
                    .padding()
                }

                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Color.listBackgroundColor }
            .putInTemplate()
            .navigationTitle("Shift for " + shift.start.getFormattedDate(format: .abreviatedMonth))
            .toast(isPresenting: $showToast, alert: {toastConfig} )
            .bottomButton(label: "Save") {
                do {
                    try Allocation(amount: amount, expense: expense, goal: nil, shift: shift, saved: nil, date: .now, context: user.getContext())
                    toastConfig = .successWith(message: "Successfully saved")
                    showToast.toggle()
                }
                catch {
                    toastConfig = .errorWith(message: "Error saving Allocation.")
                    showToast.toggle()
                }
            }
        }
    }
    
    struct SavedAllocSheet: View {
        @ObservedObject private var user = User.main
        @ObservedObject private var settings = User.main.getSettings()
        @State private var amount: Double = 0
        let saved: Saved
        let expense: Expense
        
        var range: ClosedRange<Double> {
            0.01 ... min(saved.totalAvailable, expense.amountRemainingToPayOff)
        }
        
        @State private var showToast = false
        @State private var toastConfig: AlertToast = .errorWith(message: "")
        @Environment (\.dismiss) private var dismiss

        var body: some View {
            VStack {
                
                
                
                HStack {
                    VStack {
                        Text("Available")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(saved.totalAvailable.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                    
                    Divider().padding(.vertical)
                    
                    VStack {
                        Text("Remaining")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(expense.amountRemainingToPayOff.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                    
                    Divider().padding(.vertical)
                    
                    VStack {
                        Text("Allocate")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(amount.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                }
                .frame(height: 80)
        
                
                if  expense.amountRemainingToPayOff.roundTo(places: 2) >= 0.01,
                   saved.totalAvailable.roundTo(places: 2) >= 0.01 {
                    Slider(value: $amount, in: range, step: 0.01) {
                        Text("Set Amount")
                    } minimumValueLabel: {
                        Text(range.lowerBound.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                    } maximumValueLabel: {
                        Text(range.upperBound.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                    }
                    .padding()
                }

                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Color.listBackgroundColor }
            .putInTemplate()
            .navigationTitle("Shift for " + saved.getDate().getFormattedDate(format: .abreviatedMonth))
            .toast(isPresenting: $showToast, alert: {toastConfig} )
            .bottomButton(label: "Save") {
                do {
                    try Allocation(amount: amount, expense: expense, goal: nil, shift: nil, saved: saved, date: .now, context: user.getContext())
                    toastConfig = .successWith(message: "Successfully saved")
                    showToast.toggle()
                }
                catch {
                    toastConfig = .errorWith(message: "Error saving Allocation.")
                    showToast.toggle()
                }
            }
        }
    }
}

// MARK: - AddAllocationForExpenseView_Previews

struct AddAllocationForExpenseView_Previews: PreviewProvider {
    static var previews: some View {
//        AddAllocationForExpenseView(expense: User.main.getExpenses().first!)
//            .putInNavView(.inline)

        AddAllocationForExpenseView.ShiftAllocSheet(shift: User.main.getShifts().first!, expense: User.main.getExpenses().first!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
