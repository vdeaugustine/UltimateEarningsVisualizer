//
//  ShiftListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import CoreData
import SwiftUI
import Vin

// MARK: - ShiftListView

struct ShiftListView: View {
    @EnvironmentObject private var navManager: NavManager
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var wage = User.main.getWage()

    @State private var shifts: [Shift] = User.main.getShifts()

    @State private var showNewShiftSheet = false
    @State private var editMode: EditMode = .inactive

    @State private var showDeleteConfirmation = false
    @State private var upcomingToDelete: [Shift] = []

    var upcomingShifts: [Shift] {
        user.getShiftsBetween(startDate: .now.addHours(1), endDate: .distantFuture).reversed()
    }

    func isSelected(_ shift: Shift) -> Bool {
        return upcomingToDelete.contains(where: { $0 == shift })
    }

    @State private var showErrorDeletingShift = false

    @State private var shiftThatCouldntBeDeleted: Shift? = nil

    @State private var mostRecentSelected = false

    @State private var payPeriods: [PayPeriod] = User.main.getPayPeriods().filter{ $0.getShifts().isEmpty == false }
    
    @State private var showResetUpcomingShiftsAlert = false

    var body: some View {
        VStack(spacing: 0) {
//            upcomingPart
            listPart
        }
        .onChange(of: wage, perform: { _ in
            shifts = user.getShifts()
        })
        .refreshable {
            update()
        }
        .toolbar {
            if shifts.isEmpty == false {
                EditButton()
                    .onChange(of: editMode.isEditing) { isEditing in
                        if !isEditing {
                            upcomingToDelete.removeAll()
                        }
                    }
            }
        }
        .alert("Error deleting shift", isPresented: $showErrorDeletingShift, actions: {
        }, message: {
            if let shift = shiftThatCouldntBeDeleted {
                Text("Could not delete shift for \(shift.start)")
            } else {
                Text("Shift is nil")
            }

        })
        .sheet(isPresented: $showNewShiftSheet) {
            NewShiftView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
        .safeAreaInset(edge: .bottom, content: {
            if editMode.isEditing {
                Button {
                    if upcomingToDelete.isEmpty {
                        editMode = .inactive
                    } else {
                        withAnimation {
                            showDeleteConfirmation.toggle()
                        }
                    }

                } label: {
                    if upcomingToDelete.isEmpty {
                        BottomButtonView(label: "Cancel")
                    } else {
                        BottomButtonView(label: "Delete", gradient: Color.niceRed.getGradient())
                    }
                }
            }
        })

        .navigationTitle("Shifts")
        .putInTemplate()
        .confirmationDialog("Confirm deletion of all selected shifts", isPresented: $showDeleteConfirmation, titleVisibility: .visible, actions: {
            Button("Delete", role: .destructive) {
                for shift in self.upcomingToDelete {
                    user.removeFromShifts(shift)
                    viewContext.delete(shift)
                    try? viewContext.save()
                }
            }
        }, message: {
            Text("Every shift that has been highlighted will be permanently deleted")
        })
        .environment(\.editMode, $editMode)
        .alert("Reset upcoming shifts", isPresented: $showResetUpcomingShiftsAlert) {
            Button("Reset", role: .destructive) {
                resetUpcoming()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all upcoming shifts but not previously completed shifts.")
        }

    }

    // swiftformat:sort:begin
    private func deleteShifts(offsets: IndexSet) {
        withAnimation {
            offsets.map { shifts[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    var listPart: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                upcomingScroll
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                ForEach(payPeriods.filter({ $0.getLastDate() <= .now || $0 == user.getCurrentPayPeriod() })) { period in
                    if period.getShifts().isEmpty == false {
                        Section {
                            ForEach(period.getShifts()) { shift in
                                Button {
                                    navManager.appendCorrectPath(newValue: .shift(shift))
                                } label: {
                                    ShiftRowView(shift: shift)
                                }
                            }
                        } header: {
                            Button {
                                navManager.appendCorrectPath(newValue: .payPeriodDetail(period))
                            } label: {
                                HStack {
                                    Text(period.dateRangeString)
                                    Spacer()
                                    Label("More", systemImage: "ellipsis")
                                        .labelStyle(.iconOnly)
                                }
                            }
                            .foregroundStyle(Color.black)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    var upcomingHeader: some View {
        Text("Upcoming")
            .font(.headline)
            .padding([.top, .leading])
            .padding(.leading, 21)
    }

    var upcomingPart: some View {
        VStack(alignment: .leading, spacing: 0) {
            upcomingHeader
            upcomingScroll
        }
        .background(Color.listBackgroundColor)
    }

    var upcomingScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center) {
                Button {
                    navManager.appendCorrectPath(newValue: .createShift)
                } label: {
                    Label("Add shifts", systemImage: "plus")
                        .padding()
                        .rectContainer(shadowRadius: 0, cornerRadius: 7)
                }

//                .padding(.bottom)
//                .padding(.leading, 6)

                ForEach(upcomingShifts) { shift in
                    if editMode.isEditing {
                        Button {
                            if isSelected(shift) {
                                upcomingToDelete.removeAll(where: { $0 == shift })
                            } else {
                                upcomingToDelete.append(shift)
                            }
                        } label: {
                            ShiftCircle(dateComponent: Calendar.current.dateComponents([.month,
                                                                                        .day],
                                                                                       from: shift.start),
                                        isEditing: editMode.isEditing,
                                        isSelected: isSelected(shift))
                        }
                        .buttonStyle(.plain)

                    } else {
                        Button {
                            navManager.appendCorrectPath(newValue: .shift(shift))
                        } label: {
                            ShiftCircle(dateComponent: Calendar.current.dateComponents([.month, .day], from: shift.start),
                                        isEditing: editMode.isEditing,
                                        isSelected: isSelected(shift))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Divider()
                    .padding()
                
                if upcomingShifts.isEmpty == false {
                    Button {
                        showResetUpcomingShiftsAlert = true
                    } label: {
                        ResetUpcoming()
                    }
                }
            }
            .frame(height: 80)
//            .padding(.horizontal)
        }
        
    }

    private func update() {
        print("Called")
        shifts = user.getShifts()
        payPeriods = user.getPayPeriods().filter { $0.getShifts().isEmpty == false }
    }
    
    private func resetUpcoming() {
        for shift in upcomingShifts {
            user.removeFromShifts(shift)
            viewContext.delete(shift)
            
            try? viewContext.save()
        }
    }

    // swiftformat:sort:end
}

// MARK: - ShiftRowView

struct ShiftRowView: View {
    let shift: Shift
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var wage = User.main.getWage()

    var body: some View {
        HStack {
            Text(shift.start.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(settings.getDefaultGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(shift.start.getFormattedDate(format: .abbreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("Duration: \(shift.duration.formatForTime())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

            Text("\(shift.totalEarned.money())")
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}

// MARK: - ShiftListView_Previews

struct ShiftListView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftListView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}


// MARK: - ResetUpcoming

struct ResetUpcoming: View {
    var body: some View {
        VStack {
            Image(systemName: "x.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .background(Circle().fill(.white))
                .foregroundStyle(Color(uiColor: .lightGray))
//            Text("Reset")
//                .font(.caption2)
//                .multilineTextAlignment(.center)
//                .lineLimit(3)
//                .foregroundStyle(Color(uiColor: .secondaryLabel))
        }
//        .frame(width: 65)
    }
}

// MARK: - ResetUpcoming_Previews

struct ResetUpcoming_Previews: PreviewProvider {
    static var previews: some View {
        ResetUpcoming()
    }
}

