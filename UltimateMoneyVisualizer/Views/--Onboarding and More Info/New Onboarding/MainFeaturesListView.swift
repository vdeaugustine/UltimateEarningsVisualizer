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
                
                Text("Features")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .frame(maxWidth: 350)
                    .multilineTextAlignment(.center)
                
                Row(imageString: "calendar", headline: "Shifts", subheadline: "Calculates your earnings as they happen to show your wages and track your cash inflow")
                Row(imageString: "target", headline: "Goals", subheadline: "Set financial goals with descriptions and due dates")
                Row(imageString: IconManager.expenseString, headline: "Expenses", subheadline: "Record any purchase or payment you make to keep an accurate detailed record of your cash outflow ")
                SavedItemRow()
                Row(imageString: "hourglass", headline: "Time & Money", subheadline: "See exactly how much money your time is worth")
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            
        }
        .background {
            Color.secondarySystemBackground
                .ignoresSafeArea()
        }
        
    }
    
    struct Row: View {
        
        let imageString: String
        let headline: String
        let subheadline: String
        
        var body: some View {
            HStack(spacing: 20) {
                Image(systemName: imageString)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.tint)
                
                VStack(alignment: .leading) {
                    Text(headline)
                        .font(.headline, design: .rounded)
                    
                    Text(subheadline)
                        .font(.body, design: .rounded)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(UIColor.secondaryLabel.color)
                }
                
                Spacer()
                
            }
            .padding()
            .background {
                UIColor.systemBackground.color.clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    struct SavedItemRow: View {
        
        var body: some View {
            HStack(spacing: 20) {
                IconManager.savedIcon
                    .stroke(lineWidth: 2.5)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                    .foregroundStyle(.tint)
                
                VStack(alignment: .leading) {
                    Text("Saved Items")
                        .font(.headline, design: .rounded)
                    
                    Text("Record any time you save money and treat it the same as earnings to pay off items")
                        .font(.body, design: .rounded)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(UIColor.secondaryLabel.color)
                }
                
                Spacer()
                
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
