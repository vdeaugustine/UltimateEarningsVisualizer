//
//  SettingsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

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
            return wage.amount.formattedForMoney(includeCents: true)
        }
        return "Not set"
    }

    var body: some View {
        List {
            Section("Money") {
                // MARK: - Set Wage

                NavigationLink {
                    if let wage = user.wage { WageView(wage: wage) }
                    else { EnterWageView() }
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "calendar", backgroundColor: settings.themeColor)
                        Text("My Wage")
                    }
                }

                // MARK: - Set Hours

                NavigationLink {
                    RegularScheduleView()
                } label: {
                    SystemImageWithFilledBackground(systemName: "hourglass", backgroundColor: settings.themeColor)
                    Text("Normal working hours")
                }

                // TODO: - Add a taxes section
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

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.hexStringToColor(hex: "BFBFBF"))
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
                }
            #endif

            Section("Plan") {
                NavigationLink {
                    PurchasePage()
                } label: {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "star.fill", backgroundColor: user.getSettings().themeColor)
                        Text("Manage Plan")
                        Spacer()
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Settings")
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
