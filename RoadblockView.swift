import SwiftUI

// MARK: - PremiumFeatureType

enum PremiumFeatureType {
    case yes
    case infinity
    case custom(AnyView)

    var view: AnyView {
        switch self {
            case .yes:
                return Image(systemName: "checkmark.circle.fill").foregroundStyle(.green).anyView
            case .infinity:
                return Image(systemName: "infinity").anyView
            case let .custom(customView):
                return customView
        }
    }
}

// MARK: - FeatureRow

struct FeatureRow {
    let featureName: String
    let freeFeature: AnyView
    let premiumFeature: PremiumFeatureType
}

// MARK: - RoadblockView

struct RoadblockView: View {
    @State private var marker: Double = 0.1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var viewFrame: CGRect = .zero

    let headerFeatureRow = FeatureRow(featureName: "Feature", freeFeature: Text("Free").anyView, premiumFeature: .custom(Text("Premium").anyView))
    let features: [FeatureRow] = [FeatureRow(featureName: "Unlimited shifts", freeFeature: Text("50").anyView, premiumFeature: .infinity),
                                  FeatureRow(featureName: "Expenses limit", freeFeature: Text("25").anyView, premiumFeature: .infinity),
                                  FeatureRow(featureName: "Goals limit", freeFeature: Text("25").anyView, premiumFeature: .infinity),
                                  FeatureRow(featureName: "Saved items limit", freeFeature: Text("25").anyView, premiumFeature: .infinity),
                                  FeatureRow(featureName: "Backup to iCloud", freeFeature: Image(systemName: "xmark").foregroundStyle(.red).anyView, premiumFeature: .yes),
                                  FeatureRow(featureName: "Customize theme", freeFeature: Image(systemName: "xmark").foregroundStyle(.red).anyView, premiumFeature: .yes),
                                  FeatureRow(featureName: "Support developer", freeFeature: Image(systemName: "xmark").foregroundStyle(.red).anyView, premiumFeature: .yes)]

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("treasure")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geo.size.width / 3 * 2)

                    UnlockPremiumHeader

//                    GroupBox {
                        VStack(spacing: 16) {
                            row(headerFeatureRow.featureName, font: .headline, free: headerFeatureRow.freeFeature, premium: headerFeatureRow.premiumFeature)

                            Divider()
                            ForEach(features, id: \.featureName) { feature in
                                row(feature.featureName, free: feature.freeFeature, premium: feature.premiumFeature)
                            }
                        }
                        .preference(key: PremiumKey.self, value: geo.frame(in: .global))
                        .frame(maxWidth: .infinity)
//                    }
//                    .modifier(ShadowForRect())
                        
                    .padding([.top, .horizontal], 20)
                    
                    

                    Spacer()

                    OnboardingButton(title: "Try one month free") {
                    }
                    .padding(.horizontal)
                }
                .frame(height: geo.size.height)
            }
        }
        .onReceive(timer) { _ in }
        .onPreferenceChange(PremiumKey.self) { value in
            print("Changed preference \(value)")
            viewFrame = value
        }
    }

    @ViewBuilder func row(_ text: String, font: Font? = nil, free: AnyView, premium: PremiumFeatureType) -> some View {
        HStack(spacing: 0) {
            Text(text)
                .font(font ?? .subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Group {
                free
                    .frame(width: viewFrame.width / 5)
                premium.view
                    .frame(width: viewFrame.width / 5)
            }
            .font(font ?? .subheadline)
        }
        .frame(maxWidth: .infinity)
    }

    var UnlockPremiumHeader: some View {
        HStack {
            Image(systemName: "crown.fill").foregroundStyle(Color.yellow)
            Text("Unlock Premium!")
        }
        .font(.system(.title, weight: .semibold))
    }

    var TryItFree: some View {
        VStack {
            Text("Try it free for one week")
        }
    }

    struct PremiumKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }
}

extension View {
    var anyView: AnyView {
        AnyView(self)
    }
}

#Preview {
    RoadblockView()
}
