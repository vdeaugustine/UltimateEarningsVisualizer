//
//  OnboardingProgressManagerView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/1/23.
//

import SwiftUI
import Vin

// MARK: - OnboardingProgressManagerViewModel

class OnboardingProgressManagerViewModel: ObservableObject {
    @Published var isWageComplete: Bool = false
    @Published var isShiftComplete: Bool = false
    @Published var isScheduleComplete: Bool = false
    @Published var isExpensesComplete: Bool = false
    @Published var isGoalsComplete: Bool = false
    @Published var isSavedItemComplete: Bool = false

    @Published var pageToShow: Page? = nil

    @ObservedObject var user: User = .main

    enum Page: Identifiable {
        case wage, shift, schedule, expenses, goals, savedItem

        var subheading: String {
            switch self {
                case .wage:
                    "How much you earn"
                case .shift:
                    "How to enter your earnings"
                case .schedule:
                    "The hours you normally work for each day"
                case .expenses:
                    "Tracking when you spend money"
                case .goals:
                    "Working towards something"
                case .savedItem:
                    "A penny saved is a penny earned"
            }
        }

        var id: Page { self }
    }

    func toggle(page: Page) {
        if pageToShow != nil {
            pageToShow = nil
        } else {
            pageToShow = page
        }
    }
}

// MARK: - OnboardingProgressManagerView

struct OnboardingProgressManagerView: View {
    @StateObject private var viewModel = OnboardingProgressManagerViewModel()

    var body: some View {
        ScrollView {
            VStack {
                Earnings()

                Spending()

                totalProgressPills
            }
            .padding(.bottom)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            UIColor.secondarySystemBackground.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
        .sheet(item: $viewModel.pageToShow, content: { page in

            switch page {
                case .wage:
                    EnterWageFirstTimeView()
                default:
                    Text("Error loading view")
            }

        })
        .environmentObject(viewModel)
        .putInTemplate(title: "Getting Started")
    }

    @State private var offset = CGSize.zero

    var totalProgressPills: some View {
        HStack {
            MainProgressPill(isFilled: viewModel.isWageComplete)
            MainProgressPill(isFilled: viewModel.isShiftComplete)
            MainProgressPill(isFilled: viewModel.isScheduleComplete)
            MainProgressPill(isFilled: viewModel.isExpensesComplete)
            MainProgressPill(isFilled: viewModel.isGoalsComplete)
        }
        .padding(.horizontal, 50)
    }

    struct Earnings: View {
        @EnvironmentObject private var viewModel: OnboardingProgressManagerViewModel

        var body: some View {
            VStack(alignment: .leading) {
                header
                rows
            }
            .padding()
        }

        var header: some View {
            HStack {
                Text("Earnings")
                    .font(.title2)
                    .fontWeight(.medium)

                Spacer()

                progressPills
            }
        }

        var rows: some View {
            VStack(alignment: .leading, spacing: 7) {
                Row(isComplete: viewModel.isWageComplete,
                    headText: "Wage",
                    subText: "How much you earn",
                    page: .wage)

                Row(isComplete: viewModel.isShiftComplete,
                    headText: "Shift",
                    subText: "How to enter your earnings",
                    page: .shift)

                Row(isComplete: viewModel.isScheduleComplete,
                    headText: "Work Schedule",
                    subText: "Enter if you have a regular schedule",
                    page: .schedule)

                Row(isComplete: viewModel.isSavedItemComplete,
                    headText: "Saved Item",
                    subText: nil,
                    page: .savedItem)
            }
        }

        var progressPills: some View {
            HStack(spacing: 5) {
                ProgressPill(isFilled: viewModel.isWageComplete)
                ProgressPill(isFilled: viewModel.isShiftComplete)
                ProgressPill(isFilled: viewModel.isScheduleComplete)
            }
        }
    }

    struct Spending: View {
        @EnvironmentObject private var viewModel: OnboardingProgressManagerViewModel
        var body: some View {
            VStack(alignment: .leading) {
                header
                rows
            }
            .padding()
        }

        var header: some View {
            HStack {
                Text("Spending")
                    .font(.title2)
                    .fontWeight(.medium)

                Spacer()

                progressPills
            }
        }

        var rows: some View {
            VStack(alignment: .leading, spacing: 7) {
                Row(isComplete: viewModel.isExpensesComplete,
                    headText: "Expenses",
                    subText: "Tracking when you spend money",
                    page: .expenses)

                Row(isComplete: viewModel.isGoalsComplete,
                    headText: "Goals",
                    subText: "Tracking things you want to save up for",
                    page: .goals)
            }
        }

        var progressPills: some View {
            HStack(spacing: 5) {
                ProgressPill(isFilled: viewModel.isExpensesComplete)
                ProgressPill(isFilled: viewModel.isGoalsComplete)
            }
        }
    }

    struct Row: View {
        @EnvironmentObject private var viewModel: OnboardingProgressManagerViewModel
        let isComplete: Bool
        let headText: String
        let subText: String?
        let page: OnboardingProgressManagerViewModel.Page

        var body: some View {
            Button {
                viewModel.toggle(page: page)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: isComplete ? "checkmark" : "circle")
                        .foregroundStyle(isComplete ? viewModel.user.getSettings().themeColor : .secondary)

                    VStack(alignment: .leading) {
                        Text(headText).font(.headline)
                        Text(subText ?? page.subheading)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Components.nextPageChevron
                }
                .padding()
                .background {
                    UIColor.systemBackground.color
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .buttonStyle(.plain)
        }
    }

    struct ProgressPill: View {
        @EnvironmentObject private var viewModel: OnboardingProgressManagerViewModel
        let isFilled: Bool
        var width: CGFloat = 20
        var height: CGFloat = 7

        var body: some View {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFilled ? viewModel.user.getSettings().themeColor : Color.secondary, lineWidth: 2)
                .frame(width: width, height: height)
                .background(isFilled ? viewModel.user.getSettings().themeColor : .clear)
        }
    }

    struct MainProgressPill: View {
        @EnvironmentObject private var viewModel: OnboardingProgressManagerViewModel
        let isFilled: Bool
        var height: CGFloat = 7
        var body: some View {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFilled ? viewModel.user.getSettings().themeColor : Color.secondary, lineWidth: 2)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(isFilled ? viewModel.user.getSettings().themeColor : .clear)
        }
    }
}

extension OnboardingProgressManagerView {
    struct EnterWageFirstTimeView: View {
        // MARK: - Body

        @EnvironmentObject private var viewModel: OnboardingProgressManagerViewModel

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

                    HStack(spacing: 10) {
                        cancelButton
                        if minimalRequiredDataEntered {
                            saveButton
                        }
                    }
                    .padding(.horizontal)
                }
                .background {
                    UIColor.systemGroupedBackground.color.ignoresSafeArea()
                }
                .alert(errorMessage ?? "Error saving.", isPresented: $showErrorAlert) {
                } message: {
                    Text("Please try again.")
                }
                .navigationTitle("Tracking your earnings")
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

                    Spacer()

                    Text("per hour")
                }
            }
        }

        var salaryWageRow: some View {
            Section("Salary") {
                HStack {
                    TransformingTextField("ex: $45,000",
                                          text: $yearlySalaryString,
                                          characterLimit: 14,
                                          TransformingTextField.transformForMoney)

                    Spacer()
                    Text(yearlySalaryString)
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
            Button {
                var wage: Double?
                if wageType == .hourly {
                    let number = hourlyWageString.filter{ "0123456789.".contains($0) }
                    guard let hourly = Double(number) else {
                        errorMessage = "Could not convert \(number) to a number."
                        showErrorAlert = true
                        return
                    }
                    wage = hourly
                } else if wageType == .salary {
                    let number = yearlySalaryString.filter{ "0123456789.".contains($0) }
                    guard let salary = Double(number) else {
                        errorMessage = "Could not convert \(number) to a number."
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
                             user: User.main,
                             includeTaxes: includeStateTaxes || includeFederalTaxes,
                             stateTax: stateTaxPercentage,
                             federalTax: federalTaxPercentage,
                             context: User.main.getContext())
                    viewModel.pageToShow = nil
                } catch {
                    showErrorAlert = true
                }

            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background {
                        viewModel.user.getSettings().themeColor
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
            }
            .buttonStyle(.plain)
        }

        var cancelButton: some View {
            Button {
                viewModel.pageToShow = nil
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
}

#Preview {
    NavigationView {
        OnboardingProgressManagerView()
    }
//    OnboardingProgressManagerView.EnterWageFirstTimeView()
}
