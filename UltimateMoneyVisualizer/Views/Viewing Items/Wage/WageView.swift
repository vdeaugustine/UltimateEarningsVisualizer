//
//  WageView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import CoreData
import SwiftUI

// MARK: - WageView

struct WageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Wage.amount, ascending: false)]) private var wages: FetchedResults<Wage>
    
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<User>

    #if DEBUG
        @State var wage: Wage
    #endif

    @State private var hourlyWage: String = ""
    @State private var isSalaried: Bool = false
    @State private var salary: String = ""
    @State private var hoursPerWeek: String = ""
    @State private var vacationDays: String = ""
    @State private var calculatedHourlyWage: Double?

    @State private var showErrorToast: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccessfulSaveToast = false

    @State private var isEditing = false

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
        VStack {
            if isEditing {
                Form {
                    Section(header: Text("Edit Wage")) {
                        TextField("Hourly Wage", text: $hourlyWage)
                            .keyboardType(.decimalPad)

                        Toggle("I have a salary", isOn: $isSalaried)

                        if isSalaried {
                            TextField("Salary", text: $salary)
                                .keyboardType(.decimalPad)
                            TextField("Hours per Week", text: $hoursPerWeek)
                                .keyboardType(.decimalPad)
                            TextField("Vacation Days", text: $vacationDays)
                                .keyboardType(.decimalPad)

                            Button("Calculate Hourly Wage") {
                                calculateHourlyWage()
                            }

                            if let calculatedHourlyWage = calculatedHourlyWage {
                                Text("Calculated Hourly Wage: \(String(format: "%.2f", calculatedHourlyWage))")
                                    .foregroundColor(.secondary)
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
                                let wage = Wage(context: viewContext)
                                wage.amount = dub
                                
                                guard let user = users.first else {
                                    throw NSError(domain: "No user present", code: 99)
                                }
                                
                                user.wage = wage
                                wage.user = user

                                try viewContext.save()
                                showSuccessfulSaveToast = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .navigationTitle("Edit Wage")
            } else {
                Form {
                    Section(header: Text("Current Wage")) {
                        Text("\(wages.first?.amount ?? 0.0, specifier: "%.2f") per hour")
                    }
                }

                .navigationTitle("View Wage")
            }
        }
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
        }) {
            Text(isEditing ? "Cancel" : "Edit")
        })
        .toast(isPresenting: $showErrorToast, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(.blue), title: errorMessage)
        } onTap: {
            showErrorToast = false
        }
        .toast(isPresenting: $showSuccessfulSaveToast, offsetY: -400) {
            AlertToast(displayMode: .banner(.pop), type: .complete(.green), title: "Wage saved successfully", style: .style(backgroundColor: .white, titleColor: nil, subTitleColor: nil, titleFont: nil, subTitleFont: nil))
        }
    }
}

// MARK: - ViewWageView_Previews

struct ViewWageView_Previews: PreviewProvider {
    static let wage: Wage = {
        let wage = Wage(context: PersistenceController.preview.container.viewContext)
        wage.amount = 60
        return wage
    }()

    static var previews: some View {
        WageView(wage: wage)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .putInNavView(.inline)
    }
}
