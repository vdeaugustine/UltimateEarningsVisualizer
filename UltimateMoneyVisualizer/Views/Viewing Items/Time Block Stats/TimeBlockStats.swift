
import SwiftUI

// MARK: - TimeBlockStatsView

struct TimeBlockStatsView: View {
    @StateObject private var vm = TimeBlockStatsViewModel.shared
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 10) {
                    Toggle("Date range", isOn: $vm.includeDateRange)
                        .padding()

                    if vm.includeDateRange {
                        HStack {
                            DatePicker("", selection: $vm.firstDate, displayedComponents: .date).labelsHidden()
                            Text("-")
                            DatePicker("", selection: $vm.lastDate, displayedComponents: .date).labelsHidden()
                        }
                        .padding(.bottom)
                    }

                    LazyVStack {
                        ForEach(vm.user.getTimeBlocksBetween(startDate: vm.firstDate, endDate: vm.lastDate).consolidate()) { block in
                            Button{
                                vm.insertOrRemove(block)
                            } label: {
                                TimeBlockRect(title: block.title,
                                              subtitle: block.duration.breakDownTime(),
                                              thirdTitle: "Recent: " + block.lastUsed.getFormattedDate(format: "MMM d • h:mm a"),
                                              color: block.color,
                                              isSelected: vm.highlightedBlocks.contains(block),
                                              accessoryString: block.actualBlocks(vm.user).count.str)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)

                    VStack(spacing: 30) {
                        selectedBlocksHeader

                        selectedBlocksInfo

                        showInstancesSection(scrollProxy)

//                        pieChart
                    }
                    .padding()
                    .background { Color.targetGray }
                    
                }
                .frame(maxWidth: .infinity)
//                .padding()
            }
        }
        .putInTemplate(title: "Time Block Stats", displayMode: .large, settings: vm.settings)
    }
}

extension TimeBlockStatsView {
    var selectedBlocksHeader: some View {
        HStack {
            Text("Selected Blocks")
                .format(size: 16, weight: .semibold)
            Spacer()
        }
        .id("instances")
    }

    var selectedBlocksInfo: some View {
        HStack(spacing: 40) {
            StatRect_TimeBlockStatsView(imageStr: "number",
                                        valueStr: vm.instancesOfHighlighted.count.str,
                                        labelStr: "Instances")

            StatRect_TimeBlockStatsView(imageStr: "clock",
                                        valueStr: vm.durationForHighlighted.breakDownTime(),
                                        labelStr: "Time")

            StatRect_TimeBlockStatsView(imageStr: "dollarsign",
                                        valueStr: vm.amountForHighlighted.money(),
                                        labelStr: "Earned")
        }
    }

    @ViewBuilder func showInstancesSection(_ scrollProxy: ScrollViewProxy) -> some View {
        if !vm.instancesOfHighlighted.isEmpty {
            Button {
                vm.showInstances.toggle()
            } label: {
                Text(vm.toggleShowInstancesLabelString)
            }
            if vm.showInstances {
                LazyVStack {
                    ForEach(vm.instancesOfHighlighted) { block in

                        TimeBlockRect(title: block.title ?? "",
                                      subtitle: block.duration.breakDownTime(),
                                      thirdTitle: "Recent: " + (block.endTime?.getFormattedDate(format: .abreviatedMonthAndMinimalTime) ?? ""),
                                      color: block.getColor())
                    }
                }
                .frame(maxWidth: .infinity)

                Button {
                    withAnimation {
                        scrollProxy.scrollTo("instances")
                    }

                } label: {
                    Text("Back to top")
                }
            }
        }
    }

    @ViewBuilder var pieChart: some View {
        if !vm.instancesOfHighlighted.isEmpty {
            GPTPieChart(pieChartData: vm.pieChartData, includeLegend: true)
                .frame(height: 200)
                
        }
        
    }
}

// MARK: - StatRect_TimeBlockStatsView

struct StatRect_TimeBlockStatsView: View {
    let imageStr: String
    let valueStr: String
    let labelStr: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: imageStr)
                .font(.system(size: 24))
            Text(valueStr)
                .format(size: 16,
                        weight: .semibold,
                        color: Color(red: 0.13,
                                     green: 0.13,
                                     blue: 0.13))
            Text(labelStr)
                .format(size: 12,
                        weight: .regular,
                        color: Color(red: 0.37,
                                     green: 0.37,
                                     blue: 0.37))
        }
    }
}

// MARK: - TimeBlockRect

struct TimeBlockRect: View {
    let title: String
    let subtitle: String
    let thirdTitle: String?
    var maxHeight: CGFloat? = nil
    let color: Color
    var isSelected: Bool = false
    var accessoryString: String? = nil
    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(color)
                .frame(width: 4)
                .frame(maxHeight: .infinity)
                .cornerRadius(4)

            VStack(alignment: .leading) {
                Text(title)
                    .format(size: 14, weight: .semibold)
                Text(subtitle)
                    .format(size: 12)

                if let thirdTitle, thirdTitle.isEmpty == false {
                    Text(thirdTitle)
                        .format(size: 12)
                }
            }

            Spacer()

            if let accessoryString {
                Text(accessoryString)
                    .format(size: 16, weight: .medium, color: .textSecondary)
            }
        }

        .padding(14, 10)
        .frame(maxWidth: .infinity, maxHeight: maxHeight ?? 70, alignment: .leading)
        .modifier(ShadowForRect())
//        .border(isSelected ? .blue : .clear)
        .overlay {
            if isSelected {
                RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 3)
            }
        }
    }
}

// MARK: - TimeBlockStatsView_Previews

// struct TimeBlockRect_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeBlockRect(title: "10:00 - 11:30 AM",
//                      subtitle: "Talked on the phone",
//                      thirdTitle: "1h 30m",
//                      color: Color(red: 0.08,
//                                   green: 0.23,
//                                   blue: 0.75))
//    }
// }

struct TimeBlockStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TimeBlockStatsView()
            .templateForPreview()
    }
}
