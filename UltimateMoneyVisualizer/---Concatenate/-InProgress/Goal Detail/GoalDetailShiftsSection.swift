//
//  GoalDetaiShiftsSection.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/11/23.
//

import SwiftUI
import Vin

// MARK: - GoalDetailShiftsSection

struct GoalDetailShiftsSection: View {
    @ObservedObject var viewModel: PayoffItemDetailViewModel


    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        header
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.payoffItem.getTags()) { tag in
                                    Button {
                                        NavManager.shared.appendCorrectPath(newValue: .tagDetail(tag))
                                    } label: {
                                        Text(tag.title ?? "NA")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .padding(.trailing, 10)
                                            .background {
                                                PriceTag(height: 30, color: tag.getColor(), holePunchColor: .secondarySystemBackground)
                                            }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    VStack {
                        largePriceTag
                    }.frame(maxHeight: .infinity)
                }
            }
        }
        .padding()
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
                .overlay {
                    backDrop
                }
        }
    }

    var backDrop: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        }
    }

    var header: some View {
        VStack {
            Text("Tags")
                .font(.title)
                .fontWeight(.semibold)
        }
    }

    var largePriceTag: some View {
        PriceTag(width: 75,
                 height: 50,
                 color: viewModel.user.getSettings().themeColor,
                 holePunchColor: .white,
                 rotation: 200)
            .padding(.trailing, 10)
    }

   
}

// MARK: - GoalDetailShiftsSection_Previews

struct GoalDetailShiftsSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.secondarySystemBackground
            GoalDetailShiftsSection(viewModel: PayoffItemDetailViewModel(payoffItem: User.main.getGoals()
                    .sorted(by: { $0.timeRemaining > $1.timeRemaining })
                    .last!))
                .padding()
        }
        .ignoresSafeArea()
    }
}
