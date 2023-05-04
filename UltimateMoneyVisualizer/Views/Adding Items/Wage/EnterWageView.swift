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
    @State private var hourlyWage: String = User.main.getWage().hourly.simpleStr()
    @State private var isSalaried: Bool = false
    @State private var salary: String = ""
    @State private var hoursPerWeek: String = ""
    @State private var vacationDays: String = ""
    @State private var calculatedHourlyWage: Double?

    @State private var showErrorToast: Bool = false

    @State private var errorMessage: String = ""
    @State private var showSuccessfulSaveToast = false

    @ObservedObject private var user: User = User.main
    @ObservedObject private var wage = User.main.getWage()
    @ObservedObject private var settings = User.main.getSettings()

    @State private var hoursPerDay: Double = User.main.getWage().hoursPerDay
    @State private var daysPerWeek: Int = Int(User.main.getWage().daysPerWeek)
    @State private var weeksPerYear: Int = Int(User.main.getWage().weeksPerYear)
    let hoursOptions = stride(from: 1.0, to: 24.25, by: 0.5).map({$0})


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
                Picker("Hours Per Day", selection: $hoursPerDay) {
                    ForEach(hoursOptions, id: \.self) { num in
                        Text(num.simpleStr())
                            .tag(num)
                    }
                }
                Picker("Days Per Week", selection: $daysPerWeek) {
                    ForEach(1 ..< 8, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }
                Picker("Weeks Per Year", selection: $weeksPerYear) {
                    ForEach(1 ..< 53, id: \.self) { num in
                        Text(num.str)
                            .tag(num)
                    }
                }

            } header: {
                Text("Calculation Assumptions")
            } footer: {
                Text("When calculating daily, weekly, monthly, and yearly, these values will be used respectively")
            }
            
//            Section {
//                Button("Save") {
//
//                }
//            }
        }
        .putInTemplate()
        .navigationTitle("Enter Hourly Wage")
        .toast(isPresenting: $showErrorToast, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(.blue), title: errorMessage)
        } onTap: {
            showErrorToast = false
        }
        .toast(isPresenting: $showSuccessfulSaveToast, offsetY: -100) {
            AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: "Wage saved successfully", style: .style(backgroundColor: .white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil))
        }
        .bottomButton(label: "Save", gradient: settings.getDefaultGradient()) {
            guard let dub = Double(hourlyWage) else {
                showErrorToast = true
                errorMessage = "Please enter a valid hourly wage"
                return
            }

            do {

                let wage = try Wage(amount: dub, user: user, context: viewContext)
                wage.daysPerWeek = Double(daysPerWeek)
                wage.hoursPerDay = Double(hoursPerDay)
                wage.weeksPerYear = Double(weeksPerYear)

                try viewContext.save()
                showSuccessfulSaveToast = true
            } catch {
                fatalError(String(describing: error))
            }
        }
    }
}

// MARK: - EnterWageView_Previews

struct EnterWageView_Previews: PreviewProvider {
    static var previews: some View {
        EnterWageView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
