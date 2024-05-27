////
////  SavedDetailView.swift
////  UltimateMoneyVisualizer
////
////  Created by Vincent DeAugustine on 4/26/23.
////
//
import SwiftUI
import Vin

// MARK: - SavedDetailView

//
//// MARK: - SavedDetailView
//
// struct SavedDetailView: View {
//    @StateObject private var vm: SavedItemDetailViewModel
//
//    var body: some View {
//        VStack {
//            SavedDetailHeaderView(vm: <#T##SavedItemDetailViewModel#>, tappedImageAction: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        }
//    }
// }
//
//// MARK: - SavedDetailHeaderView
//
// struct SavedDetailHeaderView: View {
//    @ObservedObject var vm: SavedItemDetailViewModel
//
//    let tappedImageAction: (() -> Void)?
//    var tappedDateAction: (() -> Void)? = nil
//
//    var dueDateLineString: String {
//        vm.savedItem.getDate().getFormattedDate(format: .abbreviatedMonth)
//    }
//
//    var body: some View {
//        VStack {
//            DateCircle(date: vm.savedItem.getDate())
//                .aspectRatio(contentMode: .fill)
//                .clipShape(Circle())
//                .frame(width: 150, height: 150)
//                .overlayOnCircle(degrees: 37, widthHeight: 150) {
//                    Image(systemName: "pencil.circle.fill")
//                        .font(.largeTitle)
//                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                        .symbolRenderingMode(.multicolor)
//                        .foregroundStyle(User.main.getSettings().getDefaultGradient())
//                }
//                .onTapGesture {
//                    tappedImageAction?()
//                }
//                .frame(width: 150, height: 150)
//
//            VStack(spacing: 30) {
//                VStack {
//                    Text(vm.savedItem.getTitle())
//                        .font(.title)
//                        .fontWeight(.bold)
//
//                    if let info = vm.payoffItem.info {
//                        Text(info)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
////                Text(PayoffItem.amountMoneyStr)
////                    .boldNumber()
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
// }
//
//// MARK: - SavedDetailView_Previews
//
// struct SavedDetailView_Previews: PreviewProvider {
//    static let context = PersistenceController.context
//
//    static let saved: Saved = {
//        let saved = Saved(context: context)
//
//        saved.title = "Test saved"
//        saved.amount = 1_000
//        saved.info = "this is a test description"
//        saved.date = Date()
//
//        return saved
//    }()
//
//    static var previews: some View {
//        SavedDetailView(saved: User.main.getSaved().first!)
//            .putInNavView(.inline)
//            .environment(\.managedObjectContext, PersistenceController.context)
//    }
// }
struct SavedDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: SavedItemDetailViewModel
    @State private var showContributionsSheet = false

    init(saved: Saved) {
        _viewModel = StateObject(wrappedValue: SavedItemDetailViewModel(savedItem: saved))
    }

    var body: some View {
        ScrollView {
            VStack {
                headerPart

                HStack {
                    progressBox

                    VStack {
                        totalAmount
                        remainingPart
                    }
                }
                
                tagsSection
            }
            .padding()
        }
        
        .background(Color.secondarySystemBackground)
        .putInTemplate(title: "Saved Item")
    }

    var headerPart: some View {
        VStack {
            DateCircle(date: viewModel.savedItem.getDate(), height: 100)

            VStack(spacing: 10) {
                Text(viewModel.savedItem.getTitle())
                    .font(.title)
                    .fontWeight(.bold)

                if let info = viewModel.savedItem.info {
                    Text(info)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }

    var progressBox: some View {
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Spent")
                        .fontWeight(.semibold)
                    Text([viewModel.savedItem.getAllocations().count.str,
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
                        Text(viewModel.savedItem.totalAllocated.moneyExtended(decimalPlaces: 2))
                            .fontWeight(.semibold)
                            .font(.title2)
                            .minimumScaleFactor(0.90)

                        Divider()
                        HStack(alignment: .bottom) {
                            Text([(viewModel.savedItem.percentSpent * 100).simpleStr(), "%"])
                                .fontWeight(.semibold)
                                .layoutPriority(1)
                        }
                        .padding(.top, 5)
                    }
                }

                Text(viewModel.savedItem.totalAvailable.money() + " remaining")
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
    }

    var totalAmount: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.savedItem.getAmount().money())
                    .font(.title)
                    .boldNumber()

                Spacer()
            }
            .layoutPriority(0)

            VStack(alignment: .leading, spacing: 7) {
                Text("Total Amount")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxHeight: .infinity)
                    .layoutPriority(2)
                    .minimumScaleFactor(0.4)

//                HStack {
//                    Text(viewModel.user.convertMoneyToTime(money: viewModel.savedItem.amount).breakDownTime())
//                    Spacer()
                ////                    Text("work time")
//                }
//                .font(.subheadline)
//                .foregroundStyle(Color.gray)
//                .layoutPriority(1)
//                .minimumScaleFactor(0.85)
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

    var remainingPart: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                IconManager.savedIcon
                    .stroke(lineWidth: 1.5)
                    .frame(width: 35, height: 35)

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
            }
            .layoutPriority(0)
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.savedItem.getTags().count.str + " Instances")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .frame(maxHeight: .infinity)
                    .layoutPriority(2)
                    .minimumScaleFactor(0.4)

                HStack {
                    Text(viewModel.user.convertMoneyToTime(money: viewModel.totalAmount).breakDownTime() + " saved")
                    Spacer()
//                    Text(viewModel.user.convertMoneyToTime(money: viewModel.savedItem.totalAvailable).breakDownTime())
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
                    .frame(width: 50, height: 75 * (1 - viewModel.savedItem.percentSpent))
            }
        }
    }

    var tagsSection: some View {
        VStack(alignment: .leading) {
            HStack {
                //                VStack(alignment: .leading, spacing: 40) {
                header
                    //                }
                    .padding([.vertical, .leading], 17)
                Spacer()
                largePriceTag
                    .padding([.trailing, .top], 10)
            }
            .padding(.top)

            Divider()
                .padding(.top)

            LazyVStack(content: {
                ForEach(viewModel.savedItem.getTags()) { tag in
                    TagRow(tag: tag)

                        .padding(.vertical, 5)
                    Divider()
                }
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .createTagForSaved(viewModel.savedItem))
                } label: {
                    Label("New", systemImage: "plus")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/, maxHeight: 45, alignment: .leading)
                }

                .padding(.vertical)
                .padding(.leading, 4)
                .padding(.bottom, 4)
            })
            .padding(.horizontal)
        }

        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
        }
//        .sheet(isPresented: $viewModel.showTags, content: {
//            TagListForItemView(item: viewModel.payoffItem)
//        })

    }
    
    var header: some View {
        Text("Tags")
            .font(.title)
            .fontWeight(.semibold)
    }

    var largePriceTag: some View {
        PriceTag(width: 75,
                 height: 50,
                 color: viewModel.user.getSettings().themeColor,
                 holePunchColor: .white,
                 rotation: 200)
            .padding(.trailing, 10)
    }
}

// MARK: - SavedDetailView_Previews

struct SavedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SavedDetailView(saved: User.main.getSaved().first!)
            .putInNavView(.large)
    }
}
