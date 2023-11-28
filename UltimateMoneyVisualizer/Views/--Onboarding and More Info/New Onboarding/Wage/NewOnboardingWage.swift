//
//  NewOnboardingWage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/29/23.
//

import SwiftUI
import PopupView

// MARK: - NewOnboardingWage

struct NewOnboardingWage: View {
    @EnvironmentObject private var vm: OnboardingModel

    enum WageTypeChoice {
        case hourly, salary, none
    }

    @State private var wageType: WageTypeChoice = {
        #if DEBUG
            return .hourly
        #else
            return .none
        #endif
    }()

    @State private var hourlyWage: Double = 20
    @State private var salaryWage: Double = 60_000

    @State private var hoursPerDay: Double = 8
    @State private var daysPerWeek: Int = 5
    @State private var weeksPerYear: Int = 50

    @State private var includeStateTaxes: Bool = false
    @State private var includeFederalTaxes: Bool = false

    @State private var stateTaxPercentage: Double = 7
    @State private var federalTaxPercentage: Double = 19

    @State private var showErrorAlert = false

    @State private var showSheetToEnterWage = false
    @State private var showSheetToEnterSalaryWage = false

    @Environment(\.dismiss) private var dismiss

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
                    .padding(.bottom)
            }
        }
        .fontDesign(.rounded)
        .background {
            Color.listBackgroundColor.ignoresSafeArea()
        }
        .alert("Error saving.", isPresented: $showErrorAlert) {
        } message: {
            Text("Please try again.")
        }
        .popup(isPresented: $showSheetToEnterWage) {
            
            if wageType == .hourly {
                EnterDouble(doubleToEdit: $hourlyWage, maxHeight: 550)
                    .padding(.horizontal)
            }
            else {
                EnterDouble(doubleToEdit: $salaryWage, maxHeight: 550)
                    .padding(.horizontal)
            }
            
            
        } customize: { view in
            view
                .type(.floater(verticalPadding: 110, horizontalPadding: 25, useSafeAreaInset: true))
//                .backgroundColor(.green)
                .position(.center)
                .closeOnTap(false)
                .closeOnTapOutside(true)
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
            Button {
                print("Tapped")
                showSheetToEnterWage = true
            } label: {
                HStack {
                    Text("Per hour")
                    Spacer()
                    Text(hourlyWage.money())
                    Components.nextPageChevron
                }
            }
            .foregroundStyle(.black)
        }
    }

    var salaryWageRow: some View {
        Section("Salary") {
            Button {
                print("Tapped")
                showSheetToEnterWage = true
            } label: {
                HStack {
                    Text("Per year")

                    Spacer()
                    Text(salaryWage.money())
                    Components.nextPageChevron
                }
            }
            .foregroundStyle(.black)
        }
    }

    var detailsSection: some View {
        Section("How much do you work?") {
            Picker("Hours per day", selection: $hoursPerDay) {
                ForEach(hoursOptions, id: \.self) { num in
                    Text(num.simpleStr())
                        .tag(num)
                }
            }
            Picker("Days per week", selection: $daysPerWeek) {
                ForEach(1 ..< 8, id: \.self) { num in
                    Text(num.str)
                        .tag(num)
                }
            }
            Picker("Weeks per year", selection: $weeksPerYear) {
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
            do {
                try Wage(amount: wageType == .hourly ? hourlyWage : salaryWage,
                         isSalary: wageType == .salary,
                         user: vm.user,
                         includeTaxes: includeStateTaxes || includeFederalTaxes,
                         stateTax: stateTaxPercentage,
                         federalTax: federalTaxPercentage,
                         context: vm.user.getContext())
                vm.wageWasSet = true
                vm.increaseScreenNumber()
                dismiss()
            } catch {
                showErrorAlert.toggle()
            }
        }
        .padding(.horizontal, vm.horizontalPad)
    }
}

// MARK: - NewOnboardingWage_Previews

struct NewOnboardingWage_Previews: PreviewProvider {
    static var previews: some View {
        NewOnboardingWage()
            .environmentObject(OnboardingModel())
    }
}
