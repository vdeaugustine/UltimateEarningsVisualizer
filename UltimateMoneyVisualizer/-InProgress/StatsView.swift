//
//  StatsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/4/23.
//

import SwiftUI
import Charts

// MARK: - StatsView

struct StatsView: View {
    enum MoneySection: String, CaseIterable, Identifiable {
        case all, earned, spent, saved, goals
        var id: MoneySection { self }
    }

    @State private var selectedSection: MoneySection = .earned
    @State private var firstDate: Date = .now.addDays(-5)
    @State private var secondDate: Date = .endOfDay()

    @ObservedObject private var user: User = User.main

    var body: some View {
        ScrollView {
            Picker("Section", selection: $selectedSection) {
                ForEach(MoneySection.allCases) { section in
                    Text(section.rawValue.capitalized).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // MARK: - Selected Section

            switch selectedSection {
                case .all:
                    Text("All")
                case .earned:
                    earnedSection
                case .spent:
                    spentSection
                case .saved:
                    savedSection
                case .goals:
                    goalsSection
            }

            HStack {
                DatePicker("", selection: $firstDate, in: .init(uncheckedBounds: (lower: Date.distantPast, upper: secondDate)), displayedComponents: .date).labelsHidden()
                Text("-")
                DatePicker("", selection: $secondDate, in: .init(uncheckedBounds: (lower: firstDate, upper: .distantFuture)), displayedComponents: .date).labelsHidden()
            }
            
            VStack(spacing: 0) {
                LineChart()
                    .frame(height: 300)
                    
                
                Text("Shows the total amount of money you had earned up to each day, including all previous days not shown")
                    .font(.footnote)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
            }
            .padding([.horizontal, .bottom])
            
            
            homeSection(rectContainer: false, header: "Items") {
                LazyVStack {
                    ForEach(user.getShiftsBetween(startDate: firstDate, endDate: secondDate)) { shift in
                        
                        VStack {
                            HStack {
                                HStack(spacing: 15) {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.green)
                                    Text(shift.start.getFormattedDate(format: .abreviatedMonth))
                                }
                                Spacer()
                                Text(shift.totalEarned.formattedForMoney())
                            }
                            .padding([.top, .horizontal])
                            Divider()
                        }
                        
                        
                    }
                }
                .rectContainer(shadowRadius: 0)
                
            }
            .padding()
            .padding(.horizontal, 5)
            
            
            
        }
        .background(Color.targetGray)
        .putInTemplate()
        .navigationTitle("My Stats")
    }

    // MARK: - Earned Section

    var earnedSection: some View {
        VStack {
            HorizontalDataDisplay(data: [.init(label: "Shifts", value: user.getShiftsBetween(startDate: firstDate, endDate: secondDate).count.str, view: nil),
                                         .init(label: "Amount", value: user.getTotalEarnedBetween(startDate: firstDate, endDate: secondDate).formattedForMoney(), view: nil),
                                         .init(label: "Time", value: user.getTimeWorkedBetween(startDate: firstDate, endDate: secondDate).formatForTime(), view: nil)])
        }
    }

    // MARK: - Saved Section

    var savedSection: some View {
        VStack {
        }
    }

    // MARK: - Spent Section

    var spentSection: some View {
        VStack {
        }
    }

    // MARK: - Goals Section

    var goalsSection: some View {
        VStack {
        }
    }
    
    struct LineChart: View {
        @ObservedObject private var user = User.main
        var title: String? = nil
        var backgroundColor: Color? = nil
        

        var body: some View {
            ZStack {
                if let backgroundColor = backgroundColor {
                    backgroundColor
                }
                VStack {
                    if let title = title {
                        Text(title.uppercased())
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
//                    Chart {
//                        ForEach((-5 ... 0), id: \.self) { ind in
//                            LineMark(x: .value("Day", Date.getDayOfWeek(daysBack: ind)),
//                                     y: .value("Value", user.getTotalEarnedBetween(endDate: .now.addDays(Double(ind)))))
//                            PointMark(x: .value("Day", Date.getDayOfWeek(daysBack: ind)),
//                                      y: .value("Value", user.getTotalEarnedBetween(ind)))
//                        }
//                    }
                    
                    VStack {
                        Text("Chart goes here")
                    }
                    .rectContainer(shadowRadius: 0.02)

                    .padding(.horizontal, 5)
                }
                .padding(.vertical)
            }
        }
    }
}

// MARK: - StatsView_Previews

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .putInNavView(.inline)
    }
}
