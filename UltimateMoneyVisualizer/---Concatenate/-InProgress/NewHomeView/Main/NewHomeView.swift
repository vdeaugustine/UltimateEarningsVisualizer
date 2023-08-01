import SwiftUI

// MARK: - NewHomeViewModel

class NewHomeViewModel: ObservableObject {
    public static var shared: NewHomeViewModel = .init()
    @Published var selectedTotalItem: TotalTypes = .expenses

    @ObservedObject var user: User = .main

    enum TotalTypes: String, CaseIterable {
        case earned, paidOff, taxes, expenses, goals, saved

        var title: String {
            switch self {
                case .paidOff:
                    "Paid Off"
                default:
                    rawValue.capitalized
            }
        }

        var imageName: String {
            switch self {
                case .expenses:
                    "chart.bar"
                case .goals:
                    "cart"
                case .saved:
                    "creditcard.and.123"
                case .earned:
                    "chart.bar"
                case .paidOff:
                    "cart"
                case .taxes:
                    "creditcard.and.123"
            }
        }

        func amount(_ vm: NewHomeViewModel) -> Double {
            switch self {
                case .earned:
                    vm.user.totalEarned()
                case .paidOff:
                    vm.user.totalSpent()
                case .taxes:
                    vm.user.totalEarned() * vm.user.getWage().totalTaxMultiplier
                case .expenses:
                    vm.user.getExpensesSpentBetween()
                case .goals:
                    vm.user.getGoalsSpentBetween()
                case .saved:
                    vm.user.getAmountSavedBetween()
            }
        }

        func quantity(_ vm: NewHomeViewModel) -> Double {
            switch self {
                case .earned:
                    Double(vm.user.getShifts().count)
                case .paidOff:
                    vm.user.convertMoneyToTime(money: vm.user.totalSpent())
                case .taxes:
                    vm.user.getWage().totalTaxMultiplier * 100
                case .expenses:
                    Double(vm.user.getExpenses().count)
                case .goals:
                    Double(vm.user.getGoals().count)
                case .saved:
                    Double(vm.user.getSaved().count)
            }
        }

        func quantityLabel(_ vm: NewHomeViewModel) -> String {
            switch self {
                case .earned:
                    "\(vm.user.getShifts().count) shifts"
                case .paidOff:
                    vm.user.convertMoneyToTime(money: vm.user.totalSpent()).breakDownTime()
                case .taxes:
                    "\(vm.user.getWage().totalTaxMultiplier * 100) %"
                case .expenses, .goals, .saved:
                    "\(Int(quantity(vm))) items"
            }
        }
    }
}

// MARK: - NewHomeView

struct NewHomeView: View {
    @StateObject private var vm: NewHomeViewModel = .shared

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                TotalsToDate_HomeView()
                SummaryView()
                
                NetMoneyGraph()
                    .padding()
                    .modifier(ShadowForRect())
                    .padding(.horizontal)
                PayoffQueueView_HomeView()
                WageBreakdown_NewHomeView()
            }
            .padding(.top)
        }
        .environmentObject(vm)
        .putInTemplate()
        .navigationTitle("Home")
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
        .modifier(NewHomeView.ShadowForRect())
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
        NewHomeView()
            .putInNavView(.inline)
            .environmentObject(NewHomeViewModel.shared)
    }
}
