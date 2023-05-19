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
    @State private var hourlyWageStringEntered: String = ""
    @State private var isSalaried: Bool = false
    @State private var salaryStringEntered: String = ""
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
    let hoursOptions = stride(from: 1.0, to: 24.25, by: 0.5).map { $0 }

    var hourlyFromSalary: Double? {
        guard let initialSalaryValue = Double(salaryStringEntered)

        else { return nil }

        let diviedSalaryValue = initialSalaryValue / 100

        let weeksPerYear = Double(weeksPerYear)
        let workingWeeks = Double(weeksPerYear)
        let totalWorkingHours = workingWeeks * hoursPerDay * Double(daysPerWeek)
        let thisHourlyWage = diviedSalaryValue / totalWorkingHours

        return thisHourlyWage
    }

    private func calculateHourlyWage() {
        guard let salaryValue = Double(salaryStringEntered.prefix(salaryStringEntered.count - 2))
        else { return }

        let weeksPerYear = Double(weeksPerYear)
        let workingWeeks = Double(weeksPerYear)
        let totalWorkingHours = workingWeeks * hoursPerDay * Double(daysPerWeek)
        let thisHourlyWage = salaryValue / totalWorkingHours

        calculatedHourlyWage = thisHourlyWage
    }
    
    private func getHourlyWage(_ salary: Double) -> Double {
        

        let weeksPerYear = Double(weeksPerYear)
        let workingWeeks = Double(weeksPerYear)
        let totalWorkingHours = workingWeeks * hoursPerDay * Double(daysPerWeek)
        let thisHourlyWage = salary / totalWorkingHours

        return thisHourlyWage
    }

    var doubleFromEnteredHourlyWageString: Double {
        if let dub = Double(hourlyWageStringEntered) {
            return dub / 100
        }

        return 0
    }

    var doubleFromEnteredSalaryString: Double {
        if let dub = Double(salaryStringEntered) {
            return dub / 100
        }

        return 0
    }

    var stringOfSalary: String {
        doubleFromEnteredSalaryString.formattedForMoney(trimZeroCents: false).replacingOccurrences(of: "$", with: "")
    }

    var stringOfHourly: String {
        doubleFromEnteredHourlyWageString.formattedForMoney(trimZeroCents: false).replacingOccurrences(of: "$", with: "")
    }

    @State private var showHourlyField = false
    @FocusState var hourlyFieldFocused
    @FocusState var salaryFieldFocused

    @State private var hourlyDouble: Double = User.main.getWage().hourly
    @State private var salaryDouble: Double = User.main.getWage().perYear

    @State private var showHourlySheet = false

    @State private var showSalarySheet = false

    var body: some View {
        Form {
            Section {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                    Text( isSalaried ? getHourlyWage(salaryDouble).formattedForMoney().replacingOccurrences(of: "$", with: "") : hourlyDouble.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                    Spacer()
//                    Button(showHourlyField ? "Done" : "Edit") {
//                        showHourlyField.toggle()
//                        hourlyFieldFocused = showHourlyField
//                    }
                }
                .allPartsTappable()
                .onTapGesture {
                    showHourlySheet = true
                }

                if showHourlyField {
                    TextField("Hourly Wage", text: $hourlyWageStringEntered)
                        .focused($hourlyFieldFocused)
                        .keyboardType(.decimalPad)
                }
            } header: {
                Text("Hourly Wage")
            } footer: {
                Text("Tap to edit")
            }

            Toggle("I have a yearly salary", isOn: $isSalaried)

            if isSalaried {
                Section {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                        Text(salaryDouble.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                        Spacer()
                    }
                    .allPartsTappable()
                    .onTapGesture {
                        showSalarySheet = true
                    }

//                    TextField("Salary", text: $salaryStringEntered)
//
//                        .keyboardType(.decimalPad)
                } header: {
                    Text("Salary")
                } footer: {
                    Text("Tap to edit")
                }

                if let calculatedHourlyWage = hourlyFromSalary {
                    Section {
                        Text("Calculated Hourly Wage: \(String(format: "%.2f", calculatedHourlyWage))")
                        Button("Use Calculated Wage") {
                            hourlyWageStringEntered = "\((calculatedHourlyWage * 100).roundTo(places: 2))"
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
                Button {
                    hoursPerDay = User.main.getWage().hoursPerDay
                    daysPerWeek = Int(User.main.getWage().daysPerWeek)
                    weeksPerYear = Int(User.main.getWage().weeksPerYear)
                } label: {
                    Label("Reset", systemImage: "arrow.uturn.backward")
                        .labelStyle(.titleOnly)
                }

            } header: {
                Text("Calculation Assumptions")
            } footer: {
                Text("When calculating daily, weekly, monthly, and yearly, these values will be used respectively")
            }
        }

        .putInTemplate()
        .navigationTitle("My Wage")
        .toast(isPresenting: $showErrorToast, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(.blue), title: errorMessage)
        } onTap: {
            showErrorToast = false
        }
        .toast(isPresenting: $showSuccessfulSaveToast, offsetY: -100) {
            AlertToast(displayMode: .banner(.slide), type: .complete(.green), title: "Wage saved successfully", style: .style(backgroundColor: .white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil))
        }
        .bottomButton(label: "Save", gradient: settings.getDefaultGradient()) {
//            guard let dub = Double(hourlyWageStringEntered),
//                  dub > 1
//            else {
//                showErrorToast = true
//                errorMessage = "Please enter a valid hourly wage"
//                return
//            }

            do {
                let hourly = isSalaried ? getHourlyWage(salaryDouble) : hourlyDouble
                let wage = try Wage(amount: hourly, user: user, context: viewContext)
                wage.daysPerWeek = Double(daysPerWeek)
                wage.hoursPerDay = Double(hoursPerDay)
                wage.weeksPerYear = Double(weeksPerYear)

                try viewContext.save()
                showSuccessfulSaveToast = true
            } catch {
                fatalError(String(describing: error))
            }
        }
        .sheet(isPresented: $showHourlySheet) {
            EnterMoneyView(dubToEdit: $hourlyDouble)
        }
        .sheet(isPresented: $showSalarySheet) {
            EnterMoneyView(dubToEdit: $salaryDouble)
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
