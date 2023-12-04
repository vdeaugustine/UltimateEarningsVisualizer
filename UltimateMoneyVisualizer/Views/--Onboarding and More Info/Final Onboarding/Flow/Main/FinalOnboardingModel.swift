//
//  FinalOnboardingModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/22/23.
//

import Combine
import Foundation
import SwiftUI
import Vin

class FinalOnboardingModel: ObservableObject {
    static var shared: FinalOnboardingModel = .init()
    let padFromTop: CGFloat = 30
    let padFromBottom: CGFloat = 50
    let buttonPad: CGFloat = 30
    let horizontalPad: CGFloat = 30
    let textAlignment: TextAlignment = .leading
    let imageHeight: CGFloat = 250
    let headerMaxWidth: CGFloat = 270
    let vStackSpacing: CGFloat = 40
    let minScaleFactorForHeader = 0.90

    @Published var currentPage: Page = .welcome

    enum Page: CaseIterable {
        case welcome
        case wage
        case regularSchedule
        case payPeriods
        case tutorialOffer

        var index: Int? {
            Page.allCases.firstIndex(of: self)
        }

        var nextPage: Page? {
            guard let index = index,
                  index < Page.allCases.count - 1 else {
                return nil
            }
            return Page.allCases[index + 1]
        }
    }

    func topPadding(_ geo: GeometryProxy) -> CGFloat {
        let knownGood: CGFloat = 30 / 763
        return min(knownGood * geo.size.height, 30)
    }

    func bottomPadding(_ geo: GeometryProxy) -> CGFloat {
        let knownGood: CGFloat = 50 / 763
        let calculatedValue = min(knownGood * geo.size.height, 50)
        if geo.size.height < 740 { return calculatedValue + 8 }
        return calculatedValue
    }

    func spacingBetweenHeaderAndContent(_ geo: GeometryProxy) -> CGFloat {
        let knownGood: CGFloat = 40 / 763
        return min(knownGood * geo.size.height, 30)
    }

    func advanceToNextPage() {
        guard let nextPage = currentPage.nextPage else {
            return
        }
        currentPage = nextPage
    }
}
