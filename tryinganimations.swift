//
//  tryinganimations.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/16/23.
//

import SwiftUI

struct tryinganimations: View {
//    @State private var show = false
//    let amount = 10
//    var range: [Int] {
//        if show {
//            return (0 ..< amount).reversed().reversed()
//        }
//        else { return  (0 ..< amount).reversed()}
//    }
//
//    @State private var num: Int = 0
//    var body: some View {
//        ZStack {
//            ForEach(range, id: \.self ) { num in
//                Color.red.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 20)
//                    .position(x: 200, y: ((show ? CGFloat(num) * 21 : 0) + 40))
//
//    //                .transition(.asymmetric(insertion: AnyTransition.move(edge: .leading), removal: .move(edge: .trailing)))
//
//
//            }
//
//
//
//        }
//        .animation(Animation.default.delay(Double(num) * 1), value: show)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .onTapGesture {
//            print("tapped")
//            withAnimation {
//                show.toggle()
//            }
//        }
//    }
    
    @State private var show = false

    struct Item: Hashable {
        let startPoint: CGFloat
        let endPoint: CGFloat
    }

    let items: [Item] =
        [.init(startPoint: 40, endPoint: 60),
         .init(startPoint: 61, endPoint: 81),
         .init(startPoint: 61, endPoint: 81)
        
        ]
    
    @State private var counter = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
        

    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { num in
                Color.blue
                    .frame(width: 100, height: 20)
                    .offset(y: CGFloat((-counter - num) * 20) )
                    .animation(Animation.default.delay(Double(num) * 1), value: show)
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                counter += 1
                if counter > 9 { counter = 0 }
            }
        }
    }
}

#Preview {
    tryinganimations()
}
