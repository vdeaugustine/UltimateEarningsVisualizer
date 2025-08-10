import SwiftUI

private struct DependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies = .shared
}

extension EnvironmentValues {
    var dependencies: AppDependencies {
        get { self[DependenciesKey.self] }
        set { self[DependenciesKey.self] = newValue }
    }
}
