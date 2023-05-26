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

    @State var wage: Wage

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
        List {
            Section(header: Text("Current Wage")) {
                Text("\(wages.first?.amount ?? 0.0, specifier: "%.2f") per hour")
            }

            Section {
                VStack(spacing: 12) {
                    Text("Period")
                        .font(.headline)
                        .fontWeight(.medium)
                        .spacedOut {
                            Text("Amount")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                    VStack {
                        Group {
                            Text("Year")
                                .spacedOut(text: wage.perYear.formattedForMoney())
                            Divider()
                            Text("Month")
                                .spacedOut(text: wage.perMonth.formattedForMoney())
                            Divider()
                            Text("Week")
                                .spacedOut(text: wage.perWeek.formattedForMoney())
                            Divider()
                            Text("Day")
                                .spacedOut(text: wage.perDay.formattedForMoney())
                            Divider()
                            Text("Hour")
                                .spacedOut(text: wage.hourly.formattedForMoney())
                        }
                        Divider()
                        Text("Minute")
                            .spacedOut(text: wage.perMinute.formattedForMoney())
                        Divider()
                        Text("Second")
                            .spacedOut(text: wage.perSecond.formattedForMoney())
                    }
                    .font(.subheadline)
                }
            }
        }

//            }
//        }
        .putInTemplate()
        .navigationTitle("View Wage")

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Edit") {
                    EnterWageView()
                }
            }
        }

//        .navigationBarItems(trailing: Button(action: {
//            isEditing.toggle()
//        }) {
//            Text(isEditing ? "Cancel" : "Edit")
//        })
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
        let wage = Wage(context: PersistenceController.context)
        wage.amount = 60
        return wage
    }()

    static var previews: some View {
        WageView(wage: wage)
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInTemplate()
            .putInNavView(.inline)
    }
}
