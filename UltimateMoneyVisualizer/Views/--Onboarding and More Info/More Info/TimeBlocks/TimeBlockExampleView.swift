//
//  TimeBlockExampleView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/26/23.
//

import SwiftUI
import Vin

struct TimeBlockExampleView: View {
    var showPopovers: Bool = true
    @State private var rowPopup = false
    @State private var titlePopup = false
    @State private var timePopup = false
    @State private var earningsPopup = false

    @State private var timesToShow: [Date] = []
    
    let dispatchPause: CGFloat = 0.7

    struct PseudoBlock {
        let title: String
        let start: String
        let end: String
        let color: Color
        let earned: String
    }

    struct StartAndEnd: Hashable {
        let start: Date
        let end: Date
    }

    func plusNavigation() -> some View {
        Image(systemName: "plus.circle")
            .foregroundStyle(.tint)
    }

    func money(forTime minutes: Double) -> String {
        let perMinute: Double = 20 / 60
        return (perMinute * minutes).money()
    }
    
    

    var body: some View {
        // ScrollView {
        VStack {
            Group {
                divider(time: "9:00 AM")

                row(
                    .init(title: "Morning routine",
                          start: "9:00 AM",
                          end: "10:00 AM",
                          color: .yellow,
                          earned: money(forTime: 60))
                )

                divider(time: "10:00 AM")

                row(
                    .init(title: "Focused work session",
                          start: "10:00 AM",
                          end: "11:30 AM",
                          color: Color(uiColor: .magenta),
                          earned: money(forTime: 90))
                )

                divider(time: "11:30 AM")

                // MARK: - Item for popovers

                HStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.green)
                        .frame(width: 3)
                        .padding(.vertical, 1)

                    VStack(alignment: .leading) {
                        Text("Checked email")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .lineLimit(1)
                            .floatingPopover(isPresented: $titlePopup, arrowDirection: .up) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchPause) {
                                    timePopup = true
                                }
                                
                            } content: {
                                VStack {
                                    Text("It shows what you did")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                                .padding(20, 5)
                                .frame(height: 45)
                                .background {
                                    Color(UIColor.darkGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(-20)
                                }
                            }


                        Text("\("11:30 AM") - \("12:07 PM")")
                            .font(.caption, design: .rounded)
                            .lineLimit(1)
                        
                            .floatingPopover(isPresented: $timePopup, arrowDirection: .left) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchPause) {
                                    earningsPopup = true
                                }
                                
                            } content: {
                                VStack {
                                    Text("How long you did it for")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                }
                                .padding(20, 5)
                                .frame(height: 45)
                                .background {
                                    Color(UIColor.darkGray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(-20)
                                }
                            }
                    }
                    .lineLimit(1)
                    Spacer()

                    Text(money(forTime: 37))
                        .font(.caption)
                        .lineLimit(1)
                        .floatingPopover(isPresented: $earningsPopup, arrowDirection: .up) {
                            VStack {
                                Text("And how much you earned while doing it")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                            .padding(10, 5)
                            .frame(height: 60)
                            .background {
                                Color(UIColor.darkGray)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(-40)
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background {
                    Color.secondarySystemBackground
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                .frame(height: 50)

                .floatingPopover(isPresented: $rowPopup, arrowDirection: .down) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + dispatchPause) {
                        titlePopup = true
                    }
                } content:  {
                    VStack {
                        Text("This is a time block")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .padding(20, 5)
                    .frame(height: 45)
                    .background {
                        Color(UIColor.darkGray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(-20)
                    }
                }
                
                

                // MARK: -

                divider(time: "12:07 PM")

                plusNavigation()

                divider(time: "12:30 PM")

                row(
                    .init(title: "Lunch",
                          start: "12:30 PM",
                          end: "1:30 PM",
                          color: .indigo,
                          earned: money(forTime: 60))
                )

                divider(time: "1:30 PM")
            }

            row(
                .init(title: "Meetings",
                      start: "1:30 PM",
                      end: "2:50 PM",
                      color: .green,
                      earned: money(forTime: 30 + 50))
            )

            divider(time: "2:50")

            plusNavigation()

            divider(time: "5:00 PM")
        }
        .onAppear(perform: {
            if showPopovers {
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchPause) {
                    rowPopup = true
                    print("yyyy")
                }
            }
        })
    }

    func timeBlockSection(timeBlock: PseudoBlock, topDiv: Bool = true, bottomDiv: Bool = true) -> some View {
        VStack(spacing: 15) {
            if topDiv {
                divider(time: timeBlock.start)
            }
            row(timeBlock)

            if bottomDiv {
                divider(time: timeBlock.end)
            }
        }
    }

    func timeBlockPill(timeBlock: TimeBlock) -> some View {
        HStack {
            if let title = timeBlock.title {
                Text(title)
                    .font(.caption, design: .rounded)
                    .foregroundColor(.white)

                Spacer()

                Text(timeBlock.amountEarned().money())
                    .font(.caption, design: .rounded)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(timeBlock.getColor())
        }
    }

    @ViewBuilder
    func row(_ block: PseudoBlock) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(block.color)
                .frame(width: 3)
                .padding(.vertical, 1)

            VStack(alignment: .leading) {
                Text(block.title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .lineLimit(1)

                Text("\(block.start) - \(block.end)")
                    .font(.caption)
                    .lineLimit(1)
            }
            .lineLimit(1)
            Spacer()

            Text(block.earned)
                .font(.caption, design: .rounded)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background {
            Color.secondarySystemBackground
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }

        .frame(height: 50)
    }

    func divider(time: String) -> some View {
        HStack(spacing: 9) {
            Text(time)
                .font(.footnote, design: .rounded)
            VStack { Divider() }
        }
    }
}

#Preview {
    TimeBlockExampleView()
}
