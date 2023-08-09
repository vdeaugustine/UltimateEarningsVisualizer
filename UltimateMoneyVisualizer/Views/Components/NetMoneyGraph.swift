import Charts
import SwiftUI

// MARK: - NetMoneyGraph

struct NetMoneyGraph: View {
    @ObservedObject private var user = User.main

    func getDay(_ int: Int) -> Date {
        Date.now.addDays(-Double(int))
    }

    var dataItems: [DataItem] {
        (1 ... 7).map{ .init($0) }
            .sorted { one, two in
                one.date < two.date
            }
    }

    struct DataItem: Hashable, Identifiable {
        init(_ num: Int) {
            let date = Date.now.addDays(Double(-num))
            let day = DayOfWeek(date: date)
            self.date = date
            self.day = day
            self.money = User.main.totalNetMoneyBetween(.distantPast, date)
            self.expensesMoney = -User.main.getAmountForAllExpensesBetween(startDate: .distantPast, endDate: date)
            self.earnedMoney = User.main.getTotalEarnedBetween(startDate: .distantPast, endDate: date)
        }

        let date: Date
        let day: DayOfWeek
        let money: Double
        let expensesMoney: Double
        let earnedMoney: Double

        let id = UUID()
    }

    var body: some View {
        VStack {
            Chart {
                ForEach(dataItems) { item in
                    LineMark(x: .value("Day",
                                       item.date.getFormattedDate(format: "EEE\nM/d")),
                             y: .value("Earnings",
                                       item.money))
                        .foregroundStyle(user.getSettings().getDefaultGradient())

                    PointMark(x: .value("Day",
                                        item.date.getFormattedDate(format: "EEE\nM/d")),
                              y: .value("Earnings",
                                        item.money))
                        .annotation {
                            Text(Int(item.money).str)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundStyle(user.getSettings().getDefaultGradient())
                        }
                        .foregroundStyle(user.getSettings().getDefaultGradient())

                    BarMark(x: .value("Day",
                                      item.date.getFormattedDate(format: "EEE\nM/d")),
                            y: .value("Expenses",
                                      item.expensesMoney))
                        .foregroundStyle(Color.niceRed.getGradient())
                       
                    
                    
                    BarMark(x: .value("Day",
                                      item.date.getFormattedDate(format: "EEE\nM/d")),
                            y: .value("Earnings",
                                      (item.expensesMoney + item.earnedMoney) * 0.95))
                    
                        .foregroundStyle(Color.okGreen.getGradient())
                        
                    
                }
            }
            
            .chartLegend(.visible)
            .chartForegroundStyleScale([
                "Earned": Color.okGreen.getGradient(),
              "Spent": Color.niceRed.getGradient()
              
            ])
        }
        .frame(height: 300)
    }
}

// MARK: - NetMoneyGraph_Previews

struct NetMoneyGraph_Previews: PreviewProvider {
    static var previews: some View {
        NetMoneyGraph()
            .tint(User.main.getSettings().themeColor)
            .frame(height: 300)
    }
}
