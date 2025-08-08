# Step 1 — Quick Wins (2025-08-07)

This document records the “quick wins” applied to improve stability, UX, and code hygiene with minimal risk.

## Summary of Changes

- __Respect user accessibility settings__
  - Removed forced dynamic type override: no longer sets `.environment(\.sizeCategory, .large)` globally.
  - File: `UltimateMoneyVisualizer/--TopLevel/UltimateMoneyVisualizerApp.swift`

- __Notification authorization + sane scheduling__
  - Request notification permission on app launch (with emoji logs).
  - Only schedule after authorization, using a daily repeating trigger at 9:00 AM (hour+minute only, no seconds).
  - Files:
    - `--TopLevel/UltimateMoneyVisualizerApp.swift`
    - `---Concatenate/Not Views/Managers/NotificationManager.swift`

- __Fix misuse of @ObservedObject in ViewModels__
  - ViewModels should expose `@Published` for UI state; references to other singletons should NOT be `@ObservedObject`.
  - `NewHomeViewModel`: `user` and `navManager` are now plain `let`; `wage` is `@Published`; removed manual `objectWillChange.send()`.
  - `StatsViewModel`: `user` and `navManager` are now plain `let`.
  - Files:
    - `NewHomeView/View Model/NewHomeViewModel.swift`
    - `Stats/StatsViewModel.swift`

- __Avoid crashing on Core Data load errors__
  - Replaced `fatalError` with emoji-rich logs and graceful continuation.
  - CloudKit schema init failure no longer crashes in DEBUG; logs instead.
  - File: `---Concatenate/Not Views/Managers/PersistenceController/Persistence.swift`

## Files Touched

- `UltimateMoneyVisualizer/--TopLevel/UltimateMoneyVisualizerApp.swift`
- `UltimateMoneyVisualizer/---Concatenate/Not Views/Managers/NotificationManager.swift`
- `UltimateMoneyVisualizer/NewHomeView/View Model/NewHomeViewModel.swift`
- `UltimateMoneyVisualizer/Stats/StatsViewModel.swift`
- `UltimateMoneyVisualizer/---Concatenate/Not Views/Managers/PersistenceController/Persistence.swift`

## Behavior Impact

- __Accessibility__: App respects user’s chosen Dynamic Type size.
- __Notifications__: Permission is requested on first launch; if granted, one daily reminder at 9:00 AM is scheduled. Emoji logs: 🔔
- __State updates__: UI updates correctly via `@Published` changes (no manual `objectWillChange`).
- __Stability__: App avoids crashing on persistent store load failures; errors are logged (🗄️ / ☁️) for diagnosis.

## QA Checklist

- __Launch app__
  - Observe prompt for notifications.
  - If granted, confirm console log shows: `🔔 Notifications authorized` and `🔔 Daily notification scheduled ...`.
- __Accessibility__
  - Change iOS Dynamic Type size in Settings; verify app text scales accordingly.
- __ViewModel sanity__
  - Navigate Home and Stats; verify values populate and update without errors.
- __Persistence__
  - Simulate store error (optional) and confirm app logs error and continues without crash.

## Follow-ups (Not in this step)

- User-configurable notification time and the ability to disable reminders.
- Fallback to in-memory store automatically on fatal Core Data load errors (opt-in).
- Migrate CloudKit schema init out of runtime into dev tooling.

## Rollback

- Revert the branch/commit associated with Step 1, or cherry-pick to undo specific file changes.
