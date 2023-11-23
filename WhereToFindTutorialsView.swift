//
//  WhereToFindTutorialsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/20/23.
//

import SwiftUI

// MARK: - WhereToFindTutorialsView

struct WhereToFindTutorialsView: View {
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                titleAndSubtitle

                Spacer(minLength: 30)

                VStack(spacing: 30) {
                    mockSettings

                    Text("You can always access informational content in the \"Tutorials and More Info\" section of the settings tab")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            OnboardingButton(title: "Let's Go", height: 50) {
            }
            .padding(.horizontal, 30)
            .padding(.bottom)
        }
    }

    var titleAndSubtitle: some View {
        VStack(spacing: 30) {
            Text("That's ok!")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            VStack(alignment: .leading, spacing: 20) {
                Text("You want to get started managing your money right away. We get it.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .foregroundStyle(.secondary)
            .lineSpacing(3)
        }
    }

    var mockSettings: some View {
        VStack(spacing: 0) {
            VStack {
                VStack(spacing: 42) {
                    blankContentMockSettings

                    VStack(spacing: 7) {
                        Text("TUTORIALS AND MORE INFO")
                            .font(.system(size: 13))
                            .foregroundStyle(UIColor.secondaryLabel.color)
                            .pushLeft()
                            .padding(.leading, 16)
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(UIColor.systemBackground.color)
                                .frame(height: 44)
                                .overlay {
                                    HStack {
                                        Image(systemName: "bookmark.fill")
                                            .foregroundStyle(settings.themeColor)
                                        Text("Tutorials")
                                        Spacer()
                                        Components.nextPageChevron
                                    }
                                    .padding()
                                }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding()
            .background {
                UIColor.secondarySystemBackground.color
                    .cornerRadius(10, corners: [.topLeft, .topRight])
            }

            settingsTab
        }
        .background {
            UIColor.systemBackground.color
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 1.5, x: 0, y: 1)
        }
    }

    private var settingsTab: some View {
        VStack(spacing: 7) {
            Rectangle()
                .fill(.black.opacity(0.3))
                .frame(height: 0.33)
            VStack(spacing: 7) {
                Image(systemName: "gear")
                    .font(.system(size: 28))

                Text("Settings")
            }
            .padding(.bottom, 7)
        }
        .foregroundStyle(settings.themeColor)
        .fontWeight(.medium)
        .frame(maxWidth: .infinity)
        .background {
            UIColor.systemBackground.color
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
    }

    private var blankContentMockSettings: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(UIColor.systemBackground.color)
                .frame(height: 44)
                .overlay {
                    HStack {
                        Spacer()
                        Components.nextPageChevron
                    }
                    .padding()
                }

            Divider()
                .padding(.leading)
            Rectangle()
                .fill(UIColor.systemBackground.color)
                .frame(height: 44)
                .overlay {
                    HStack {
                        Spacer()
                        Components.nextPageChevron
                    }
                    .padding()
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    WhereToFindTutorialsView()
}
