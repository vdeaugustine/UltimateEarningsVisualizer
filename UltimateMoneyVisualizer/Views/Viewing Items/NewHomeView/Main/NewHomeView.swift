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

    @State private var popoverQueueRemaining: [ViewTags] = NewHomeView.fullPopoverQueue
    @State private var popoverQueueShown: [ViewTags] = []

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
        .modifier(Modifiers(vm: vm,
                            settings: settings,
                            floatingButton: { floatingButton }))
    }

    // MARK: - Modifiers

    struct Modifiers<FB: View>: ViewModifier {
        let floatingButton: FB

        init(vm: NewHomeViewModel, settings: Settings, @ViewBuilder floatingButton: @escaping () -> FB) {
            self.floatingButton = floatingButton()
            self.vm = vm
            self.settings = settings
        }

        @ObservedObject var vm: NewHomeViewModel
        @ObservedObject var settings: Settings

        func body(content: Content) -> some View {
            content
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
                    floatingButton
                }
                .environmentObject(vm)
                .putInTemplate(displayMode: .large, settings: settings)
                .navigationTitle(Date.now.getFormattedDate(format: .abbreviatedMonth))
                .navigationDestination(for: NavManager.AllViews.self) { view in
                    vm.navManager.getDestinationViewForStack(destination: view)
                }
        }
    }

    @ViewBuilder private var floatingButton: some View {
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
}

extension NewHomeView {
    // swiftformat:sort:begin
    var currentPopover: ViewTags? {
        popoverQueueRemaining.first
    }

    static let fullPopoverQueue: [ViewTags] = [.totals, .netMoney, .payoffQueue, .wageBreakdown, .timeBlocks]

    func handleOffset(_ scrollOffset: CGPoint) {
        self.scrollOffset = scrollOffset
        print("New offset: ", scrollOffset)
    }

    func insertLastIntoPopoverQueue() {
        if !popoverQueueShown.isEmpty {
            let last = popoverQueueShown.removeLast()
            popoverQueueRemaining.insert(last, at: 0)
        }
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
    // swiftformat:sort:end
}

// MARK: - NewHomeView_Previews

struct NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationStack {
                NewHomeView()
                    .environmentObject(NewHomeViewModel.shared)
                    .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
    }
}
