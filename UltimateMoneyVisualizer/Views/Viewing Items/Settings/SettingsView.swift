//
//  SettingsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showColorOptions: Bool = false

    @ObservedObject var user = User.main
    @ObservedObject var settings = User.main.getSettings()

    #if DEBUG
        @State private var inMemory = UserDefaults.inMemory
    #endif

    private var wageStr: String {
        if let wage = user.wage {
            return wage.amount.money(includeCents: true)
        }
        return "Not set"
    }

    var body: some View {
        List {
            Section("Money") {
                // MARK: - Set Wage

                Button {
                    if let wage = user.wage {
                        NavManager.shared.appendCorrectPath(newValue: .wage)
                    } else { NavManager.shared.appendCorrectPath(newValue: .enterWage) }
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "calendar",
                                                        backgroundColor: settings.themeColor)
                        Text("My Wage")
                        Spacer()
                        Components.nextPageChevron
                    }.allPartsTappable()
                }
                .foregroundStyle(.black)

                Button {
                    NavManager.shared.appendCorrectPath(newValue: .enterWage)
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "percent")
                        Text("Taxes")
                        Spacer()
                        Components.nextPageChevron
                    }.allPartsTappable()
                }
                .buttonStyle(.plain)

                // MARK: - Set Hours

                Button {
                    NavManager.shared.appendCorrectPath(newValue: .regularSchedule)
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "hourglass",
                                                        backgroundColor: settings.themeColor)
                        Text("Normal working hours")
                        Spacer()
                        Components.nextPageChevron
                    }.allPartsTappable()
                }
                .buttonStyle(.plain)

                // MARK: - Pay Period

                Button {
                    NavManager.shared.appendCorrectPath(newValue: .payPeriods)
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "calendar",
                                                        backgroundColor: settings.themeColor)
                        Text("Pay Periods")

                        Spacer()
                        Components.nextPageChevron
                    }
                    .allPartsTappable()
                }
                .buttonStyle(.plain)
            }
            
            Section {
                Button("Calendars") {
                    NavManager.shared.appendCorrectPath(newValue: .selectCalendarsForSettings)
//                    SelectCalendarForSettingsView()
                }
            }

            Section("Visuals") {
                Button {
                    withAnimation {
                        showColorOptions.toggle()
                    }

                } label: {
                    Text("Theme color (PREMIUM)")
                        .foregroundColor(.black)
                        .spacedOut {
                            HStack {
                                Circle()
                                    .fill(settings.getDefaultGradient())
                                    .frame(height: 20)

                                    .overlay(content: {
                                        Circle()
                                            .stroke(lineWidth: 1)
                                            .foregroundColor(.gray)
                                    })

                                Components.nextPageChevron
                                    .rotationEffect(showColorOptions ? .degrees(90) : .degrees(0))
                            }
                        }
                }

                if showColorOptions {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Color.defaultColorOptions, id: \.self) { color in
                                Button {
                                    settings.themeColor = color
                                } label: {
                                    Circle()
                                        .frame(height: 20)
                                        .foregroundColor(color)
                                        .overlay {
                                            Circle()
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(.gray)
                                        }
                                }
                            }
                        }
                    }
                }
            }

            #if DEBUG
                Section {
                    Toggle("In Memory", isOn: $inMemory)
                        .onChange(of: inMemory) { newValue in
                            UserDefaults.inMemory = newValue
                        }

                    Button("Reset all Core Data") {
                        DebugOperations.deleteAll()
                    }
                    Button("Restore default") {
                        user.instantiateExampleItems(context: viewContext)
                    }
                }

            #endif

            Section("Plan") {
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .purchasePage)
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "star.fill", backgroundColor: user.getSettings().themeColor)
                        Text("Manage Plan")
                        Spacer()
                        Components.nextPageChevron
                    }
                    .allPartsTappable()
                }
                .buttonStyle(.plain)
            }
            
            
            if let numberOfVisits = User.main.statusTracker?.numberOfTimesOpeningApp {
                Section {
                    
                } header: {
                    
                } footer: {
                    Text("You have opened the app \(numberOfVisits) time\(numberOfVisits > 1 ? "s" : "")! Nice Job!")
                }
            }
        }
        .listStyle(.insetGrouped)
        .putInTemplate()
        .navigationTitle("Settings")
        .navigationDestination(for: NavManager.AllViews.self) { view in
            NavManager.shared.getDestinationViewForStack(destination: view)
        }
        
    }
}

// MARK: - SettingsView_Previews

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.managedObjectContext, PersistenceController.testing)
            .putInTemplate()
            .putInNavView(.inline)
    }
}
