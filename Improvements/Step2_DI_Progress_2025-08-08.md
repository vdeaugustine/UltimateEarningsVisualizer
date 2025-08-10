# Step 2 – Dependency Injection Progress & Next Actions (2025-08-08)

This document tracks what changed today and what to do next for the Step 2 DI and Repository rollout.

## Summary

- Replaced Home feature singletons with DI-backed instances.
- Routed Home navigation via `NavigationCoordinating` (DI) while keeping the central Nav factory temporarily.
- Cleaned up previews to construct fresh `NewHomeViewModel()` rather than `.shared`.
- Enabled standalone DI files and removed embedded definitions from the app entry.

## Changes Completed (Today)

- NewHome container now owns a fresh VM and propagates it via EnvironmentObject:
  - `UltimateMoneyVisualizer/NewHomeView/Main Container/NewHomeView.swift`
    - `@StateObject private var vm = NewHomeViewModel()`
    - Navigation: `vm.navigator.push(...)` for in-Home actions.
    - Keeps `.navigationDestination` using `NavManager.shared.getDestinationViewForStack(...)` for now.
    - Ensures `.environmentObject(vm)` reaches all subviews/overlays.
- Home subviews route through DI navigator and no longer reference singletons:

  - `.../NewHomeView/Content/Totals Section/Header/TodayViewTotalsHeaderView.swift`
    - `vm.navigator.push(.stats)`
  - `.../NewHomeView/Content/Totals Section/Content/HomeViewTotalsContent.swift`
    - Preview injects `NewHomeViewModel()`
  - `.../NewHomeView/Content/Time Blocks/TopTimeBlocks_HomeView.swift`
    - `vm.navigator.push(.allTimeBlocks/.condensedTimeBlock)` + preview inject
  - `.../NewHomeView/Content/Wage Breakdown/WageBreakdown_HomeView.swift`
    - `vm.navigator.push(.wage)` + preview inject
  - `.../NewHomeView/Content/Payoff Queue/PayoffQueueView_HomeView.swift`
    - `vm.navigator.push(.oldPayoffQueue)` + preview inject
  - `.../NewHomeView/Components/FloatingPlusButton.swift`
    - Added `@EnvironmentObject var vm: NewHomeViewModel`
    - Menu actions use `vm.navigator.push(.createExpense/.createGoal/.createSaved/.createShift)`
    - Converted static lets → computed vars to capture navigator
    - Preview injects `NewHomeViewModel()`

- Stats feature moved to DI (no singleton):

  - `UltimateMoneyVisualizer/Stats/StatsViewModel.swift`
    - Removed `static var shared`
    - VM initializes via `init(deps: AppDependencies = .shared)` and uses `deps.navigator` + `deps.earningsRepository`
  - `UltimateMoneyVisualizer/Stats/StatsView.swift`
    - `@StateObject private var vm = StatsViewModel()`
    - `onAppear { vm.refresh() }`

- Replaced direct NavManager calls with DI navigator:

  - `UltimateMoneyVisualizer/Settings/SettingsView.swift`
    - Added `@Environment(\.dependencies) var deps`
    - Replaced `.appendCorrectPath(...)` with `deps.navigator.push(...)`
    - Updated nested `TutorialsSection` similarly
  - `UltimateMoneyVisualizer/All Items View/Lists/SavedListView.swift`
    - Added `deps` and used `deps.navigator.push(.saved/.createSaved)`
  - `UltimateMoneyVisualizer/All Items View/Lists/PayoffItemListView.swift`
    - Added `deps` and used `deps.navigator.push(.goal/.expense/.createGoal/.createExpense)`
  - `UltimateMoneyVisualizer/Views/Components/WageBreakdownBox.swift`
    - Added `deps` and used `deps.navigator.push(.enterWage)`

- Convert more screens to DI navigator (batch 2):
  - `UltimateMoneyVisualizer/Wage/WageView.swift`
    - Toolbar Edit -> `deps.navigator.push(.enterWage)`
  - `UltimateMoneyVisualizer/Views/Components/ItemizedPartOfShiftView.swift`
    - Replaced `navManager.appendCorrectPath` with `deps.navigator.push` for time block actions
  - `UltimateMoneyVisualizer/Time Blocks/AllTimeBlocksView.swift`
    - Tap row -> `deps.navigator.push(.timeBlockDetail)`
  - `UltimateMoneyVisualizer/Time Blocks/CondensedTimeBlockVIew.swift`
    - Tap row -> `deps.navigator.push(.timeBlockDetail)`
  - `UltimateMoneyVisualizer/Tag/TagListForItemView.swift`
    - View/New -> `deps.navigator.push(.tagDetail/.createTag)`
  - `UltimateMoneyVisualizer/Tag/TagDetailView.swift`
    - Navigate to goal/expense/saved via `deps.navigator.push`
  - `UltimateMoneyVisualizer/Shifts/ShiftDetailView.swift`
    - Allocation taps -> `deps.navigator.push(.allocationDetail)`
  - `UltimateMoneyVisualizer/Schedule/RegularScheduleView.swift`
    - Add/Edit -> `deps.navigator.push(.selectDaysView)`
  - `UltimateMoneyVisualizer/Saved/SavedDetailView.swift`
    - New Tag -> `deps.navigator.push(.createTagForSaved)`
  - `UltimateMoneyVisualizer/Payoff Queue/PayoffQueueView.swift`
    - Tap queue items -> `deps.navigator.push(.expense/.goal)`
  - `UltimateMoneyVisualizer/Payoff Item/Detail View/Main Container/PayoffItemDetailView.swift`
    - Contributions/Edit -> `deps.navigator.push(...)`
  - `UltimateMoneyVisualizer/Payoff Item/Detail View/.../PayoffItemDetailTagsSection.swift`
    - View/New tag -> `deps.navigator.push(...)`
  - `UltimateMoneyVisualizer/Payoff Item/Contributions/PayoffContributionsView.swift`
    - Navigate to shift/saved/assign -> `deps.navigator.push(...)`
  - `UltimateMoneyVisualizer/Pay Period/Detail View/PayPeriodDetailView.swift`
    - Shift tap -> `deps.navigator.push(.shift)`
  - `UltimateMoneyVisualizer/Pay Period/All Periods List/PayPeriodRow.swift`
    - Row tap -> `deps.navigator.push(.payPeriodDetail)`
  - `UltimateMoneyVisualizer/Pay Period/All Periods List/AllPayPeriodsView.swift`
    - Settings/Row tap -> `deps.navigator.push(...)`

## Current DI Baseline

- DI types are now enabled as standalone files:
  - `UltimateMoneyVisualizer/AppDependencies/AppDependencies.swift`
    - `AppDependencies`, `NavigationCoordinating` (+ `NavCoordinator`), `UserProviding`
  - `UltimateMoneyVisualizer/AppDependencies/Environment+Dependencies.swift`
    - `EnvironmentValues.dependencies`
  - `UltimateMoneyVisualizer/Data/Repositories/EarningsRepository.swift`
    - `EarningsRepository` (+ default impl)
- `NewHomeViewModel` already consumes DI:
  - `UltimateMoneyVisualizer/NewHomeView/View Model/NewHomeViewModel.swift`
    - Props: `user`, `navigator`, `wage` via `AppDependencies`

## What’s Next

- Remove singletons in remaining features (switch to DI navigator where a VM exists):
  - `UltimateMoneyVisualizer/All Items View/Main Controller/AllItemsView.swift`
  - `UltimateMoneyVisualizer/Pay Period/Editing Items/EditShiftView.swift`
  - `UltimateMoneyVisualizer/New Today View/NewTodayView.swift`
  - Grep for: `NavManager.shared`, `appendCorrectPath`, `getDestinationViewForStack`
- Stats feature to DI:
  - DONE. Consider follow-ups in related stats subviews if any rely on singletons.
- Replace remaining direct uses in Today feature (`New Today View/*`) and deprecated views (optional)
- Expand repository adoption in other ViewModels (migrate data reads off `User` globals to `EarningsRepository`)
- Navigation refactor (next iteration):
  - Replace central `getDestinationViewForStack` with feature coordinators/typed routes
- Tests:
  - Add unit tests with in-memory Core Data for repository-backed VMs
- Docs:
  - Update README with DI overview and usage patterns

## Verification Checklist

- [x] No `NewHomeViewModel.shared` usages remain in Home
- [x] Home navigations use `vm.navigator.push(...)`
- [x] Previews inject `NewHomeViewModel()` where `@EnvironmentObject` is required
- [ ] All `NavManager.shared.appendCorrectPath` in other features removed
  - Replaced in: Settings, SavedListView, PayoffItemListView, WageBreakdownBox
  - Replaced in: WageView, ItemizedPartOfShiftView, AllTimeBlocksView, CondensedTimeBlockView, TagListForItemView, TagDetailView, ShiftDetailView, RegularScheduleView, SavedDetailView, PayoffQueueView, PayoffItemDetailView(+TagsSection), PayoffContributionsView, PayPeriodDetailView, PayPeriodRow, AllPayPeriodsView
  - Remaining only in deprecated views (kept for now): `Deprecated/*`, old EnterWage, and some legacy Today subviews
- [x] `StatsViewModel` singleton removed; DI-backed init and repository in place
- [x] DI files re-enabled and embedded definitions removed from app file
- [ ] Basic unit tests for Home/Stats VMs (in-memory store)

## Rollback Notes

- If needed, revert DI navigation changes by swapping `vm.navigator.push(...)` back to `NavManager.shared.appendCorrectPath(...)` in modified files above.
- Re-introduce `NewHomeViewModel.shared` only as a last resort (not recommended).
