import SwiftUI

struct MoneyPicker: View {
    @Binding var amount: Double
    let lowerBound: Double?
    let upperBound: Double?
    let step: Double

    private var dollars: [Int] {
        let minDollars = Int(lowerBound ?? 0)
        let maxDollars = Int(upperBound ?? 10_000)
        return Array(minDollars...maxDollars)
    }

    private var cents: [Int] {
        return Array(0...99)
    }

    private var stepCents: [Int] {
        let stepInt = Int(step * 100)
        return stride(from: 0, to: 100, by: stepInt).map { $0 }
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Picker("", selection: $amount.dollars) {
                    ForEach(dollars, id: \.self) { dollar in
                        Text("\(dollar)").tag(dollar)
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.4)
                .pickerStyle(.wheel)

                Text(".")

                Picker("", selection: $amount.firstDecimal) {
                    ForEach(stepCents, id: \.self) { cent in
                        Text("\(cent)").tag(cent)
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.3)

                Picker("", selection: $amount.secondDecimal) {
                    ForEach(stepCents, id: \.self) { cent in
                        Text("\(cent)").tag(cent)
                    }
                }
                .frame(maxWidth: geometry.size.width * 0.3)
            }
            .pickerStyle(.wheel)
        }
    }
}

private extension Binding where Value == Double {
    var dollars: Binding<Int> {
        Binding<Int>(
            get: { Int(wrappedValue) },
            set: { newValue in
                wrappedValue = Double(newValue) + (wrappedValue.truncatingRemainder(dividingBy: 1))
            }
        )
    }

    var firstDecimal: Binding<Int> {
        Binding<Int>(
            get: { Int(wrappedValue * 10) % 10 },
            set: { newValue in
                let dollarsValue = floor(wrappedValue)
                let secondDecimalValue = Double(Int(wrappedValue * 100) % 10) / 100
                let newValueInDimes = Double(newValue) / 10
                let newAmount = dollarsValue + newValueInDimes + secondDecimalValue
                wrappedValue = newAmount
            }
        )
    }

    var secondDecimal: Binding<Int> {
        Binding<Int>(
            get: { Int(wrappedValue * 100) % 10 },
            set: { newValue in
                let dollarsValue = floor(wrappedValue)
                let firstDecimalValue = Double(Int(wrappedValue * 10) % 10) / 10
                let newValueInCents = Double(newValue) / 100
                let newAmount = dollarsValue + firstDecimalValue + newValueInCents
                wrappedValue = newAmount
            }
        )
    }


}

struct MoneyPicker_Previews: PreviewProvider {
    static var previews: some View {
        MoneyPicker(amount: .constant(0), lowerBound: 0, upperBound: 5000, step: 0.01)
    }
}

