import SwiftUI

extension ScrollViewProxy {
    func scrollWithAnimation<ID>(
        _ id: ID,
        anchor: UnitPoint? = nil
    ) where ID : Hashable {
        withAnimation {
            self.scrollTo(id, anchor: anchor)
        }
    }
}

// MARK: - NewHomeView

struct NewHomeView: View {
    @StateObject private var vm: NewHomeViewModel = .shared
    @ObservedObject private var settings = User.main.getSettings()

    @State private var showWageBreakdownPopover = true
    @State private var moreStatsPopover = false
    @State private var totalsPopover = false
    @State private var netMoneyPopover = false
    @State private var payoffQueuePopover = false

    enum ViewTags: Hashable {
        case totals, summary, netMoney, payoffQueue, wageBreakdown, timeBlocks
    }

    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 40) {
                    TotalsToDate_HomeView()
                    SummaryView_HomeView()
                    NetMoney_HomeView()
                        .defaultPopover(isPresented: $netMoneyPopover, text: "This graph shows your net money over time.\nIt takes into account your earnings + saved\nitems and your payoff items", direction: .down)
                    PayoffQueueView_HomeView()
                        .id(ViewTags.payoffQueue)
                        .floatingPopover(isPresented: $payoffQueuePopover, arrowDirection: .up) {
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                Group {
                                    Text("Your Payoff Queue automatically utilizes every penny you earn in real-time to chip away at your expenses and goals!")
                                    Text("As you earn, watch your queued items get paid off, one by one, keeping your financial journey smoothly on track.")
                                    Text("Simply prioritize, and your earnings handle the rest!")
                                }
                                .font(.subheadline)
                                    
                                Button("Next") {
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                                    
                                
                            }
                            .padding()
                            .foregroundStyle(.white)
                            .frame(height: 275)
                            .background {
                                
                                settings.themeColor.getGradient()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(-20)
                            }
                            
                            
                            
                        }

                    WageBreakdown_HomeView()

                    TopTimeBlocks_HomeView()
                }
                .padding(.top)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        scrollProxy.scrollWithAnimation(ViewTags.payoffQueue, anchor: .top)
                        
                        payoffQueuePopover = true
                    }
                })
//
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
            HStack {
                Spacer()
                FloatingPlusButton(isShowing: $vm.quickMenuOpen)
                    .padding(.bottom)
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
