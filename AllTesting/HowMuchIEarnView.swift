//
//  HowMuchIEarnView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/13/23.
//

import SwiftUI

// MARK: - HowMuchIEarnView

struct HowMuchIEarnView: View {
    @State private var timeLength: TimeLength = .days

    @State private var number: Int = 1

    @State private var showingWheel = false

    @State private var startingDate: Date = .now

    @State private var user = User.main

    var endDate: Date {
        guard let numberOfDays = timeLength.calculateDays(from: number) else { return startingDate }
        return Calendar.current.date(byAdding: .day, value: numberOfDays, to: startingDate) ?? startingDate
    }

    var body: some View {
        Form {
            amountRow
            Section("Time") {
                timeLengthRowWithPicker
                startingDateRow
            }

            if let schedule = user.regularSchedule {
                Section("Your schedule") {
                    ForEach(schedule.getDays().sorted(by: { $0.dayNum < $1.dayNum })) { day in
                        Text(day.description)
                    }
                }
                
                Section {
                    ForEach(schedule.getDays(from: startingDate, to: endDate), id: \.self) { date in
                        
                        Text(date.getFormattedDate(format: .shortWeekdayFullDayMonthYear))
                        
                    }
                }
            }
            
            
        }
    }

    var amountRow: some View {
        HStack {
            Text("Amount")
            Spacer()
        }
    }

    @ViewBuilder var timeLengthRowWithPicker: some View {
        Button {
            withAnimation {
                showingWheel.toggle()
            }
        } label: {
            HStack {
                Text("Time Period")
                Spacer()
                Text("\(number)" + " " + timeLength.rawValue)
                Components.nextPageChevron
                    .rotationEffect(.degrees(showingWheel ? 90 : 0))
            }
            .foregroundStyle(.black)
        }
        if showingWheel {
            HStack(spacing: 0) {
                Picker("Number", selection: $number) {
                    ForEach(0 ... 100, id: \.self) { num in
                        Text("\(num)").tag(num)
                    }
                }

                Picker("Period", selection: $timeLength) {
                    ForEach(TimeLength.allCases, id: \.self) { time in
                        Text(time.rawValue.capitalized).tag(time)
                    }
                }
            }
            .pickerStyle(.wheel)
        }
    }

    var startingDateRow: some View {
        DatePicker("Starting", selection: $startingDate, displayedComponents: .date)
            .datePickerStyle(.automatic)
    }

    var numberOfShiftsRow: some View {
        HStack {
            Text("")
            Spacer()
//            Text(User.main.shif)
        }
    }
}

// MARK: - TimeLength

enum TimeLength: String, CaseIterable {
    case days
    case weeks
    case months
    case years

    func calculateDays(from number: Int) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()

        var dateComponent = DateComponents()
        switch self {
            case .days:
                dateComponent.day = number
            case .weeks:
                dateComponent.day = number * 7
            case .months:
                dateComponent.month = number
            case .years:
                dateComponent.year = number
        }

        if let futureDate = calendar.date(byAdding: dateComponent, to: currentDate) {
            let days = calendar.dateComponents([.day], from: currentDate, to: futureDate).day
            return days
        }

        return nil
    }

//    case custom
}

// MARK: - TimeWheelPickerController

struct TimeWheelPickerController: UIViewControllerRepresentable {
    @Binding var selectedNumber: Int
    @Binding var selectedTimeLength: TimeLength

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let pickerView = UIPickerView()
        pickerView.dataSource = context.coordinator
        pickerView.delegate = context.coordinator
        viewController.view.addSubview(pickerView)

        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([pickerView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                                     pickerView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
                                     pickerView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                                     pickerView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)])

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let pickerView = uiViewController.view.subviews.first as? UIPickerView {
            pickerView.selectRow(selectedNumber, inComponent: 0, animated: true)
            pickerView.selectRow(TimeLength.allCases.firstIndex(of: selectedTimeLength) ?? 0, inComponent: 1, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let parent: TimeWheelPickerController

        init(_ pickerView: TimeWheelPickerController) {
            self.parent = pickerView
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if component == 0 {
                return 101
            } else {
                return TimeLength.allCases.count
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return "\(row)"
            } else {
                return TimeLength.allCases[row].rawValue.capitalized
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                parent.selectedNumber = row
            } else {
                parent.selectedTimeLength = TimeLength.allCases[row]
            }
        }
    }
}

// MARK: - HowMuchIEarnView_Previews

struct HowMuchIEarnView_Previews: PreviewProvider {
    static var previews: some View {
        HowMuchIEarnView()
            .onAppear(perform: {
                User.main.instantiateExampleItems(context: PersistenceController.context)
                User.main.regularSchedule?.addToDays(.init(dayOfWeek: .sunday, startTime: .nineAM, endTime: .fivePM, user: User.main))
            })
    }
}
