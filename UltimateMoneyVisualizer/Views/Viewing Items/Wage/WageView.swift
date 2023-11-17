//
//  WageView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import Combine
import CoreData
import SwiftUI

// MARK: - WageViewModel

class WageViewModel: ObservableObject {
    public static var shared: WageViewModel = .init()

    @ObservedObject var wage: Wage = User.main.getWage()
    @ObservedObject var user: User = .main
    @Published var hourlyWage: String = ""
    @Published var isSalaried: Bool = false
    @Published var salary: String = ""
    @Published var hoursPerWeek: String = ""
    @Published var vacationDays: String = ""
    @Published var calculatedHourlyWage: Double?

    @Published var showErrorToast: Bool = false
    @Published var errorMessage: String = ""
    @Published var showSuccessfulSaveToast = false

    @Published var isEditing = false

    @Published var toggleTaxes = User.main.getWage().includeTaxes

    init() {
        setupWageListener()
    }

    
    private func setupWageListener() {
        wageChangesPublisher.sink { [weak self] newWage in
            self?.wage = newWage
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }

    // MARK: - publishers

    var wageChangesPublisher = PassthroughSubject<Wage, Never>()
    private var cancellables = Set<AnyCancellable>()

    func calculateHourlyWage(salary: Double, hoursPerWeek: Double, vacationDays: Double) -> Double? {
        let weeksPerYear = 52.0
        let vacationWeeks = vacationDays / 5.0
        let workingWeeks = weeksPerYear - vacationWeeks
        let totalWorkingHours = workingWeeks * hoursPerWeek
        return salary / totalWorkingHours
    }
}

// MARK: - WageView

struct WageView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject private var vm = WageViewModel.shared

    @FetchRequest(entity: Wage.entity(),
                  sortDescriptors: []) private var wages: FetchedResults<Wage>

    private func calculateHourlyWage() {
        guard let salaryValue = Double(vm.salary),
              let hoursPerWeekValue = Double(vm.hoursPerWeek),
              let vacationDaysValue = Double(vm.vacationDays) else { return }

        let weeksPerYear = 52.0
        let vacationWeeks = vacationDaysValue / 5.0
        let workingWeeks = weeksPerYear - vacationWeeks
        let totalWorkingHours = workingWeeks * hoursPerWeekValue
        let hourlyWage = salaryValue / totalWorkingHours

        vm.calculatedHourlyWage = hourlyWage
    }

    private func populateHourlyWage() {
        if let calculatedHourlyWage = vm.calculatedHourlyWage {
            vm.hourlyWage = String(format: "%.2f", calculatedHourlyWage)
        }
    }

    private var wageToShow: Double {
        guard let wage = wages.first(where: { $0.user == vm.user }) else {
            // TODO: Fix this
            fatalError("Could not find wage?!")
        }
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
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: vm.user.getSettings().themeColor)
                    Text(wageToShow.money(trimZeroCents: false)
                        .replacingOccurrences(of: "$", with: ""))
                        .boldNumber()
                    Spacer()
                    Text(vm.wage.isSalary ? "SALARY" : "HOURLY")
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
                                .spacedOut(text: vm.wage.perYear.money())
                            Divider()
                            Text("Month")
                                .spacedOut(text: vm.wage.perMonth.money())
                            Divider()
                            Text("Week")
                                .spacedOut(text: vm.wage.perWeek.money())
                            Divider()
                            Text("Day")
                                .spacedOut(text: vm.wage.perDay.money())
                            Divider()
                            Text("Hour")
                                .spacedOut(text: vm.wage.hourly.money())
                        }
                        Divider()
                        Text("Minute")
                            .spacedOut(text: vm.wage.perMinute.money())
                        Divider()
                        Text("Second")
                            .spacedOut(text: vm.wage.perSecond.money())
                    }
                    .font(.subheadline)
                }
            } header: {
                Text("Breakdown")

            } footer: {
                Text("These values are based on your wage settings and can be edited by tapping the **Edit** button.")
            }
        }
        .onAppear(perform: {
            print("appearing WageView")
        })
        .putInTemplate()
        .navigationTitle("My Wage")

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    NavManager.shared.appendCorrectPath(newValue: .enterWage)
                }
                .tint(Color.white)
            }
        }

        .toast(isPresenting: $vm.showErrorToast, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(.blue), title: vm.errorMessage)
        } onTap: {
            vm.showErrorToast = false
        }
        .toast(isPresenting: $vm.showSuccessfulSaveToast, offsetY: -400) {
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
        WageView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInTemplate()
            .putInNavView(.inline)
    }
}
