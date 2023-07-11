//
//  TestingChatGPTUI.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Image("userProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.yellow, lineWidth: 4))
                        .padding()
                    Spacer()
                }

                HStack {
                    Image("additionalProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.yellow, lineWidth: 3))
                        .padding()
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Features")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.yellow)
                            Text("Notifications")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.yellow)
                            Text("Profile")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                    // Add more buttons as needed
                }
                .padding()

                Spacer()
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

