//
//  FinalWageViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/30/23.
//

import Foundation
import SwiftUI

class FinalWageViewModel: ObservableObject {
    // MARK: - General

    @ObservedObject var user = User.main

    @Published var slideNumber: Int = 1
    @Published var stepNumber: Int = 1

    let totalStepCount: Int = 5
    var stepPercentage: Double {
        Double(stepNumber) / Double(totalStepCount)
    }

    // MARK: - First Slide

    @Published var wageType: WageType? = nil

    // MARK: - Second Slide

    @Published var showWageAmountSheet = false
    @Published var wageAmount: Double? = nil

    // MARK: - CalculationAssumptions

    
    @Published var hoursPerDay: Double = 8
    @Published var daysPerWeek: Int = 5
    @Published var weeksPerYear: Int = 50
    
    
    // MARK: - Taxes
    @Published var includeStateTaxes = false
    @Published var stateTaxAmount: Double = 7
    @Published var federalTaxAmount: Double = 19
    @Published var includeFederalTaxes = true
    
    @Published var showCalculateStateTaxes = false
    @Published var showCalculateFedTaxes = false 
    

    // MARK: - Fourth Slide

    func saveWageToCoreData() throws {
        guard let wageAmount else {
            throw WageSaveError.wageAmountNotSet
        }
        guard let wageType else {
            throw WageSaveError.wageTypeNotSet
        }

        do {
            try Wage(amount: wageAmount,
                     isSalary: wageType == .salary,
                     user: user,
                     includeTaxes: includeStateTaxes || includeFederalTaxes,
                     stateTax: includeStateTaxes ? stateTaxAmount : nil,
                     federalTax: includeFederalTaxes ? federalTaxAmount : nil,
                     context: PersistenceController.context)
        } catch {
            throw WageSaveError.couldNotSaveToCoreData
        }
    }

    enum WageSaveError: Error {
        case wageAmountNotSet
        case wageTypeNotSet
        case couldNotSaveToCoreData

        var errorMessage: String {
            switch self {
                case .wageAmountNotSet:
                    return "Wage amount is not set"
                case .wageTypeNotSet:
                    return "Wage type is not set"
                case .couldNotSaveToCoreData:
                    return "Could not save to core data"
            }
        }
    }
}
