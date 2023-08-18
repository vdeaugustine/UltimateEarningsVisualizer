import SwiftUI

// MARK: - NewHomeView

struct NewHomeView: View {
    @StateObject private var vm: NewHomeViewModel = .shared
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                TotalsToDate_HomeView()
                SummaryView_HomeView()
                NetMoney_HomeView()
                PayoffQueueView_HomeView()
                WageBreakdown_HomeView()
                TopTimeBlocks_HomeView()
            }
            .padding(.top)
        }
        .safeAreaInset(edge: .bottom) { QuickAddButton() }
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
        NavigationStack {
            NewHomeView()
                .environmentObject(NewHomeViewModel.shared)
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
        .padding(.horizontal)
    }
}
