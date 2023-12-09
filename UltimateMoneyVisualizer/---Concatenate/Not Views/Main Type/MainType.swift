import Foundation

enum MainType: String, CaseIterable, Hashable, Identifiable, CustomStringConvertible {

    case shift, expense, goal, saved
    case timeBlock = "Time Block"
    
    var sub: SubType {
        switch self {
            case .shift, .saved:
                return .earned
            case .expense, .goal:
                return .payoff
            default:
                return .other
        }
    }
    
    // MARK: Initializers for convenience 
    init(_ payoff: PayoffItem) {
        if payoff is Goal {
            self = .goal
        }
        self = .expense
    }
    
    init(_ shift: Shift) { self = .shift }
    init(_ saved: Saved) { self = .saved }
    init (_ timeBlock: TimeBlock) { self = .timeBlock }
    
    //MARK: Protocol conformances
    var id: Self { self }
    var description: String { self.rawValue.capitalized }

}

enum SubType: String, CaseIterable, Hashable, Identifiable, CustomStringConvertible {
    
    case earned, payoff, other
    
    
    //MARK: Protocol conformances
    var id: Self { self }
    var description: String { self.rawValue.capitalized }
    
}
