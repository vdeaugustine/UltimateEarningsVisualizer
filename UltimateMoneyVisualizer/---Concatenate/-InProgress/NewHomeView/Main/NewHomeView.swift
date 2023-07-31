import SwiftUI

// MARK: - NewHomeView

struct NewHomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                TotalsToDate_HomeView()
                GoalsSummaryView()
                PayoffQueueView_HomeView()
            }
        }
    }
}

// MARK: - GoalsSummaryView

struct GoalsSummaryView: View {
    var body: some View {
        VStack(spacing: 16) {
            HeaderView(title: "Goals Summary", subtitle: "15 items")
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
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.5)
                .stroke(Color(red: 0.87, green: 0.87, blue: 0.87), lineWidth: 1)
        )
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
    }
}
