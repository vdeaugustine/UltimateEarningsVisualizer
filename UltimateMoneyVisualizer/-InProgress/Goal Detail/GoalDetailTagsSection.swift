//
//  GoalDetailTagsSection.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/11/23.
//

import SwiftUI
import Vin

// MARK: - GoalDetailTagsSection

struct GoalDetailTagsSection: View {
    @ObservedObject var viewModel: GoalDetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 40) {
                    header
                    buttonsPart
                }
                .padding([.vertical, .leading], 17)
                Spacer()
                largePriceTag
//                        .frame(maxHeight: .infinity)
                    .padding(.trailing, 10)
            }

            if viewModel.showTags {
                Spacer()
                tagsPart
            }
        }

        .frame(height: viewModel.tagsRectHeight)
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
        Text("Tags")
            .font(.title)
            .fontWeight(.semibold)
    }

    var tagsPart: some View {
        ScrollView {
            Divider()
                .padding(.bottom)

            ForEach(0 ..< viewModel.goal.getTags().count / 2, id: \.self) { index in
                HStack {
                    if let even = viewModel.goal.getTags().safeGet(at: index * 2) {
                        NewTagDesign(tag: even)
                            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
                    }

                    if let odd = viewModel.goal.getTags().safeGet(at: index * 2 + 1) {
                        NewTagDesign(tag: odd)
                            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            .padding(.horizontal)
        }
        .padding(.bottom)
        .frame(maxHeight: viewModel.tagsRectIncreaseAmount - 10)
//        List {
//            ForEach(viewModel.goal.getTags(), id: \.self) { tag in
//                if let title = tag.title {
//                    Text(title)
//                        .foregroundStyle(Color.white)
//                        .padding(5)
//                        .padding(.trailing)
//                        .background {
//                            PriceTag(width: nil,
//                                     height: 30,
//                                     color: tag.getColor(),
//                                     holePunchColor: .white,
//                                     rotation: 0)
//                        }
//                }
//            }
        ////            .listRowSeparator(.hidden)
//        }
//        .padding(.bottom)
//        .listStyle(.plain)
//        .frame(maxHeight: viewModel.tagsRectIncreaseAmount - 10)
    }

    var buttonsPart: some View {
        HStack {
            showHideButton
            addNewTagButton
        }
    }

    var showHideButton: some View {
        PayoffItemDetailViewStyledButton(text: viewModel.tagsButtonText,
                                         width: 100,
                                         animationValue: viewModel.showTags,
                                         action: viewModel.tagsButtonAction)
    }

    var addNewTagButton: some View {
        PayoffItemDetailViewStyledButton(text: "New",
                                         width: 100,
                                         animationValue: viewModel.showTags) {
            print("NEW TAPPED")
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

// MARK: - GoalDetailTagsSection_Previews

struct GoalDetailTagsSection_Previews: PreviewProvider {
    static var model = GoalDetailViewModel(goal: User.main.getGoals()
        .sorted(by: { $0.timeRemaining > $1.timeRemaining })
        .last!)
    static var previews: some View {
        ZStack(alignment: .leading) {
            Color.listBackgroundColor
            GoalDetailTagsSection(viewModel: GoalDetailViewModel(goal: User.main.getGoals()
                    .sorted(by: { $0.timeRemaining > $1.timeRemaining })
                    .last!))
                .padding()
        }
        .ignoresSafeArea()
    }
}
