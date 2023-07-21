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

    @State var wage: Wage

    @ObservedObject private var user = User.main
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

    private var wageToShow: Double {
        if wage.isSalary {
            return wage.perYear
        } else {
            return wage.hourly
        }
    }

    var body: some View {
        List {
            Section(header: Text("Current Wage")) {
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: user.getSettings().themeColor)
                    Text(wageToShow.money(trimZeroCents: false)
                        .replacingOccurrences(of: "$", with: ""))
                        .boldNumber()
                    Spacer()
                    Text(wage.isSalary ? "SALARY" : "HOURLY")
                        .font(.caption)
                        .fontWeight(.medium)
                }
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
                                .spacedOut(text: wage.perYear.money())
                            Divider()
                            Text("Month")
                                .spacedOut(text: wage.perMonth.money())
                            Divider()
                            Text("Week")
                                .spacedOut(text: wage.perWeek.money())
                            Divider()
                            Text("Day")
                                .spacedOut(text: wage.perDay.money())
                            Divider()
                            Text("Hour")
                                .spacedOut(text: wage.hourly.money())
                        }
                        Divider()
                        Text("Minute")
                            .spacedOut(text: wage.perMinute.money())
                        Divider()
                        Text("Second")
                            .spacedOut(text: wage.perSecond.money())
                    }
                    .font(.subheadline)
                }
            } header: {
                Text("Breakdown")

            } footer: {
                Text("These values are based on your wage settings and can be edited by tapping the **Edit** button.")
            }
        }

        .putInTemplate()
        .navigationTitle("My Wage")

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Edit") {
                    EnterWageView()
                }
                .tint(Color.white)
            }
        }

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
