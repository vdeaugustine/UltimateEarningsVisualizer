
import SwiftUI

@available(iOS 12.0, *)
struct FigmaDesign: View {
    @State private var showRect = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Content Here")
                if showRect {
                    Rectangle()
                        .fill()
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Set the title display mode to inline
            
            // Replace the navigation bar title with a custom HStack containing the name "FigmaDesign"
            
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        // Your button action here
                    } label: {
                        // your button label here
                        Text("I am a button")
                    }
                }
                
            }
            
        }
    }
}


struct FigmaDesign_Previews: PreviewProvider {
    static var previews: some View {
        FigmaDesign()
    }
}
