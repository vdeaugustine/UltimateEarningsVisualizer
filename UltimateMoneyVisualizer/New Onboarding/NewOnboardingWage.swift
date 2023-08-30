//
//  NewOnboardingWage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/29/23.
//

import SwiftUI

// MARK: - NewOnboardingWage

struct NewOnboardingWage: View {
    enum WageTypeChoice {
        case hourly, salary, none
    }

    @State private var wageType: WageTypeChoice = .none
    @State private var hourlyWage: Double = 20
    @State private var salaryWage: Double = 60_000

    @State private var hoursPerDay: Double = 8
    @State private var daysPerWeek: Int = 5
    @State private var weeksPerYear: Int = 50

    @State private var includeStateTaxes: Bool = false
    @State private var includeFederalTaxes: Bool = false

    @State private var stateTaxPercentage: Double = 7
    @State private var federalTaxPercentage: Double = 19

    let hoursOptions = stride(from: 1.0, to: 24.25, by: 0.5).map { $0 }
    
    var minimalRequiredDataEntered: Bool {
        wageType != .none && (hourlyWage > 0 || salaryWage > 0)
    }

    var body: some View {
        VStack {
            Form {
                Section("Wage Type") {
                    typePicker
                }

                if wageType == .hourly {
                    hourlyWageRow
                }

                if wageType == .salary {
                    salaryWageRow
                    detailsSection
                }

                if wageType != .none {
                    Section("Include taxes in earnings calculations") {
                        taxesToggle
                    }
                }

                
                if includeStateTaxes && wageType != .none {
                    stateTaxRow
                }
                
                if includeFederalTaxes && wageType != .none {
                    federalTaxRow
                }
                
                
            }
            
            if minimalRequiredDataEntered {
                saveButton
            }
        }
        .background {
            Color.listBackgroundColor
        }
    }

    var typePicker: some View {
        Picker("Pick one", selection: $wageType) {
            Text("None").tag(WageTypeChoice.none)
            Divider()
            Text("Hourly").tag(WageTypeChoice.hourly)
            Text("Salary").tag(WageTypeChoice.salary)
        }
    }

    var hourlyWageRow: some View {
        Section("Wage") {
            HStack {
                Text("Per hour")
                Spacer()
                Text(hourlyWage.money())
                Components.nextPageChevron
            }
        }
    }

    var salaryWageRow: some View {
        Section("Salary") {
            HStack {
                Text("Per year")

                Spacer()
                Text(salaryWage.money())
                Components.nextPageChevron
            }
        }
    }

    var detailsSection: some View {
        Section("How much do you work?") {
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
        }
    }

    var taxesToggle: some View {
        Group {
            Toggle("State", isOn: $includeStateTaxes)
            Toggle("Federal", isOn: $includeFederalTaxes)
        }
    }

    var stateTaxRow: some View {
        Section("State Tax") {
            Menu {
                Button("Enter manually") {
                }

                Button("Calculate for me") {
                }

            } label: {
                HStack {
                    Text("Percentage of income")
                    Spacer()
                    Text("\(stateTaxPercentage.simpleStr(1, false))%")
                    Components.nextPageChevron
                }
                .foregroundStyle(Color.black)
            }
        }
    }

    var federalTaxRow: some View {
        Section("Federal Tax") {
            Menu {
                Button("Enter manually") {
                }

                Button("Calculate for me") {
                }

            } label: {
                HStack {
                    Text("Percentage of income")
                    Spacer()
                    Text("\(federalTaxPercentage.simpleStr(1, false))%")
                    Components.nextPageChevron
                }
                .foregroundStyle(Color.black)
            }
        }
    }
    
    var saveButton: some View {
        OnboardingButton(title: "Save") {
            
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - NewOnboardingWage_Previews

struct NewOnboardingWage_Previews: PreviewProvider {
    static var previews: some View {
        NewOnboardingWage()
    }
}
