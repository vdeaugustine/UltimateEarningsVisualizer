//
//  MoreInfoRectTemplate.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/27/23.
//

import SwiftUI

struct MoreInfoRectTemplate: View {
    // MARK: - WhatIsInfoRect

    let title: String
    let titleImage: String
    let rowsContent: [RowContent]

    let contentHPadding: CGFloat = 10
    let contentVPadding: CGFloat = 20

    var body: some View {
        VStack {
            HeaderPart
            ListPart
        }
        .padding(contentHPadding, contentVPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 10)) /* .shadow(radius: 4) */ )
    }

    @ViewBuilder
    var HeaderPart: some View {
        VStack(spacing: 20) {
            Image(systemName: titleImage /* IconManager.timeBlockExpanded */ )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .fixedSize()
                .foregroundStyle(.tint)

            Text(title)
                .font(.title)
        }

        .fontWeight(.semibold)
    }

    @ViewBuilder
    var ListPart: some View {
        VStack(spacing: 20) {
            ForEach(rowsContent, id: \.self) { row in
                RowForList(content: row)
            }
        }
    }

    struct RowForList: View {
        let content: RowContent
        @State private var isShowingExample = false
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: content.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                    .foregroundStyle( /* User.main.settings?.themeColor ?? */ Color.blue)

                VStack(alignment: .leading, spacing: 5) {
                    Text(content.header)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    Text(content.body)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
        }
    }

    struct RowContent: Hashable {
        let image: String
        let header: String
        let body: String
        let example: String
    }
}

#Preview {
    MoreInfoRectTemplate(title: "Benefits",
                   titleImage: "clock",
                   rowsContent: [.init(image: "text.badge.checkmark",
                                       header: "Task Management",
                                       body: "Break your shift into manageable chunks, each dedicated to a specific task",
                                      example: "Check email, go to meetings, even taking trips to the water cooler. Anything you want!"
                                      ),

                                 .init(image: "dollarsign.circle.fill",
                                       header: "Earnings Insights",
                                       body: "Ever wondered how much you earn per task? Time Blocks allow you to track earnings against specific activities",
                                       example: "Check email, go to meetings, even taking trips to the water cooler. Anything you want!"),
                                 .init(image: "chart.bar.fill",
                                       header: "Productivity Analysis",
                                       body: "Gain insights into where you spend most of your time and money",
                                       example: "Check email, go to meetings, even taking trips to the water cooler. Anything you want!")])
}
