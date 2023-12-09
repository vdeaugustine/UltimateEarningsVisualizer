//
//  MasterTheAppViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/7/23.
//

import Foundation
import SwiftUI

// MARK: - MasterTheAppViewModel

class MasterTheAppViewModel: ObservableObject {
    @Published var viewStack: NavigationPath = .init()
    @Published var level: Int = 0

    static var shared: MasterTheAppViewModel = .init()

    @ObservedObject private var statusTracker = User.main.getStatusTracker()
    @ObservedObject private var user = User.main

    func continueTapped() {
        switch level {
            case 0:
                navigateToSetup()
            case 1:
                navigateToSchedule()
            case 2:
                finish()
            default:
                return
        }
    }

    func finish() {
        print("Finished")
        level = 2

        handleCoreDataLogic()
    }

    func handleCoreDataLogic() {
        statusTracker.hasSeenOnboardingFlow = true
        do {
            try user.getContext().save()
        } catch {
            print("error. could not save the onboarding flow change ")
        }
    }

    func navigateToSetup() {
        viewStack.append(Views.wageWalkthrough)
    }

    func navigateToSchedule() {
        viewStack.append(Views.scheduleWalkthrough)
    }

    enum Views: Hashable {
        case wageWalkthrough
        case scheduleWalkthrough
    }

    @ViewBuilder func getDestination(for view: Views) -> some View {
        switch view {
            case .wageWalkthrough:
                FinalOnboardingWageWalkThrough()
            case .scheduleWalkthrough:
                FinalOnboardingScheduleFullSheet()
        }
    }
}
