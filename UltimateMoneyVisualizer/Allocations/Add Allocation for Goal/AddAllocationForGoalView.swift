//
//  AddAllocationForSavedView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/10/23.
//

import AlertToast
import SwiftUI

// MARK: - AddAllocationForGoalView

struct AddAllocationForGoalView: View {
    let goal: Goal

    @State private var selectedSource: String = "shifts"

    @ObservedObject private var user: User = .main

    @State private var showShiftSheet = false

    var body: some View {
        VStack(spacing: 0) {
            Picker("Source", selection: $selectedSource) {
                Text("Shifts").tag("shifts")
                Text("Saved Items").tag("saved")

            }
            .pickerStyle(.segmented).padding([.horizontal, .top])
            .background(Color.clear)
            
            Form {
                if selectedSource == "shifts" {
                    ForEach(user.getShifts().filter { $0.totalAvailable >= 0.01 }) { shift in

                        Button {
                            NavManager.shared.appendCorrectPath(newValue: .shiftAllocSheet_Goal(shift, goal))
//                            ShiftAllocSheet(shift: shift, goal: goal)
                        } label: {
                            HStack {
                                DateCircle(date: shift.start, height: 35)

                                VStack(alignment: .leading) {
                                    Text(shift.duration.formatForTime() + " shift")
                                        .foregroundColor(.primary)
                                }
                                Spacer()

                                Text(shift.totalAvailable.money())
                                    .fontWeight(.semibold)

                                    .foregroundStyle(user.getSettings().getDefaultGradient())
                            }
                        }
                        .allPartsTappable()
                    }
                }

                if selectedSource == "saved" {
                    ForEach(user.getSaved().filter { $0.totalAvailable >= 0.01 }) { saved in

                        Button {
                            NavManager.shared.appendCorrectPath(newValue: .savedItemAllocationSheet_Goal(saved, goal))
//                            SavedAllocSheet(saved: saved, goal: goal)
                        } label: {
                            HStack {
                                DateCircle(date: saved.getDate(), height: 35)

                                VStack(alignment: .leading) {
                                    Text(saved.getTitle())
                                        .foregroundColor(.primary)
                                }
                                Spacer()

                                Text(saved.totalAvailable.money())
                                    .fontWeight(.semibold)

                                    .foregroundStyle(user.getSettings().getDefaultGradient())
                            }
                        }
                        .allPartsTappable()
                    }
                }
            }
        }
        .background { Color.listBackgroundColor }
        .putInTemplate()
        .navigationTitle("Allocate Money")
        
    }

    struct ShiftAllocSheet: View {
        @ObservedObject private var user = User.main
        @ObservedObject private var settings = User.main.getSettings()
        @State private var amount: Double = 0
        let shift: Shift
        let goal: Goal

        var range: ClosedRange<Double> {
            guard goal.amountRemainingToPayOff > 0.01,
                  shift.totalAvailable > 0.01
            else { return 0 ... 0.01 }

            return 0.01 ... min(shift.totalAvailable, goal.amountRemainingToPayOff)
        }

        @State private var showToast = false
        @State private var toastConfig: AlertToast = .errorWith(message: "")
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack {
                HStack {
                    VStack {
                        Text("Available")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(shift.totalAvailable.money())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)

                    Divider().padding(.vertical)

                    VStack {
                        Text("Remaining")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(goal.amountRemainingToPayOff.money())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)

                    Divider().padding(.vertical)

                    VStack {
                        Text("Allocate")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(amount.money())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                }
                .frame(height: 80)

                if goal.amountRemainingToPayOff > 0.01,
                   shift.totalAvailable > 0.01 {
                    Slider(value: $amount, in: range, step: 0.01) {
                        Text("Set Amount")
                    } minimumValueLabel: {
                        Text(range.lowerBound.money().replacingOccurrences(of: "$", with: ""))
                    } maximumValueLabel: {
                        Text(range.upperBound.money().replacingOccurrences(of: "$", with: ""))
                    } 
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Color.listBackgroundColor }
            .putInTemplate()
            .navigationTitle("Shift for " + shift.start.getFormattedDate(format: .abbreviatedMonth))
            .toast(isPresenting: $showToast, alert: { toastConfig })
            .bottomButton(label: "Save") {
                do {
                    try Allocation(amount: amount, expense: nil, goal: goal, shift: shift, saved: nil, date: .now, context: user.getContext())
                    toastConfig = .successWith(message: "Successfully saved")
                    showToast.toggle()
                } catch {
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
        let goal: Goal

        var range: ClosedRange<Double> {
            0.01 ... min(saved.totalAvailable, goal.amountRemainingToPayOff)
        }

        @State private var showToast = false
        @State private var toastConfig: AlertToast = .errorWith(message: "")
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            VStack {
                HStack {
                    VStack {
                        Text("Available")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(saved.totalAvailable.money())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)

                    Divider().padding(.vertical)

                    VStack {
                        Text("Remaining")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(goal.amountRemainingToPayOff.money())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)

                    Divider().padding(.vertical)

                    VStack {
                        Text("Allocate")
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(amount.money())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                            .minimumScaleFactor(0.01)
                    }.padding(.horizontal)
                }
                .frame(height: 80)

                if goal.amountRemainingToPayOff.roundTo(places: 2) >= 0.01,
                   saved.totalAvailable.roundTo(places: 2) >= 0.01 {
                    Slider(value: $amount, in: range, step: 0.01) {
                        Text("Set Amount")
                    } minimumValueLabel: {
                        Text(range.lowerBound.money().replacingOccurrences(of: "$", with: ""))
                    } maximumValueLabel: {
                        Text(range.upperBound.money().replacingOccurrences(of: "$", with: ""))
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background { Color.listBackgroundColor }
            .putInTemplate()
            .navigationTitle("Shift for " + saved.getDate().getFormattedDate(format: .abbreviatedMonth))
            .toast(isPresenting: $showToast, alert: { toastConfig })
            .bottomButton(label: "Save") {
                do {
                    try Allocation(amount: amount, expense: nil, goal: goal, shift: nil, saved: saved, date: .now, context: user.getContext())
                    toastConfig = .successWith(message: "Successfully saved")
                    showToast.toggle()
                } catch {
                    toastConfig = .errorWith(message: "Error saving Allocation.")
                    showToast.toggle()
                }
            }
        }
    }
}

// MARK: - AddAllocationForSavedView_Previews

struct AddAllocationForSavedView_Previews: PreviewProvider {
    static var previews: some View {
        AddAllocationForGoalView(goal: User.testing.getGoals().first!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
