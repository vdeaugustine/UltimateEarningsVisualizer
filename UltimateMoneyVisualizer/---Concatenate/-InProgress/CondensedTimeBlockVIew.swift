import SwiftUI

// MARK: - CondensedTimeBlockView

struct CondensedTimeBlockView: View {
    let block: CondensedTimeBlock
    @ObservedObject private var user = User.main
    var body: some View {
        List {
            Text(block.title)
            
            Text(block.duration.breakDownTime())
            Text(user.convertTimeToMoney(seconds: block.duration).money())
            Text("Average").spacedOut(text: (block.duration / Double(block.actualBlocks(user).count)).breakDownTime())
            Text("Instances").spacedOut(text: block.actualBlocks(user).count.str)
            Color(hex: block.colorHex).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            
            Section("Instances") {
                ForEach(block.actualBlocks(user)) { block in
                    Button {
                        NavManager.shared.homeNavPath.append(NavManager.AllViews.timeBlockDetail(block))
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
        .navigationTitle("Blocks")
        .putInTemplate(displayMode: .large, settings: user.getSettings())
    }
}

// MARK: - CondensedTimeBlockView_Previews

struct CondensedTimeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        CondensedTimeBlockView(block: User.main.getTimeBlocksBetween().consolidate().first!)
            .putInNavView(.large)
    }
}