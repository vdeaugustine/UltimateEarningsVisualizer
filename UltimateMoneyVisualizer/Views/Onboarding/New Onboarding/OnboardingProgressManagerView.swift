//
//  OnboardingProgressManagerView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/1/23.
//

import SwiftUI

// MARK: - OnboardingProgressManagerViewModel

class OnboardingProgressManagerViewModel: ObservableObject {
    @Published var isWageComplete: Bool = true
    @Published var isShiftComplete: Bool = false
    @Published var isScheduleComplete: Bool = false
    @Published var isExpensesComplete: Bool = false
    @Published var isGoalsComplete: Bool = false

    @Published var pageToShow: Page? = nil

    enum Page: Identifiable {
        case wage, shift, schedule, expenses, goals
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
                Text("Getting Started")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Earnings()

                Spending()

                Spacer()
                    .frame(idealHeight: 120, maxHeight: .infinity)

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
        .fullScreenCover(item: $viewModel.pageToShow, content: { page in
            switch page {
                case .wage:
                    EnterWageFirstTimeView()
                default:
                    Text("Default")
            }
        })
        .environmentObject(viewModel)
    }

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
        let subText: String
        let page: OnboardingProgressManagerViewModel.Page

        var body: some View {
            Button {
                viewModel.toggle(page: page)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: isComplete ? "checkmark" : "circle")
                        .foregroundStyle(isComplete ? .blue : .secondary)

                    VStack(alignment: .leading) {
                        Text(headText).font(.headline)
                        Text(subText)
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
        let isFilled: Bool
        var width: CGFloat = 20
        var height: CGFloat = 7

        var body: some View {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFilled ? Color.blue : Color.secondary, lineWidth: 2)
                .frame(width: width, height: height)
                .background(isFilled ? .blue : .clear)
        }
    }

    struct MainProgressPill: View {
        let isFilled: Bool
        var height: CGFloat = 7
        var body: some View {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFilled ? Color.blue : Color.secondary, lineWidth: 2)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(isFilled ? .blue : .clear)
        }
    }
}

extension OnboardingProgressManagerView {
    struct EnterWageFirstTimeView: View {
        // MARK: - Body

        @EnvironmentObject private var vm: OnboardingProgressManagerViewModel

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
            .alert("Error saving.", isPresented: $showErrorAlert) {
            } message: {
                Text("Please try again.")
            }
            .popup(isPresented: $showSheetToEnterWage) {
                if wageType == .hourly {
                    EnterDouble(doubleToEdit: $hourlyWage, maxHeight: 550)
                        .padding(.horizontal)
                } else {
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
            Button {
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                    .background {
                        Color.blue
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
            }
            .buttonStyle(.plain)

//            OnboardingButton(title: "Save") {
//                do {
//                    try Wage(amount: wageType == .hourly ? hourlyWage : salaryWage,
//                             isSalary: wageType == .salary,
//                             user: vm.user,
//                             includeTaxes: includeStateTaxes || includeFederalTaxes,
//                             stateTax: stateTaxPercentage,
//                             federalTax: federalTaxPercentage,
//                             context: vm.user.getContext())
//                    vm.wageWasSet = true
//                    vm.increaseScreenNumber()
//                    dismiss()
//                } catch {
//                    showErrorAlert.toggle()
//                }
//            }
//            .padding(.horizontal, vm.horizontalPad)
        }

        var cancelButton: some View {
            Button {
                vm.pageToShow = nil
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


struct CurrencyTextField: UIViewRepresentable {
    @Binding var value: String
    var fontSize: CGFloat = UIFont.labelFontSize // Default label size
    var backgroundColor: UIColor = .white
    var textColor: UIColor = .black

    static func formatAsCurrency(string: String) -> String {
        let intValue = Int(string) ?? 0
        let dollars = Double(intValue) / 100.0
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        return formatter.string(from: NSNumber(value: dollars)) ?? "$0.00"
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.font = UIFont.systemFont(ofSize: fontSize)
        textField.backgroundColor = backgroundColor
        textField.textColor = textColor
        textField.textAlignment = .left // Change to left alignment
        textField.borderStyle = .roundedRect // Gives the rounded corners typical of a UITextField
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = CurrencyTextField.formatAsCurrency(string: value)
        uiView.font = UIFont.systemFont(ofSize: fontSize)
        uiView.backgroundColor = backgroundColor
        uiView.textColor = textColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CurrencyTextField
        
        init(_ textField: CurrencyTextField) {
            self.parent = textField
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentText = textField.text, let textRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                parent.value = updatedText.filter("0123456789".contains)
                textField.text = CurrencyTextField.formatAsCurrency(string: parent.value)
                return false
            }
            return true
        }
    }
}

struct TestMoneyTextField: View {
    @State private var amount: String = ""
    
    var body: some View {
        VStack {
            CurrencyTextField(value: $amount, fontSize: 70, backgroundColor: .clear, textColor: .gray)
                .frame(height: 44) // Set the default height for the UITextField
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.blue, lineWidth: 1))
            Text("Formatted amount: \(amount)")
        }
        .padding()
    }
}


#Preview {
    OnboardingProgressManagerView()
//    OnboardingProgressManagerView.EnterWageFirstTimeView()
//    TestMoneyTextField()
}
