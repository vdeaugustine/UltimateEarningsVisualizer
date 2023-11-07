//
//  OnboardingManager.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/1/23.
//

import Foundation
import Combine
import SwiftUI

enum OnboardingStep: String, CaseIterable {
    case welcomeIntroduction = "Welcome Introduction"
    case features = "Features"
    case benefits = "Benefits"
    case onboardingProgressContainer = "Onboarding Overview"
    case cashInflowContainer = "Cash Inflow"
    case cashOutflowContainer = "Cash Outflow"
    
//    case addShift = "Add a Shift"
//    case addExpense = "Add an Expense"
//    case setGoal = "Set a Goal"
//    case enterSavedItem = "Enter a Saved Item"
//    case overviewPayPeriods = "Overview of Pay Periods"
//    case setupWorkSchedule = "Set Up Work Schedule"
//    case interactTodayShift = "Interact with Today Shift"
//    case customizeWageSettings = "Customize Wage Settings"
//    case finishTutorial = "Finish and Exit Tutorial"

    // Get the next case for the next step
    var next: OnboardingStep? {
        let allCases = OnboardingStep.allCases
        let index = allCases.firstIndex(of: self)!
        let nextIndex = index + 1
        return allCases.count > nextIndex ? allCases[nextIndex] : nil
    }

    var previous: OnboardingStep? {
        let allCases = OnboardingStep.allCases
        let index = allCases.firstIndex(of: self)!
        let previousIndex = index - 1
        return previousIndex >= 0 ? allCases[previousIndex] : nil
    }

    // Get the percentage completed given a case
    var percentageComplete: Double {
        let allCases = OnboardingStep.allCases
        let index = allCases.firstIndex(of: self)!
        return min((Double(index) / Double(allCases.count - 1)), 1)
    }

    // Get the step number given a case
    var stepNumber: Int {
        let allCases = OnboardingStep.allCases
        return allCases.firstIndex(of: self)! + 1
    }
}

class OnboardingManager: ObservableObject {
    
    static var shared: OnboardingManager = .init()
    
    @ObservedObject var user = User.main
    
    @Published var currentStep: OnboardingStep = {
        guard let stepString = User.main.statusTracker?.onboardingStep else {
            return .welcomeIntroduction
        }
        return OnboardingStep(rawValue: stepString) ?? .welcomeIntroduction
    }()
    
    @Published var progress: Double = 0
    
    func goToNextStep() {
        if let nextStep = currentStep.next {
            currentStep = nextStep
            progress = nextStep.percentageComplete
            
            user.statusTracker?.onboardingStep = nextStep.rawValue
            
            do {
                try user.managedObjectContext?.save()
            } catch {
                print("Error saving after going to next step :::: \(error.localizedDescription)")
            }

        }
    }
    
    func goBackToPreviousStep() {
        if let previousStep = OnboardingStep.allCases.first(where: { $0.next == currentStep }) {
            currentStep = previousStep
            progress = previousStep.percentageComplete
            
            user.statusTracker?.onboardingStep = previousStep.rawValue
            
            do {
                try user.managedObjectContext?.save()
            } catch {
                print("Error saving after going to next step :::: \(error.localizedDescription)")
            }
        }
    }
    
    
}
