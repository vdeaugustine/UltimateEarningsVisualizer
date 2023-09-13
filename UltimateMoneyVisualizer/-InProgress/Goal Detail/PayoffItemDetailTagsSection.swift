
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
    @State private var showAlert = false
    @State private var showSelectTagsSheet = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                header
                    .padding([.vertical, .leading], 17)
                Spacer()
                largePriceTag
                    .padding([.trailing, .top], 10)
            }
            .padding(.top)

            Divider()
                .padding(.top)

            LazyVStack(content: {
                ForEach(viewModel.tags) { tag in
                    Menu {
                        Button {
                            NavManager.shared.appendCorrectPath(newValue: .tagDetail(tag))
                        } label: {
                            Label("View", systemImage: "info.circle")
                        }
                        
                        Button {
                            do {
                                try viewModel.payoffItem.removeTag(tag: tag)
                                viewModel.tags = viewModel.payoffItem.getTags()
                            } catch {
                                showAlert = true
                            }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                        
                        
                    } label: {
                        TagRow(tag: tag)
                            .padding(.vertical, 5)

                    }.foregroundStyle(Color.black)
                    Divider()
                }
                Menu {
                    Button {
                        showSelectTagsSheet.toggle()
                    } label: {
                        Label("Existing", systemImage: "list")
                    }
                    
                    Button {
                        NavManager.shared.appendCorrectPath(newValue: .createTag(AnyPayoffItem(viewModel.payoffItem)))
                    } label: {
                        Label("New", systemImage: "plus")
                    }
                    
                    
                } label: {
                    Label("Add", systemImage: "plus")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, maxHeight: 45, alignment: .leading)
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Failed to remove tag"), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $viewModel.showTags, content: {
            TagListForItemView(item: viewModel.payoffItem)
        })
        .sheet(isPresented: $showSelectTagsSheet, onDismiss: {
            viewModel.tags = viewModel.payoffItem.getTags()
        } ) {
            SelectATagView(item: viewModel.payoffItem)
        }
        
    }

    var header: some View {
        Text("Tags")
            .font(.title)
            .fontWeight(.semibold)
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

// MARK: - PayoffItemDetailTagsSection_Previews

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

