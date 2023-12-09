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

    @State private var scrollPosition = CGFloat.zero

    let dispatchPause: CGFloat = 0.7

    // MARK: - Main Body

    var body: some View {
        ScrollViewReader { _ in
            GeometryReader { _ in
                ScrollViewWithOffset(onScroll: handleOffset) {
                    Color.clear.frame(height: 0)
                        .id(ViewTags.scrollView)
                    VStack(spacing: 40) {
                        HomeViewTotalsContent()
                            .id(ViewTags.totals)
                        Button {
                            vm.navManager.appendCorrectPath(newValue: .stats)
                        } label: {
                            SummaryView_HomeView()
                        }
                        .id(ViewTags.summary)
                        NetMoney_HomeView()
                            .id(ViewTags.netMoney)
                        PayoffQueueView_HomeView()
                            .id(ViewTags.payoffQueue)

                        WageBreakdown_HomeView()
                            .id(ViewTags.wageBreakdown)

                        TopTimeBlocks_HomeView()
                            .id(ViewTags.timeBlocks)
                    }
                    .background(Color(.secondarySystemBackground))
                    .padding(.top)
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
                .animation(.easeIn, value: vm.quickMenuOpen)
                .safeAreaInset(edge: .bottom) {
                    floatingButton
                }
                .environmentObject(vm)
                .putInTemplate(displayMode: .large, settings: settings)
                .navigationTitle(Date.now.getFormattedDate(format: .abbreviatedMonth))
                .navigationDestination(for: NavManager.AllViews.self) { view in
                    vm.navManager.getDestinationViewForStack(destination: view)
                }
                .background(Color(.secondarySystemBackground))
        }
    }

    @ViewBuilder private var floatingButton: some View {
        HStack {
            Spacer()
            FloatingPlusButton(isShowing: $vm.quickMenuOpen)
                .padding(.bottom)
        }
    }
}

extension NewHomeView {
    // swiftformat:sort:begin

    func handleOffset(_ scrollOffset: CGPoint) {
        self.scrollOffset = scrollOffset
        print("New offset: ", scrollOffset)
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
