import SwiftUI

// MARK: - NewHomeView

struct NewHomeView: View {
    @StateObject private var vm: NewHomeViewModel = .shared
    @ObservedObject private var settings = User.main.getSettings()

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                TotalsToDate_HomeView()
                SummaryView()

                VStack(alignment: .leading, spacing: 14) {
                    Text("Net Money")
                        .format(size: 16, weight: .semibold)
                    NetMoneyGraph()
                }
                .padding()
                .modifier(ShadowForRect())
                .padding(.horizontal)

                PayoffQueueView_HomeView()
                WageBreakdown_NewHomeView()
            }
            .padding(.top)
        }
        .environmentObject(vm)
        .putInTemplate(displayMode: .large, settings: settings)
        .navigationTitle(Date.now.getFormattedDate(format: .abreviatedMonth))
        .navigationDestination(for: NavManager.AllViews.self) { view in

            vm.navManager.getDestinationViewForHomeStack(destination: view)
        }
    }

    
}

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

// MARK: - SummaryView

struct SummaryView: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    var body: some View {
        VStack(spacing: 16) {
            HeaderView(title: "\(vm.selectedTotalItem.title) Summary", subtitle: vm.selectedTotalItem.quantityLabel(vm))
            VStack(spacing: 12) {
                SubSectionView(title: "Paid off", value: "$821")
                SubSectionView(title: "Outstanding", value: "$1,829")
            }
            Divider()
            HStack {
                Text("Total")
                    .font(.system(size: 16))
                    .underline()
                    .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
                Spacer()
                Text("$2,400")
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
                    .font(.system(size: 16))
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

    struct SubSectionView: View {
        let title: String
        let value: String

        var body: some View {
            HStack {
                Text(title)
                    .underline()
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
