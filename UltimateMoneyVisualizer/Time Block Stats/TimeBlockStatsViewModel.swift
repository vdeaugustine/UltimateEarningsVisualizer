import Foundation
import SwiftUI

class TimeBlockStatsViewModel: ObservableObject {
    static var shared: TimeBlockStatsViewModel = .init()

    @ObservedObject var user = User.main
    @ObservedObject var settings = User.main.getSettings()

    @Published var highlightedBlocks: Set<CondensedTimeBlock> = []

    @Published var includeDateRange: Bool = false
    @Published var firstDate: Date = User.main.getShifts().last?.startDate ?? .now
    @Published var lastDate: Date = User.main.getShifts().first?.startDate ?? .now
    @Published var showInstances: Bool = false

    var instancesOfHighlighted: [TimeBlock] {
        var instances: [TimeBlock] = []
        for block in highlightedBlocks {
            if includeDateRange {
                instances += block.actualBlocks(user, start: firstDate, end: lastDate)
            } else {
                instances += block.actualBlocks(user)
            }
        }
        return instances
    }

    var amountForHighlighted: Double {
        instancesOfHighlighted.reduce(Double(0)) { $0 + $1.amountEarned() }
    }

    var durationForHighlighted: Double {
        instancesOfHighlighted.reduce(Double(0)) { $0 + $1.duration }
    }

    var toggleShowInstancesLabelString: String {
        showInstances ? "Hide instances" : "Show instances"
    }

    func insertOrRemove(_ block: CondensedTimeBlock) {
        if highlightedBlocks.contains(block) {
            highlightedBlocks.remove(block)
            return
        } else {
            highlightedBlocks.insert(block)
        }
    }

    var pieChartData: [GPTPieChart.PieSliceData] {
        let totalTimeWorked: Double = {
            if includeDateRange {
                return user.getTimeWorkedBetween(startDate: firstDate, endDate: lastDate)
            } else {
                return user.totalTimeWorked()
            }
        }()

        return [.init(color: .green, name: "In time block", amount: durationForHighlighted),
                .init(color: .orange, name: "Other work", amount: totalTimeWorked - durationForHighlighted)]
    }
}
