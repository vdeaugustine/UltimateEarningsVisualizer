// Disabled – environment key lives in `UltimateMoneyVisualizerApp.swift`
#if false
import SwiftUI

private struct DependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies = .shared
}

public extension EnvironmentValues {
    var dependencies: AppDependencies {
        get { self[DependenciesKey.self] }
        set { self[DependenciesKey.self] = newValue }
    }
}
#endif
