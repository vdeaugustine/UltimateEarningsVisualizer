//
//  TagDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import SwiftUI

// MARK: - TagDetailView

struct TagDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main
    @Environment(\.dismiss) private var dismiss

    let tag: Tag

    let symbolWidthHeight: CGFloat = 40
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    symbol
                    Text(tag.getTitle())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    var symbol: some View {
        Image(systemName: tag.getSymbolStr())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: symbolWidthHeight, height: symbolWidthHeight)
            .foregroundColor(Color.white)
            .padding(15)
            .background(tag.getColor())
            .clipShape(Circle())
    }
//    var body: some View {
//        Form {
//            Section("Tag Title") {
//                Text(tag.getTitle())
//            }
//
//            Section("Symbol") {
//                HStack {
//                    SystemImageWithFilledBackground(systemName: tag.getSymbolStr(), backgroundColor: tag.getColor(), width: symbolWidthHeight, height: symbolWidthHeight)
//
//                    Spacer()
//
//                    Button("Edit") {
//                    }
//                }
//            }
//
//            Section("Goals") {
//                ForEach(user.getGoalsWith(tag: tag)) { goal in
//
//                    Button {
//                        NavManager.shared.appendCorrectPath(newValue: .payoffItemDetailView(AnyPayoffItem(goal)))
    ////                        PayoffItemDetailView(payoffItem: goal)
//                    } label: {
//                        Text(goal.titleStr)
//                    }
//                }
//            }
//
//            Section("Expenses") {
//                ForEach(user.getExpensesWith(tag: tag)) { expense in
//
//                    Button {
//                        NavManager.shared.appendCorrectPath(newValue: .payoffItemDetailView(AnyPayoffItem(expense)))
//                    } label: {
//                        Text(expense.titleStr)
//                    }
//                }
//            }
//
//            Section("Saved Items") {
//                ForEach(user.getSavedItemsWith(tag: tag)) { saved in
//
//                    Button {
//
//
//                        NavManager.shared.appendCorrectPath(newValue: .saved(saved))
//
//                    } label: {
//                        Text(saved.getTitle())
//                    }
//                }
//            }
//        }
//        .putInTemplate()
//        .navigationTitle("Tag Details")
//    }
}

extension Array where Element: Equatable {
    enum PopDirection {
        case fromFront
        case fromBack
    }

    mutating func popUntil(_ element: Element, direction: PopDirection) {
        switch direction {
            case .fromBack:
                while let lastItem = last, lastItem != element {
                    removeLast()
                }
            case .fromFront:
                while let firstItem = first, firstItem != element {
                    removeFirst()
                }
        }
    }
}

extension Color {
    static let primaryBackground = UIColor.systemBackground.color
    static let secondaryBackground = UIColor.secondarySystemBackground.color
    static let tertiaryBackground = UIColor.tertiarySystemBackground.color
}

// MARK: - NewTagDetailView

struct NewTagDetailView: View {
    let symbolWidthHeight: CGFloat = 40

    var body: some View {
        ScrollView {
            VStack {
                symbolAndTitle
                topRow
                    .padding(.top)
                
                
                GroupBox {
                    
                }
                
                
            }
            .padding()
            .background(Color.secondaryBackground)
        }
        .background(Color.secondaryBackground)
    }
    
    var topRow: some View {
        GeometryReader { geo in
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("24")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        

                    Text("Instances")
                        .font(.title3)
                }
                .pushLeft()
                .padding(10)
                .frame(width: geo.size.width * 0.35)

                .background(.tertiaryBackground, cornerRadius: 12, shadow: 0)

                VStack(alignment: .leading) {
                    Text("$240")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        

                    Text("Total")
                        .font(.title3)
                }
                .pushLeft()
                .padding(10)
                .frame(width: geo.size.width * 0.35)

                .background(.tertiaryBackground, cornerRadius: 12, shadow: 0)
            }
            .frame(maxWidth: .infinity)
        }
    }

    var symbol: some View {
        Image(systemName: "tag")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: symbolWidthHeight, height: symbolWidthHeight)
            .foregroundColor(Color.white)
            .padding(15)
            .background(.cyan)
            .clipShape(Circle())
    }

    var symbolAndTitle: some View {
        HStack(spacing: 20) {
            symbol
            Text("Christmas Presents")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NewTagDetailView()
}

// MARK: - TagDetailView_Previews

// struct TagDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagDetailView(tag: User.main.getTags().first!)
//            .environment(\.managedObjectContext, PersistenceController.context)
//            .putInNavView(.inline)
//    }
// }
