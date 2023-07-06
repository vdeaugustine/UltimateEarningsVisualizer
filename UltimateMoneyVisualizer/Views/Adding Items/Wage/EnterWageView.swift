import AlertToast
import SwiftUI

// MARK: - EnterWageView

struct EnterWageView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var isSalaried: Bool = User.main.getWage().isSalary

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
    @State private var stateTax = User.main.getWage().stateTaxPercentage
    @State private var federalTax = User.main.getWage().federalTaxPercentage

    @State private var showStateSheet = false
    @State private var showFederalSheet = false

    @State private var showAssumptions = false

    var wageToShow: String {
        if isSalaried {
            getHourlyWage(salaryDouble)
                .formattedForMoney(trimZeroCents: false)
                .replacingOccurrences(of: "$", with: "")
        } else {
            hourlyDouble
                .formattedForMoney(trimZeroCents: false)
                .replacingOccurrences(of: "$", with: "")
        }
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
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

            Toggle("Salary", isOn: $isSalaried)

            if isSalaried {
                Section {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                        Text(salaryDouble.formattedForMoney().replacingOccurrences(of: "$", with: ""))
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
//            footer: {
//                    Text("Tap to edit")
//                }
            }

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

            Section {
                Toggle("Include taxes", isOn: $includeTaxes)
            }

            if includeTaxes {
                Section("State tax") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "percent", backgroundColor: user.getSettings().themeColor)
                        Text(stateTax.simpleStr(3, false))
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
                    NavigationLink {
                        CalculateTaxView(taxType: .state, bindedRate: $stateTax)
                    } label: {
                        Label("Calculate for me", systemImage: "info.circle")
                    }
                }

                Section("Federal tax") {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "percent", backgroundColor: user.getSettings().themeColor)
                        Text(federalTax.simpleStr(3, false))
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

                    NavigationLink {
                        CalculateTaxView(taxType: .federal, bindedRate: $federalTax)
                    } label: {
                        Label("Calculate for me", systemImage: "info.circle")
                    }
                }
            }
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
        .bottomButton(label: "Save", gradient: settings.getDefaultGradient()) {
            do {
                let hourly = isSalaried ? getHourlyWage(salaryDouble) : hourlyDouble
                let wage = try Wage(amount: hourly,
                                    isSalary: isSalaried,
                                    user: user,
                                    includeTaxes: includeTaxes,
                                    stateTax: includeTaxes ? stateTax : nil,
                                    federalTax: includeTaxes ? federalTax : nil,
                                    context: viewContext)
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
            EnterDoubleView(dubToEdit: $hourlyDouble, format: .dollar)
        }
        .sheet(isPresented: $showSalarySheet) {
            EnterDoubleView(dubToEdit: $salaryDouble, format: .dollar)
        }
        .sheet(isPresented: $showStateSheet) {
            EnterDoubleView(dubToEdit: $stateTax, format: .percent)
        }
        .sheet(isPresented: $showFederalSheet) {
            EnterDoubleView(dubToEdit: $federalTax, format: .percent)
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
