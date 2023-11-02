//
//  OnboardingProgressManagerView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/1/23.
//

import SwiftUI

// MARK: - OnboardingProgressManagerView

struct OnboardingProgressManagerView: View {
    @State private var gaugeAmount: Double = 0.2

    var body: some View {
        ScrollView {
            VStack {
                Text("Onboarding")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Earnings()

                Spending()

                Spacer()
                    .frame(idealHeight: 120, maxHeight: .infinity)

                HStack {
                    MainProgressPill(isFilled: true)
                    MainProgressPill(isFilled: true)
                    MainProgressPill(isFilled: true)
                    MainProgressPill(isFilled: false)
                    MainProgressPill(isFilled: false)
                }
                .padding(.horizontal, 50)
            }
            .padding(.bottom)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            UIColor.secondarySystemBackground.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
    }

    struct Earnings: View {
        var body: some View {
            VStack(alignment: .leading) {
                header
                rows
            }
            .padding()
        }

        var header: some View {
            HStack {
                Text("Earnings")
                    .font(.title2)
                    .fontWeight(.medium)

                Spacer()

                progressPills
            }
        }

        var rows: some View {
            VStack(alignment: .leading, spacing: 7) {
                Row(isComplete: true, headText: "Wage", subText: "How much you earn")

                Row(isComplete: false, headText: "Shift", subText: "How to enter your earnings")

                Row(isComplete: false, headText: "Work Schedule", subText: "Enter if you have a regular schedule")
            }
        }

        var progressPills: some View {
            HStack(spacing: 5) {
                ProgressPill(isFilled: true)
                ProgressPill(isFilled: true)
                ProgressPill(isFilled: true)
            }
        }
    }

    struct Spending: View {
        var body: some View {
            VStack(alignment: .leading) {
                header
                rows
            }
            .padding()
        }

        var header: some View {
            HStack {
                Text("Spending")
                    .font(.title2)
                    .fontWeight(.medium)

                Spacer()

                progressPills
            }
        }

        var rows: some View {
            VStack(alignment: .leading, spacing: 7) {
                Row(isComplete: true, headText: "Expenses", subText: "Tracking when you spend money")

                Row(isComplete: false, headText: "Goals", subText: "Tracking things you want to save up for")
            }
        }

        var progressPills: some View {
            HStack(spacing: 5) {
                ProgressPill(isFilled: true)
                ProgressPill(isFilled: false)
            }
        }
    }

    struct Row: View {
        let isComplete: Bool
        let headText: String
        let subText: String

        var body: some View {
            HStack(spacing: 10) {
                Image(systemName: isComplete ? "checkmark" : "circle")
                    .foregroundStyle(isComplete ? .blue : .secondary)

                VStack(alignment: .leading) {
                    Text(headText).font(.headline)
                    Text(subText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Components.nextPageChevron
            }
            .padding()
            .background {
                UIColor.systemBackground.color
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }

    struct ProgressPill: View {
        let isFilled: Bool
        var width: CGFloat = 20
        var height: CGFloat = 7

        var body: some View {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFilled ? Color.blue : Color.secondary, lineWidth: 2)
                .frame(width: width, height: height)
                .background(isFilled ? .blue : .clear)
        }
    }

    struct MainProgressPill: View {
        let isFilled: Bool
        var height: CGFloat = 7
        var body: some View {
            RoundedRectangle(cornerRadius: 4)
                .stroke(isFilled ? Color.blue : Color.secondary, lineWidth: 2)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(isFilled ? .blue : .clear)
        }
    }
}

#Preview {
    OnboardingProgressManagerView()
}
