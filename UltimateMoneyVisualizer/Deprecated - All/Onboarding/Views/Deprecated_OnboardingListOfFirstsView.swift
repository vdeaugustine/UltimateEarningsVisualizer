//
//  OnboardingListOfFirstsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/30/23.
//

import SwiftUI

// MARK: - OnboardingListOfFirstsView

struct Deprecated_OnboardingListOfFirstsView: View {
    @State private var goalCompleted = false
    @State private var expenseCompleted = false
    @State private var shiftCompleted = false
    @State private var todayViewCompleted = false
    @State private var enterWageCompleted = false

    var body: some View {
        ScrollView {
            VStack {
                headerAndSubheader
                VStack(spacing: 8) {
                    singleRow(isComplete: enterWageCompleted, title: "Wage", description: "Enter details about your wage so you can see your earnings in real time and get accurate earnings from shifts.") {
                        withAnimation {
                            enterWageCompleted.toggle()
                        }
                    }
                    
                    singleRow(isComplete: enterWageCompleted, title: "Schedule", description: "Set up your regular schedule so shifts are generated for you automatically.") {
                        withAnimation {
                            enterWageCompleted.toggle()
                        }
                    }
                    
                    singleRow(isComplete: enterWageCompleted, title: "First Goal", description: "Enter details about your wage so you can see your earnings in real time and get accurate earnings from shifts.") {
                        withAnimation {
                            enterWageCompleted.toggle()
                        }
                    }
                    
                    singleRow(isComplete: enterWageCompleted, title: "First Expense", description: "Enter details about your wage so you can see your earnings in real time and get accurate earnings from shifts.") {
                        withAnimation {
                            enterWageCompleted.toggle()
                        }
                    }
                }
                Spacer()
                OnboardingButton(title: "Continue") {
                    
                }
                Text("Skip tutorial")
                    .foregroundColor(.blue)
                    .font(.system(.subheadline, weight: .medium))
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
            .padding(.bottom, 50)
            .padding(.horizontal, 29)
        }
    }

    var bookmarkIconAtTop: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.cyan, .blue]), startPoint: .top, endPoint: .bottom)
                .mask { RoundedRectangle(cornerRadius: 18, style: .continuous) }
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            Image(systemName: "bookmark.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .font(.system(.largeTitle, weight: .light))
                .rotationEffect(.degrees(90), anchor: .center)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 3)
        }
        .frame(width: 80, height: 80)
        .clipped()
        .padding(.bottom, 8)
    }

    var headerAndSubheader: some View {
        VStack(spacing: 4) {
            Text("Tutorial Walkthrough")
                .font(.system(.title, weight: .semibold).width(.condensed))
                .multilineTextAlignment(.center)
            Text("Create your first of each item to get an understanding of how the app works")
                .font(.system(.footnote, weight: .medium))
                .frame(width: 280)
                .clipped()
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom, 32)
    }
    
    
    func singleRow(isComplete: Bool, title: String, description: String, _ tapAction: @escaping () -> Void) -> some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .imageScale(.small)
                .foregroundColor(.blue)
                .font(.system(.title, weight: .regular))
                .frame(width: 44, height: 50)
                .clipped()
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(title.uppercased())
                        .font(.system(.subheadline, weight: .semibold).width(.expanded))
//                    Text("$6 / $30")
//                        .font(.system(.caption, weight: .semibold))
//                        .foregroundColor(.secondary)
                }
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding()
        .background(Color(.quaternarySystemFill))
        .mask { RoundedRectangle(cornerRadius: 18, style: .continuous) }
        .onTapGesture {
            tapAction()
        }
    }
    
    
    
}

// MARK: - OnboardingListOfFirstsView_Previews

struct OnboardingListOfFirstsView_Previews: PreviewProvider {
    static var previews: some View {
        Deprecated_OnboardingListOfFirstsView()
    }
}
