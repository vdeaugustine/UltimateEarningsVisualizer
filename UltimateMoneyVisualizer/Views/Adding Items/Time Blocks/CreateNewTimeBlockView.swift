//
//  CreateNewTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import SwiftUI

// MARK: - CreateNewTimeBlockView

struct CreateNewTimeBlockView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main
    @Environment (\.dismiss) private var dismiss
    
    let shift: Shift

    @State private var title: String = ""
    @State var start: Date = .now
    @State var end: Date = .now
    @State private var selectedColorHex: String = Color.overcastColors.first!
    @State private var showColorOptions = false

    var pastBlocks: [TimeBlock] {
        guard let blocks = user.timeBlocks?.allObjects as? [TimeBlock] else {
            return []
        }
        if title.isEmpty == false {
            return blocks
                .filter { thisBlock in
                    let thisTitle = thisBlock.title ?? ""
                    return thisTitle.contains(title)
                }
                .sorted { $0.dateCreated ?? .distantPast > $1.dateCreated ?? .distantPast }
        }
        return blocks
    }

    var titles: [String] {
        var retArr: [String] = []
        for block in pastBlocks {
            guard let title = block.title else { continue }
            if retArr.contains(title) { continue }
            retArr.append(title)
        }
        return retArr
    }

    var body: some View {
        Form {
            TextField("Title", text: $title)
            DatePicker("Start Time", selection: $start,
                       in: shift.start ... shift.end,
                       displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $end,
                       in: shift.start ... shift.end,
                       displayedComponents: .hourAndMinute)
            VStack {
                
                Button {
                    withAnimation {
                        showColorOptions.toggle()
                    }

                } label: {
                    Text("Color")
                        .foregroundColor(.black)
                        .spacedOut {
                            HStack {
                                Circle()
                                    .fill(Color.hexStringToColor(hex: selectedColorHex))
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
                        .padding(.top, showColorOptions ? 10 : 0)
                }

                if showColorOptions {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Color.overcastColors, id: \.self) { colorHex in
                                Button {
                                    selectedColorHex = colorHex
                                } label: {
                                    Circle()
                                        .frame(height: 20)
                                        .foregroundColor(.hexStringToColor(hex: colorHex))
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

            Section {
                ForEach(titles, id: \.self) { blockTitle in
                    Text(blockTitle)
                        .allPartsTappable(alignment: .leading)
                        .onTapGesture {
                            title = blockTitle
                        }
                }

            } header: {
                Text("Recent")
            } footer: {
                Text("Tap to autofill Title field")
            }
        }
        .navigationTitle("Create TimeBlock")
        .putInTemplate()
        .conditionalModifier(title.isEmpty == false, { thisView in
            thisView
                .bottomButton(label: "Save") {
                    saveAction()
                }
        })
        
    }
}

extension CreateNewTimeBlockView {
    
    func saveAction() {
        
        // TODO: Check that the times are ok
        // TODO: Handle errors 
        do {
            try TimeBlock(
                title: title,
                start: start,
                end: end,
                colorHex: selectedColorHex,
                shift: shift,
                user: user,
                context: viewContext
            )
//            print("Saved timeblock")
            dismiss()
        }
        catch {
            print("Error saving time block")
        }
        
    }
    
    
}

// MARK: - CreateNewTimeBlockView_Previews

struct CreateNewTimeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTimeBlockView(shift: User.main.getShifts().first!)
            .putInNavView(.inline)
    }
}
