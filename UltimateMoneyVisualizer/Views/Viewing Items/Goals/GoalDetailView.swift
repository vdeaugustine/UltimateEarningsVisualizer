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
        ScrollViewReader { _ in
            ScrollView {
                VStack {
                    GoalDetailHeaderView(goal: viewModel.goal,
                                         shownImage: viewModel.shownImage,
                                         tappedImageAction: viewModel.goalDetailHeaderAction)
                    .padding(.bottom)

                    HStack {
                        GoalDetailProgressBox(viewModel: viewModel)
                        VStack {
                            GoalDetailTotalAmount(viewModel: viewModel)
                            GoalDetailDueDateBox(viewModel: viewModel)
                        }
                    }

                    GoalDetailTagsSection(viewModel: viewModel)

                    GoalDetailContributionsSection(viewModel: viewModel)
                }
                .padding()

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
        }
        .background(Color.listBackgroundColor)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
//                    showDeleteConfirmation.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
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
