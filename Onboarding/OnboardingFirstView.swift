//
//  OnboardingFirstView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/25/23.
//

import SwiftUI


class OnboardingModel: ObservableObject {
    
    public static var shared: OnboardingModel = OnboardingModel()
    let backgroundColor: Color = .clear
    @Published var screenNumber: Int = 1
    
    @ObservedObject var user: User = User.main
    
    
    func increaseScreenNumber() {
        withAnimation {
            screenNumber += 1
        }
    }
    
    func decreaseScreenNumber() {
        withAnimation {
            screenNumber += 1
        }
    }
    
}



// MARK: - OnboardingFirstView

struct OnboardingFirstView: View {
    @StateObject private var model = OnboardingModel.shared
    @Environment (\.dismiss) private var dismiss
    @State private var tab: Int = 1

    var body: some View {
        TabView(selection: $model.screenNumber) {
            first
                .tag(1)

            OnboardingSecondView()
                .tag(2)
        }
        
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(model.backgroundColor.ignoresSafeArea())
        .environmentObject(model)
    }

    @ViewBuilder var first: some View {
        VStack {
            Spacer()

            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 85)
                .foregroundColor(.gray)

            VStack(spacing: 14) {
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Text("We will walk you through the steps of getting set up.")
                    .fontWeight(.medium)
            }

            Spacer()

            Button("Lets go!") {
                print("tapped")
                model.increaseScreenNumber()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .padding()
        .background(model.backgroundColor.ignoresSafeArea())
    }
    
    @ViewBuilder var arrows: some View {
        HStack {
            if tab > 1 {
                Button(action: {
                    model.decreaseScreenNumber()
                }) {
                    HStack {
                        Text("Previous")
                            .fontWeight(.medium)
                        Image(systemName: "arrow.left")
                    }
                    .padding()
                    .cornerRadius(10)
                }
                
                
            }
            
            Spacer()

            Button(action: {
                model.increaseScreenNumber()
            }) {
                HStack {
                    Text("Next")
                        .fontWeight(.medium)
                    Image(systemName: "arrow.right")
                }
                .padding()
                .cornerRadius(10)
            }
        }
    }
}

// MARK: - OnboardingFirstView_Previews

struct OnboardingFirstView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingFirstView()
    }
}
