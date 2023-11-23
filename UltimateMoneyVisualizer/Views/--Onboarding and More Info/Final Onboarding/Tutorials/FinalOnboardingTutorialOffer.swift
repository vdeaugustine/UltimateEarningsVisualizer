//
//  FinalOnboardingTutorialOffer.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/20/23.
//

import SwiftUI

// MARK: - FinalOnboardingTutorialOffer

struct FinalOnboardingTutorialOffer: View {
    @ObservedObject private var user = User.main

    let shifts = PseudoShift.generatePseudoShifts(hourlyWage: 20, numberOfShifts: 3)

    let title = "Become a Master"
    let subtitle = "See everything the app has to offer and become a personal finance master"
    let buttonLabel = "Explore Features"

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                titleAndSubtitle
                    .padding([.horizontal])

                Spacer(minLength: 20)

                middleContent

                Spacer(minLength: 70)
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(user.getSettings().themeColor)
                        Text("Or come back later:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }

                    Text("If you want to get started right away, you can skip this part for now.")
                        .font(.footnote)
                        .layoutPriority(1)
                }
                .padding(.horizontal)

                VStack(spacing: 10) {
                    OnboardingButton(title: "Explore Features", height: 50) {
                    }
                    .padding(.horizontal, 30)
                    Button("Skip for now") {
                    }
                    .font(.callout)
                }
            }
            .padding(.bottom)
        }
        .background {
            OnboardingBackground()
        }
    }

    var bonus: some View {
        GroupBox {
            Text("You can simulate shifts you haven't worked yet to project your finances in the future")
                .font(.footnote)
                .layoutPriority(1)

        } label: {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundStyle(.yellow)
                Text("Bonus:")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .groupBoxStyle(
            ShadowBoxGroupBoxStyle(headerContentSpacing: 5,
                                   paddingInsets: nil)
        )
    }

    var titleAndSubtitle: some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            VStack(spacing: 10) {
                Text(subtitle)
            }
            .foregroundStyle(.secondary)
            .lineSpacing(3)
        }
    }

    var middleContent: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let offsetAmount = geo.size.width * 0.05
            VStack(spacing: -30) {
                ShiftSummaryBox(shift: .oneExample)

                    .frame(maxWidth: width - offsetAmount)
                VStack(spacing: -20) {
                    makePayoffRect()
                        .frame(maxWidth: width - offsetAmount)
                        .offset(x: offsetAmount)
                    makeSavedRect()
                        .frame(maxWidth: width - (offsetAmount * 2))
                        .offset(x: offsetAmount * 2)
                }
            }
            .padding([.top, .horizontal])
            .frame(maxWidth: .infinity)
            .offset(x: -(offsetAmount / 2))
            .fadeEffect(endOpacity: 0.3)
        }
    }

    private func makeSavedRect() -> some View {
        HStack {
            DateCircle(date: .now.addDays(20), height: 40)

            VStack(alignment: .leading) {
                Text("Family Vacation")
                    .font(.callout)
            }

            Spacer()
            Text(2_000.money())
                .font(.subheadline)
        }
        .padding()
        .background {
            Color.white.clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 3, x: 0, y: 2)
        }
    }

    private func makePayoffRect() -> some View {
        VStack {
            PayoffItemRectGeneral(
                item: PseudoPayoffItem(amount: 200,
                                       amountPaidOff: 150,
                                       dueDate: .now.addDays(10),
                                       titleStr: "Car Payment",
                                       imageString: "dollar3d")
            )
        }
    }
}

// MARK: - PseudoPayoffItem

struct PseudoPayoffItem: PayoffItem {
    var amount: Double

    var amountMoneyStr: String { amount.money() }

    var amountPaidBySaved: Double = 0

    var amountPaidByShifts: Double = 0

    var amountPaidOff: Double = 0

    var amountRemainingToPayOff: Double = 0

    var dateCreated: Date? = .now

    var dueDate: Date? = .now

    var info: String? = ""

    var isPaidOff: Bool = false

    var optionalQSlotNumber: Int16? = nil

    var optionalTempQNum: Int16? = nil

    var percentPaidOff: Double { amountPaidOff / amount }

    var percentTemporarilyPaidOff: Double = 0

    var repeatFrequencyObject: RepeatFrequency = .never

    var timeRemaining: Double = 0

    var titleStr: String = ""

    var type: PayoffType = .goal

    var imageString: String = ""

    let id: UUID = .init()

    func addTag(tag: Tag) throws {
    }

    func getAllocations() -> [Allocation] {
        []
    }

    func getArrayOfTemporaryAllocations() -> [TemporaryAllocation] {
        []
    }

    func getID() -> UUID {
        id
    }

    func getMostRecentTemporaryAllocation() -> TemporaryAllocation? {
        nil
    }

    func getSavedItems() -> [Saved] {
        []
    }

    func getShifts() -> [Shift] {
        []
    }

    func getTags() -> [Tag] {
        []
    }

    func handleWhenPaidOff() throws {
    }

    func handleWhenTempPaidOff() throws {
    }

    func loadImageIfPresent() -> UIImage? {
        if imageString.isEmpty == false {
            return UIImage(named: imageString)
        }
        return nil
    }

    func removeAllocation(alloc: Allocation) throws {
    }

    func removeTag(tag: Tag) throws {
    }

    func setOptionalQSlotNumber(newVal: Int16?) {
    }

    func setOptionalTempQNum(newVal: Int16?) {
    }
}

#Preview {
    FinalOnboardingTutorialOffer()
}
