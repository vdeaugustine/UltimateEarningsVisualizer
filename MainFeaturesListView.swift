//
//  MainFeaturesListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/30/23.
//

import SwiftUI

struct MainFeaturesListView: View {
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                
                Text("Entities")
                    .font(.system(.largeTitle, weight: .bold))
                    .frame(maxWidth: 350)
                    .multilineTextAlignment(.center)
                
                Row(imageString: "target", headline: "Goals", subheadline: "Set financial goals with descriptions and due dates")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .background {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
        }
        
    }
    
    struct Row: View {
        
        let imageString: String
        let headline: String
        let subheadline: String
        
        var body: some View {
            HStack {
                Image(systemName: "target")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                
                VStack(alignment: .leading) {
                    Text(headline)
                        .font(.headline)
                    
                    Text(subheadline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(UIColor.secondaryLabel.color)
                }
                
                
            }
            .padding()
            .background {
                UIColor.systemBackground.color.clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    MainFeaturesListView()
}
