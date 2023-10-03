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
    @EnvironmentObject private var newItemViewModel: NewItemViewModel
    @StateObject var vm = CreateGoalViewModel()

    @State private var firstTextMax: CGFloat = 0
    @State private var secondTextMax: CGFloat = 0
    @State private var showRoadblock = false

    typealias TempTag = CreateGoalViewModel.TemporaryTag

    @FocusState private var focusedField: CreateGoalViewModel.FocusedField?

    // MARK: Helper functions

    func getMaxX(geo: GeometryProxy) -> CGFloat {
        let x = geo.frame(in: .local).maxX
        print(x)
        return x
    }

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

            Section("Due date") {
                dateRow
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
                Text("Tap on a recent tag to add it to this goal")
            }
        }
        .putInTemplate()
        .navigationTitle("New Goal")
        .toast(isPresenting: $vm.showToast, duration: 2, tapToDismiss: true) {
            vm.alertToastConfig
        } onTap: {
            vm.showToast = false
        }

        .sheet(isPresented: $vm.showEditDoubleSheet, content: {
            EnterMoneyView(dubToEdit: $vm.amountDouble)
        })

        .sheet(isPresented: $vm.showNewTagSheet, content: {
            CreateTagForGoal(vm: vm)
        })

        .toolbarSave {
            if SubscriptionManager.shared.canCreateGoal() {
                vm.saveGoal(amount: newItemViewModel.enteredStr)
            } else {
                showRoadblock = true
            }
        }
        .sheet(isPresented: $showRoadblock, content: {
            RoadblockView()
        })
        .onAppear {
            
            if SubscriptionManager.shared.canCreateGoal() == false {
                showRoadblock = true
            } else {
                vm.amountDouble = newItemViewModel.dubValue
                focusedField = .title
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
        }
//        .modifier(Modifiers(vm: vm))
    }

    func nextButtonTapped() {
        if focusedField == .title {
            focusedField = .info
        } else {
            focusedField = nil
        }
    }

    // MARK: - Subviews

    @ViewBuilder var titleRow: some View {
        TextField("Vacation", text: $vm.title)
            .submitLabel(.next)
            .focused($focusedField, equals: .title)
            .onSubmit {
                nextButtonTapped()
            }
    }

    @ViewBuilder var infoRow: some View {
        TextField("I want to take the family to Hawaii", text: $vm.info)
            .submitLabel(.done)
            .focused($focusedField, equals: .info)
            .onSubmit {
                nextButtonTapped()
            }
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
    }

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
        Button{ withAnimation{ vm.showRecentGoals.toggle() }
        } label: {
            HStack {
                Text(vm.showRecentGoals ? "Hide" : "Show")
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(vm.showRecentGoals ? .degrees(-180) : .degrees(0))
            }
        }
    }

    @ViewBuilder func tagPill(_ tag: CreateGoalViewModel.TemporaryTag, includeRemoveButton: Bool) -> some View {
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
        if vm.showRecentGoals {
            ForEach(vm.user.getGoals().sorted(by: { $0.dateCreated ?? Date.now > $1.dateCreated ?? Date.now }).prefixArray(20)) { goal in
                recentRow(goal)
            }
        }
    }

    @ViewBuilder func recentRow(_ goal: Goal) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(goal.titleStr)
                Text("Last used: " + (goal.dateCreated?.getFormattedDate(format: .slashDate) ?? ""))
                    .font(.caption2)
            }
            Spacer()

            Text(goal.amount.money())
        }
        .allPartsTappable(alignment: .leading)
        .onTapGesture {
            vm.title = goal.titleStr
            vm.amountDouble = goal.amount
            vm.info = goal.info ?? ""
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
        @ObservedObject var viewModel: CreateGoalViewModel
        @EnvironmentObject private var newItemViewModel: NewItemViewModel
        @FocusState private var focusedField: CreateGoalViewModel.FocusedField?

        func body(content: Content) -> some View {
            content
        }
    }
}

// MARK: - CreateTagForGoal

struct CreateTagForGoal: View {
    @ObservedObject var vm: CreateGoalViewModel

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
                    SFSymbolsPicker(selectedSymbol: $symbolStr,
                                    numberOfColumns: 5,
                                    width: symbolWidthHeight,
                                    height: symbolWidthHeight,
                                    color: colorSelected)
                        .padding(.vertical)
                }
            }
            .toolbarSave {
                vm.tags.insert(
                    CreateGoalViewModel.TemporaryTag(title: tagTitle,
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

// MARK: - CreateGoalView_Previews

struct CreateGoalView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGoalView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
            .environmentObject(NewItemViewModel.shared)

//        CreateGoalView().tagPill(.init(User.main.getTags().first!), includeRemoveButton: true)
    }
}
