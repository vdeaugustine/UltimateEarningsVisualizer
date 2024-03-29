import AlertToast
import SwiftUI

// MARK: - EnterWageView

class EnterWageViewModel: ObservableObject, Hashable {
    static func == (lhs: EnterWageViewModel, rhs: EnterWageViewModel) -> Bool {
        lhs.stateTax == rhs.stateTax
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(stateTax)
        hasher.combine(federalTax)
    }
    
    @Published var stateTax = User.main.getWage().stateTaxPercentage
    @Published var federalTax = User.main.getWage().federalTaxPercentage
}

// swiftformat:sort:begin

struct EnterWageView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var isSalaried: Bool = User.main.getWage().isSalary
    @StateObject private var viewModel: EnterWageViewModel = .init()

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

    private func getHourlyWage(_ salary: Double) -> Double {
        let workingWeeks = Double(weeksPerYear)
        let totalWorkingHours = workingWeeks * hoursPerDay * Double(daysPerWeek)
        let thisHourlyWage = salary / totalWorkingHours

        return thisHourlyWage
    }

    @State private var hourlyDouble: Double = User.main.getWage().hourly
    @State private var salaryDouble: Double = User.main.getWage().perYear

    @State private var showHourlySheet = false
    @State private var showSalarySheet = false

    @State private var includeTaxes = User.main.getWage().includeTaxes
    

    @State private var showStateSheet = false
    @State private var showFederalSheet = false

    @State private var showAssumptions = false

    var wageToShow: String {
        if isSalaried {
            return getHourlyWage(salaryDouble)
                .money(trimZeroCents: false)
                .replacingOccurrences(of: "$", with: "")
        } else {
            return hourlyDouble
                .money(trimZeroCents: false)
                .replacingOccurrences(of: "$", with: "")
        }
    }

    @ViewBuilder var hourlyWageSection: some View {
        Section {
            HStack {
                SystemImageWithFilledBackground(systemName: "dollarsign",
                                                backgroundColor: user.getSettings().themeColor)
                Text(wageToShow)
                    .boldNumber()
                Spacer()
                if !isSalaried {
                    Button("Edit") {
                        showHourlySheet = !isSalaried
                    }
                }
            }
            .allPartsTappable()
            .onTapGesture {
                showHourlySheet = !isSalaried
            }

        } header: {
            Text("Hourly Wage")
        } footer: {
            if isSalaried {
                Text("An hourly representation of your yearly salary")
            }
        }
    }

    @ViewBuilder var salarySection: some View {
        if isSalaried {
            Section {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign",
                                                    backgroundColor: user.getSettings().themeColor)
                    Text(salaryDouble
                        .money()
                        .replacingOccurrences(of: "$", with: ""))
                        .boldNumber()
                    Spacer()
                    Button("Edit") {
                        showSalarySheet = true
                    }
                }
                .allPartsTappable()
                .onTapGesture {
                    showSalarySheet = true
                }
            } header: {
                Text("Salary")
            }
        }
    }

    @ViewBuilder var assumptionsSection: some View {
        Section {
            if showAssumptions {
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

                Button {
                    hoursPerDay = 8
                    daysPerWeek = 5
                    weeksPerYear = 50
                } label: {
                    Label("Standard", systemImage: "arrow.uturn.backward")
                        .labelStyle(.titleOnly)
                }
                Button("Hide") {
                    showAssumptions.toggle()
                }
            } else {
                Button("Show") {
                    showAssumptions.toggle()
                }
            }

        } header: {
            Text("Calculation Assumptions")
        } footer: {
            Text("When calculating daily, weekly, monthly, and yearly, these values will be used respectively")
        }
    }

    @ViewBuilder var taxesSection: some View {
        if includeTaxes {
            Section("State tax") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "percent",
                                                    backgroundColor: user.getSettings().themeColor)
                    Text(viewModel.stateTax.simpleStr(3, false))
                        .boldNumber()
                    Spacer()
                    Button("Edit") {
                        showFederalSheet = true
                    }
                }
                .allPartsTappable()
                .onTapGesture {
                    showStateSheet = true
                }
                Button {
                    
                    NavManager.shared.appendCorrectPath(newValue: .calculateTax(.init(taxType: .state, bindedRate: $viewModel.stateTax)))
                    
                } label: {
                    Label("Calculate for me", systemImage: "info.circle")
                }
            }

            Section("Federal tax") {
                HStack {
                    SystemImageWithFilledBackground(systemName: "percent",
                                                    backgroundColor: user.getSettings().themeColor)
                    Text(viewModel.federalTax.simpleStr(3, false))
                        .boldNumber()
                    Spacer()
                    Button("Edit") {
                        showFederalSheet = true
                    }
                }
                .allPartsTappable()
                .onTapGesture {
                    showFederalSheet = true
                }

                Button {
                    NavManager.shared.appendCorrectPath(newValue: .calculateTax(.init(taxType: .federal, bindedRate: $viewModel.federalTax)))
                } label: {
                    Label("Calculate for me", systemImage: "info.circle")
                }
            }
        }
    }

    func saveAction() {
        do {
            if let existingWage = user.wage {
                viewContext.delete(existingWage)
                try viewContext.save()
                print("Was able to save")
            }
            let wage = try Wage(amount: isSalaried ? salaryDouble : hourlyDouble,
                                isSalary: isSalaried,
                                user: user,
                                includeTaxes: includeTaxes,
                                stateTax: includeTaxes ? viewModel.stateTax : nil,
                                federalTax: includeTaxes ? viewModel.federalTax : nil,
                                context: viewContext)
            wage.daysPerWeek = Double(daysPerWeek)
            wage.hoursPerDay = Double(hoursPerDay)
            wage.weeksPerYear = Double(weeksPerYear)

            try viewContext.save()
            showSuccessfulSaveToast = true
            user.wage = wage
            WageViewModel.shared.wageChangesPublisher.send(wage)
            
        } catch {
            fatalError(String(describing: error))
        }
    }

    var body: some View {
        Form {
            hourlyWageSection

            Toggle("Salary", isOn: $isSalaried)

            salarySection

            assumptionsSection

            Section {
                Toggle("Include taxes", isOn: $includeTaxes)
            }

            taxesSection
        }
        .putInTemplate()
        .navigationTitle("My Wage")
        .toast(isPresenting: $showErrorToast,
               duration: 2,
               tapToDismiss: true) {
            AlertToast(displayMode: .alert,
                       type: .error(.blue),
                       title: errorMessage)
        } onTap: {
            showErrorToast = false
        }
        .toast(isPresenting: $showSuccessfulSaveToast,
               offsetY: -50) {
            AlertToast(displayMode: .banner(.slide),
                       type: .complete(.green),
                       title: "Wage saved successfully",
                       style: .style(backgroundColor: .white,
                                     titleColor: nil,
                                     subTitleColor: nil,
                                     titleFont: nil,
                                     subTitleFont: nil))
        }
        .toolbarSave { saveAction() }
        .sheet(isPresented: $showHourlySheet) {
            EnterDoubleView(dubToEdit: $hourlyDouble, format: .dollar)
        }
        .sheet(isPresented: $showSalarySheet) {
            EnterDoubleView(dubToEdit: $salaryDouble, format: .dollar)
        }
        .sheet(isPresented: $showStateSheet) {
            EnterDoubleView(dubToEdit: $viewModel.stateTax, format: .percent)
        }
        .sheet(isPresented: $showFederalSheet) {
            EnterDoubleView(dubToEdit: $viewModel.federalTax, format: .percent)
        }
    }
}

// MARK: - EnterWageView_Previews

// swiftformat:sort:end

struct EnterWageView_Previews: PreviewProvider {
    static var previews: some View {
        EnterWageView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
