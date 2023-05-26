//
//  GoalDetailView.swift
//  UltimateGoalVisualizer
//
//  Created by ChatGPT on 4/26/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - GoalDetailView

struct GoalDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()
    let goal: Goal
    @Environment(\.dismiss) private var dismiss
    
    @State private var presentConfirmation = false
    @State private var showSheet = false
    @State private var showImageSelector = false
    @State private var shownImage: UIImage? = nil
    @State private var initialImage: UIImage? = nil
    @State private var showAlert = false
    @State private var toastConfiguration: AlertToast = AlertToast(type: .regular)
    @State private var isShowingFullScreenImage = false
    @State private var isBlurred = false
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Info")) {
                    Text("Amount")
                        .spacedOut {
                            Text(goal.amount.formattedForMoney())
                                .fontWeight(.bold)
                                .foregroundStyle(settings.getDefaultGradient())
                        }
                    
                    if let dueDate = goal.dueDate {
                        Text("Goal date")
                            .spacedOut(text: dueDate.getFormattedDate(format: .abreviatedMonth))
                    }
                    
                    HStack(spacing: 5) {
                        Text(goal.amount.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(settings.getDefaultGradient())
                        Text("is equivalent to")
                        Spacer()
                        Text(user.convertMoneyToTime(money: goal.amount).formatForTime())
                    }
                }
                
                Section("Tags") {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            NavigationLink {
                            }
                        label: {
                            
                            
                            
                            Label("New Tag", systemImage: "plus")
//                                .foregroundColor(.white)
//                                .padding(.trailing, 10)
//                                .background {
//                                    PriceTag(height: 30, color: settings.themeColor, holePunchColor: .listBackgroundColor)
//                                }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                            
                            ForEach(goal.getTags()) { tag in
                                Text(tag.title ?? "NA")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .padding(.trailing, 10)
                                    .background {
                                        PriceTag(height: 30, color: settings.themeColor, holePunchColor: .listBackgroundColor)
                                    }
                            }
                        }
                    }
                    .listRowBackground(Color.listBackgroundColor)
                }
                
                Section(header: Text("Progress")) {
                    Text("Paid off")
                        .spacedOut(text: goal.amountPaidOff.formattedForMoney())
                    
                    Text("Remaining")
                        .spacedOut(text: goal.amountRemainingToPayOff.formattedForMoney())
                }
                
                // MARK: - Insight Section
                
                Section("Insight") {
                    Text("Time required to pay off")
                        .spacedOut(text: goal.totalTimeRemaining.formatForTime([.day, .hour, .minute]))
                }
                
                Section(header: Text("Contributions")) {
                    ForEach(goal.getAllocations()) { alloc in
                        if let shift = alloc.shift {
                            AllocShiftRow(shift: shift, allocation: alloc)
                        }
                        
                        if let saved = alloc.savedItem {
                            AllocSavedRow(saved: saved, allocation: alloc)
                        }
                    }
                }
                
                Section(header: Text("Image")) {
                    VStack {
                        if let uiImage = shownImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(8)
                                .centerInParentView()
                                .onTapGesture {
                                    withAnimation {
                                        if self.shownImage != nil {
                                            self.isShowingFullScreenImage = true
                                            self.isBlurred = true
                                        }
                                    }
                                }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .centerInParentView()
                                .onTapGesture {
                                    showImageSelector = true
                                }
                        }
                        
                        HStack {
                            Button("Choose image") {
                                showImageSelector = true
                            }
                            .buttonStyle(.borderedProminent)
                            
                            if shownImage != nil {
                                Button("Remove image", role: .destructive) {
                                    shownImage = nil
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .frame(maxHeight: 250)
                }
                
                Section {
                    Button("Delete goal", role: .destructive) {
                        presentConfirmation.toggle()
                    }
                    .centerInParentView()
                    .listRowBackground(Color.clear)
                }
            }
        }
        .blur(radius: isBlurred ? 10 : 0)
        .overlay(
            VStack {
                if isShowingFullScreenImage, let shownImage = shownImage {
                    Image(uiImage: shownImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onTapGesture {
                            withAnimation {
                                self.isShowingFullScreenImage = false
                                self.isBlurred = false
                            }
                        }
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.7))
                .edgesIgnoringSafeArea(.all)
                .opacity(isShowingFullScreenImage ? 1 : 0)
        )
        .background(Color.targetGray)
        .confirmationDialog("Are you sure you want to delete this goal?", isPresented: $presentConfirmation, titleVisibility: .visible, actions: {
            Button("Delete", role: .destructive) {
                guard let context = user.managedObjectContext else {
                    return
                }
                
                do {
                    context.delete(goal)
                    try context.save()
                } catch {
                    print("Failed to delete")
                }
                
                dismiss()
            }
        }, message: {
            Text("This action cannot be undone")
        })
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        .putInTemplate()
        .navigationTitle(goal.titleStr)
        .sheet(isPresented: $showImageSelector) {
            ImagePicker(isShown: self.$showImageSelector, image: self.$shownImage)
        }
        .toolbar {
            if initialImage != shownImage, let shownImage {
                ToolbarItem {
                    Button("Save") {
                        do {
                            try goal.saveImage(image: shownImage)
                            try user.managedObjectContext!.save()
                            toastConfiguration = AlertToast(displayMode: .alert, type: .complete(settings.themeColor), title: "Saved successfully")
                            showAlert = true
                            
                            let dummyGoalForUpdate = try Goal(title: "", info: nil, amount: 124, dueDate: nil, user: user, context: viewContext)
                            viewContext.delete(dummyGoalForUpdate)
                            try viewContext.save()
                            
                        } catch {
                            toastConfiguration = AlertToast(displayMode: .alert, type: .error(settings.themeColor), title: "Failed to save image")
                            showAlert = true
                        }
                    }
                }
            }
        }
        .onAppear {
            initialImage = goal.loadImageIfPresent()
            shownImage = goal.loadImageIfPresent()
        }
        .toast(isPresenting: $showAlert, duration: 2, tapToDismiss: false, offsetY: 40, alert: { toastConfiguration })
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - ImagePicker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var isShown: Bool
        @Binding var image: UIImage?
        
        init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
            _isShown = isShown
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.image = image
            isShown = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }
    }
}

// MARK: - ImageContentView

struct ImageContentView: View {
    @State private var isShown = false
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Select an image")
            }
            Button("Select Image") {
                self.isShown = true
            }
        }
        .sheet(isPresented: $isShown, onDismiss: saveImage) {
            ImagePicker(isShown: self.$isShown, image: self.$image)
        }
    }
    
    func saveImage() {
    }
}

// MARK: - ChooseImageView

struct ChooseImageView: View {
    var body: some View {
        ImageContentView()
    }
}

// MARK: - GoalDetailView_Previews

struct GoalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GoalDetailView(goal: User.main.getGoals().first!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
