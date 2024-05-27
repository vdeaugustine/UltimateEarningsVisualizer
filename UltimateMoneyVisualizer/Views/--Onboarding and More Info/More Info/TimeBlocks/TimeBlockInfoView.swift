//
//  MoreInfoGenericView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/26/23.
//

import SwiftUI

// MARK: - MoreInfoGenericView

struct TimeBlockInfoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
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
                
                
                
                
                ExamplesButton()
                
//                TutorialsButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .navigationTitle("Time Blocks")
        .background {
            Color.secondarySystemBackground
                .ignoresSafeArea()
        }
    }
}


#Preview {
    NavigationView {
        TimeBlockInfoView()
    }
}

extension TimeBlockInfoView {
    struct ExamplesButton: View {
        var body: some View {
            Button {
                NavManager.shared.appendCorrectPath(newValue: .timeBlockExampleForTutorial)
            } label: {
                HStack(spacing: 20) {
                    Image(systemName: "rectangle.stack.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                        .fixedSize()
                        .foregroundStyle(.tint)
                    VStack {
                        Text("Examples")
                            .font(.headline, design: .rounded)
                    }
                    Spacer()
                    Components.nextPageChevron
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 10)))
            }
            .buttonStyle(.plain)
        }
    }
}

extension TimeBlockInfoView {
    struct TutorialsButton: View {
        var body: some View {
            HStack(spacing: 20) {
                Image(systemName: "book.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 33)
                    .fixedSize()
                    .foregroundStyle(.tint)
                VStack {
                    Text("Tutorial")
                        .font(.headline, design: .rounded)
                }
                Spacer()
                Components.nextPageChevron
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 10))/*.shadow(radius: 4)*/)
        }
    }
}
