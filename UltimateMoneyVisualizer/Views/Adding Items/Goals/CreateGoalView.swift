//
//  CreateGoalView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI

// MARK: - CreateGoalView

struct CreateGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = CreateGoalViewModel()

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $viewModel.title)
                HStack {
                    SystemImageWithFilledBackground(systemName: "dollarsign", backgroundColor: viewModel.user.getSettings().themeColor)
                    Text(viewModel.amountDouble.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(viewModel.user.getSettings().getDefaultGradient())
                }
                .allPartsTappable(alignment: .leading)
                .onTapGesture {
                    viewModel.showEditDoubleSheet.toggle()
                }
                TextField("Info", text: $viewModel.info)
                DatePicker("Due Date", selection: $viewModel.dueDate, displayedComponents: .date)
            } header: {
                Text("Goal Information")
            } footer: {
                Text("Tap on a recent goal to create a new instance of that same goal")
            }

            Section("Recent Goals") {
                ForEach(viewModel.user.getGoals().sorted(by: { $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now })) { goal in
                    HStack {
                        Text(goal.titleStr)
                        Spacer()
                        Text(goal.dateCreated?.getFormattedDate(format: .slashDate) ?? "")
                    }
                    .allPartsTappable(alignment: .leading)
                    .onTapGesture {
                        viewModel.title = goal.titleStr
                        viewModel.amountDouble = goal.amount
                        viewModel.info = goal.info ?? ""
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("New Goal")
        // Add the alert toast modifier to the view
        .toast(isPresenting: $viewModel.showToast, duration: 2, tapToDismiss: true) {
            viewModel.alertToastConfig
        } onTap: {
            viewModel.showToast = false
        }

        .sheet(isPresented: $viewModel.showEditDoubleSheet, content: {
            EnterMoneyView(dubToEdit: $viewModel.amountDouble)
        })

        .bottomButton(label: "Save", action: viewModel.saveGoal)
    }
}

// MARK: - CreateGoalView_Previews

struct CreateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGoalView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
