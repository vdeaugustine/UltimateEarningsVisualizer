//
//  PopUpTester.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/17/23.
//

import PopupView
import SwiftUI

// MARK: - PopUpTester

struct PopUpTester: View {
    @State private var showingTopFirst = false

    var body: some View {
        VStack {
            Button("Show") {
                showingTopFirst.toggle()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.secondarySystemBackground
        }
        .popup(isPresented: $showingTopFirst) {
            PopupInfoContent(title: "This is a test tutorial", bodyContent: "This is a test content")
                .padding(30, 100)
        } customize: {
            $0
                .closeOnTap(true)
                .backgroundColor(.black.opacity(0.4))
        }
    }
}

// MARK: - PopupInfoContent

struct PopupInfoContent: View {
    // MARK: - Body

    let title: String
    let bodyContent: String
    var buttonText: String = "OK"
    var color: Color = .blue
    var buttonWeight: Font.Weight = .semibold
    var buttonAction: (() -> Void)?
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(.title3).fontWeight(.semibold)
            Text(bodyContent)
            Spacer()
            if let buttonAction {
                Button {
                    buttonAction()
                } label: {
                    Text(buttonText)
                        .fontWeight(buttonWeight)
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            color
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
    }
}

// MARK: - TimeBlockPopup

struct TimeBlockPopup: View {
    enum Options {
        case whyUse, howUse
    }
    @State private var optionSelected: Options = .whyUse
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Spacer()
                Text("Time Blocks")
                    .font(.title).fontWeight(.bold)
                GroupBox("What are they?") {
                    VStack(alignment: .leading, spacing: 10) {
                        bulletContent("Unique time segments within your work shift for you to categorize different tasks or activities.")
                        bulletContent("Each block represents a specific period you've spent doing a particular task during your shift.")
                    }
                    .font(.subheadline)
                    .padding(.vertical, 10)
                }
//                .groupBoxStyle(BlueBorderGroupBoxStyle())

//                Text("Why Use Time Blocks?")
//                    .font(.headline)
//                    .padding(.vertical, 10)

                Text("Why use them?")
                    .font(.title).bold()
                
                Picker("Option", selection: $optionSelected) {
                    Text("Why use them").tag(Options.whyUse)
                    Text("How to use them").tag(Options.howUse)
                    Text("What are they").tag(3)
                }
                .pickerStyle(.segmented)

//                VStack(alignment: .leading, spacing: 10) {
//                    GroupBox("Why use Time Blocks?") {
                if optionSelected == .whyUse {
                    TabView {
                        reasonsRow(title: "Task Management:", texts: ["Break your shift into manageable chunks, each dedicated to a specific task.", "It helps you organize your day and ensures you're covering all necessary work!"])

                        reasonsRow(title: "Earnings Insights:", texts: ["Ever wondered how much you earn per task? Time Blocks allow you to track earnings against specific activities.", "Discover how much you've earned just by 'Checking Emails' or 'Coding'!"])

                        reasonsRow(title: "Productivity Analysis:", texts: ["By categorizing your work, you can gain insights into where you spend most of your time and money.", "This information can be a game-changer for your productivity and financial planning!"])
                    }
                    .tabViewStyle(.page)
                    .frame(height: 200)
                }

//                    }
//                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }

        .background {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding()
    }

    @ViewBuilder func bulletContent(_ text: String, color: Color = .black, font: Font = .subheadline, fontWeight: Font.Weight = .regular) -> some View {
        HStack {
            Circle()
                .foregroundStyle(color)
                .frame(height: 7)
            Text(text)
                .font(font)
                .fontWeight(fontWeight)
        }
    }

    @ViewBuilder func reasonsRow(title: String, texts: [String]) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                VStack(alignment: .leading) {
                    ForEach(texts, id: \.self) { text in

                        HStack(spacing: 10) {
                            Circle()
                                .frame(height: 5)
                            Text(text)
                                .font(.footnote)
                        }
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                        .padding(.leading)
                    }
                }
            }
        }
        .groupBoxStyle(BlueBorderGroupBoxStyle())
        .padding(.horizontal)

//        .padding()
//        .border(Color.blue, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - BlueBorderGroupBoxStyle

struct BlueBorderGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            configuration.label
                .fontWeight(.semibold)
//                .padding(.leading, 8) // Add padding to the leading edge of the label if needed
            configuration.content
        }
        .frame(maxWidth: .infinity)
        .padding() // Add padding around the content
        .background(Color.white) // Set the background color to white
        .clipShape(RoundedRectangle(cornerRadius: 10)) // Optional: if you want rounded corners
        .overlay(RoundedRectangle(cornerRadius: 10)

            .stroke(LinearGradient(gradient: Gradient(colors: [.blue, .teal]), startPoint: .leading, endPoint: .trailing), lineWidth: 2
//                    EllipticalGradient(colors: [.blue, .purple], center: .center, startRadiusFraction: 0.0, endRadiusFraction: 1.0)
            )

//                .stroke(Color.blue, lineWidth: 1) // Set the border color to blue and width to 1
        )
    }
}



// MARK: - PopupContentOne_Previews

struct PopupContentOne_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
//            Color.red.ignoresSafeArea()
            TimeBlockPopup()
        }
    }
}
