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
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: GoalDetailViewModel

    init(goal: Goal) {
        _viewModel = StateObject(wrappedValue: GoalDetailViewModel(goal: goal))
    }

    var body: some View {
        ScrollView {
            VStack {
                GoalDetailHeaderView(goal: viewModel.goal,
                                     shownImage: viewModel.shownImage,
                                     tappedImageAction: viewModel.goalDetailHeaderAction)
                
                HStack {
                    GoalDetailProgressBox(viewModel: viewModel)
                    VStack {
                        GoalDetailDueDateBox(viewModel: viewModel)
                    }
                }
                
                GoalDetailTagsSection(viewModel: viewModel)

                Section(header: Text("Info")) {
                    Text("Amount")
                        .spacedOut {
                            Text(viewModel.goal.amount.formattedForMoney())
                                .fontWeight(.bold)
                                .foregroundStyle(viewModel.settings.getDefaultGradient())
                        }

                    if let dueDate = viewModel.goal.dueDate {
                        Text("Goal date")
                            .spacedOut(text: dueDate.getFormattedDate(format: .abreviatedMonth))
                    }

                    HStack(spacing: 5) {
                        Text(viewModel.goal.amount.formattedForMoney())
                            .fontWeight(.bold)
                            .foregroundStyle(viewModel.settings.getDefaultGradient())
                        Text("is equivalent to")
                        Spacer()
                        Text(viewModel.user.convertMoneyToTime(money: viewModel.goal.amount).formatForTime())
                    }
                }

                Section("Tags") {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.goal.getTags()) { tag in
                                    NavigationLink {
                                        TagDetailView(tag: tag)

                                    } label: {
                                        Text(tag.title ?? "NA")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .padding(.trailing, 10)
                                            .background {
                                                PriceTag(height: 30, color: tag.getColor(), holePunchColor: .listBackgroundColor)
                                            }
                                    }
                                }
                            }
                        }

                        NavigationLink {
                            CreateTagView(goal: viewModel.goal)
                        } label: {
                            Label("New Tag", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .padding(.top)
                    }
                    .listRowBackground(Color.listBackgroundColor)
                }

                Section(header: Text("Progress")) {
                    Text("Paid off")
                        .spacedOut(text: viewModel.goal.amountPaidOff.formattedForMoney())

                    Text("Remaining")
                        .spacedOut(text: viewModel.goal.amountRemainingToPayOff.formattedForMoney())
                }

                Section("Instances") {
                    ForEach(viewModel.user.getInstancesOf(goal: viewModel.goal)) { thisExpense in
                        if let date = thisExpense.dateCreated {
                            NavigationLink {
                                GoalDetailView(goal: thisExpense)
                            } label: {
                                Text(date.getFormattedDate(format: .abreviatedMonth))
                                    .spacedOut(text: thisExpense.amountMoneyStr)
                            }
                        }
                    }
                }

                // MARK: - Insight Section

                Section("Insight") {
                    Text("Time required to pay off")
                        .spacedOut(text: viewModel.goal.totalTimeRemaining.formatForTime([.day, .hour, .minute]))
                }

                Section(header: Text("Contributions")) {
                    ForEach(viewModel.goal.getAllocations()) { alloc in
                        if let shift = alloc.shift {
                            AllocShiftRow(shift: shift, allocation: alloc)
                        }
                        if let saved = alloc.savedItem {
                            AllocSavedRow(saved: saved, allocation: alloc)
                        }
                    }
                }

                Section {
                    Button("Delete goal",
                           role: .destructive,
                           action: viewModel.deleteGoalTapped)
                        .centerInParentView()
                        .listRowBackground(Color.clear)
                }
            }
            .padding()
        }
        
        .blur(radius: viewModel.blurRadius)
        .overlay {
            if viewModel.showSpinner {
                ProgressView()
            }
        }
        .overlay(fullScreenImage())
        .background(Color.listBackgroundColor)
        .confirmationDialog("Are you sure you want to delete this goal?", isPresented: $viewModel.presentConfirmation, titleVisibility: .visible, actions: {
            Button("Delete", role: .destructive, action: viewModel.doDeleteAction)
        }, message: {
            Text("This action cannot be undone")
        })
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
        .putInTemplate()
        .navigationTitle("Goal")
        .sheet(isPresented: $viewModel.showImageSelector) {
            if viewModel.shownImage != nil {
                viewModel.viewIDForReload = UUID()
            }
        } content: {
            ImagePicker(isShown: $viewModel.showImageSelector, image: $viewModel.shownImage)
                .onAppear {
                    viewModel.showSpinner = false
                }
        }
        .toolbar {
            if viewModel.initialImage != viewModel.shownImage {
                ToolbarItem {
                    Button("Save", action: viewModel.saveButtonAction)
                }
            }
        }
        .onAppear(perform: viewModel.onAppearAction)
        .toast(isPresenting: $viewModel.showAlert,
               duration: 2,
               tapToDismiss: false,
               offsetY: 40,
               alert: { viewModel.toastConfiguration })
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    func fullScreenImage() -> some View {
        VStack {
            if viewModel.isShowingFullScreenImage, let shownImage = viewModel.shownImage {
                Image(uiImage: shownImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        withAnimation {
                            viewModel.isShowingFullScreenImage = false
                            viewModel.isBlurred = false
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.7))
        .edgesIgnoringSafeArea(.all)
        .opacity(viewModel.isShowingFullScreenImage ? 1 : 0)
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
