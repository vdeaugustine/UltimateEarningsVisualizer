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
        VStack {
            Text("That's ok!")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            VStack {
                Text("You want to get started managing your money right away. We get it.")

                Text("You can always access informational content in the \"Tutorials and More Info\" section of the settings tab")
            }
            .foregroundStyle(.secondary)
            .lineSpacing(3)

            mockSettings
        }
        .padding()
    }

    var mockSettings: some View {
        VStack(spacing: 0) {
            VStack {
                VStack(spacing: 42) {
//                    blankContentMockSettings

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

//                            Divider()
//                                .padding(.leading)
//                            Rectangle()
//                                .fill(UIColor.systemBackground.color)
//                                .frame(height: 44)
//                                .overlay {
//                                    HStack {
//                                        Spacer()
//                                        Components.nextPageChevron
//                                    }
//                                    .padding()
//                                }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

//                    VStack {
//                        Text("TUTORIALS AND MORE INFO")
//                            .font(.system(size: 13))
//                            .foregroundStyle(UIColor.secondaryLabel.color)
//                            .pushLeft()
//                            .padding(.leading, 16)
//
//                        Rectangle()
//                            .fill(UIColor.systemBackground.color)
//                            .frame(height: 44)
//                            .overlay {
//                                HStack {
//
//                                    Image(systemName: "bookmark.fill")
//                                        .foregroundStyle(settings.themeColor)
//                                    Text("Tutorials")
//
//
//
//                                    Spacer()
//                                    Components.nextPageChevron
//                                }
//                                .padding()
//                            }
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
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
//        .padding()

//        .background {
//            UIColor.secondarySystemBackground.color
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
////                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .shadow(radius: 1.5, x: 0, y: 1)
//        }

//        .background {
//            UIColor.systemBackground.color
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .shadow(radius: 1.5, x: 0, y: 1)
//        }
    }

    private var settingsTab: some View {
        VStack(spacing: 7){
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
//        .padding(7)
        .background {
            UIColor.systemBackground.color
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
//                .shadow(color: .black.opacity(0.3), radius: 0, x: 0, y: -0.33)
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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - RoundedCorner

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    WhereToFindTutorialsView()
}
