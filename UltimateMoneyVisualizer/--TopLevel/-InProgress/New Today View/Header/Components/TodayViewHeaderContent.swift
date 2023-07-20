//
//  TodayViewHeaderContent.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/18/23.
//

import SwiftUI

// MARK: - TodayViewHeaderContent

struct TodayViewHeaderContent: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    var body: some View {
        VStack {
            HStack(spacing: 84) {
                HStack(spacing: 20) {
                    Image(systemName: "bolt.shield")
                        .font(.system(size: 40))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.start.getFormattedDate(format: .abreviatedMonth))
                            .font(.lato(.black, 24))
                        Text(viewModel.timeStringForHeader)
                            .font(.lato(.thin, 20))
                            .kerning(-0.02 * 20)
                    }
                }

                ZStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .padding(10)
                        .background {
                            Circle()
                                .fill(Color(hex: "3F63F3"))
                        }
                        .frame(width: 48, height: 48)
                }
            }
            .foregroundStyle(Color.white)
        }
    }
}

// MARK: - TodayViewHeaderContent_Previews

struct TodayViewHeaderContent_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TodayViewHeaderBackground()
//                .frame(height: 237)
            TodayViewHeaderContent()
        }

        .previewLayout(.sizeThatFits)
        .environmentObject(TodayViewModel.main)
    }
}

extension Font {
    static func lato(_ type: LatoTypes = .regular, _ size: CGFloat = 16) -> Font {
        Font.custom("Lato-\(type.rawValue)", fixedSize: size)
    }
    
    static func lato(_ size: CGFloat = 16) -> Font {
        Font.custom("Lato-Regular", fixedSize: size)
    }

    public enum LatoTypes: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case italic = "Italic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case regular = "Regular"
        case thin = "Thin"
        case thinItalic = "ThinItalic"
    }
}
