////
////  BankingScreen.swift
////  Example
////
////  Created by Danil Kristalev on 30.12.2021.
////  Copyright © 2021 Exyte. All rights reserved.
////
//
//#if DEBUG
//import SwiftUI
//import ScalingHeaderScrollView
//
//struct BankingScreen: View {
//
//    @Environment(\.presentationMode) var presentationMode
//    @State var progress: CGFloat = 0
//    @State private var isloading = false
//    
//    let service = BankingService()
//
//    var body: some View {
//        ZStack {
//            ScalingHeaderScrollView {
//                ZStack {
//                    Color(hex: "#EFF3F5").edgesIgnoringSafeArea(.all)
//                    CardView(progress: progress)
//                        .padding(.top, 130)
//                        .padding(.bottom, 40)
//                }
//            } content: {
//                Color.white.frame(height: 15)
//                ForEach(service.transactions) { transaction in
//                    TransactionView(transaction: transaction)
//                }
//                Color.white.frame(height: 15)
//            }
//            .height(min: 220, max: 372)
//            .collapseProgress($progress)
//            .allowsHeaderCollapse()
//            .pullToLoadMore(isLoading: $isloading, contentOffset: 50) {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    isloading = false
//                }
//            }
//            topButtons
//
//            VStack {
//                Text("Visa Card")
//                    .font(.system(size: 17))
//                    .padding(.top, 63)
//                Spacer()
//            }
//        }
//        .ignoresSafeArea()
//    }
//
//    private var topButtons: some View {
//        VStack {
//            HStack {
//                Button("", action: { self.presentationMode.wrappedValue.dismiss() })
//                    .buttonStyle(CircleButtonStyle(imageName: "arrow.backward", background: .white.opacity(0), width: 50, height: 50))
//                    .padding(.leading, 17)
//                    .padding(.top, 50)
//                Spacer()
//                Button("", action: { print("Info") })
//                    .buttonStyle(CircleButtonStyle(imageName: "ellipsis", background: .white.opacity(0), width: 50, height: 50))
//                    .padding(.trailing, 17)
//                    .padding(.top, 50)
//            }
//            Spacer()
//        }
//        .ignoresSafeArea()
//    }
//}
//
//struct CircleButtonStyle: ButtonStyle {
//
//    var imageName: String
//    var foreground = Color.black
//    var background = Color.white
//    var width: CGFloat = 40
//    var height: CGFloat = 40
//
//    func makeBody(configuration: Configuration) -> some View {
//        Circle()
//            .fill(background)
//            .overlay(Image(systemName: imageName)
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundColor(foreground)
//                        .padding(12))
//            .frame(width: width, height: height)
//    }
//}
//
//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b: CGFloat
//
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            let hexColor = String(hex[start...])
//
//            if hexColor.count == 6 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
//                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
//                    b = CGFloat(hexNumber & 0x0000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: 1)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}
//
//extension Color {
//    static func hex(_ hex: String) -> Color {
//        guard let uiColor = UIColor(hex: hex) else {
//            return Color.red
//        }
//        return Color(uiColor)
//    }
//}
//
//extension Color {
//    
//    static let appDarkGray = Color.hex("#0C0C0C")
//    static let appGray = Color.hex("#0C0C0C").opacity(0.8)
//    static let appLightGray = Color.hex("#0C0C0C").opacity(0.4)
//    static let appYellow = Color.hex("#FFAC0C")
//    
//    //Booking
//    static let appRed = Color.hex("#F62154")
//    static let appBookingBlue = Color.hex("#1874E0")
//    
//    //Profile
//    static let appProfileBlue = Color.hex("#374BFE")
//}
//
//extension View {
//
//    func fontBold(color: Color = .black, size: CGFloat) -> some View {
//        foregroundColor(color).font(.custom("Circe-Bold", size: size))
//    }
//
//    func fontRegular(color: Color = .black, size: CGFloat) -> some View {
//        foregroundColor(color).font(.custom("Circe", size: size))
//    }
//}
//
//struct BankingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        BankingScreen()
//    }
//}
//
//#endif 
