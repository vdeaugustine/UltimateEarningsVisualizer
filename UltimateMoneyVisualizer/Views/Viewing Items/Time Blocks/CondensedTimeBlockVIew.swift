import SwiftUI
import Vin

// MARK: - CondensedTimeBlockView

struct CondensedTimeBlockView: View {
    @EnvironmentObject private var navManager: NavManager
    let block: CondensedTimeBlock
    @ObservedObject private var user = User.main

    var averageTime: Double {
        let count = block.actualBlocks(user).count
        guard count > 0 else { return 0 }
        return block.duration / Double(count)
    }

    var body: some View {
        List {
//            Section {
//                Text(block.title)
//
//                Text(block.duration.breakDownTime())
//                Text(user.convertTimeToMoney(seconds: block.duration).money())
//                Text("Average").spacedOut(text: averageTime.breakDownTime())
//
////                Color(hex: block.colorHex).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//            } header: {
//                Text("").hidden()
//            }

            Section("Title") {
                Text(block.title)
            }

            Section("Time") {
                Text("Total")
                    .spacedOut(text: block.duration.breakDownTime())
                Text("Average")
                    .spacedOut(text: averageTime.breakDownTime())
            }

            Section("Earnings") {
                Text("Total")
                    .spacedOut {
                        Text(user.convertTimeToMoney(seconds: block.duration).money())
                    }

                Text("Average")
                    .spacedOut {
                        Text(user.convertTimeToMoney(seconds: averageTime).money())
                    }
            }

            Section {
                DisclosureGroup("\(block.actualBlocks(user).count) instances") {
                    ForEach(block.actualBlocks(user)) { block in
                        Button {
                            navManager.appendCorrectPath(newValue: .timeBlockDetail(block))
                        } label: {
                            Text(block.startTime?.getFormattedDate(format: .abbreviatedMonth) ?? "")
                                .spacedOut {
                                    HStack {
                                        Text(block.startTime?.getFormattedDate(format: .minimalTime, amPMCapitalized: false) ?? "")
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                    }
                                }
                                .allPartsTappable()
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationTitle("Blocks")
        .putInTemplate(displayMode: .large, settings: user.getSettings())
    }
}

// MARK: - CondensedTimeBlockView_Previews

struct CondensedTimeBlockView_Previews: PreviewProvider {
    static let user: User = {
        let user = User.main
        user.instantiateExampleItems(context: user.getContext())
        return user
    }()

    static var previews: some View {
        CondensedTimeBlockView(block: user.getTimeBlocksBetween().consolidate().first!)
            .putInNavView(.large)
    }
}
