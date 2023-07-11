//
//  GoalDetailViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import AlertToast
import Foundation
import SwiftUI

class GoalDetailViewModel: ObservableObject {
    init(goal: Goal) {
        self.goal = goal
    }

    @ObservedObject var user: User = User.main
    @ObservedObject var settings: Settings = User.main.getSettings()
    @ObservedObject var goal: Goal

    @Published var presentConfirmation = false
    @Published var showSheet = false
    @Published var showImageSelector = false
    @Published var shownImage: UIImage? = nil
    @Published var initialImage: UIImage? = nil
    @Published var showAlert = false
    @Published var toastConfiguration: AlertToast = AlertToast(type: .regular)
    @Published var isShowingFullScreenImage = false
    @Published var isBlurred = false
    @Published var showSpinner = false
    @Published var viewIDForReload: UUID = UUID()
    
    func onAppearAction() {
        initialImage = goal.loadImageIfPresent()
        shownImage = goal.loadImageIfPresent()
    }

    func goalDetailHeaderAction() {
        showImageSelector.toggle()
        showSpinner = true
    }
    
    func deleteGoalTapped() {
        presentConfirmation.toggle()
    }
    
    func doDeleteAction() {
        guard let context = user.managedObjectContext else {
            return
        }

        do {
            context.delete(goal)
            try context.save()
        } catch {
            print("Failed to delete")
        }

    }

    var blurRadius: CGFloat {
        isBlurred || showSpinner ? 10 : 0
    }
    
    func saveButtonAction() {
        if let shownImage {
            do {
                try goal.saveImage(image: shownImage)
                toastConfiguration = AlertToast(displayMode: .alert, type: .complete(settings.themeColor), title: "Saved successfully")
                showAlert = true
                viewIDForReload = UUID()

            } catch {
                toastConfiguration = AlertToast(displayMode: .alert, type: .error(settings.themeColor), title: "Failed to save image")
                showAlert = true
            }
        }
    }
    
}

// MARK: - Extra abandoned(?) code
//Section(header: Text("Image")) {
//    VStack {
//        viewModel.imageForImageSelector
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .cornerRadius(8)
//            .centerInParentView()
//            .onTapGesture(perform: viewModel.imageTapGestureAction)
//
//        HStack {
//            Button("Choose image") {
//                viewModel.showImageSelector = true
//            }
//            .buttonStyle(.borderedProminent)
//
//            if viewModel.shownImage != nil {
//                Button("Remove image", role: .destructive) {
//                    viewModel.shownImage = nil
//                }
//                .buttonStyle(.borderedProminent)
//            }
//        }
//    }
//    .frame(maxHeight: 250)
//}
//func imageTapGestureAction() {
//    if shownImage != nil {
//        withAnimation {
//            if shownImage != nil {
//                isShowingFullScreenImage = true
//                isBlurred = true
//            }
//        }
//    }
//    else {
//        viewModel.showImageSelector = true
//    }
//   
//}
//
//var imageForImageSelector: Image {
//    if let uiImage = shownImage {
//        Image(uiImage: uiImage)
//            
//    } else {
//        Image(systemName: "photo")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .foregroundColor(.gray)
//            .centerInParentView()
//            .onTapGesture {
//                
//            }
//    }
//}
