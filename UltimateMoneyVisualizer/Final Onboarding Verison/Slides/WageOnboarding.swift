//
//  WageOnboarding.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/15/23.
//

import SwiftUI
import Vin

struct WageOnboarding: View {
    // MARK: - SwipingWageSection

    // MARK: State

    @State private var showSheet = false

    // MARK: Binding

    @Binding var tab: Int

    let totalSlides: Int

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    ZStack {
                        let width = geo.size.width
                        let height = geo.size.height
                        let startX = CGFloat(0)
                        let startY = CGFloat(CGFloat(height / 4 + 20) * (height / 759))
                        let endY = startY
                        let start = CGPoint(x: startX, y: startY)
                        let end = CGPoint(x: width, y: endY)
                        let controlPoint = CGPoint(x: width / 2, y: endY + (130 * (height / 759)))

                        Path { path in
                            path.move(to: start)
                            path.addQuadCurve(to: end,
                                              control: controlPoint)
                            path.addLine(to: CGPoint(x: width, y: 0))
                            path.addLine(to: .zero)
                            path.closeSubpath()
                        }
                        .fill(.tint)

                        #if DEBUG
                            // Make visible if you want to see the control points for designing
                            //                            Circle().frame(width: 10).position(controlPoint)
                        #endif

                        ImageWithCircleForOnboarding(image: "moneyCalendar", size: geo.size)
                            .position(x: geo.frame(in: .global).midX, y: endY)
                    }
                    .frame(height: 350 * (geo.size.height / 759))

                    .ignoresSafeArea()

                    VStack(spacing: 20) {
                        Text("Get Started With Wage")
                            .font(.title)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            .layoutPriority(1.1)

                        VStack(alignment: .leading, spacing: 30 * (geo.size.height / 759)) {
                            Text("Unlock personalized finance insights by entering your wage!")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Get started to see your earnings increase in real time!")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            //                                .foregroundStyle(UIColor.secondaryLabel.color)
                        }
                        .padding(.horizontal, 10)
                        .layoutPriority(1)

                        Spacer()

                        VStack(spacing: 40) {
                            SwipingButton(label: "Enter Wage") {
                                showSheet = true
                            }

                            HStack {
                                ForEach(0 ..< totalSlides, id: \.self) { num in
                                    OnboardingPill(isFilled: num <= tab)
                                }
                            }
                            .frame(maxWidth: geo.size.width * 0.45)
                            .minimumScaleFactor(0.5)
                        }

                        .layoutPriority(0)
                    }

                    .kerning(1)

                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                print(geo.size)
            })
        }
        .sheet(isPresented: $showSheet, content: {
            FinalOnboardingEnteringWageFirstTime(tab: $tab)
        })
    }
}

// MARK: - SwipingEnterWageFirstTimeView

struct FinalOnboardingEnteringWageFirstTime: View {
    @Binding var tab: Int
    @EnvironmentObject var user: User

    enum WageTypeChoice {
        case hourly, salary, none
    }

    @State private var wageType: WageTypeChoice = {
        #if DEBUG
            return .salary
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

    @State private var hourlyWageString = ""
    @State private var yearlySalaryString = ""

    @State private var errorMessage: String? = nil

    @Environment(\.dismiss) private var dismiss

    let hoursOptions = stride(from: 1.0, to: 24.25, by: 0.5).map { $0 }

    var minimalRequiredDataEntered: Bool {
        wageType != .none && (hourlyWage > 0 || salaryWage > 0)
    }

    @FocusState private var salaryFocused: Bool
    @FocusState private var hourlyFocused: Bool
    
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Pick a Wage Type") {
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

                if !salaryFocused && !hourlyFocused {
                    HStack(spacing: 10) {
                        cancelButton
                        if minimalRequiredDataEntered {
                            saveButton
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background {
                UIColor.systemGroupedBackground.color.ignoresSafeArea()
            }
            .alert(errorMessage ?? "Error saving.", isPresented: $showErrorAlert) {
            } message: {
                Text("Please try again.")
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hourlyFocused = false
                        salaryFocused = false
                    }
                }
            }
        }
        
    }

    var typePicker: some View {
        Picker("Wage type", selection: $wageType) {
            Text("Hourly").tag(WageTypeChoice.hourly)
            Text("Salary").tag(WageTypeChoice.salary)
            Divider()
            Text("None").tag(WageTypeChoice.none)
        }
    }

    var hourlyWageRow: some View {
        Section("Wage") {
            HStack {
                TransformingTextField("ex: $20.00",
                                      text: $hourlyWageString,
                                      characterLimit: 10,
                                      TransformingTextField.transformForMoney)
                    .keyboardType(.decimalPad)
                    .focused($hourlyFocused)

                Spacer()

                Text("per hour")
            }
        }
    }

    var salaryWageRow: some View {
        Section("Salary") {
//            HStack {
            HStack {
                TransformingTextField("ex: $45,000",
                                      text: $yearlySalaryString,
                                      characterLimit: 14,
                                      TransformingTextField.transformForMoney)
                    .keyboardType(.decimalPad)
                    .focused($salaryFocused)
                Spacer()
                Text("per year")
            }
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
        .tint(settings.themeColor)
    }

    var stateTaxRow: some View {
        Section("State Tax") {
            Menu {
                Button("Enter manually") {
                    // TODO:
                }

                Button("Calculate for me") {
                    // TODO:
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
                    // TODO:
                }

                Button("Calculate for me") {
                    // TODO:
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
        Button {
            var wage: Double?
            if wageType == .hourly {
                let number = hourlyWageString.filter{ "0123456789.".contains($0) }
                guard let hourly = Double(number) else {
                    if number.isEmpty {
                        errorMessage = "Wage can not be empty"
                    } else {
                        errorMessage = "Could not convert \(number) to a number."
                    }

                    showErrorAlert = true
                    return
                }
                wage = hourly
            } else if wageType == .salary {
                let number = yearlySalaryString.filter{ "0123456789.".contains($0) }
                guard let salary = Double(number) else {
                    if number.isEmpty {
                        errorMessage = "Salary can not be empty"
                    } else {
                        errorMessage = "Could not convert \(number) to a number."
                    }

                    showErrorAlert = true
                    return
                }
                wage = salary
            }

            guard let wage else {
                errorMessage = "Could not convert entered wage to a number."
                showErrorAlert = true
                return
            }

            do {
                try Wage(amount: wage,
                         isSalary: wageType == .salary,
                         user: user,
                         includeTaxes: includeStateTaxes || includeFederalTaxes,
                         stateTax: stateTaxPercentage,
                         federalTax: federalTaxPercentage,
                         context: user.getContext())
                tab += 1
                dismiss()
            } catch {
                showErrorAlert = true
            }

        } label: {
            Text("Save")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundStyle(.white)
                .background {
                    settings.themeColor
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
        }
        .buttonStyle(.plain)
    }

    var cancelButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Cancel")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundStyle(UIColor.darkText.color)
                .background {
                    UIColor.tertiaryLabel.color
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    WageOnboarding(tab: .constant(0), totalSlides: 5)
}
