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
    @State private var showTotalTimePopover = false
    @State private var showTotalEarningsPopover = false
    var body: some View {
        VStack {
            HStack(spacing: 84) {
                HStack(spacing: 20) {
                    Image(systemName: "bolt.shield")
                        .font(.system(size: 52))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.dateStringForHeader)
                            .font(.system(size: 24))
                            .fontWeight(.black)
                        Text(viewModel.timeStringForHeader)
                            .font(.system(size: 20))
                            .kerning(-0.02 * 20)
                        HStack {
                            Text(viewModel.user.todayShift?.totalShiftDuration.breakDownTime() ?? "")
                                .onTapGesture {
                                    showTotalTimePopover = true
                                }
                                .floatingPopover(isPresented: $showTotalTimePopover, arrowDirection: .up) {
                                    VStack {
                                        Text("Workday duration")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                    }
                                    .padding(10, 5)
                                    .frame(height: 45)
                                    .background {
                                        Color(UIColor.darkGray)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(-20)
                                    }
                                }
                            Text("•")
                            Text(viewModel.willEarn.money())
                                .onTapGesture {
                                    showTotalEarningsPopover = true
                                }
                                .floatingPopover(isPresented: $showTotalEarningsPopover, arrowDirection: .up) {
                                    VStack {
                                        Text("Expected daily earnings")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                    }
                                    .padding(10, 5)
                                    .frame(height: 45)
                                    .background {
                                        Color(UIColor.darkGray)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding(-20)
                                    }
                                }
                        }
                        .font(.system(size: 20))
                    }
                }
                .onChange(of: viewModel.user.wage?.amount) { newValue in
                    print("New value \(newValue ?? 0)")
                }

                VStack(spacing: 4) {
                    HeaderButton(imageName: "gearshape.fill") {
                        viewModel.showHoursSheet.toggle()
                    }

                    HeaderButton(imageName: "minus.circle.fill") {
                        viewModel.tappedDeleteAction()
                    }

                    #if DEBUG
                        HeaderButton(imageName: "checkmark") {
                            viewModel.saveShift()
                        }
                    #else
                        if viewModel.shiftIsOver {
                            HeaderButton(imageName: "checkmark") {
                                viewModel.saveShift()
                            }
                        }
                    #endif
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

// MARK: - HeaderButton

struct HeaderButton: View {
    @EnvironmentObject private var vm: TodayViewModel

    let imageName: String
//    let widthHeight: CGFloat = 48
    let action: () -> Void

    var body: some View {
        ZStack {
            Image(systemName: imageName)
                .font(.system(size: 20))
                .padding(10)
                .background {
                    vm.settings.themeColor.brightness(0.2)
                        .clipShape(Circle())
                }
//                .frame(width: widthHeight, height: widthHeight)
                .onTapGesture(perform: action)
        }
    }
}
