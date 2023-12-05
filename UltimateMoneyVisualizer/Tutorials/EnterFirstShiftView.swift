//
//  EnterFirstShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/6/23.
//

import SwiftUI

// MARK: - EnterFirstShiftView

struct EnterFirstShiftView: View {
    
    @State private var step = 0
    @State private var startTime = Date.getThisTime(hour: 9, minute: 0) ?? .now.addHours(-4)
    @State private var endTime = Date.getThisTime(hour: 17, minute: 0) ?? .now.addHours(4)
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            List {
    //            VStack {

                if step > 0 {
                    Section {
                        Text("Shifts are a way for you to keep track of the hours you work and earn money")
    //                    VStack(alignment: .leading, spacing: 20) {
    ////                        Text("• Shifts are exactly what they sound like.")
    ////                        Text("• They are ways for you to enter your work days")
    ////                        Text("• You can either enter them after they happen or after they are over.")
    ////                        Text("• You can also track your shift if it is currently in progress by using a ") + Text("TodayShift").bold()
    //                    }
                        
                        
                    }
                    .id(0)
    //                .transition(.move(edge: .trailing))
                    
                }
                
                if step > 1 {
                    Section {
                        Text("Let's create your first shift together")
                    }
                }
                
                if step > 2 {
                    Section {
                        Text("Simply enter the start time and end time")
                        
                        DatePicker("Start", selection: $startTime/*, displayedComponents: .hourAndMinute*/)
                            .listRowSeparator(.hidden)
                        DatePicker("End", selection: $endTime/*, displayedComponents: .hourAndMinute*/)
                    }
                }
                
                
                
    //            }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            UIColor.secondarySystemBackground.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
        .bottomButton(label: "Next") {
            withAnimation {
                step += 1
            }
        }
        .onAppear(perform: {
            withAnimation {
                step += 1
            }
        })
    }
}

// MARK: - WhiteBackgroundGroupBoxStyle

struct WhiteBackgroundGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .frame(maxWidth: .infinity)
//            .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 1)
    }
}

#Preview {
    EnterFirstShiftView()
}
