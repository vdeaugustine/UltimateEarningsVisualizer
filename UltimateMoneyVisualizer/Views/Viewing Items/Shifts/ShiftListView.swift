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
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @State private var shifts: [Shift] = User.main.getShifts()

    @State private var showNewShiftSheet = false
    @State private var editMode: EditMode = .inactive

    @State private var showDeleteConfirmation = false
    @State private var upcomingToDelete: [Shift] = []

    var upcomingShifts: [Shift] {
        user.getShiftsBetween(startDate: .now.addHours(1), endDate: .distantFuture).reversed()
    }

    var pastShifts: [Shift] {
        user.getShiftsBetween(startDate: .distantPast, endDate: .now.addHours(-1))
    }

    func isSelected(_ shift: Shift) -> Bool {
        return upcomingToDelete.contains(where: { $0 == shift })
    }

    var shiftsByWeek: [Date: [Shift]] {
        Dictionary(grouping: pastShifts, by: { $0.start.startOfWeek() })
    }

    var sortedWeeks: [Date] {
        shiftsByWeek.keys.sorted(by: >)
    }

    @State private var mostRecentSelected = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Upcoming")
                    .font(.headline)
                    .padding([.top, .leading])
                    .padding(.leading, 21)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
//                        if upcomingShifts.isEmpty {
                        NavigationLink {
                            NewShiftView()
                        } label: {
                            Label("Add shifts", systemImage: "plus")
                                .padding()
                                .rectContainer(shadowRadius: 0, cornerRadius: 7)
                        }

                        .padding(.vertical)
                        .padding(.leading, 6)
//                        }

//                        if upcomingShifts.isEmpty == false {
//                            ZStack {
//                               Circle()
//                                    .fill(Color.white)
//                                VStack(spacing: 5) {
//                                   Text("New")
//
//                                       .font(.system(size: 10))
//                                   Image(systemName: "plus")
//                                       .font(.system(size: 14, weight: .medium))
//                               }
//                                .foregroundStyle(settings.getDefaultGradient())
//                           }
//                           .frame(height: 50)
//                        }

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
                                NavigationLink {
                                    ShiftDetailView(shift: shift)
                                } label: {
                                    ShiftCircle(dateComponent: Calendar.current.dateComponents([.month, .day], from: shift.start),
                                                isEditing: editMode.isEditing,
                                                isSelected: isSelected(shift))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
            }
            .background(Color.listBackgroundColor)

            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(user.groupShiftsByWeek().sortedKeys, id: \.self) { key in

                        if let arrayOfShifts = user.groupShiftsByWeek().dict[key] {
                            Section(key) {
                                ForEach(arrayOfShifts) { shift in

                                    NavigationLink {
                                        ShiftDetailView(shift: shift)
                                    } label: {
                                        ShiftRowView(shift: shift)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
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
    }

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
}

// MARK: - ShiftRowView

struct ShiftRowView: View {
    let shift: Shift
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        HStack {
            Text(shift.start.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(settings.getDefaultGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(shift.start.getFormattedDate(format: .abreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("Duration: \(shift.duration.formatForTime())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer()

            Text("\(shift.totalEarned.formattedForMoney())")
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
