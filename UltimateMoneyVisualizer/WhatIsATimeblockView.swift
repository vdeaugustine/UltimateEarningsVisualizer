//
//  WhatIsATimeblockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/9/24.
//

import SwiftUI

struct WhatIsATimeblockView: View {
    var body: some View {
        ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("What is a Time Block?")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("A time block is a feature that allows you to break down your shifts into smaller, manageable segments where you specify what tasks you performed during that time. This helps you track how much time you spend on different activities and how much you earn from each task.")
                            .font(.body)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Benefits")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("• **Detailed Task Tracking:** See how your work hours are divided among various tasks.")
                            Text("• **Earnings Insight:** Understand how much money you make from specific activities, like checking emails or attending meetings.")
                            Text("• **Productivity Analysis:** Analyze where you spend most of your time and how it impacts your earnings.")
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Example")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("Shift on [Date]")
                            Text("• **9 am - 10 am:** Checked emails")
                            Text("• **10 am - 1 pm:** Coding")
                            Text("• **1 pm - 5 pm:** Meetings")
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Visualization")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("• **Earnings Breakdown:** Visualize earnings by task (e.g., \"I made $5000 this year just checking emails\").")
                            Text("• **Expense Comparison:** Compare task earnings with expenses (e.g., \"I paid off my rent for 2 months this year just from checking emails\").")
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Attributes")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text("• **Color:** Customizable color for display purposes.")
                            Text("• **Date Created:** The date the time block was created.")
                            Text("• **Start Time:** The time the block started.")
                            Text("• **End Time:** The time the block ended.")
                            Text("• **Title:** The name of the block (e.g., \"Checking Email\").")
                        }

                        Button(action: {
                            // Action for learning more
                        }) {
                            Text("Learn More")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
                .background(Color(.secondarySystemBackground))
                .navigationBarTitle("Time Block Info", displayMode: .inline)
    }
}

#Preview {
    WhatIsATimeblockView()
}
