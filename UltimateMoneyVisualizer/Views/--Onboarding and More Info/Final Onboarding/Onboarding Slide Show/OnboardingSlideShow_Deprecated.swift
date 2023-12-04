//
//  OnboardingSlideShow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/8/23.
//

import SwiftUI

// MARK: - OnboardingSlideShow

struct OnboardingSlideShow_Deprecated: View {
    @State private var currentIndex: Int = 0

    struct Slide: Identifiable, Equatable, Hashable {
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Slide, rhs: Slide) -> Bool {
            return lhs.id == rhs.id
        }

        let topic: Topic
        let title: String
        let imageString: String
        let header: String
        let bodyTexts: [String]
        let id = UUID()

        init(topic: Topic, imageString: String, header: String, bodyTexts: [String]) {
            self.title = topic.rawValue
            self.imageString = imageString
            self.header = header
            self.bodyTexts = bodyTexts
            self.topic = topic
        }
    }

    enum Topic: String, CaseIterable, Identifiable {
        var id: Self { self }

        case shifts = "Shifts"
        case goals = "Goals"
        case expenses = "Expenses"
        case allocations = "Allocations"
        case iCloud
    }

    @State private var learnMoreTopic: Topic? = nil

    let slides: [Slide] = [Slide(topic: .shifts,
                                 imageString: "timeToMoney",
                                 header: "Earnings in Real-Time",
                                 bodyTexts: ["Watch your earnings increase as you work, visualizing your financial growth",
                                             "Review your shift history to track daily earnings and understand your income patterns"]),

                           Slide(topic: .goals,
                                 imageString: "goalJar",
                                 header: "Your Goals, Visualized",
                                 bodyTexts: ["Define your financial targets with set amounts and dates, and enjoy the journey towards achieving them",
                                             "Stay inspired as you visually track your progress and see your goals coming within reach"]),

                           Slide(topic: .expenses,
                                 imageString: "expense",
                                 header: "Streamline Your Expenses",
                                 bodyTexts: ["Effortlessly monitor both recurring and one-time expenses",
                                             "Prioritize your financial obligations and celebrate as you direct your earnings towards personal gains"]),

                           Slide(topic: .allocations,
                                 imageString: "timeToExpense",
                                 header: "Smart Money Allocation",
                                 bodyTexts: ["Allocate your earnings and savings to efficiently manage expenses and goals",
                                             "Gain clarity on your finances with a visual representation of each paid item and its source"]),

                           Slide(topic: .iCloud,
                                 imageString: "cloud",
                                 header: "iCloud Integration: Safe & Synced",
                                 bodyTexts: ["Experience the peace of mind with your data securely stored and backed up in iCloud",
                                             "Effortlessly sync and restore your financial data, worry-free, even if you switch devices or reinstall the app"])]

    var body: some View {
        VStack(spacing: 40) {
            CustomCarousel(index: $currentIndex,
                           items: slides,
                           spacing: 10,
                           cardPadding: 60,
                           id: \.self) { slide, _ in

                // MARK: YOUR CUSTOM CELL VIEW

//                Button {
//                    learnMoreTopic = slide.topic
//                } label: {
                OnboardingSlide(slide: slide) {}
//                }
//                .buttonStyle(.plain)
            }
            .padding(.top)
//            .padding(.horizontal, -15)
//            .padding(.vertical)

//            .frame(height: 500)

            HStack(spacing: 40) {
                if currentIndex > 0 {
                    Button {
                        withAnimation {
                            currentIndex = max(currentIndex - 1, 0)
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .padding(.horizontal, 15)
                            .frame(maxHeight: .infinity)
                            .background(User.main.getSettings().themeColor)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }

                if currentIndex < (slides.count - 1) {
                    Button {
                        withAnimation {
                            currentIndex += 1
                        }
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .padding(.horizontal, 15)
                            .frame(maxHeight: .infinity)
                            .background(LinearGradient(stops: [.init(color: User.main.getSettings().themeColor,
                                                                     location: -0.5),
                                                               .init(color: User.main.getSettings().themeColor.getLighterColorForGradient(90),
                                                                     location: 3)],
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                } else {
                    Button {
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .padding(.horizontal, 15)
                            .frame(maxHeight: .infinity)
                            .background(LinearGradient(stops: [.init(color: User.main.getSettings().themeColor,
                                                                     location: -0.5),
                                                               .init(color: .green,
                                                                     location: 3)],
                                                       startPoint: .leading,
                                                       endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .frame(maxHeight: 40)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background {
//            ZStack {
//                UIColor.secondarySystemBackground.color
//                Rectangle()
//                    .fill(Material.regular)
//            }
//            .ignoresSafeArea()
//        }
        .putInTemplate(title: "Features", displayMode: .large)
//        .navigationTitle("Features")
        .putInNavView(.large)
        .sheet(item: $learnMoreTopic) { topic in
            switch topic {
                case .shifts:
                    ShiftInfoView()
                case .goals:
                    GoalsInfoView()
                case .expenses:
                    ShiftInfoView()
                case .allocations:
                    ShiftInfoView()
                case .iCloud:
                    ShiftInfoView()
            }
        }
    }
}

// MARK: - CustomCarousel

struct CustomCarousel<Content: View, Item, ID>: View where Item: RandomAccessCollection, ID: Hashable, Item.Element: Equatable {
    var content: (Item.Element, CGSize) -> Content
    var id: KeyPath<Item.Element, ID>

    // View Properties
    var spacing: CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int

    @State private var maxHeight: CGFloat = 0

    let mainYOffset: CGFloat = 40

    init(index: Binding<Int>,
         items: Item,
         spacing: CGFloat = 30,
         cardPadding: CGFloat = 80,
         id: KeyPath<Item.Element,
             ID>,
         @ViewBuilder content: @escaping (Item.Element,
                                          CGSize) -> Content) {
        self.content = content
        self.id = id
        self._index = index
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.items = items
    }

    // Gesture Properties
    @GestureState var translation: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @State var currentIndex: Int = 0

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let cardWidth = size.width - (cardPadding - spacing)

            LazyHStack(spacing: spacing) {
                ForEach(items, id: id) { item in
                    let index = indexOf(item: item)
                    content(item,
                            CGSize(width: size.width - cardPadding,
                                   height: size.height))
                        .offset(y: offsetY(index: index, cardWidth: cardWidth))
                        .frame(width: size.width - cardPadding, height: size.height)
                        .contentShape(Rectangle())
                        .background {
                            GeometryReader { secondGeo in
                                Color.clear.onAppear {
                                    let height = secondGeo.size.height
                                    maxHeight = max(height, maxHeight)
                                    print("max height", maxHeight)
                                }
                            }
                        }
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: limitScroll())
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onChanged { onChanged(value: $0, cardWidth: cardWidth) }
                    .onEnded { onEnd(value: $0, cardWidth: cardWidth) }
            )
            .onChangeProper(of: index) {
                if index >= items.count {
                    index = 0
                    return
                }
                withAnimation(.easeInOut(duration: 0.25)) {
                    // MARK: Removing Extra Space

                    // Why /2 -> Because We Need Both Sides Need to Be Visible
                    let extraSpace = (cardPadding / 2) - spacing
                    offset = -(cardWidth * CGFloat(index)) + extraSpace

                    // MARK: Calculating Rotation

                    // Since Index Starts With Zero
                }
                lastStoredOffset = offset
            }
        }
        .onAppear {
            let extraSpace = (cardPadding / 2) - spacing
            offset = extraSpace
            lastStoredOffset = extraSpace
        }
        .animation(.easeInOut, value: translation == 0)
        .offset(y: mainYOffset)
    }

    // MARK: Moving Current Item Up

//    func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat{
//        // MARK: We're Converting The Current Translation, Not Whole Offset
//
//        // That's Why Created @GestureState to Hold the Current Translation Data
//
//        // Converting Translation to -mainYOffset...mainYOffset
//        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * mainYOffset
//        let yOffset = -progress < mainYOffset ? progress : -(progress + mainYOffset * 2)
//
//        // MARK: Checking Previous, Next And In-Between Offsets
//
//        let previous = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0
//        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0
//        let In_Between = (index - 1) == self.index ? previous : next
//
//        return index == self.index ? -mainYOffset - yOffset : In_Between
//    }

    func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat {
        // MARK: Handling the Current Translation

        // This is where the current drag translation is converted into a vertical offset.
        // The translation value is stored in a @GestureState property which updates during the drag gesture.
        // The aim is to convert the drag translation to a vertical offset within a range of -mainYOffset to mainYOffset.

        // Calculate 'progress' as a proportion of the translation to the card width, then scale it to -mainYOffset to mainYOffset.
        // If the translation is negative (dragging left), it keeps the negative sign, otherwise, it becomes negative.

        // Determine if the translation is negative, and if so, maintain its sign; otherwise, make it negative.
        let adjustedTranslation = translation < 0 ? translation : -translation

        // Calculate the progress as a proportion of the translation relative to the card width.
        let proportionOfTranslation = adjustedTranslation / cardWidth

        // Scale the progress to a range of -mainYOffset to mainYOffset.
        let progress = proportionOfTranslation * mainYOffset

        // 'yOffset' determines the vertical offset of the current card.
        // If 'progress' is less than mainYOffset, 'yOffset' is equal to 'progress'.
        // Otherwise, it's the negative of 'progress' plus mainYOffset * 2, effectively inverting the direction.
        // Check if the negative value of 'progress' is less than mainYOffset.
        let isNegativeProgressLessThanMainYOffset = -progress < mainYOffset

        // If 'isNegativeProgressLessThanmainYOffset' is true, then 'yOffset' is equal to 'progress'.
        // Otherwise, it's the negative of 'progress' plus mainYOffset * 2.
        let yOffset = isNegativeProgressLessThanMainYOffset ? progress : -(progress + (mainYOffset * 2))

        // MARK: Calculating Offsets for Adjacent Cards

        // The function calculates different offsets for the previous, next, and in-between cards.

        // 'previous' calculates the offset for the card just before the current one.
        // If the previous card is the current one, it uses 'yOffset' or '-yOffset' based on the translation direction.
        // If not, it's set to 0, meaning no vertical offset for non-adjacent cards.
        let previous = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0

        // 'next' calculates the offset for the card just after the current one.
        // The logic is similar to 'previous', but the offset is applied to the next card instead.
        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0

        // 'In_Between' determines the offset for the card that is either immediately before or after the current card.
        // If the card is just before the current one, 'In_Between' is equal to 'previous'.
        // If not, it takes the value of 'next'.
        let In_Between = (index - 1) == self.index ? previous : next

        // The function returns the calculated vertical offset for the current card.
        // If the card at the given index is the current one, it applies a fixed -mainYOffset offset and adjusts it with 'yOffset'.
        // For other cards, it uses the 'In_Between' value calculated above.
        return index == self.index ? -mainYOffset - yOffset : In_Between
    }

    // MARK: Item Index

    func indexOf(item: Item.Element) -> Int{
        let array = Array(items)
        if let index = array.firstIndex(of: item) {
            return index
        }
        return 0
    }

    // MARK: Limiting Scroll On First And Last Items

    func limitScroll() -> CGFloat{
        let extraSpace = (cardPadding / 2) - spacing
        if index == 0 && offset > extraSpace{
            return extraSpace + (offset / 4)
        }else if index == items.count - 1 && translation < 0{
            return offset - (translation / 2)
        }else{
            return offset
        }
    }

    func onChanged(value: DragGesture.Value, cardWidth: CGFloat) {
        let translationX = value.translation.width
        offset = translationX + lastStoredOffset

        // MARK: Calculating Rotation

//        let progress = offset / cardWidth
    }

    func onEnd(value: DragGesture.Value, cardWidth: CGFloat) {
        // MARK: Finding Current Index

        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count - 1), _index)
        _index = min(_index, 0)

        currentIndex = Int(_index)

        // MARK: Updating Index

        // Note Since We're Moving On Right Side
        // So All Data Will be Negative
        index = -currentIndex
        withAnimation(.easeInOut(duration: 0.25)) {
            // MARK: Removing Extra Space

            // Why /2 -> Because We Need Both Sides Need to Be Visible
            let extraSpace = (cardPadding / 2) - spacing
            offset = (cardWidth * _index) + extraSpace

            // MARK: Calculating Rotation

            // Since Index Starts With Zero
        }
        lastStoredOffset = offset
    }
}

#Preview {
    OnboardingSlideShow_Deprecated()
        .onAppear() {
            UserDefaults.themeColor = .defaultColorOptions.first!
        }
}
