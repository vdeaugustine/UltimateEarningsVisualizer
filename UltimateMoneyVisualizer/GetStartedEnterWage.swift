//
//  GetStartedEnterWage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/13/23.
//

import SwiftUI


struct MoneyCalendar: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Color.accentColor.brightness(0.20)
            Image("moneyCalendar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(30 * (size.height / 759))
        }
        .clipShape(Circle())
        .frame(width: 300 * (size.height / 759) )
    }
}


struct GetStartedEnterWage: View {
    
    //(393.0, 759.0)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                VStack {
                    ZStack {
                        let width = geo.size.width
                        let height = geo.size.height
                        let startX = CGFloat(0)
                        let startY = CGFloat(CGFloat(height / 4 + 50) * (height / 759))
                        let endX = width
                        let endY = startY
                        let start = CGPoint(x: startX, y: startY)
                        let end = CGPoint(x: width, y: endY)
                        let controlPoint = CGPoint(x: width / 2, y: endY + (130 * (height / 759)))
                        let controlPoint2 = CGPoint(x: endX - 30, y: endY)

            //            UIColor.secondarySystemBackground.color

                        Path { path in
                            path.move(to: start)
                            path.addQuadCurve(to: end,
                                              control: controlPoint)
    //                        path.addCurve(to: end, control1: controlPoint1, control2: controlPoint2)
                            
                            path.addLine(to: CGPoint(x: width, y: 0))
                            path.addLine(to: .zero)
                            path.closeSubpath()
                        }
                        .fill(.tint)

                        #if DEBUG
                            // Make visible if you want to see the control points for designing
//                            Circle().frame(width: 10).position(controlPoint)
                        #endif
                        
                        MoneyCalendar(size: geo.size)
                            .position(x: geo.frame(in: .global).midX, y: endY)

                    }
                    .frame(height: 350 * (geo.size.height / 759))

                    .ignoresSafeArea()
                    
                    
                    
                    VStack(spacing: 20) {
                        Text("Get Started With Wage")
                            .font(.title)
                            .fontWeight(.bold)
                            .pushLeft()
                            .padding(.leading)
                            
                        
                        VStack(alignment: .leading, spacing: 30  * (geo.size.height / 759)) {
                            Text("Unlock personalized finance insights by entering your wage!")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Get started to see your earnings increase in real time!")
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .foregroundStyle(UIColor.secondaryLabel.color)
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Let's Get Started!")
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding()
                                .padding(.horizontal)
                                .background {
                                    Color.accentColor
                                }
                                .clipShape(Capsule(style: .circular))
                        }
                            
                        
                    }
                    .padding()
                    .kerning(1)
                    
                    
                    Spacer()
                    
                    
                }
                
                
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: {
                print(geo.size)
            })
        }
        
    }
}

#Preview {
    GetStartedEnterWage()
}
