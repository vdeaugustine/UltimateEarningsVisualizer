# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UltimateEarningsVisualizer (also known as UltimateMoneyVisualizer) is an iOS app built with SwiftUI that helps users track earnings, expenses, and financial goals through detailed shift tracking and visualization features.

## Development Commands

```bash
# Build the project
xcodebuild -project UltimateMoneyVisualizer.xcodeproj -scheme UltimateMoneyVisualizer build

# Run tests
xcodebuild test -project UltimateMoneyVisualizer.xcodeproj -scheme UltimateMoneyVisualizer

# Clean build
xcodebuild clean -project UltimateMoneyVisualizer.xcodeproj -scheme UltimateMoneyVisualizer

# Archive for release
xcodebuild archive -project UltimateMoneyVisualizer.xcodeproj -scheme UltimateMoneyVisualizer
```

Note: For development, use Xcode directly. These commands are useful for CI/CD or command-line builds.

## Architecture Overview

### Navigation Architecture
- Tab-based navigation managed by `NavManager` singleton (UltimateMoneyVisualizer/--TopLevel/ContentView/NavManager.swift)
- Four main tabs: Home, All Items, Today, Settings
- Each tab has its own navigation stack
- Sheet presentations handled through `NavManager` properties

### Data Architecture
- **Core Data with CloudKit** for persistence and sync
- `PersistenceController` (UltimateMoneyVisualizer/--TopLevel/ContentView/Persistence.swift) manages the Core Data stack
- Entities are extended with computed properties and methods in `/Core Data/Extensions/`
- Key entities: User, Shift, Expense, Goal, Saved, PayPeriod, TimeBlock, Allocation

### View Architecture
- Views follow SwiftUI patterns with @StateObject/@ObservedObject for state management
- Complex views are broken down into smaller components in `Components/` folder
- Feature-specific views organized by domain (Expenses/, Goals/, Shifts/, etc.)
- Shared UI components like buttons, cards, and lists in dedicated component folders

### Key Design Patterns
1. **Singleton Navigation**: `NavManager` provides centralized navigation state
2. **Core Data Extensions**: Business logic lives in entity extensions, not in views
3. **Environment Objects**: Core Data context and user settings passed via environment
4. **Computed Properties**: Extensive use of computed properties on Core Data entities for derived values
5. **Protocol-Oriented**: Many views conform to common protocols for consistent behavior

## Important Architectural Decisions

1. **Pay Period System**: The app revolves around pay periods that determine how shifts, expenses, and allocations are grouped
2. **Allocation Engine**: Complex allocation system that distributes earnings across expenses and goals based on priorities
3. **Real-time Tracking**: "Today" view provides live tracking of ongoing shifts with automatic calculations
4. **Goal Types**: Different goal types (date-based vs amount-based) with different calculation logic
5. **Time Block System**: Shifts can be broken into time blocks for detailed tracking

## Testing Approach

- Unit tests focus on data model logic, date calculations, and business rules
- Test files mirror the structure of source files (e.g., `ExpenseTests.swift` tests `Expense` extensions)
- Run specific tests in Xcode using the Test Navigator (⌘5)

## Common Development Tasks

When modifying earnings calculations:
1. Check `Shift` and `TimeBlock` extensions for calculation logic
2. Verify `PayPeriod` calculations that aggregate shift data
3. Test allocation logic in `Allocation` extensions

When working on UI:
1. Check existing components in `Components/` before creating new ones
2. Follow the established pattern of breaking complex views into smaller components
3. Use the custom button styles and card components for consistency

When adding new features:
1. Create Core Data entities if needed
2. Add business logic as extensions on the entities
3. Create views in appropriate feature folders
4. Update `NavManager` if new navigation paths are needed

## Dependencies

Managed via Swift Package Manager in Xcode:
- AlertToast: Toast notifications
- ConfettiSwiftUI: Celebration animations
- FloatingButton: FAB components
- PopupView: Modal presentations
- ScalingHeaderScrollView: Scrolling effects
- VinPackage: Custom utility package
- Welcome-Sheet: Onboarding flows