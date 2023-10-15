import PopupView
import ScrollKit
import SwiftUI

extension ScrollViewProxy {
    func scrollWithAnimation<ID>(_ id: ID,
                                 anchor: UnitPoint? = nil) where ID: Hashable {
        withAnimation {
            self.scrollTo(id, anchor: anchor)
        }
    }
}

// MARK: - NewHomeView

struct NewHomeView: View {
    @StateObject private var vm: NewHomeViewModel = .shared
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var status = User.main.getStatusTracker()
    @State private var scrollOffset: CGPoint = .zero

    @State private var showWageBreakdownPopover = false
    @State private var summaryPopover = false
    @State private var moreStatsPopover = false
    @State private var totalsPopover = false
    @State private var netMoneyPopover = false
    @State private var payoffQueuePopover = false
    @State private var showFirstPopOverMain = false
    @State private var wagePopover = false
    @State private var timeBlockPopover = false
    @State private var quickAddPopover = false

    @State private var scrollPosition = CGFloat.zero

    func setAllPopoversFalseExcept(for popover: ViewTags) {
        showWageBreakdownPopover = false
        summaryPopover = false
        moreStatsPopover = false
        totalsPopover = false
        netMoneyPopover = false
        payoffQueuePopover = false
        showFirstPopOverMain = false
        wagePopover = false
        timeBlockPopover = false
        quickAddPopover = false

        switch popover {
            case .wageBreakdown:
                showWageBreakdownPopover = true
            case .summary:
                summaryPopover = true
            case .netMoney:
                netMoneyPopover = true
            case .payoffQueue:
                payoffQueuePopover = true
            case .timeBlocks:
                timeBlockPopover = true
            case .totals:
                totalsPopover = true
            case .scrollView:
                showFirstPopOverMain = true
        }

        print("\(popover) is now \(true)")
    }

    enum ViewTags: String, Hashable {
        case totals, summary, netMoney, payoffQueue, wageBreakdown, timeBlocks, scrollView
    }

    func handleOffset(_ scrollOffset: CGPoint) {
        self.scrollOffset = scrollOffset
        print("New offset: ", scrollOffset)
    }

    static let fullPopoverQueue: [ViewTags] = [.totals, .netMoney, .payoffQueue, .wageBreakdown, .timeBlocks]

    @State private var popoverQueueRemaining: [ViewTags] = NewHomeView.fullPopoverQueue
    @State private var popoverQueueShown: [ViewTags] = []

    var currentPopover: ViewTags? {
        popoverQueueRemaining.first
    }

    func removeFirstFromPopoverQueue(scrollProxy: ScrollViewProxy) {
        if !popoverQueueRemaining.isEmpty {
            let first = popoverQueueRemaining.removeFirst()
            popoverQueueShown.append(first)
            withAnimation {
                scrollProxy.scrollWithAnimation(first)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let first = popoverQueueRemaining.first {
                        setAllPopoversFalseExcept(for: first)
                    }
                }
            }
        }
    }

    func insertLastIntoPopoverQueue() {
        if !popoverQueueShown.isEmpty {
            let last = popoverQueueShown.removeLast()
            popoverQueueRemaining.insert(last, at: 0)
        }
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            GeometryReader { geo in
                ScrollViewWithOffset(onScroll: handleOffset) {
                    Color.clear.frame(height: 0)
                        .id(ViewTags.scrollView)
                    VStack(spacing: 40) {
                        TotalsToDate_HomeView()
                            .id(ViewTags.totals)
                            .floatingPopover(isPresented: $totalsPopover, arrowDirection: .up) {
                                Totals_HomeView_Popover {
                                    removeFirstFromPopoverQueue(scrollProxy: scrollProxy)
                                }
                            }
                        SummaryView_HomeView()
                            .id(ViewTags.summary)
                        NetMoney_HomeView()
                            .id(ViewTags.netMoney)
                            .floatingPopover(isPresented: $netMoneyPopover, arrowDirection: .down) {
                                NetMoney_HomeView_Popover {
                                    removeFirstFromPopoverQueue(scrollProxy: scrollProxy)
                                }
                            }
                        PayoffQueueView_HomeView()
                            .id(ViewTags.payoffQueue)
                            .floatingPopover(isPresented: $payoffQueuePopover,
                                             arrowDirection: .up) {
                                PayoffQueue_HomeView_Popup {
                                    removeFirstFromPopoverQueue(scrollProxy: scrollProxy)
                                }
                            }

                        WageBreakdown_HomeView()
                            .id(ViewTags.wageBreakdown)
                            .floatingPopover(isPresented: $wagePopover, arrowDirection: .down) {
                                WageBreakdown_HomeView_Popover {
                                    removeFirstFromPopoverQueue(scrollProxy: scrollProxy)
                                }
                            }

                        TopTimeBlocks_HomeView()
                            .id(ViewTags.timeBlocks)
                            .floatingPopover(isPresented: $timeBlockPopover, arrowDirection: .down) {
                                TimeBlock_HomeView_Popover {
                                    removeFirstFromPopoverQueue(scrollProxy: scrollProxy)
                                }
                            }
                    }
                    .padding(.top)

                    .onAppear(perform: {
                        if status.hasSeenHomeTutorial == false {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                totalsPopover = true
                            }
                        }
                    })
                }
                .popup(isPresented: $showFirstPopOverMain) {
                    VStack {
                        Text("Welcome to home view")
                    }
                    .frame(maxWidth: geo.size.width - 50, maxHeight: geo.size.height - 140)
                    .padding()
                    .background {
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 3)
                    }
                }
            }
        }
        .blur(radius: vm.quickMenuOpen ? 3 : 0)
        .overlay {
            if vm.quickMenuOpen {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        vm.quickMenuOpen = false
                    }
            }
        }
        .animation(/*@START_MENU_TOKEN@*/ .easeIn/*@END_MENU_TOKEN@*/, value: vm.quickMenuOpen)
        .safeAreaInset(edge: .bottom) {
            if !totalsPopover,
               !netMoneyPopover,
               !payoffQueuePopover,
               !wagePopover,
               !timeBlockPopover {
                HStack {
                    Spacer()
                    FloatingPlusButton(isShowing: $vm.quickMenuOpen)
                        .padding(.bottom)
                        .floatingPopover(isPresented: $quickAddPopover, arrowDirection: .down) {
                            QuickAddButton_HomeView_Popover {
                                quickAddPopover = false
                            }
                        }
                }
            }
        }
        .environmentObject(vm)
        .putInTemplate(displayMode: .large, settings: settings)
        .navigationTitle(Date.now.getFormattedDate(format: .abbreviatedMonth))
        .navigationDestination(for: NavManager.AllViews.self) { view in
            vm.navManager.getDestinationViewForStack(destination: view)
        }
    }
}

// MARK: - ShadowForRect

struct ShadowForRect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
    }
}

// MARK: - SummaryView_HomeView

struct SummaryView_HomeView: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    var body: some View {
        VStack(spacing: 16) {
            HeaderView(title: "\(vm.selectedTotalItem.title) Summary", subtitle: vm.selectedTotalItem.quantityLabel(vm))
            VStack(spacing: 12) {
                ForEach(vm.getSummaryRows()) { row in
                    SubSection(title: row.title, value: row.valueString)
                }
            }
            Divider()
            HStack {
                Text("Total")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(red: 0.13, green: 0.13, blue: 0.13))
                    .underline()
                Spacer()
                Text(vm.getSummaryTotal().money())
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
            }
        }
        .padding(20)
        .background(.white)
        .cornerRadius(12)
        .modifier(ShadowForRect())
        .padding(.horizontal)
    }

    // MARK: - HeaderView

    struct HeaderView: View {
        let title: String
        let subtitle: String

        var body: some View {
            HStack {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

                Spacer()
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
            }
        }
    }

    // MARK: - SubSectionView

    struct SubSection: View {
        let title: String
        let value: String

        var body: some View {
            HStack {
                Text(title)
//                    .underline()
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))

                Spacer()

                Text(value)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.black)
            }
            .font(.system(size: 14))
        }
    }
}

// MARK: - NewHomeView_Previews

struct NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationStack {
                NewHomeView()
                    .environmentObject(NewHomeViewModel.shared)
            }
        }
    }
}

// MARK: - NetMoney_HomeView

struct NetMoney_HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Net Money")
                .font(.callout)
                .fontWeight(.semibold)
            NetMoneyGraph()
        }
        .padding()
        .modifier(ShadowForRect())
        .padding(.horizontal)
    }
}

// MARK: - TopTimeBlocks_HomeView

struct TopTimeBlocks_HomeView: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Top Time Blocks")
                    .font(.callout)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    vm.navManager.appendCorrectPath(newValue: .allTimeBlocks)
                } label: {
                    Text("All")
                        .format(size: 14, weight: .medium)
                }
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.user.getTimeBlocksBetween().consolidate()) { block in

                        TimeBlockRect(title: block.title,
                                      subtitle: block.duration.breakDownTime(),
                                      thirdTitle: "",
                                      color: block.color)
                            .onTapGesture {
                                vm.navManager.appendCorrectPath(newValue: .condensedTimeBlock(block))
                            }
                    }
                }
                .padding()
            }
        }

        .background { Color.clear }
    }
}
