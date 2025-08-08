# Following Step 1 — Remaining Work

This document tracks the refactors and features to complete after the Step 1 Quick Wins (2025-08-07).

## 1) Architecture & State Management

- [ ] Introduce lightweight DI at app boundaries; pass dependencies via initializers, not singletons
- [ ] Extract feature modules/folders: `Features/Today`, `Features/Stats`, `Features/PayPeriods`, `Services`, `Data`, `UI/Components`, `App/`
- [ ] Move any live code out of `Deprecated/` (e.g., `TodayViewModel`) and delete dead code
- [ ] Add repositories/services (`UserRepository`, `PayPeriodService`, etc.) and move data logic out of Views/VMs
- [ ] Standardize ViewModel patterns: inputs/outputs, `@Published` only for UI-bound state

## 2) Navigation Refactor

- [ ] Replace `NavManager` giant switch with feature-scoped coordinators and typed routes
- [ ] Each feature owns a `NavigationStack` and its destination enum
- [ ] Decouple navigation from business logic in VMs

## 3) Persistence & CloudKit

- [ ] Remove runtime `initializeCloudKitSchema` from app; move to dev tooling or scripts
- [ ] Create non-CloudKit `NSPersistentContainer` for tests/in-memory runs
- [ ] Add error recovery paths on store load (migrate, retry, fall back to in-memory)
- [ ] Add background context writes + merge policy, and batch operations where appropriate
- [ ] Audit fetch requests for performance (predicates, sorting, batch size)

## 4) Notifications

- [ ] User-configurable reminder time (settings screen) and ability to disable reminders
- [ ] Manage pending requests and avoid duplicates (remove existing before rescheduling)
- [ ] Foreground presentation options and deep links to relevant screens
- [ ] Respect Do Not Disturb/Focus suggestions in copy and timing

## 5) Monetization (StoreKit 2)

- [ ] Define product identifiers and load products
- [ ] Implement purchase + restore flows with verification
- [ ] Maintain entitlement state (cache + refresh) and update UI/paywalls reactively
- [ ] Replace `SubscriptionManager` stubs with real checks and limits
- [ ] Handle introductory offers / price changes gracefully

## 6) Testing & CI

- [ ] Unit tests with in-memory Core Data for repositories and view models
- [ ] UI smoke tests for Today, Stats, and Paywall flows
- [ ] Add `SwiftLint` + `SwiftFormat` and fix violations
- [ ] GitHub Actions CI: build + tests on PRs

## 7) UX/Accessibility & Performance

- [ ] VoiceOver labels, traits, and rotor navigation for key screens
- [ ] Audit Dynamic Type at component level; ensure layouts scale cleanly
- [ ] Reduce heavy computations on main thread; memoize or move to background
- [ ] Add subtle haptics and consistent theming

## 8) Codebase Hygiene & Docs

- [ ] Delete deprecated folders once migrated
- [ ] Unify naming conventions and folder structure
- [ ] Expand `README.md` with setup, architecture, data model, testing
- [ ] Add Dev Onboarding guide (how to run, test, and release)

## Proposed Iteration Plan (Weeks 2–6)

- Week 2: DI setup, repositories/services, unit test harness
- Weeks 3–4: Navigation refactor to feature coordinators; move Today/PayPeriods
- Week 5: StoreKit 2 implementation and entitlement-driven UI
- Week 6: CI (build/tests/lint/format), UI smoke tests, analytics opt-in

## Success Criteria

- Navigation and dependencies isolated per feature; no global singletons in VMs
- Stable daily notifications with user-configured time
- Real purchase/entitlement checks replace stubs
- Tests run in CI; PRs must pass
- Accessibility and performance issues reduced (no obvious layout breaks at large text sizes; smooth scrolling)
