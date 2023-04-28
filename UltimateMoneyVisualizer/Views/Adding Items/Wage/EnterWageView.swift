//
//  EnterWageView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI

// MARK: - EnterWageView

struct EnterWageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var hourlyWage: String = ""
    @State private var isSalaried: Bool = false
    @State private var salary: String = ""
    @State private var hoursPerWeek: String = ""
    @State private var vacationDays: String = ""
    @State private var calculatedHourlyWage: Double?

    @State private var showErrorToast: Bool = false

    @State private var errorMessage: String = ""
    @State private var showSuccessfulSaveToast = false

    @FetchRequest(sortDescriptors: []) var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) var wages: FetchedResults<Wage>

    private func calculateHourlyWage() {
        guard let salaryValue = Double(salary),
              let hoursPerWeekValue = Double(hoursPerWeek),
              let vacationDaysValue = Double(vacationDays) else { return }

        let weeksPerYear = 52.0
        let vacationWeeks = vacationDaysValue / 5.0
        let workingWeeks = weeksPerYear - vacationWeeks
        let totalWorkingHours = workingWeeks * hoursPerWeekValue
        let hourlyWage = salaryValue / totalWorkingHours

        calculatedHourlyWage = hourlyWage
    }

    private func populateHourlyWage() {
        if let calculatedHourlyWage = calculatedHourlyWage {
            hourlyWage = String(format: "%.2f", calculatedHourlyWage)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Hourly Wage", text: $hourlyWage)
                        .keyboardType(.decimalPad)
                }

                Toggle("I have a salary", isOn: $isSalaried)

                if isSalaried {
                    Section(header: Text("Salary Information")) {
                        TextField("Salary", text: $salary)
                            .keyboardType(.decimalPad)
                        TextField("Hours per Week", text: $hoursPerWeek)
                            .keyboardType(.decimalPad)
                        TextField("Vacation Days", text: $vacationDays)
                            .keyboardType(.decimalPad)

                        Button("Calculate Hourly Wage") {
                            calculateHourlyWage()
                        }
                    }

                    if let calculatedHourlyWage = calculatedHourlyWage {
                        Section {
                            Text("Calculated Hourly Wage: \(String(format: "%.2f", calculatedHourlyWage))")
                            Button("Use Calculated Wage") {
                                populateHourlyWage()
                            }
                        }
                    }
                }

                Section {
                    Button("Save") {
                        guard let dub = Double(hourlyWage) else {
                            showErrorToast = true
                            errorMessage = "Please enter a valid hourly wage"
                            return
                        }

                        do {
                            wages.forEach { viewContext.delete($0) }

                            let wage = Wage(context: viewContext)
                            wage.amount = dub
                            wage.user = user.first
                            user.first?.wage = wage

                            try viewContext.save()
                            showSuccessfulSaveToast = true
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .navigationTitle("Enter Hourly Wage")
            .toast(isPresenting: $showErrorToast, duration: 2, tapToDismiss: true) {
                AlertToast(displayMode: .alert, type: .error(.blue), title: errorMessage)
            } onTap: {
                showErrorToast = false
            }
            .toast(isPresenting: $showSuccessfulSaveToast, offsetY: -100) {
                AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: "Wage saved successfully", style: .style(backgroundColor: .white, titleColor: .red, subTitleColor: nil, titleFont: nil, subTitleFont: nil))
            }
        }
    }
}

// MARK: - EnterWageView_Previews

struct EnterWageView_Previews: PreviewProvider {
    static var previews: some View {
        EnterWageView()
            .environment(\.managedObjectContext, PersistenceController.context)
            
    }
}
