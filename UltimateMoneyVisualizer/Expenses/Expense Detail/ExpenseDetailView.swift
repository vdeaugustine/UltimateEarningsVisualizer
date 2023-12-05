//
//  ExpenseDetailView.swift
//  UltimateExpenseVisualizer
//
//  Created by ChatGPT on 4/26/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - ExpenseDetailView

struct ExpenseDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: ExpenseDetailViewModel
    @State private var showDeleteConfirmation = false

    init(expense: Expense) {
        _viewModel = StateObject(wrappedValue: ExpenseDetailViewModel(expense: expense))
    }

    var body: some View {
        ScrollView {
            VStack {
                ExpenseDetailHeaderView(expense: viewModel.expense,
                                        shownImage: viewModel.shownImage,
                                        tappedImageAction: viewModel.expenseDetailHeaderAction)
                    .padding(.bottom)

                HStack {
                    ExpenseDetailProgressBox(viewModel: viewModel)
                    VStack {
                        ExpenseDetailTotalAmount(viewModel: viewModel)
                        ExpenseDetailDueDateBox(viewModel: viewModel)
                    }
                }

                ExpenseDetailTagsSection(viewModel: viewModel)

                ExpenseDetailContributionsSection(viewModel: viewModel)

                Spacer()
                    .frame(height: 40)

//                Button("Delete", role: .destructive) {
//
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
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
            .confirmationDialog("Are you sure you want to delete this expense?", isPresented: $viewModel.presentConfirmation, titleVisibility: .visible, actions: {
                Button("Delete", role: .destructive, action: viewModel.doDeleteAction)
            }, message: {
                Text("This action cannot be undone")
            })
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .putInTemplate()
            .navigationTitle("Expense")
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

        .background(Color.listBackgroundColor)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteConfirmation.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .confirmationDialog("Delete Expense", isPresented: $showDeleteConfirmation, titleVisibility: .visible, actions: {
            Button("Delete", role: .destructive) {
                viewContext.delete(viewModel.expense)
                do {
                    try viewContext.save()

                } catch {
                    // TODO: Add an alert and show error
                    print("error deleting")
//                    showErrorAlert.toggle()
                }

                dismiss()
            }
        }, message: {
            Text("This action cannot be undone.")
        })
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

// MARK: - ExpenseDetailHeaderView

struct ExpenseDetailHeaderView: View {
    @ObservedObject var expense: Expense
    let shownImage: UIImage?
    let tappedImageAction: (() -> Void)?
    var tappedDateAction: (() -> Void)? = nil

    var dueDateLineString: String {
        if let dueDate = expense.dueDate {
            return dueDate.getFormattedDate(format: .abbreviatedMonth)
        } else {
            return "Set a due date"
        }
    }

    var image: Image {
        if let shownImage {
            return Image(uiImage: shownImage)
        } else if let image = expense.loadImageIfPresent() {
            return Image(uiImage: image)
        } else {
            return Image("dollar3d")
        }
    }

    var body: some View {
        VStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 150, height: 150)
                .overlayOnCircle(degrees: 37, widthHeight: 150) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.largeTitle)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(User.main.getSettings().getDefaultGradient())
                }
                .onTapGesture {
                    tappedImageAction?()
                }
                .frame(width: 150, height: 150)

            VStack(spacing: 30) {
                VStack {
                    Text(expense.titleStr)
                        .font(.title)
                        .fontWeight(.bold)

                    if let info = expense.info {
                        Text(info)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
//                Text(expense.amountMoneyStr)
//                    .boldNumber()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - ExpenseDetailProgressBox

struct ExpenseDetailProgressBox: View {
    @ObservedObject var viewModel: ExpenseDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Progress")
                        .fontWeight(.semibold)
                    Text([viewModel.expense.getAllocations().count.str,
                          "contributions"])
                        .font(.caption2)
                        .foregroundStyle(Color.gray)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }

            VStack(alignment: .leading, spacing: 35) {
                HStack {
                    batteryImage

                    VStack(alignment: .center) {
                        Text(viewModel.expense.amountPaidOff.moneyExtended(decimalPlaces: 2))
                            .fontWeight(.semibold)
                            .font(.title2)
                            .minimumScaleFactor(0.90)

                        Divider()
                        HStack(alignment: .bottom) {
                            Text([(viewModel.expense.percentPaidOff * 100).simpleStr(), "%"])
                                .fontWeight(.semibold)
                                .layoutPriority(1)
                        }
                        .padding(.top, 5)
                    }
                }

                Text(viewModel.expense.amountRemainingToPayOff.money() + " remaining")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
        .frame(minWidth: 175)
        .frame(minHeight: 225, maxHeight: .infinity)
        .onTapGesture {
            NavManager.shared.appendCorrectPath(newValue: .expenseContributions(viewModel.expense))
        }
    }

    var batteryImage: some View {
        VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "E7E7E7"))
                .frame(width: 35, height: 7)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "E7E7E7"))
                    .frame(width: 50, height: 75)

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "389975"))
                    .frame(width: 50, height: 75 * viewModel.expense.percentPaidOff)
            }
        }
    }
}

// MARK: - ExpenseDetailTotalAmount

struct ExpenseDetailTotalAmount: View {
    @ObservedObject var viewModel: ExpenseDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.expense.amountMoneyStr)
                    .font(.title)
                    .boldNumber()

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }
            .layoutPriority(0)
            VStack(alignment: .leading, spacing: 7) {
                Text("Total Amount")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxHeight: .infinity)
                    .layoutPriority(2)
                    .minimumScaleFactor(0.4)

                HStack {
                    Text(viewModel.user.convertMoneyToTime(money: viewModel.expense.amount).breakDownTime())
                    Spacer()
//                    Text("work time")
                }
                .font(.subheadline)
                .foregroundStyle(Color.gray)
                .layoutPriority(1)
                .minimumScaleFactor(0.85)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
        .frame(minWidth: 175)
        .frame(height: 120)
    }
}

// MARK: - ExpenseDetailDueDateBox

struct ExpenseDetailDueDateBox: View {
    @ObservedObject var viewModel: ExpenseDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "hourglass")
                    .font(.title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }
            .layoutPriority(0)
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.breakDownTime())
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxHeight: .infinity)
                    .layoutPriority(2)
                    .minimumScaleFactor(0.4)

                HStack {
                    if let dueDate = viewModel.expense.dueDate {
                        Text("Remaining")
                        Spacer()
                        Text(dueDate.getFormattedDate(format: .slashDate))
                    } else {
                        Text("Set due date")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.gray)
                .layoutPriority(1)
                .minimumScaleFactor(0.85)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
        .frame(minWidth: 175)
        .frame(height: 120)
    }
}

// MARK: - ExpenseDetailTagsSection

struct ExpenseDetailTagsSection: View {
    @ObservedObject var viewModel: ExpenseDetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 40) {
                    header
                    buttonsPart
                }
                .padding([.vertical, .leading], 17)
                Spacer()
                largePriceTag
//                        .frame(maxHeight: .infinity)
                    .padding(.trailing, 10)
            }

            if viewModel.showTags {
                Spacer()
                tagsPart
            }
        }

        .frame(height: viewModel.tagsRectHeight)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
                .overlay {
                    backDrop
                }
        }
    }

    var backDrop: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        }
    }

    var header: some View {
        Text("Tags")
            .font(.title)
            .fontWeight(.semibold)
    }

    var tagsPart: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(viewModel.expense.getTags(), id: \.self) { tag in
                    if let title = tag.title {
                        VStack {
                            Text(title)
                                .foregroundStyle(Color.white)
                                .padding(5)
                                .padding(.trailing)
                                .background {
                                    PriceTag(width: nil,
                                             height: 30,
                                             color: tag.getColor(),
                                             holePunchColor: .white,
                                             rotation: 0)
                                }
                        }
                        .frame(height: 100) // Adjust the height as needed
                    }
                }
            }
        }
        .padding(.bottom)
        .frame(maxHeight: viewModel.tagsRectIncreaseAmount - 10)
//        List {
//            ForEach(viewModel.expense.getTags(), id: \.self) { tag in
//                if let title = tag.title {
//                    Text(title)
//                        .foregroundStyle(Color.white)
//                        .padding(5)
//                        .padding(.trailing)
//                        .background {
//                            PriceTag(width: nil,
//                                     height: 30,
//                                     color: tag.getColor(),
//                                     holePunchColor: .white,
//                                     rotation: 0)
//                        }
//                }
//            }
        ////            .listRowSeparator(.hidden)
//        }
//        .padding(.bottom)
//        .listStyle(.plain)
//        .frame(maxHeight: viewModel.tagsRectIncreaseAmount - 10)
    }

    @ViewBuilder var buttonsPart: some View {
        HStack {
            showHideButton
            addNewTagButton
        }
    }

    @ViewBuilder var showHideButton: some View {
        PayoffItemDetailViewStyledButton(text: viewModel.tagsButtonText,
                                         width: 100,
                                         animationValue: viewModel.showTags,
                                         action: viewModel.tagsButtonAction)
    }

    @ViewBuilder var addNewTagButton: some View {
        PayoffItemDetailViewStyledButton(text: "New",
                                         width: 100,
                                         animationValue: viewModel.showTags) {
            print("NEW Tapped")
        }
    }

    @ViewBuilder var largePriceTag: some View {
        PriceTag(width: 75,
                 height: 50,
                 color: viewModel.user.getSettings().themeColor,
                 holePunchColor: .white,
                 rotation: 200)
            .padding(.trailing, 10)
    }
}

// MARK: - ExpenseDetailContributionsSection

struct ExpenseDetailContributionsSection: View {
    @ObservedObject var viewModel: ExpenseDetailViewModel

    @ViewBuilder var body: some View {
        VStack {
            mainRect

            Spacer()

            if viewModel.showContributions {
                shiftsPart
            }
        }
        .frame(height: viewModel.contributionsRectHeight)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
    }

    var mainRect: some View {
        HStack {
            VStack(alignment: .leading, spacing: 40) {
                header
                showHideButton
            }
            .padding(.vertical)
            Spacer()

            calendarIcon
        }
        .padding(.horizontal, 20)
    }

    var shiftsPart: some View {
        List {
            ForEach(viewModel.expense.getAllocations()) { alloc in

                if let shift = alloc.shift {
                    AllocShiftRow(shift: shift, allocation: alloc)
                }

                if let saved = alloc.savedItem {
                    AllocSavedRow(saved: saved, allocation: alloc)
                }
            }
        }
        .padding(.bottom)
        .listStyle(.plain)
        .frame(maxHeight: viewModel.contributionsRectIncreaseAmount - 10)
    }

    var header: some View {
        VStack {
            Text("Contributions")
                .font(.title)
                .fontWeight(.semibold)
        }
        .padding(.top, 10)
    }

    var showHideButton: some View {
        PayoffItemDetailViewStyledButton(text: viewModel.contributionsButtonText,
                                         animationValue: viewModel.showContributions,
                                         action: viewModel.contributionsButtonAction)
    }

    var calendarIcon: some View {
        Image(systemName: "tray.and.arrow.down.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 70)
            .foregroundStyle(viewModel.settings.getDefaultGradient())
    }

    func shiftRow(_ shift: Shift) -> some View {
        HStack {
            Text(shift.start.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(viewModel.settings.getDefaultGradient())
                .cornerRadius(8)
        }
        .padding()
        .background {
            Capsule(style: .circular)
                .fill(Color.targetGray)
        }
    }
}

// MARK: - ExpenseDetailView_Previews

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailView(expense: User.main.getExpenses().first!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
