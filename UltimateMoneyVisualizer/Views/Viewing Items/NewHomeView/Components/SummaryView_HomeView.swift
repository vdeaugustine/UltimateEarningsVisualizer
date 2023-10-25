//
//  SummaryView_HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/25/23.
//

import SwiftUI

// MARK: - SummaryView_HomeView

struct SummaryView_HomeView: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    var body: some View {
        VStack(spacing: 16) {
            HeaderView(title: "\(vm.selectedTotalItem.title) Summary", subtitle: vm.selectedTotalItem.quantityLabel(vm))
            VStack(spacing: 12) {
                ForEach(vm.getSummaryRows()) { row in
                    SubSection(title: row.title, value: row.valueString)
                }
            }
            Divider()
            HStack {
                Text("Total")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.13, green: 0.13, blue: 0.13))
                    .underline()
                Spacer()
                Text(vm.getSummaryTotal().money())
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
            }
        }
        .padding(20)
        .background(.white)
        .cornerRadius(12)
        .modifier(ShadowForRect())
        .padding(.horizontal)
    }

    // MARK: - HeaderView

    struct HeaderView: View {
        let title: String
        let subtitle: String

        var body: some View {
            HStack {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

                Spacer()
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
            }
        }
    }

    // MARK: - SubSectionView

    struct SubSection: View {
        let title: String
        let value: String

        var body: some View {
            HStack {
                Text(title)
//                    .underline()
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

                Spacer()

                Text(value)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.black)
            }
            .font(.system(size: 14))
        }
    }
}


#Preview {
    SummaryView_HomeView()
}
