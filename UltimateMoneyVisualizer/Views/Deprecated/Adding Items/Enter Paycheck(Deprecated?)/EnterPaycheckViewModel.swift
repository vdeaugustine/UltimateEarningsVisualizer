//
//  EnterPaycheckViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/20/23.
//

import Foundation
import CoreData
import SwiftUI

// MARK: - PaycheckViewModel

class EnterPaycheckViewModel: ObservableObject {
    @Published var thisCheckGross: Double = 0
    @Published var thisCheckTax: Double = 0
    @Published var YTDGross: Double = 0
    @Published var YTDTax: Double = 0

    @Published var showCheckGrossSheet = false
    @Published var showCheckTaxSheet = false
    @Published var showYTDGrossSheet = false
    @Published var showYTDTaxSheet = false

    @Published var typeSelected = TypeChoice.YTD

    @Published var includeDeductions = false
    @Published var deductionsIncluded: [Deductions] = []

    @Published var includeRetirement = false
    @Published var includeInsurance = false
    @Published var includeStocks = false
    @ObservedObject var user = User.main

    enum TypeChoice: String {
        case YTD, paycheck = "Paycheck"
    }

    enum Deductions: String, CaseIterable, Identifiable {
        case retirement
        case insurance
        case stock = "Stock Options"

        var id: Deductions { self }
    }

    var YTDTaxRate: Double {
        guard YTDGross > 0 else { return 0 }
        return YTDTax / YTDGross * 100
    }

    var paycheckTaxRate: Double {
        guard thisCheckGross > 0 else { return 0 }
        return thisCheckTax / thisCheckGross * 100
    }

    func savePaycheck() {
        // Perform saving logic here
    }
}
