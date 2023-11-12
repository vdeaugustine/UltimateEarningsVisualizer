//
//  OnboardingSlideShow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/8/23.
//

import SwiftUI

// MARK: - OnboardingSlideShow

struct OnboardingSlideShow: View {
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
                                 header: "Track your earnings",
                                 bodyTexts: ["Watch your money grow in real-time as you earn it",
                                             "Look back on previous shifts to see how much you made each day"]),

                           Slide(topic: .goals, imageString: "goalJar", header: "Something to work toward", bodyTexts: ["Set an amount and a date, and watch yourself progress towards it.", "Motivate yourself by seeing the goal get closer."]),

                           Slide(topic: .expenses, imageString: "expense", header: "Cross it off the list", bodyTexts: ["Track recurring or one-time expenses.", "Work down your list until you see your earnings going right into your pocket"]),

                           Slide(topic: .allocations, imageString: "timeToExpense", header: "Visual cash flow", bodyTexts: ["Use the money you earn or save to payoff expenses and goals!", "Every time an item is paid off, you can see exactly where that money came from."]),

                           Slide(topic: .iCloud,
                                 imageString: "cloudLock",
                                 header: "Secure Backup Assurance",
                                 bodyTexts: ["Your data is securely stored in iCloud with Apple's advanced backup system",
                                             "Sync and restore your data seamlessly, even after deleting and reinstalling the app"])]

    var body: some View {
        VStack {
            CustomCarousel(index: $currentIndex,
                           items: slides,
                           spacing: 10,
                           cardPadding: 60,
                           id: \.self) { slide, _ in

                // MARK: YOUR CUSTOM CELL VIEW

                Button {
                    learnMoreTopic = slide.topic
                } label: {
                    OnboardingSlide(slide: slide) {}
                }
                .buttonStyle(.plain)
            }
//            .padding(.horizontal, -15)
//            .padding(.vertical)

//            .frame(height: 500)

            HStack(spacing: 40) {
                if currentIndex > 0 {
                    Button {
                        withAnimation {
                            currentIndex -= 1
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal)
                            .padding(.horizontal, 15)
                            .frame(maxHeight: .infinity)
                            .background(.blue)
                            
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
                            .padding()
                            .padding(.horizontal)
                            .padding(.horizontal, 15)
                            .frame(maxHeight: .infinity)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                else {
                    Button {
                       
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                            .padding(.horizontal)
                            .padding(.horizontal, 15)
                            .frame(maxHeight: .infinity)
                            .background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
            .frame(maxHeight: 40)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack {
                UIColor.secondarySystemBackground.color
                Rectangle()
                    .fill(Material.regular)
            }
            .ignoresSafeArea()
        }
        .putInTemplate(title: "Features")
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

    init(index: Binding<Int>, items: Item, spacing: CGFloat = 30, cardPadding: CGFloat = 80, id: KeyPath<Item.Element, ID>, @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content) {
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
                    content(item, CGSize(width: size.width - cardPadding, height: size.height))
                        .offset(y: offsetY(index: index, cardWidth: cardWidth))
                        .frame(width: size.width - cardPadding, height: size.height)
                        .contentShape(Rectangle())
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

                    let progress = offset / cardWidth
                    // Since Index Starts With Zero
                }
                lastStoredOffset = offset
            }
        }
//        .padding(.top, 60)
        .onAppear {
            let extraSpace = (cardPadding / 2) - spacing
            offset = extraSpace
            lastStoredOffset = extraSpace
        }
        .animation(.easeInOut, value: translation == 0)
    }

    // MARK: Moving Current Item Up

    func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat{
        // MARK: We're Converting The Current Translation, Not Whole Offset

        // That's Why Created @GestureState to Hold the Current Translation Data

        // Converting Translation to -60...60
        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * 60
        let yOffset = -progress < 60 ? progress : -(progress + 120)

        // MARK: Checking Previous, Next And In-Between Offsets

        let previous = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0
        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0
        let In_Between = (index - 1) == self.index ? previous : next

        return index == self.index ? -60 - yOffset : In_Between
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

            let progress = offset / cardWidth
            // Since Index Starts With Zero
        }
        lastStoredOffset = offset
    }
}

#Preview {
    OnboardingSlideShow()
}
