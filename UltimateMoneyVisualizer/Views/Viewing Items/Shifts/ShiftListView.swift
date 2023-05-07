//
//  ShiftListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI
import CoreData

struct ShiftListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var user: User = User.main
    @State private var shifts: [Shift] = User.main.getShifts()
    
    @State private var showNewShiftSheet = false
    @State private var editMode: EditMode = .inactive

    @State private var showDeleteConfirmation = false
    @State private var upcomingToDelete: [Shift] = []

    var upcomingShifts: [Shift] {
        user.getShiftsBetween(startDate: .now.addHours(1), endDate: .distantFuture)
    }

    var pastShifts: [Shift] {
        user.getShiftsBetween(startDate: .distantPast, endDate: .now.addHours(-1))
    }

    func isSelected(_ shift: Shift) -> Bool {
        return upcomingToDelete.contains(where: { $0 == shift })
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
                                    ShiftCircle(dateComponent: Calendar.current.dateComponents([.month,.day], from: shift.start),
                                                isEditing: editMode.isEditing,
                                                isSelected: isSelected(shift))
                                }
                                .buttonStyle(.plain)
                            }
                        }
//
                        if upcomingShifts.isEmpty {
                            NavigationLink("Add upcoming shifts") {
                                MultipleNewShiftsView()
                            }
                            .padding()
//                            .putInRect(withShadow: false)
                            .padding(.vertical)
                            .padding(.leading, 6)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
            }
            .background(Color.targetGray)

            VStack(alignment: .leading, spacing: 0) {
                List {
                    Section {
                        if pastShifts.isEmpty {
                            Text("No shifts recorded yet")
                        } else {
                            ForEach(pastShifts) { shift in
                                NavigationLink {
                                    ShiftDetailView(shift: shift)
                                } label: {
                                    ShiftRowView(shift: shift)
//                                    Text(shift.startTime.getFormattedDate(format: .abreviatedMonth))
                                }
                            }
                            .onDelete(perform: deleteShifts)
                        }

                    } header: {
                        Text("Recent")
                            .textCase(nil)
                            .font(.headline)
                            .foregroundColor(.black)
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
            CreateShiftView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
        .safeAreaInset(edge: .bottom, content: {
            if editMode.isEditing {
                Button {
                    withAnimation {
                        showDeleteConfirmation.toggle()
                    }

                } label: {
                    if upcomingToDelete.isEmpty {
                        BottomViewButton(label: "Cancel")
                    } else {
                        BottomViewButton(label: "Delete", gradient: Color.red.getGradient())
                        
                    }
                }

            }
        })
        
        
//        .if(editMode == .inactive, content: { selfView in
//            selfView
//                .bottomPlusNav(destination: {
//                    MultipleNewShiftsView()
//                })
//        })
        
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

    

    
    
    
    
    

//    var body: some View {
//
//
        
        
//            List {
//                ForEach(shifts) { shift in
//                    NavigationLink(destination: ShiftDetailView(shift: shift)) {
//                        VStack(alignment: .leading) {
//                            Text("\(shift.startDate?.getFormattedDate(format: .abreviatedMonthAndMinimalTime) ?? "")")
//                                .font(.headline)
//                            Text("\(shift.dayOfWeek ?? "")")
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//                .onDelete(perform: deleteShifts)
//            }
//            .putInTemplate()
//            .navigationTitle("Shifts")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    NavigationLink(destination: CreateShiftView()) {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
        
//    }
    
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

struct ShiftListView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftListView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}

