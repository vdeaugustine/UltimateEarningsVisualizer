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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Shift.startDate, ascending: false)],
        animation: .default)
    private var shifts: FetchedResults<Shift>

    var body: some View {
            List {
                ForEach(shifts) { shift in
                    NavigationLink(destination: ShiftDetailView(shift: shift)) {
                        VStack(alignment: .leading) {
                            Text("\(shift.startDate?.getFormattedDate(format: .abreviatedMonthAndMinimalTime) ?? "")")
                                .font(.headline)
                            Text("\(shift.dayOfWeek ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteShifts)
            }
            .navigationTitle("Shifts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: CreateShiftView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        
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

struct ShiftListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.context
        let shift = Shift(context: context)
        shift.startDate = Date()
        shift.endDate = Date()
        shift.dayOfWeek = "Monday"
        return ShiftListView().environment(\.managedObjectContext, context).putInNavView(.inline)
    }
}

