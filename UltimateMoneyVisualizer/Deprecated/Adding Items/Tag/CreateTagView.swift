//
//  CreateTagView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import AlertToast
import SwiftUI

// MARK: - CreateTagView

struct CreateTagView: View {
    var goal: Goal?
    var expense: Expense?
    var saved: Saved?

    @EnvironmentObject private var navManager: NavManager

    @State private var tagTitle = ""
    @State private var symbolStr = Tag.defaultSymbolStr
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main
    @Environment(\.dismiss) private var dismiss

    @State private var showAlert = false
    @State private var alertConfig = AlertToast.successWith(message: "")

    @State private var colorSelected: Color = User.main.getSettings().themeColor

    @State private var showColorOptions = false

    @State private var showErrorNoTitle = false

    let symbolWidthHeight: CGFloat = 40

    @FocusState private var titleFocused

    init(payoff: AnyPayoffItem) {
        if let goal = payoff.getGoal() {
            self.goal = goal
        }
        if let expense = payoff.getExpense() {
            self.expense = expense
        }
    }

    init(saved: Saved) {
        self.saved = saved
    }

    init() { }

    enum ViewTags: Hashable {
        case top
    }

    var body: some View {
        ScrollViewReader { _ in
            Form {
                Section("Tag Title") {
                    TextField("Ex: Groceries", text: $tagTitle)
                        .focused($titleFocused)

                    if !symbolStr.isEmpty {
                        HStack {
                            Text("Symbol")
                            Spacer()
                            SystemImageWithFilledBackground(systemName: symbolStr, backgroundColor: colorSelected, width: symbolWidthHeight, height: symbolWidthHeight)
                        }
                    }
                }

                Section("Color") {
                    Button {
                        withAnimation {
                            showColorOptions.toggle()
                        }

                    } label: {
                        Text("Color (PREMIUM)")
                            .foregroundColor(.black)
                            .spacedOut {
                                HStack {
                                    Circle()
                                        .fill(colorSelected)
                                        .frame(height: 20)

                                        .overlay(content: {
                                            Circle()
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(.gray)
                                        })

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color(hex: "BFBFBF"))
                                        .rotationEffect(showColorOptions ? .degrees(90) : .degrees(0))
                                }
                            }
                    }

                    if showColorOptions {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(Color.defaultColorOptions, id: \.self) { color in
                                    Button {
                                        colorSelected = color
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

                Section("Select New Symbol") {
                    SFSymbolsPicker(selectedSymbol: $symbolStr, numberOfColumns: 5, width: symbolWidthHeight, height: symbolWidthHeight, color: colorSelected, completion: {
                    })
                    .padding(.vertical)
                }
            }
            .onAppear(perform: {
                titleFocused = true
            })
        }
        .putInTemplate()
        .navigationTitle("Create Tag")

        .toast(isPresenting: $showAlert) {
            alertConfig
        }
        .alert("Title cannot be empty", isPresented: $showErrorNoTitle) {
            Button("Ok") {
            }
        }
        .overlay {
            if titleFocused {
                Color.white.opacity(0.0001)
                    .onTapGesture {
                        titleFocused = false
                    }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    titleFocused = false
                }
            }

            ToolbarItem(placement: topBarPlacement()) {
                Button("Save") {
                    do {
                        if let goal {
                            try Tag(tagTitle, symbol: symbolStr, color: colorSelected, goal: goal, user: user, context: viewContext)
                        } else if let expense {
                            try Tag(tagTitle, symbol: symbolStr, color: colorSelected, expense: expense, user: user, context: viewContext)
                        } else if let saved {
                            try Tag(tagTitle, symbol: symbolStr, color: colorSelected, savedItem: saved, user: user, context: viewContext)
                        } else {
                            try Tag(tagTitle, symbol: symbolStr, color: colorSelected, user: user, context: viewContext)
                        }

                        try viewContext.save()
                        alertConfig = .successWith(message: "Saved successfully")
                        showAlert.toggle()
                        dismiss()
                    } catch {
                        alertConfig = .errorWith(message: "Error saving. Please try again")
                        showAlert.toggle()
                    }
                }
            }
        }
    }

    func topBarPlacement() -> ToolbarItemPlacement {
        if #available(iOS 17, *) {
            return .topBarTrailing
        } else {
            return .navigationBarTrailing
        }
    }
}

// MARK: - CreateTagView_Previews

struct CreateTagView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTagView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
            .environmentObject(NavManager())
    }
}
