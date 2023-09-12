//
//  CreateExpenseView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - CreateExpenseView

struct CreateExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var newItemViewModel: NewItemViewModel
    @StateObject var vm = CreateExpenseViewModel()
    @State private var firstTextMax: CGFloat = 0
    @State private var secondTextMax: CGFloat = 0
    @State private var isRepeatingExpense = false // New toggle for repeating expense

    typealias TempTag = CreateExpenseViewModel.TemporaryTag

    @FocusState private var focusedField: CreateExpenseViewModel.FocusedField?

    // MARK: Helper functions

    var body: some View {
        Form {
            Section {
                titleRow
            } header: {
                Text("Title")
            } footer: {
                Text("A title that helps you identify the expense")
            }

            Section {
                infoRow
            } header: {
                Text("Description")
            } footer: {
                Text("A short description about the expense (optional)")
            }

            Section("Due date") {
                dateRow
                repeatRow
            }
            
            

            Section("Amount") {
                amountRow
            }

            Section {
                tagSectionContent
            } header: {
                Text("Tags")
            } footer: {
                Text("Add tags that can be used to filter and group items throughout the app")
            }
            .listRowSeparator(.hidden)

            Section {
                recentTags
            } header: {
                Text("Recent Tags")
            } footer: {
                Text("Tap on a recent tag to add it to this expense")
            }
            
            

            
        }
        .putInTemplate()
        .navigationTitle("New Expense")
        .toast(isPresenting: $vm.showToast, duration: 2, tapToDismiss: true) {
            vm.alertToastConfig
        } onTap: {
            vm.showToast = false
        }

        .sheet(isPresented: $vm.showEditDoubleSheet, content: {
            EnterMoneyView(dubToEdit: $vm.amountDouble)
        })

        .sheet(isPresented: $vm.showNewTagSheet, content: {
            CreateTagForExpense(vm: vm)
        })

        .toolbarSave {
            vm.saveExpense(amount: newItemViewModel.enteredStr)
        }

//                .bottomButton(label: "Save", action: vm.saveExpense)
        .onAppear {
            vm.amountDouble = newItemViewModel.dubValue
//            #if !DEBUG
                focusedField = .title
//            #endif
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
        }
//        .modifier(Modifiers(vm: vm))
    }

    // MARK: - Subviews

    @ViewBuilder var titleRow: some View {
        TextField("Vacation", text: $vm.title)
            .focused($focusedField, equals: .title)
    }

    @ViewBuilder var infoRow: some View {
        TextField("I want to take the family to Hawaii", text: $vm.info)
            .focused($focusedField, equals: .info)
    }

    @ViewBuilder var dateRow: some View {
        DatePicker("Due Date", selection: $vm.dueDate, displayedComponents: .date)
    }

    @ViewBuilder var tagSectionContent: some View {
        VStack(alignment: .leading) {
            if !vm.tags.isEmpty {
                includedTags
                Divider()
            }
            addTag
        }

//            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var repeatRow: some View {
        // New section for repeating expense toggle
            Picker("Repeat", selection: $vm.repeatFrequency) {
                ForEach(RepeatFrequency.allCases, id: \.self) { frequency in
                    Text(frequency.rawValue).tag(frequency)
                }
            }
            .pickerStyle(MenuPickerStyle())
        
    }

//    @ViewBuilder var showRecentsRow: some View {
//        HStack {
//            Button("Recents") {
//                withAnimation {
//                    vm.showRecentTags.toggle()
//                }
//            }
//
//            Spacer()
//            Image(systemName: "chevron.down")
//                .rotationEffect(vm.showRecentTags ? .degrees(-180) : .degrees(0))
//        }
//    }

    @ViewBuilder var recentTags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(User.main.getTags(), id: \.self) { realTag in
                    tagPill(TempTag(realTag), includeRemoveButton: false)
                }
            }
        }
    }

    @ViewBuilder var includedTags: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.tags.sorted(), id: \.self) {
                    tagPill($0, includeRemoveButton: true)
                }
            }
        }
    }

    @ViewBuilder var addTag: some View {
        Button {
//            #if DEBUG
//                print("tapped add tag")
//
//                vm.tagStrings.insert("Tag \(vm.tagStrings.count + 1)")
//                vm.tagStrings.sorted().forEach { print($0) }
//
//            #endif

            vm.showNewTagSheet.toggle()

        } label: {
            Label("New", systemImage: "plus")
//                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    @ViewBuilder var showRecentsButtonRow: some View {
        Button{ withAnimation{ vm.showRecentExpenses.toggle() }
        } label: {
            HStack {
                Text(vm.showRecentExpenses ? "Hide" : "Show")
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(vm.showRecentExpenses ? .degrees(-180) : .degrees(0))
            }
        }
    }

    @ViewBuilder func tagPill(_ tag: CreateExpenseViewModel.TemporaryTag, includeRemoveButton: Bool) -> some View {
        HStack(spacing: 4) {
            if includeRemoveButton {
                Image(systemName: "plus")
                    .font(.caption2)
                    .foregroundStyle(Color.gray)
                    .rotationEffect(.degrees(45))
                    .onTapGesture {
                        vm.tags.remove(tag)
                    }
            }

            Text(tag.title)
                .font(.caption2)
                .foregroundStyle(Color.googleBlueLabelText)
        }
        .padding(7)
        .background {
            Color.googleBlueLabelBackground
                .clipShape(Capsule(style: .continuous))
        }
        .onTapGesture {
            if includeRemoveButton == false {
                vm.tags.insert(tag)
            }
        }
    }

    @ViewBuilder var expandedRecents: some View {
        if vm.showRecentExpenses {
            ForEach(vm.user.getExpenses().sorted(by: { $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now }).prefixArray(20)) { expense in
                recentRow(expense)
            }
        }
    }

    @ViewBuilder func recentRow(_ expense: Expense) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.titleStr)
                Text("Last used: " + (expense.dateCreated?.getFormattedDate(format: .slashDate) ?? ""))
                    .font(.caption2)
            }
            Spacer()

            Text(expense.amount.money())
        }
        .allPartsTappable(alignment: .leading)
        .onTapGesture {
            vm.title = expense.titleStr
            vm.amountDouble = expense.amount
            vm.info = expense.info ?? ""
        }
    }

    @ViewBuilder var amountRow: some View {
        HStack {
            SystemImageWithFilledBackground(systemName: "dollarsign",
                                            backgroundColor: vm.user.getSettings().themeColor)
            Text(vm.amountDouble.money().replacingOccurrences(of: "$", with: ""))
                .font(.system(size: 20))
        }
        .allPartsTappable(alignment: .leading)
        .onTapGesture {
            vm.showEditDoubleSheet.toggle()
        }
    }

    struct Modifiers: ViewModifier {
        @ObservedObject var viewModel: CreateExpenseViewModel
        @EnvironmentObject private var newItemViewModel: NewItemViewModel
        @FocusState private var focusedField: CreateExpenseViewModel.FocusedField?

        func body(content: Content) -> some View {
            content
        }
    }
}

// MARK: - CreateTagForExpense

struct CreateTagForExpense: View {
    @ObservedObject var vm: CreateExpenseViewModel

    @State private var tagTitle = ""
    @State private var symbolStr = Tag.defaultSymbolStr

    @State private var colorSelected: Color = User.main.getSettings().themeColor

    @State private var showColorOptions = false

    @Environment(\.dismiss) private var dismiss

    @FocusState var isTitleFocused: Bool

    let symbolWidthHeight: CGFloat = 35

    var body: some View {
        NavigationStack {
            Form {
                Section("Tag Title") {
                    TextField("Ex: Groceries", text: $tagTitle)
                        .focused($isTitleFocused)
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
                    SFSymbolsPicker(selectedSymbol: $symbolStr, numberOfColumns: 5, width: symbolWidthHeight, height: symbolWidthHeight, color: colorSelected)
                        .padding(.vertical)
                }
            }
            .toolbarSave {
                vm.tags.insert(
                    CreateExpenseViewModel.TemporaryTag(title: tagTitle,
                                                        symbolStr: symbolStr,
                                                        color: colorSelected)
                )
                dismiss()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isTitleFocused = false
                    }
                }
            }
            .navigationTitle("New Tag")
            .putInTemplate()
            .onAppear(perform: {
                isTitleFocused = true
            })
        }
    }
}

// MARK: - CreateExpenseView_Previews

struct CreateExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        CreateExpenseView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
            .environmentObject(NewItemViewModel.shared)

        CreateExpenseView().tagPill(.init(User.main.getTags().first!), includeRemoveButton: true)
    }
}
