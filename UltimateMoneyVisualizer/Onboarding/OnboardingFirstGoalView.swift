//
//  OnboardingFirstGoalView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/27/23.
//

import SwiftUI

// MARK: - OnboardingFirstGoalView

struct OnboardingFirstGoalView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var amount: Double = 0
    @State private var dueDate: Date = .now.addDays(100)
    @State private var showEditAmount = false

    @State private var firstTextMax: CGFloat = 0
    @State private var secondTextMax: CGFloat = 0

    typealias TempTag = CreateGoalViewModel.TemporaryTag

    @FocusState private var focusedField: CreateGoalViewModel.FocusedField?

    var body: some View {
        Form {
            Section {
                titleRow
            } header: {
                Text("Title")
            } footer: {
                Text("A title that helps you identify the goal")
            }

            Section {
                infoRow
            } header: {
                Text("Description")
            }footer: {
                Text("A short description about the goal (optional)")
            }
            
            Section("Amount") {
                amountRow
            }

            Section("Due date") {
                dateRow
            }

            
        }
        .onChange(of: focusedField) { newValue in
            print(newValue ?? "nil")
        }

        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if focusedField == .title {
                    Button("Close") {
                        focusedField = nil
                    }

                    Spacer()

                    Button("Next") {
                        focusedField = .info
                    }
                } else {
                    Button("Back") {
                        focusedField = .title
                    }

                    Button("Done") {
                        focusedField = nil
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Next") { }
            }
        }
        .navigationTitle("Create your first goal")
//        .modifier(Modifiers(vm: vm))
    }

    // MARK: - Subviews

    var titleRow: some View {
        TextField("Vacation", text: $title)
            .focused($focusedField, equals: .title)
    }

    var infoRow: some View {
        TextField("I want to take the family to Hawaii", text: $description)
            .focused($focusedField, equals: .info)
    }

    var dateRow: some View {
        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
    }

    var amountRow: some View {
        HStack {
            SystemImageWithFilledBackground(systemName: "dollarsign",
                                            backgroundColor: .blue)
            Text(amount.money().replacingOccurrences(of: "$", with: ""))
                .font(.system(size: 20))
        }
        .allPartsTappable(alignment: .leading)
        .onTapGesture {
            showEditAmount.toggle()
        }
    }

    struct Modifiers: ViewModifier {
        @ObservedObject var viewModel: CreateGoalViewModel
        @EnvironmentObject private var newItemViewModel: NewItemViewModel
        @FocusState private var focusedField: CreateGoalViewModel.FocusedField?

        func body(content: Content) -> some View {
            content
        }
    }
}

// MARK: - OnboardingFirstGoalView_Previews

struct OnboardingFirstGoalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingFirstGoalView()
                .previewDevice("iPhone 14 Pro Max")
                .putInNavView(.large)

            OnboardingFirstGoalView()
                .previewDevice("iPhone SE (3rd generation)")
                .putInNavView(.large)
        }
        .environmentObject(OnboardingModel())
    }
}
