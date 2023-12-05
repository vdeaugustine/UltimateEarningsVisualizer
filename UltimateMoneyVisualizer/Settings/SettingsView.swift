//
//  SettingsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import CoreData
import SwiftUI
import Vin


struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showColorOptions: Bool = false
    @State private var showRoadblock = false
    
    @State private var errorSaving: Error? = nil
    @State private var showError = false

    @EnvironmentObject private var user: User
    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var statusTracker = User.main.getStatusTracker()
    
    @State private var show = true

    #if DEBUG
        @State private var inMemory = UserDefaults.inMemory
        @State private var useColorNavBar = User.main.getSettings().useColoredNavBar
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

                        NavManager.shared.appendCorrectPath(newValue: user.wage != nil ? .wage : .enterWage)
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

//                Button {
//                    NavManager.shared.appendCorrectPath(newValue: .enterWage)
//                } label: {
//                    HStack {
//                        SystemImageWithFilledBackground(systemName: "percent")
//                        Text("Taxes")
//                        Spacer()
//                        Components.nextPageChevron
//                    }.allPartsTappable()
//                }
//                .buttonStyle(.plain)

                // MARK: - Set Hours

                Button {
                    NavManager.shared.appendCorrectPath(newValue: .regularSchedule)
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "hourglass",
                                                        backgroundColor: settings.themeColor)
                        Text("Regular Schedule")
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
                
                
                
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .enterLumpSum)
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "dollarsign")
                        Text("Enter lump sum")
                        Spacer()
                        Components.nextPageChevron
                    }
                }
                .foregroundStyle(.black)
            }

//            Section {
//                Button("Calendars") {
//                    NavManager.shared.appendCorrectPath(newValue: .selectCalendarsForSettings)
////                    SelectCalendarForSettingsView()
//                }
//            }

            Section("Visuals") {
                Button {
                    
                    #if DEBUG
                    withAnimation {
                        showColorOptions.toggle()
                    }
                    #else
                    
                    if SubscriptionManager.shared.canAccessPremiumFeatures() {
                        withAnimation {
                            showColorOptions.toggle()
                        }
                    } else {
                        showRoadblock = true
                    }
                    
                    #endif

                } label: {
                    Text("Theme color")
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
                        user.instantiateExampleItems(context: user.getContext())
                    }

                    Toggle("Use colored nav bar", isOn: $useColorNavBar)
                        .onChange(of: useColorNavBar) { _ in
                            settings.useColoredNavBar = useColorNavBar
                            try! viewContext.save()
                        }
                }

            #endif
            
            //TODO: Remove
            Section {
                Button("Reset onboarding flag") {
                    
                    user.getStatusTracker().hasSeenOnboardingFlow = false
                    do {
                        try user.getContext().save()
                        print("Saved! NEw value: ", statusTracker.hasSeenOnboardingFlow )
                    } catch {
                        errorSaving = error
                        showError = true
                    }
                }
            }

            Section("Plan") {
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .purchasePage)
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "star.fill", backgroundColor: settings.themeColor)
                        Text("Manage Plan")
                        Spacer()
                        Components.nextPageChevron
                    }
                    .allPartsTappable()
                }
                .buttonStyle(.plain)
            }
            
            TutorialsSection()

            if let numberOfVisits = User.main.statusTracker?.numberOfTimesOpeningApp {
                Section(footer:
                    Text("You have opened the app \(numberOfVisits) time\(numberOfVisits > 1 ? "s" : "")! Nice Job!")

                ) {}
            }
        }
        .listStyle(.insetGrouped)
        .putInTemplate()
        .navigationTitle("Settings")
        .navigationDestination(for: NavManager.AllViews.self) { view in
            NavManager.shared.getDestinationViewForStack(destination: view)
        }
        .sheet(isPresented: $showRoadblock, content: {
            RoadblockView()
        })
        .alert(errorSaving?.localizedDescription ?? "Error saving", isPresented: $showError) {
            
        }
        
    }
}


extension SettingsView {
    struct TutorialsSection: View {
        var body: some View {
            Section {
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .timeBlockMoreInfoAndTutorial)
                } label: {
                    HStack {
                        Label("Time Blocks", systemImage: "clock.fill")
                        Spacer()
                        Components.nextPageChevron
                    }
                    .allPartsTappable()
                }
                .buttonStyle(.plain)
                
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .goalsInfoView)
                } label: {
                    HStack {
                        Label("Goals", systemImage: "star.fill")
                        Spacer()
                        Components.nextPageChevron
                    }
                    .allPartsTappable()
                }
                .buttonStyle(.plain)
                
                
                
            } header: {
                Text("Tutorials and More Info")
            }
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
            .environmentObject(User.main)
    }
}
