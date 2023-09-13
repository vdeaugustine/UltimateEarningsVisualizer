//
//  GoalDetailShiftSection.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/12/23.
//

import SwiftUI

// MARK: - GoalDetailContributionsSection

struct GoalDetailContributionsSection: View {
    @ObservedObject var viewModel: PayoffItemDetailViewModel

    var body: some View {
        VStack {
            mainRect

            Spacer()

            if viewModel.showContributions {
                shiftsPart
            }
        }
        .frame(height: viewModel.contributionsRectHeight)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
    }

    var mainRect: some View {
        HStack {
            VStack(alignment: .leading, spacing: 40) {
                header
                showHideButton
            }
            .padding(.vertical)
            Spacer()

            calendarIcon
        }
        .padding(.horizontal, 20)
    }

    var shiftsPart: some View {
        List {
            ForEach(viewModel.payoffItem.getAllocations()) { alloc in

                if let shift = alloc.shift {
                    AllocShiftRow(shift: shift, allocation: alloc)
                }

                if let saved = alloc.savedItem {
                    AllocSavedRow(saved: saved, allocation: alloc)
                }
            }
        }
        .padding(.bottom)
        .listStyle(.plain)
        .frame(maxHeight: viewModel.contributionsRectIncreaseAmount - 10)
    }

    var header: some View {
        VStack {
            Text("Contributions")
                .font(.title2)
                .fontWeight(.medium)
        }
        .padding(.top, 10)
    }

    var showHideButton: some View {
        PayoffItemDetailViewStyledButton(text: viewModel.contributionsButtonText,
                                         animationValue: viewModel.showContributions,
                                         action: viewModel.contributionsButtonAction)
    }

    var calendarIcon: some View {
        Image(systemName: "tray.and.arrow.down.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 70)
            .foregroundStyle(viewModel.settings.getDefaultGradient())
    }

    func shiftRow(_ shift: Shift) -> some View {
        HStack {
            Text(shift.start.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(viewModel.settings.getDefaultGradient())
                .cornerRadius(8)
        }
        .padding()
        .background {
            Capsule(style: .circular)
                .fill(Color.targetGray)
        }
    }
}

// MARK: - GoalDetailContributionsSection_Previews

struct GoalDetailContributionsSection_Previews: PreviewProvider {
    static var previews: some View {
        GoalDetailContributionsSection(viewModel: PayoffItemDetailViewModel(payoffItem: User.main.getGoals().first(where: { $0.getAllocations().isEmpty == false })!))
            .padding()
            .templateForPreview()
    }
}
