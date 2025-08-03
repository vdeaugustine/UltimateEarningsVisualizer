# Project Organization Standards

## Current Issues
- Inconsistent naming conventions
- Confusing folder structure with cryptic names (`---Concatenate/`, `--TopLevel/`)
- Multiple deprecated folders creating confusion
- Business logic mixed with UI components
- Test files scattered throughout source code

## Improved Folder Structure

```
UltimateMoneyVisualizer/
├── App/                          # App lifecycle & configuration
│   ├── UltimateMoneyVisualizerApp.swift
│   ├── ContentView.swift
│   └── NavManager.swift
├── Core/                         # Core business logic & data
│   ├── Data/
│   │   ├── Models/              # Core Data model (.xcdatamodeld)
│   │   ├── Extensions/          # Core Data entity extensions
│   │   └── Persistence.swift
│   ├── Managers/                # System managers
│   │   ├── NotificationManager.swift
│   │   └── SubscriptionManager.swift
│   ├── Protocols/
│   │   └── PayoffItem.swift
│   └── Enums/
│       ├── WageType.swift
│       └── DayOfWeek.swift
├── Features/                     # Feature-based organization
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── HomeViewModel.swift
│   │   └── Components/
│   ├── TodayShift/
│   │   ├── TodayShiftView.swift
│   │   ├── TodayShiftViewModel.swift
│   │   └── Components/
│   ├── Shifts/
│   │   ├── ShiftListView.swift
│   │   ├── ShiftDetailView.swift
│   │   └── ShiftDetailViewModel.swift
│   ├── Expenses/
│   ├── Goals/
│   ├── Savings/
│   ├── PayoffQueue/
│   ├── TimeBlocks/
│   ├── Schedule/
│   ├── PayPeriods/
│   └── Settings/
├── Shared/                       # Reusable components
│   ├── Components/              # UI components used across features
│   │   ├── PayoffItemProgressBar.swift
│   │   ├── MoneyPicker.swift
│   │   └── CircleBadgeView.swift
│   ├── Extensions/              # Swift standard library extensions
│   │   ├── Date+Formatting.swift
│   │   ├── Color+Custom.swift
│   │   └── View+Modifiers.swift
│   ├── Modifiers/               # Custom view modifiers
│   │   └── ShadowForRect.swift
│   └── Utilities/               # Helper classes and functions
├── Resources/                    # Assets & configuration files
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── UltimateMoneyVisualizer.entitlements
├── Onboarding/                   # App onboarding flow
│   ├── WelcomeView.swift
│   ├── OnboardingFlow.swift
│   └── Components/
├── Testing/                      # Development testing views
│   ├── FigmaDesign.swift
│   ├── FontTester.swift
│   └── TestingCloudkit.swift
└── Legacy/                       # Deprecated code (temporary during migration)
    ├── DeprecatedViews/
    └── OldImplementations/
```

## File Naming Conventions

### Swift Files
- **Views**: `FeatureNameView.swift`
  - Examples: `ShiftDetailView.swift`, `ExpenseListView.swift`
- **ViewModels**: `FeatureNameViewModel.swift`
  - Examples: `ShiftDetailViewModel.swift`, `HomeViewModel.swift`
- **Extensions**: 
  - Core Data: `EntityName+Extensions.swift` (e.g., `Shift+Extensions.swift`)
  - Standard Library: `TypeName+Feature.swift` (e.g., `Date+Formatting.swift`)
- **Managers**: `FeatureManager.swift`
  - Examples: `NotificationManager.swift`, `SubscriptionManager.swift`
- **Protocols**: `ProtocolName.swift`
  - Examples: `PayoffItem.swift`, `Trackable.swift`
- **Enums**: `EnumName.swift`
  - Examples: `WageType.swift`, `DayOfWeek.swift`

### Folders
- Use **PascalCase**: `TimeBlocks/`, `PayoffQueue/`, `CoreData/`
- **Descriptive names**: `Components/` not `Comp/`, `Extensions/` not `Ext/`
- **No special characters**: Avoid `---`, `--`, spaces, or numbers
- **Plural for collections**: `Views/`, `Models/`, `Extensions/`

### Assets
- **Images**: lowercase with hyphens: `goal-jar.png`, `time-to-money.png`
- **Colors**: camelCase: `primaryText.colorset`, `backgroundLaunch.colorset`
- **Image sets**: descriptive names without abbreviations

## Migration Strategy

### Phase 1: Foundation (Week 1)
1. **Create new folder structure** in Xcode
2. **Move core files**:
   - App lifecycle files → `App/`
   - Core Data model and extensions → `Core/Data/`
   - Managers → `Core/Managers/`
   - Protocols and enums → `Core/`

### Phase 2: Features (Weeks 2-3)
1. **Migrate by feature**, starting with smallest:
   - Settings, Wage (simple)
   - Then: Home, TodayShift, Shifts (complex)
2. **Update imports** as files are moved
3. **Remove duplicates** and choose best implementation
4. **Test builds** after each feature migration

### Phase 3: Cleanup (Week 4)
1. **Move deprecated code** to `Legacy/` folder
2. **Clean up** any remaining inconsistencies
3. **Update documentation** and file references
4. **Remove Legacy folder** once all features verified

### Safety Measures
- Create **git branch** for reorganization work
- **Commit frequently** during migration
- **Test app builds** after major file moves
- Keep **Legacy folder** until all features are verified working
- **Update CLAUDE.md** with new structure once complete

## Benefits of New Organization

1. **Clear separation** of concerns (App, Core, Features, Shared)
2. **Feature-based organization** makes development more intuitive
3. **Consistent naming** reduces confusion and improves navigation
4. **Easier onboarding** for new developers
5. **Better maintainability** and code discoverability
6. **Reduced build times** through better dependency management
7. **Cleaner git history** with logical file groupings

## Implementation Notes

- Use Xcode's **"New Group"** feature to create folder structure
- **Drag and drop** files in Xcode to maintain project references
- **Update imports** in batches using find-and-replace
- **Test frequently** to catch broken references early
- **Document decisions** in commit messages for future reference