//
//  DetailsProView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/25/23.
//
import SwiftUI

// MARK: - DetailsProView

struct DetailsProView: View {
    @FetchRequest(entity: Goal.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Goal.dateCreated, ascending: false)]) private var goals: FetchedResults<Goal>

    @FetchRequest(entity: Expense.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Expense.dateCreated, ascending: false)]) private var expenses: FetchedResults<Expense>

    var payoffItems: [PayoffItem] {
        var combinedItems: [PayoffItem] = []
        combinedItems.append(contentsOf: goals.map { $0 as PayoffItem })
        combinedItems.append(contentsOf: expenses.map { $0 as PayoffItem })
        combinedItems.sort { $0.optionalQSlotNumber ?? 0 < $1.optionalQSlotNumber ?? 0 }
        return combinedItems
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                titleSection
                horizontalScrollView
                collectionsSection
            }
            .frame(maxWidth: .infinity)
            .clipped()
            .padding(.bottom, 150)
        }
    }

    private var titleSection: some View {
        Text("Payoff Items")
            .font(.system(.largeTitle, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
            .padding(.leading)
    }

    @ViewBuilder
    private var horizontalScrollView: some View {
        if payoffItems.isEmpty {
            GroupBox {
                Text("No payoff items yet")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            .padding()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(payoffItems.indices, id: \.self) { itemIndex in // Replace with your data model here
                        if let item = payoffItems.safeGet(at: itemIndex) {
                            PayoffItemCard(item: item)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var collectionsSection: some View {
        ForEach(0 ..< 5) { _ in // Replace with your data model here
            CollectionView()
        }
    }
}

// MARK: - PayoffItemCard

private struct PayoffItemCard: View {
    var item: PayoffItem

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Divider()
                .padding(.bottom, 8)
            Text(item.titleStr.uppercased())
                .font(.system(.caption2, weight: .medium))
                .foregroundColor(.blue)
            Text(item.info ?? "")
                .font(.system(.headline, weight: .regular))
            payoffItemImage
        }
        .frame(width: 350)
        .clipped()
    }

    @ViewBuilder
    private var payoffItemImage: some View {
        if let image = item.loadImageIfPresent() {
            Image(uiImage: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 230)
                .clipped()
                .mask(RoundedRectangle(cornerRadius: 5, style: .continuous))
                .padding(.top, 8)
        }
    }
}

// MARK: - CollectionView

private struct CollectionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.horizontal)
            Text("Collection Title")
                .padding(.leading)
                .font(.system(.title3, weight: .semibold))
            Text("Collection Subtitle")
                .padding(.leading)
                .font(.system(.headline, weight: .regular))
                .foregroundColor(.secondary)
            horizontalCollectionScrollView
        }
        .padding(.top, 24)
    }

    private var horizontalCollectionScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.adaptive(minimum: 62))], spacing: 13) {
                ForEach(0 ..< 5) { _ in // Replace with your data model here
                    CollectionItem()
                }
            }
            .frame(minHeight: 136)
            .clipped()
            .padding(.horizontal)
        }
    }
}

// MARK: - CollectionItem

private struct CollectionItem: View {
    var body: some View {
        HStack {
            Image("myImage")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 62, height: 62)
                .clipped()
            VStack(alignment: .leading, spacing: 2) {
                Text("App Name")
                Text("Subtitle")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("Get".uppercased())
                .font(.system(.footnote, weight: .medium))
                .foregroundColor(.blue)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(Color(.secondarySystemFill))
                .mask(RoundedRectangle(cornerRadius: 40, style: .continuous))
        }
        .frame(width: 350)
        .clipped()
    }
}

#Preview {
    DetailsProView()
}
