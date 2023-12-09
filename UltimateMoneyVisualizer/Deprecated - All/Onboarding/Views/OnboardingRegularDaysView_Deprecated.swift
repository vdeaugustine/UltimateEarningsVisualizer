//
//  OnboardingThirdView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/26/23.
//

import PopupView
import SwiftUI

// MARK: - OnboardingRegularDaysView

struct OnboardingRegularDaysView_Deprecated: View {
    @EnvironmentObject private var model: OnboardingModel

    @State private var dayForWhichTimeWasTapped: DayOfWeek = .monday
    @State private var showTimeSheet: Bool = false

    var body: some View {
        GeometryReader { geo in
            VStack {
                HeaderPart(geo: geo)

                Spacer()
                    .frame(maxHeight: geo.size.height / 20)

                ChecklistPart(geo: geo)

                Spacer()
                ButtonsStackPart
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 30)
            .padding(.bottom, model.bottomPadding(geo))
            .conditionalModifier(showTimeSheet, { view in
                view.blur(radius:  4)
            })
            
            .popup(isPresented: $showTimeSheet) {
                SetTimesForDay(day: dayForWhichTimeWasTapped, showSheet: $showTimeSheet)
                    .padding(.horizontal)

            } customize: {
                $0
                    .type(.floater(verticalPadding: 110, horizontalPadding: 25, useSafeAreaInset: true))
                    .position(.center)
                    .closeOnTap(false)
                    .closeOnTapOutside(true)
                    .backgroundView {
                        Color.black.opacity(0.4)
                    }
            }
        }

        .background {
            Color(.systemBackground).ignoresSafeArea()
        }
    }

    @ViewBuilder func ChecklistPart(geo: GeometryProxy) -> some View {
        ScrollView {
            VStack {
                ForEach(DayOfWeek.orderedCases) { day in // Replace with your data model here
                    HStack {
                        Button {
                            model.daysSelected.insertOrRemove(element: day)
                        } label: {
                            HStack {
                                Image(systemName: model.daysSelected.contains(day) ? "checkmark.circle" : "circle")
                                    .imageScale(.large)
                                    .symbolRenderingMode(.monochrome)

                                Text(day.description)
                                    .font(.title2)
                                Spacer()
                            }
                        }
                        .foregroundStyle(Color(.label))

                        Spacer()

//                                if model.daysSelected.contains(day) {
                        HStack {
                            Text(model.getTimeString(for: day))
                                .font(.subheadline)
                        }
                        .padding(10)
                        .background {
                            Color(.secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .opacity(model.daysSelected.contains(day) ? 1 : 0)
                        .onTapGesture {
                            print("tapped time")
                            dayForWhichTimeWasTapped = day
                            showTimeSheet = true
                            print("Should show sheet: \(showTimeSheet)")
                        }
//                                }
                    }
                    .padding(.vertical, geo.size.height / 100)
                }
            }
        }
    }

    @ViewBuilder func HeaderPart(geo: GeometryProxy) -> some View {
        Text("Your Schedule")
            .font(.system(.largeTitle, weight: .bold))
            .frame(minWidth: 240)
            .multilineTextAlignment(.center)
            .padding(.top, model.topPadding(geo))
    }

    @ViewBuilder var ButtonsStackPart: some View {
        VStack {
            Button("Set up later") {
            }
            OnboardingButton(title: "Continue") {
                model.increaseScreenNumber()
            }
           
        }
    }

    struct SetTimesForDay: View {
        @EnvironmentObject private var model: OnboardingModel
        let day: DayOfWeek
        @Binding var showSheet: Bool
        @Environment(\.dismiss) private var dismiss
        var body: some View {
            VStack {
                DatePicker("Start time", selection: model.getStartBinding(for: day), displayedComponents: .hourAndMinute)
                    .bold()
                DatePicker("End time", selection: model.getEndBinding(for: day), displayedComponents: .hourAndMinute)
                    .bold()

                Spacer()

                OnboardingButton(title: "Done", height: 40) {
                    showSheet = false
                }
                .padding(.horizontal, model.horizontalPad / 9)
                .padding(.top)
            }

            .padding(30)
            .background {
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(maxWidth: 275, maxHeight: 200)
            .onAppear(perform: {
                print("Should be showing")
            })
//            .modifier(ShadowForRect())
//            .presentationDetents([.fraction(0.25), .medium])
        }
    }
}

// MARK: - OnboardingThirdView_Previews

struct OnboardingThirdView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingRegularDaysView_Deprecated()
                .previewDevice("iPhone 14 Pro Max")
        }
        .environmentObject(OnboardingModel())
    }
}
