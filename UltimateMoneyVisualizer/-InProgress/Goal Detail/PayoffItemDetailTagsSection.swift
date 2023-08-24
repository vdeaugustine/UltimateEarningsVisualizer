//
//  PayoffItemDetailTagsSection.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/11/23.
//

import SwiftUI
import Vin

// MARK: - PayoffItemDetailTagsSection

struct PayoffItemDetailTagsSection: View {
    @ObservedObject var viewModel: PayoffItemDetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
//                VStack(alignment: .leading, spacing: 40) {
                    header
//                }
                .padding([.vertical, .leading], 17)
                Spacer()
                largePriceTag
                    .padding([.trailing, .top], 10)
            }
            .padding(.top)
            
            Divider()
                .padding(.top)
            
            LazyVStack(content: {
                ForEach(viewModel.payoffItem.getTags()) { tag in
                    TagRow(tag: tag)
                        
                        .padding(.vertical, 5)
                    Divider()
                }
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .createTag(AnyPayoffItem(viewModel.payoffItem)))
                } label: {
                    Label("New", systemImage: "plus")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 45, alignment: .leading)
                }
                
                
                .padding(.vertical)
                .padding(.leading, 4)
                .padding(.bottom, 4)
            })
            .padding(.horizontal)
        }

        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
                
        }
        .sheet(isPresented: $viewModel.showTags, content: {
            TagListForItemView(item: viewModel.payoffItem)
        })
    }


    var header: some View {
        Text("Tags")
            .font(.title)
            .fontWeight(.semibold)
    }
//
//    var tagsPart: some View {
//        ScrollView {
//            Divider()
//                .padding(.bottom)
//
//            ForEach(0 ..< viewModel.payoffItem.getTags().count / 2, id: \.self) { index in
//                HStack {
//                    if let even = viewModel.payoffItem.getTags().safeGet(at: index * 2) {
//                        NewTagDesign(tag: even)
//                            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
//                    }
//
//                    if let odd = viewModel.payoffItem.getTags().safeGet(at: index * 2 + 1) {
//                        NewTagDesign(tag: odd)
//                            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//
//            .padding(.horizontal)
//        }
//        .padding(.bottom)
//        .frame(maxHeight: viewModel.tagsRectIncreaseAmount - 10)
////        List {
////            ForEach(viewModel.payoffItem.getTags(), id: \.self) { tag in
////                if let title = tag.title {
////                    Text(title)
////                        .foregroundStyle(Color.white)
////                        .padding(5)
////                        .padding(.trailing)
////                        .background {
////                            PriceTag(width: nil,
////                                     height: 30,
////                                     color: tag.getColor(),
////                                     holePunchColor: .white,
////                                     rotation: 0)
////                        }
////                }
////            }
//        ////            .listRowSeparator(.hidden)
////        }
////        .padding(.bottom)
////        .listStyle(.plain)
////        .frame(maxHeight: viewModel.tagsRectIncreaseAmount - 10)
//    }

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
            NavManager.shared.appendCorrectPath(newValue: .createTag(.init(viewModel.payoffItem)))
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

struct PayoffItemDetailTagsSection_Previews: PreviewProvider {
    static var model = PayoffItemDetailViewModel(payoffItem: User.main.getGoals()
        .sorted(by: { $0.timeRemaining > $1.timeRemaining })
        .last!)
    static var previews: some View {
        ZStack(alignment: .leading) {
            Color.listBackgroundColor
            PayoffItemDetailTagsSection(viewModel: model)
                .padding()
        }
        .ignoresSafeArea()
    }
}
