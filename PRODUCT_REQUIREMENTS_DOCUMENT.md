# Ultimate Earnings Visualizer - Product Requirements Document

## Document Purpose

This document serves as a comprehensive specification for the Ultimate Earnings Visualizer iOS application. It is designed to provide developers, product owners, and stakeholders with complete details about all features, functionality, user flows, data models, and business logic required to recreate this application from scratch.

**Target Audience**: Developers, Product Managers, Designers, QA Engineers, Business Analysts

**Document Version**: 1.0  
**Last Updated**: 2025-01-27

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Product Overview](#product-overview)
3. [Core Features](#core-features)
4. [Data Architecture](#data-architecture)
5. [User Interface & Navigation](#user-interface--navigation)
6. [Business Logic & Calculations](#business-logic--calculations)
7. [User Flows](#user-flows)
8. [Technical Requirements](#technical-requirements)
9. [Monetization Model](#monetization-model)
10. [Onboarding & User Education](#onboarding--user-education)
11. [Settings & Customization](#settings--customization)
12. [Analytics & Statistics](#analytics--statistics)
13. [Notifications & Reminders](#notifications--reminders)
14. [Integration Capabilities](#integration-capabilities)
15. [Platform Requirements](#platform-requirements)
16. [Success Metrics](#success-metrics)

---

## Executive Summary

**Ultimate Earnings Visualizer** is an iOS application built with SwiftUI that helps users track their work earnings in real-time, manage financial goals and expenses, and visualize their financial progress through detailed shift tracking and allocation systems.

### Core Value Proposition

The app transforms how users think about their work time by:
- Providing real-time earnings visualization during active shifts
- Automatically allocating earnings to expenses and goals based on user-defined priorities
- Offering comprehensive financial tracking through shifts, expenses, goals, and savings
- Enabling detailed time block tracking within shifts for granular activity monitoring
- Supporting pay period management with automatic calculations and projections

### Key Differentiators

1. **Real-Time Shift Tracking**: Live earnings calculation during active work shifts with second-by-second updates
2. **Unified Payoff System**: Expenses and goals share a common prioritization queue for automatic allocation
3. **Time Block Granularity**: Break down shifts into detailed time blocks for activity-specific tracking
4. **Automatic Allocation Engine**: Intelligent distribution of earnings across financial obligations and goals
5. **Pay Period Intelligence**: Automatic pay period creation and management with shift grouping

---

## Product Overview

### App Structure

The application uses a **tab-based navigation** architecture with four main sections:

1. **Home Tab**: Dashboard view with financial overview, totals, payoff queue preview, and quick actions
2. **All Items Tab**: Comprehensive list view of all shifts, expenses, goals, and saved items with filtering
3. **Today Tab**: Real-time shift tracking interface for active work sessions
4. **Settings Tab**: Configuration, preferences, wage setup, and subscription management

### Primary Use Cases

1. **Hourly Workers**: Track earnings per shift, monitor progress toward financial goals
2. **Salary Workers**: Convert salary to hourly equivalent, track time worked, manage expenses
3. **Goal-Oriented Users**: Set financial goals, track progress, allocate earnings automatically
4. **Expense Managers**: Track recurring expenses, manage payoff priorities, visualize debt reduction
5. **Time Trackers**: Monitor work activities through time blocks, analyze time allocation

---

## Core Features

### 1. Shift Management

#### 1.1 Shift Creation

**Single Shift Creation**
- Users can create individual shifts with:
  - Start date and time
  - End date and time
  - Automatic conflict detection for overlapping shifts
  - Automatic assignment to appropriate pay period
  - Optional time blocks for activity breakdown

**Multiple Shift Creation**
- Bulk creation with:
  - Date range selection
  - Day of week selection (Monday-Sunday)
  - Automatic generation of shifts for selected days
  - Conflict detection across all generated shifts
  - Batch assignment to pay periods

**Shift Validation**
- Overlap detection prevents conflicting shift times
- Validation ensures end time is after start time
- Automatic pay period assignment based on shift dates

#### 1.2 Shift Display & Management

**Shift List View**
- Grouped by pay periods (past and upcoming)
- Carousel view for upcoming shifts
- Chronological sorting (most recent first)
- Quick access to shift details
- Edit and delete capabilities

**Shift Detail View**
- Complete earnings breakdown:
  - Gross earnings (before taxes)
  - Tax deductions (federal and state)
  - Net earnings (after taxes)
  - Total allocated to expenses/goals
  - Remaining available amount
- Visual pie chart showing allocation distribution
- Time blocks visualization with color coding
- Duration and hourly rate display
- Allocation history and details

**Shift Editing**
- Modify start and end times
- Update time blocks
- Adjust allocations
- Reassign to different pay period

#### 1.3 Shift Calculations

**Earnings Calculation**
- Based on wage rate (hourly or salary-derived)
- Real-time calculation: `duration × wage.perSecond`
- Tax calculations applied if enabled:
  - Federal tax: `gross × federalTaxPercentage`
  - State tax: `gross × stateTaxPercentage`
  - Net = gross - (federal tax + state tax)
- Support for per-second, per-minute, hourly, daily, weekly, monthly, yearly rates

**Allocation Calculations**
- Automatic allocation based on payoff queue priority
- Manual allocation override available
- Percent-based shift expenses (fixed percentage of shift earnings)
- Remaining amount after allocations tracked

---

### 2. Today Shift (Real-Time Tracking)

#### 2.1 Active Shift Tracking

**Shift Initialization**
- User sets start and end times for current day
- Pre-filled with regular schedule if configured
- Creates temporary `TodayShift` entity
- Initializes payoff item queue from user's main queue

**Real-Time Updates**
- Timer updates earnings every second
- Live calculation: `elapsedTime × wage.perSecond`
- Progress bar shows time completion percentage
- Earnings display updates continuously
- Allocation preview updates in real-time

**Visual Feedback**
- Progress bar with time remaining
- Earnings counter with live updates
- Allocation breakdown showing where money is going
- Time blocks can be added during active shift
- Segment picker to view different aspects (earnings, allocations, time blocks)

#### 2.2 Temporary Allocations

**During Shift**
- Users can preview allocations to expenses/goals
- Temporary allocations stored in `TemporaryAllocation` entities
- Queue order can be modified during shift
- Real-time calculation of how much each item will receive

**Shift Completion**
- Banner appears when shift end time is reached
- "Save" button converts TodayShift to permanent Shift
- Temporary allocations become permanent Allocation entities
- User can review and adjust allocations before saving
- Confirmation screen shows final breakdown

#### 2.3 TodayShift Expiration

- TodayShift automatically expires at end of day
- If not saved, data is lost (by design for temporary nature)
- Prevents accumulation of incomplete shifts

---

### 3. Payoff Items System

#### 3.1 Unified Payoff Architecture

**PayoffItem Protocol**
- Common interface for both Expenses and Goals
- Shared properties:
  - `amount`: Total amount to pay off
  - `amountPaidOff`: Current progress
  - `amountRemainingToPayOff`: Calculated remaining
  - `dueDate`: Optional target date
  - `queueSlotNumber`: Priority position
  - `tags`: Categorization system
  - `imageData`: Optional visual identifier
  - `info`: Additional notes/description

**Expense Entity**
- Financial obligations with due dates
- Recurring expense support (daily, weekly, monthly, yearly)
- Tracks allocations from shifts and saved items
- Progress tracking with visual indicators
- Can be marked as recurring with frequency

**Goal Entity**
- Financial targets (savings goals, purchase goals)
- Optional due dates for time-based goals
- Same allocation and progress tracking as expenses
- Visual progress bars and percentage indicators
- Supports both amount-based and date-based goals

#### 3.2 Payoff Queue Management

**Queue System**
- Drag-and-drop reordering of expenses and goals
- Priority determines allocation order
- Queue slot numbers (1, 2, 3, etc.) define priority
- Visual queue view shows all items in priority order
- Items can be added/removed from queue
- Queue persists across app sessions

**Automatic Allocation**
- When shift is saved, earnings automatically allocated to queue items
- Allocation follows queue order (first item gets money first)
- Continues until item is fully paid or shift earnings exhausted
- Remaining amount after all allocations tracked as "available"

**Queue Display**
- Home view shows top items in queue
- Today view shows queue items receiving allocations
- All Items view shows complete queue with reordering
- Visual indicators show progress for each item

#### 3.3 Payoff Item Features

**Progress Tracking**
- Visual progress bars showing completion percentage
- Amount remaining calculation
- Time remaining (if due date set)
- Allocation history showing all contributions

**Recurring Items**
- Expenses can be set to recur automatically
- Frequency options: daily, weekly, monthly, yearly
- Recurring date tracks next occurrence
- New instances created based on frequency

**Tags & Organization**
- Shared tag system across expenses, goals, and saved items
- Tags can be created, edited, and deleted
- Filtering by tags in list views
- Tag-based analytics and reporting

**Image Attachments**
- Users can attach photos to expenses/goals
- Visual recognition aid
- Stored as binary data in Core Data
- Displayed in detail views

---

### 4. Saved Items

#### 4.1 Saved Item Concept

**Purpose**
- Track money saved by avoiding purchases
- Record economical choices and smart substitutions
- Monitor savings habits and patterns
- Allocate saved money to expenses/goals

**Data Model**
- `amount`: Amount saved
- `date`: When saving occurred
- `title`: Brief description
- `info`: Additional details
- `tags`: Categorization
- `allocations`: Links to expenses/goals

#### 4.2 Saved Item Features

**Creation**
- Manual entry with amount and description
- Date selection (defaults to today)
- Optional tags and notes
- Quick entry for common savings types

**Allocation**
- Saved money can be allocated to expenses/goals
- Same allocation system as shift earnings
- Tracks how much saved money went to each item
- Visual progress tracking

**Tracking**
- List view of all saved items
- Grouping by title (instances of same saving type)
- Total saved over time periods
- Analytics on saving patterns

---

### 5. Time Blocks

#### 5.1 Time Block Concept

**Purpose**
- Break down shifts into smaller activity segments
- Track different tasks or activities within a shift
- Monitor time allocation across activities
- Calculate earnings per activity type

**Data Model**
- `title`: Activity name
- `startTime`: Block start timestamp
- `endTime`: Block end timestamp
- `colorHex`: Visual identifier color
- `dateCreated`: Creation timestamp
- Relationships: `shift`, `todayShift`, `user`

#### 5.2 Time Block Features

**Creation**
- Can be added to active TodayShift or completed Shift
- Time range selection (start and end times)
- Color picker for visual distinction
- Title entry for activity description
- Overlap detection prevents conflicting blocks

**Display**
- Visual timeline showing all blocks in shift
- Color-coded blocks for quick identification
- Condensed view groups blocks with same title
- Expanded view shows all individual blocks
- Duration and earnings per block displayed

**Statistics**
- Time spent per activity type
- Earnings per activity type
- Most common activities
- Time allocation patterns
- Top time blocks by duration or earnings

**Calendar Integration**
- Import recurring events from device calendars
- Convert calendar events to RecurringTimeBlock entities
- Automatic time block creation from calendar
- Support for EKRecurrenceRule patterns

---

### 6. Pay Periods

#### 6.1 Pay Period System

**Purpose**
- Group shifts into pay periods
- Track earnings per pay period
- Manage pay day calculations
- Project future earnings

**Data Model**
- `firstDate`: Period start date
- `payDay`: Pay day date
- `cycleCadence`: Pay frequency (daily, weekly, bi-weekly, monthly)
- `dateSet`: When period was created
- Relationship: `shifts` (all shifts in this period)

#### 6.2 Pay Period Features

**Automatic Creation**
- System can auto-generate pay periods based on settings
- Creates new period when current one ends
- Respects user-defined pay cycle (daily, weekly, bi-weekly, monthly)
- Automatic shift assignment to appropriate period

**Manual Creation**
- Users can create pay periods manually
- Set first date and pay day
- Assign shifts to periods
- Edit period dates

**Pay Period Settings**
- Configure pay cycle frequency
- Set pay day of week
- Enable/disable auto-generation
- Set first pay period date
- Configure next pay day

**Pay Period Calculations**
- Total earnings per period
- Total allocated per period
- Available amount per period
- Shift count per period
- Average earnings per shift
- Projected earnings for upcoming periods

**Display**
- List view of all pay periods
- Most recent period first
- Shift grouping by period
- Period summary with totals
- Navigation to period detail view

---

### 7. Wage Management

#### 7.1 Wage Configuration

**Wage Types**
- **Hourly**: Direct hourly rate entry
- **Salary**: Annual salary converted to hourly equivalent
  - Requires: salary amount, hours per day, days per week, weeks per year, vacation days
  - Calculation: `salary / (workingWeeks × hoursPerWeek)`

**Wage Attributes**
- `amount`: Base wage (hourly rate or annual salary)
- `isSalary`: Boolean flag for wage type
- `includeTaxes`: Enable/disable tax calculations
- `federalTaxPercentage`: Federal tax rate (0.0 to 1.0)
- `stateTaxPercentage`: State tax rate (0.0 to 1.0)
- `hoursPerDay`: Default hours per day (typically 8)
- `daysPerWeek`: Default days per week (typically 5)
- `weeksPerYear`: Default weeks per year (typically 52)

#### 7.2 Wage Calculations

**Time-Based Conversions**
- Per second: `hourly / 3600`
- Per minute: `hourly / 60`
- Per hour: Direct hourly rate
- Per day: `hourly × hoursPerDay`
- Per week: `perDay × daysPerWeek`
- Per month: `perWeek × 4.33` (average)
- Per year: `perWeek × weeksPerYear` or direct salary

**Tax Calculations**
- Federal tax multiplier: `1 - federalTaxPercentage`
- State tax multiplier: `1 - stateTaxPercentage`
- Combined tax multiplier: `federalMultiplier × stateMultiplier`
- Applied to shift earnings if taxes enabled

**Salary Conversion**
- Accounts for vacation days
- Calculates working weeks: `52 - (vacationDays / 5)`
- Total working hours: `workingWeeks × hoursPerWeek`
- Hourly equivalent: `salary / totalWorkingHours`

#### 7.3 Wage Display

**Wage View**
- Current wage display (hourly or salary)
- Breakdown table showing all time periods
- Edit button to modify wage settings
- Tax configuration if enabled

**Wage Entry/Edit**
- Form for entering wage information
- Toggle between hourly and salary
- Salary calculator with vacation days
- Tax percentage inputs
- Save and validation

---

### 8. Regular Schedule

#### 8.1 Schedule Configuration

**Purpose**
- Define typical work schedule
- Pre-fill shift times in Today view
- Support for schedule-based automation (future)

**Data Model**
- `RegularSchedule`: Main schedule entity
- `RegularDay`: Individual day entries
  - Day of week (Monday-Sunday)
  - Start time
  - End time
  - Active/inactive flag

**Schedule Features**
- Set work days (Monday through Sunday)
- Define start and end times for each day
- Activate/deactivate specific days
- View schedule in list format
- Edit schedule through Settings

#### 8.2 Schedule Integration

**Today View Integration**
- Pre-fills start and end times based on schedule
- Uses current day's schedule if available
- User can override pre-filled times

**Future Automation** (Planned)
- Automatic shift creation based on schedule
- Schedule-based notifications
- Schedule adherence tracking

---

### 9. Allocations

#### 9.1 Allocation System

**Purpose**
- Link money from shifts/saved items to expenses/goals
- Track payment history
- Enable automatic distribution
- Provide allocation transparency

**Data Model**
- `amount`: Allocation amount
- `date`: When allocation occurred
- `id`: Unique identifier
- Relationships: `shift`, `expense`, `goal`, `savedItem`, `user`

#### 9.2 Allocation Types

**Automatic Allocations**
- Created when shift is saved
- Follows payoff queue order
- Continues until item paid or funds exhausted
- Multiple allocations can go to same item

**Manual Allocations**
- User can manually allocate money
- From shift earnings (remaining amount)
- From saved items
- To any expense or goal
- Override automatic allocation if needed

**Percent-Based Allocations**
- `PercentShiftExpense`: Fixed percentage of shift goes to expense
- Applied before queue-based allocations
- Useful for recurring fixed expenses (rent, insurance)

#### 9.3 Allocation Display

**Allocation History**
- View all allocations to an expense/goal
- Sorted by date (most recent first)
- Shows source (which shift or saved item)
- Total allocated amount displayed

**Allocation Summary**
- Per shift: Shows all allocations from that shift
- Per pay period: Aggregated allocations
- Per expense/goal: All contributions received
- Visual breakdown with amounts

---

### 10. Tags System

#### 10.1 Tag Management

**Purpose**
- Categorize expenses, goals, and saved items
- Enable filtering and organization
- Support analytics and reporting

**Data Model**
- `name`: Tag name
- `colorHex`: Visual identifier
- `dateCreated`: Creation timestamp
- `lastUsed`: Most recent use timestamp
- Relationships: `expenses`, `goals`, `user`

**Tag Features**
- Create new tags with name and color
- Edit existing tags
- Delete tags (with confirmation)
- Tags sorted by most recently used
- Shared across all item types

#### 10.2 Tag Usage

**Item Tagging**
- Add multiple tags to expenses/goals/saved items
- Tag selection interface
- Visual tag display in list and detail views
- Filter items by tags

**Tag Analytics**
- Items per tag
- Total amounts per tag
- Tag usage frequency
- Tag-based time period analysis

---

## Data Architecture

### Core Data Entities

#### User (Central Entity)
- **Attributes**: `username`, `email`
- **Relationships**: 
  - `wage` (1:1)
  - `settings` (1:1)
  - `statusTracker` (1:1)
  - `payPeriodSettings` (1:1)
  - `payoffQueue` (1:1)
  - `regularSchedule` (1:1)
  - `shifts` (1:many)
  - `todayShift` (1:1)
  - `expenses` (1:many)
  - `goals` (1:many)
  - `savedItems` (1:many)
  - `timeBlocks` (1:many)
  - `tags` (1:many)
  - `allocations` (1:many)
  - `deductions` (1:many)
  - `banks` (1:many)
  - `payPeriods` (1:many)
  - `percentShiftExpenses` (1:many)
  - `recurringTimeBlocks` (1:many)

#### Shift
- **Attributes**: `startDate`, `endDate`, `dayOfWeek`
- **Relationships**: `user`, `payPeriod`, `allocations`, `timeBlocks`, `percentShiftExpenses`
- **Computed Properties**: `totalEarned`, `totalAllocated`, `totalAvailable`, `duration`, `taxesPaid`, `totalEarnedAfterTaxes`

#### TodayShift
- **Attributes**: `startTime`, `endTime`, `dateCreated`, `expiration`, `payoffItemQueue` (comma-separated UUIDs)
- **Relationships**: `user`, `temporaryAllocations`, `timeBlocks`
- **Computed Properties**: `totalEarnedSoFar`, `remainingTime`, `percentTimeCompleted`

#### Expense
- **Attributes**: `title`, `amount`, `dateCreated`, `dueDate`, `info`, `imageData`, `isRecurring`, `recurringDate`, `repeatFrequency`, `queueSlotNumber`, `tempQNum`, `id`
- **Relationships**: `user`, `allocations`, `temporaryAllocations`, `tags`
- **Computed Properties**: `amountPaidOff`, `amountRemainingToPayOff`, `percentPaidOff`, `isFullyPaidOff`

#### Goal
- **Attributes**: `title`, `amount`, `dateCreated`, `dueDate`, `info`, `imageData`, `repeatFrequency`, `queueSlotNumber`, `tempQNum`, `id`
- **Relationships**: `user`, `allocations`, `temporaryAllocations`, `tags`
- **Computed Properties**: `amountPaidOff`, `amountRemainingToPayOff`, `percentPaidOff`, `isFullyPaidOff`

#### Saved
- **Attributes**: `title`, `amount`, `date`, `info`, `id`
- **Relationships**: `user`, `allocations`, `tags`
- **Computed Properties**: `totalAvailable`, `percentSpent`, `totalAllocated`

#### Allocation
- **Attributes**: `amount`, `date`, `id`
- **Relationships**: `user`, `shift`, `expense`, `goal`, `savedItem`
- **Purpose**: Links money from shifts/saved items to expenses/goals

#### TimeBlock
- **Attributes**: `title`, `startTime`, `endTime`, `colorHex`, `dateCreated`
- **Relationships**: `user`, `shift`, `todayShift`
- **Purpose**: Activity segments within shifts

#### PayPeriod
- **Attributes**: `firstDate`, `payDay`, `cycleCadence`, `dateSet`
- **Relationships**: `user`, `settings`, `shifts`
- **Computed Properties**: `totalEarned`, `totalAllocated`, `totalAvailable`, `shiftCount`

#### Wage
- **Attributes**: `amount`, `isSalary`, `includeTaxes`, `federalTaxPercentage`, `stateTaxPercentage`, `hoursPerDay`, `daysPerWeek`, `weeksPerYear`
- **Relationships**: `user`
- **Computed Properties**: `hourly`, `perSecond`, `perMinute`, `perDay`, `perWeek`, `perMonth`, `perYear`, `federalTaxMultiplier`, `stateTaxMultiplier`, `totalTaxMultiplier`

#### Tag
- **Attributes**: `name`, `colorHex`, `dateCreated`, `lastUsed`
- **Relationships**: `user`, `expenses`, `goals`
- **Purpose**: Categorization system

#### PayoffQueue
- **Attributes**: `list` (comma-separated UUIDs), `lastEdited`
- **Relationships**: `user`
- **Purpose**: Manages priority order of expenses and goals

#### Settings
- **Attributes**: `themeColor`, `useColoredNavBar`
- **Relationships**: `user`
- **Purpose**: User preferences and customization

#### StatusTracker
- **Attributes**: `hasSeenOnboardingFlow`, `numberOfTimesOpeningApp`
- **Relationships**: `user`
- **Purpose**: Track user onboarding and app usage

#### PayPeriodSettings
- **Attributes**: `cycleCadence`, `autoGeneratePeriods`, `payDayOfWeek`
- **Relationships**: `user`, `periods`
- **Purpose**: Pay period configuration

#### RegularSchedule
- **Attributes**: (managed through RegularDay relationships)
- **Relationships**: `user`, `regularDays`
- **Purpose**: User's typical work schedule

#### RegularDay
- **Attributes**: `dayOfWeek`, `startTime`, `endTime`, `isActive`
- **Relationships**: `schedule`
- **Purpose**: Individual day entries in regular schedule

#### TemporaryAllocation
- **Attributes**: `amount`, `id`
- **Relationships**: `todayShift`, `expense`, `goal`
- **Purpose**: Preview allocations during active shift

#### PercentShiftExpense
- **Attributes**: `percentage`
- **Relationships**: `user`, `expense`, `shift`
- **Purpose**: Fixed percentage allocations from shifts

#### Deduction
- **Attributes**: `title`, `amount`, `amountType`, `type` (pre-tax, taxes, after-tax)
- **Relationships**: `user`
- **Purpose**: Payroll deductions (currently underutilized)

#### Bank
- **Attributes**: (minimal implementation)
- **Relationships**: `user`
- **Purpose**: Bank account tracking (future feature)

#### RecurringTimeBlock
- **Attributes**: `title`, `startTime` (string), `endTime` (string), `colorHex`
- **Relationships**: `user`
- **Purpose**: Recurring time blocks from calendar integration

### Data Persistence

**Core Data with CloudKit**
- Local Core Data store for primary persistence
- CloudKit sync for multi-device support
- Automatic conflict resolution
- Background sync capabilities

**Key Design Patterns**
- Singleton `PersistenceController` manages Core Data stack
- Business logic in Core Data entity extensions
- Computed properties for derived values
- Protocol-oriented design (`PayoffItem` protocol)

---

## User Interface & Navigation

### Navigation Architecture

**Tab-Based Navigation**
- Four main tabs: Home, All Items, Today, Settings
- Each tab has independent navigation stack
- `NavManager` singleton manages navigation state
- Sheet presentations handled through NavManager properties

**Navigation Paths**
- Home tab: Home view → Stats, Payoff Queue, Item details
- All Items tab: List views → Item details, Edit views
- Today tab: Today view → Time blocks, Confirm shift
- Settings tab: Settings → Wage, Schedule, Pay Periods, etc.

### Main Views

#### Home View (NewHomeView)
**Components**:
- Totals section (earned, allocated, available)
- Summary view (quick stats overview)
- Net money display
- Payoff queue preview (top items)
- Wage breakdown
- Top time blocks

**Features**:
- Scrollable vertical layout
- Floating action button for quick item creation
- Quick menu overlay for creating shifts, expenses, goals, saved items
- Navigation to detailed views
- Real-time data updates

#### All Items View
**Sections**:
- Segmented picker: Shifts, Saved, Expenses, Goals
- List view for selected type
- Edit mode for reordering/deleting
- Search and filter capabilities
- Empty state placeholders

**Features**:
- Switch between item types
- Drag-and-drop reordering (payoff queue)
- Tap to view details
- Swipe actions for quick operations
- Grouping by pay periods (for shifts)

#### Today View (NewTodayView)
**States**:
- **No Shift**: Empty state with "Add Shift" button
- **Active Shift**: Real-time tracking interface

**Active Shift Components**:
- Header with shift times
- Progress bar showing time completion
- Segment picker (Earnings, Allocations, Time Blocks)
- Info rects showing totals
- Payoff queue stack showing allocations
- Time blocks list
- Bottom banner when shift completes

**Features**:
- Real-time timer updates
- Live earnings calculation
- Allocation preview
- Time block management
- Shift completion banner
- Confirmation screen before saving

#### Settings View
**Sections**:
- Money: Wage, Regular Schedule, Pay Periods, Enter Lump Sum
- Visuals: Theme color selection
- Plan: Subscription management
- Tutorials: Time blocks info, Goals info
- Debug (development only)

**Features**:
- Navigation to configuration screens
- Theme color picker (premium feature)
- Subscription status and management
- Tutorial links
- App visit counter

### UI Components

**Reusable Components**:
- `PayoffItemRectGeneral`: Display card for expenses/goals
- `SystemImageWithFilledBackground`: Icon with colored background
- `FloatingPlusButton`: Floating action button
- `NoContentPlaceholderCustomView`: Empty state placeholder
- Progress bars and indicators
- Money display formatters
- Date formatters

**Visual Design**:
- Theme color customization (premium)
- System colors for accessibility
- Card-based layouts with shadows
- List styles (inset grouped)
- Custom gradients and backgrounds

---

## Business Logic & Calculations

### Earnings Calculations

**Shift Earnings**
```
grossEarnings = duration × wage.perSecond
federalTax = grossEarnings × federalTaxPercentage
stateTax = grossEarnings × stateTaxPercentage
netEarnings = grossEarnings - (federalTax + stateTax)
```

**Real-Time Earnings (TodayShift)**
```
elapsedTime = currentTime - startTime
earningsSoFar = elapsedTime × wage.perSecond
remainingTime = endTime - currentTime
percentComplete = elapsedTime / totalDuration
```

### Allocation Logic

**Automatic Allocation Algorithm**
1. Start with shift net earnings (or saved item amount)
2. Apply percent-based expenses first (fixed percentages)
3. For remaining amount, iterate through payoff queue:
   - Get next item in queue
   - Calculate amount needed: `item.amountRemainingToPayOff`
   - Allocate: `min(remainingAmount, amountNeeded)`
   - Create Allocation entity
   - Update remaining amount
   - Continue until queue exhausted or funds exhausted
4. Track remaining as "available"

**Allocation Validation**
- Cannot allocate more than available
- Cannot allocate negative amounts
- Allocation amount must be positive
- Item must be in payoff queue (for automatic)

### Pay Period Logic

**Period Assignment**
- Shift assigned to pay period based on shift dates
- Period must contain shift's date range
- Automatic period creation if none exists
- Period boundaries based on cycleCadence

**Period Calculations**
```
totalEarned = sum(all shifts in period).totalEarned
totalAllocated = sum(all shifts in period).totalAllocated
totalAvailable = totalEarned - totalAllocated
shiftCount = count(shifts in period)
averagePerShift = totalEarned / shiftCount
```

### Payoff Queue Logic

**Queue Management**
- Queue stored as comma-separated UUIDs in PayoffQueue.list
- Items have queueSlotNumber (1, 2, 3, ...)
- Reordering updates queueSlotNumber for all items
- Queue persists across app sessions
- Temporary queue (tempQNum) used during TodayShift

**Queue Ordering**
- Items sorted by queueSlotNumber ascending
- Items without queueSlotNumber excluded from queue
- Queue can contain both expenses and goals
- Empty queue means no automatic allocations

### Recurring Items Logic

**Recurring Expense Creation**
- When recurring expense is paid off, check if isRecurring = true
- If recurring, create new expense instance:
  - Copy title, amount, tags, image
  - Set new dueDate based on repeatFrequency
  - Set new dateCreated to current date
  - Add to payoff queue if original was in queue

**Frequency Calculations**
- Daily: add 1 day
- Weekly: add 7 days
- Monthly: add ~30 days (or use calendar months)
- Yearly: add 365 days (or use calendar years)

---

## User Flows

### First-Time User Onboarding

1. **Welcome Screen**
   - App introduction and value proposition
   - "Let's get started" button

2. **Wage Setup**
   - Choose hourly or salary
   - Enter wage amount
   - Configure tax settings (optional)
   - Save wage

3. **Regular Schedule Setup**
   - Select work days
   - Set start and end times for each day
   - Save schedule

4. **Pay Period Configuration**
   - Select pay cycle (daily, weekly, bi-weekly, monthly)
   - Set first pay period dates
   - Choose auto-generation preference
   - Save settings

5. **Tutorial Offer**
   - Option to view tutorials
   - Can skip and access later

6. **Onboarding Complete**
   - Set `hasSeenOnboardingFlow = true`
   - Navigate to main app

### Creating and Tracking a Shift

1. **Start Shift**
   - Navigate to Today tab
   - Tap "Add Shift"
   - Select start and end times (pre-filled from schedule)
   - Confirm shift creation

2. **During Shift**
   - View real-time earnings
   - See allocation preview
   - Optionally add time blocks
   - Monitor progress bar

3. **Complete Shift**
   - Banner appears at end time
   - Tap "Save" button
   - Review allocations on confirmation screen
   - Adjust allocations if needed
   - Confirm save

4. **Shift Saved**
   - TodayShift converted to Shift
   - Allocations created
   - Shift appears in All Items > Shifts
   - Today view returns to empty state

### Setting Up a Financial Goal

1. **Create Goal**
   - Tap floating action button on Home
   - Select "Goal"
   - Enter goal details:
     - Title (e.g., "Vacation Fund")
     - Amount target
     - Optional due date
     - Optional image
     - Optional tags
   - Save goal

2. **Add to Payoff Queue**
   - Navigate to Payoff Queue view
   - Drag goal to desired position
   - Queue order determines allocation priority

3. **Track Progress**
   - View goal in Home payoff queue preview
   - See progress bar and percentage
   - Check allocation history
   - Monitor time remaining (if due date set)

4. **Goal Completion**
   - When fully paid, goal marked complete
   - Celebration/confirmation
   - Option to create new goal

### Managing Expenses

1. **Create Expense**
   - Tap floating action button
   - Select "Expense"
   - Enter expense details:
     - Title (e.g., "Credit Card Payment")
     - Amount owed
     - Due date
     - Optional: recurring frequency
     - Optional: image, tags, notes
   - Save expense

2. **Set Priority**
   - Add to payoff queue
   - Position in queue determines payment order
   - Higher priority = paid first

3. **Track Payments**
   - View expense in list
   - See progress toward payoff
   - Check allocation history
   - Monitor due date countdown

4. **Recurring Expenses**
   - If marked recurring, new instance created when paid
   - New expense appears with updated due date
   - Maintains same queue position if configured

### Using Time Blocks

1. **Add Time Block During Shift**
   - While shift is active, navigate to Time Blocks segment
   - Tap "Add Time Block"
   - Enter:
     - Title (activity name)
     - Start and end times
     - Color selection
   - Save time block

2. **View Time Blocks**
   - Condensed view: Groups blocks with same title
   - Expanded view: Shows all individual blocks
   - See duration and earnings per block
   - Visual timeline representation

3. **Time Block Statistics**
   - View top time blocks by duration
   - See earnings per activity type
   - Analyze time allocation patterns
   - Track most common activities

### Entering a Saved Item

1. **Record Savings**
   - Tap floating action button
   - Select "Saved"
   - Enter:
     - Title (what you saved on)
     - Amount saved
     - Date (defaults to today)
     - Optional: tags, notes
   - Save item

2. **Allocate Saved Money**
   - View saved item detail
   - Tap "Allocate"
   - Select expense or goal
   - Enter allocation amount
   - Confirm allocation

3. **Track Savings**
   - View all saved items in list
   - See total saved over time
   - Monitor allocation of saved money
   - Analyze saving patterns

---

## Technical Requirements

### Platform & Framework

**iOS Platform**
- Minimum iOS version: iOS 16.0+
- Built with SwiftUI
- Uses Core Data for persistence
- CloudKit integration for sync

**Architecture**
- MVVM pattern (Model-View-ViewModel)
- Dependency Injection (lightweight)
- Protocol-oriented design
- Singleton pattern for shared managers

**Key Technologies**
- SwiftUI for UI
- Core Data for persistence
- CloudKit for sync
- Combine for reactive programming
- UserNotifications for reminders
- EventKit for calendar integration

### Dependencies

**Swift Package Manager**
- AlertToast: Toast notifications
- ConfettiSwiftUI: Celebration animations
- FloatingButton: FAB components
- PopupView: Modal presentations
- ScalingHeaderScrollView: Scrolling effects
- VinPackage: Custom utility package
- Welcome-Sheet: Onboarding flows

### Performance Requirements

**Data Loading**
- Lazy loading for large lists
- Efficient Core Data fetch requests
- Batch operations for bulk updates
- Background context for heavy operations

**Real-Time Updates**
- Timer updates every second for active shifts
- Efficient calculation caching
- Minimal UI updates during timer ticks
- Background processing where possible

**CloudKit Sync**
- Automatic background sync
- Conflict resolution
- Efficient change tracking
- Error handling and retry logic

### Security & Privacy

**Data Storage**
- Local Core Data store (encrypted at rest by iOS)
- CloudKit sync (Apple-managed encryption)
- No external data transmission
- User data remains on device and iCloud

**Permissions**
- Notification permissions (optional)
- Calendar access (optional, for time block import)
- No location tracking
- No analytics tracking (user privacy)

---

## Monetization Model

### Subscription Tiers

**Free Tier**
- Limited items:
  - 2 shifts
  - 2 expenses
  - 2 goals
  - 2 saved items
- Basic features available
- Standard theme colors

**Premium Tier**
- Unlimited items (shifts, expenses, goals, saved items)
- Customizable theme color
- Custom app icon (future)
- Advanced graphs and stats
- Support independent developer

### Subscription Management

**Subscription Options**
- 7-day free trial
- Monthly subscription: $5/month
- Yearly subscription: $50/year

**Subscription Features**
- Managed through StoreKit
- Subscription status checking
- Roadblock views for premium features
- Purchase page with benefits list
- Subscription management in Settings

**Feature Gating**
- `SubscriptionManager` checks premium status
- Limits enforced at creation time
- Roadblock shown when limit reached
- Upgrade prompts at strategic points

---

## Onboarding & User Education

### Onboarding Flow

**Welcome Experience**
- Welcome screen with app value proposition
- Visual introduction to key features
- Smooth transition to setup

**Setup Steps**
1. Wage configuration (required)
2. Regular schedule (optional but recommended)
3. Pay period settings (optional)
4. Tutorial offer (optional)

**Tutorials Available**
- Time Blocks tutorial
- Goals tutorial
- General app navigation
- Feature-specific guides

### User Education

**In-App Tutorials**
- Accessible from Settings
- Step-by-step guides
- Visual examples
- Interactive demonstrations

**Help & Support**
- Info views for complex features
- Tooltips and hints
- Empty state guidance
- Contextual help text

---

## Settings & Customization

### User Preferences

**Theme Customization** (Premium)
- Color picker with predefined options
- Custom theme color application
- Affects navigation bars, accents, highlights
- Persistent across app sessions

**Navigation Preferences**
- Colored navigation bar option
- Display mode preferences
- Tab bar customization

### Configuration Options

**Wage Settings**
- Edit wage amount
- Switch between hourly/salary
- Configure tax percentages
- Update work assumptions (hours/day, days/week)

**Schedule Settings**
- Edit regular schedule
- Add/remove work days
- Adjust work times
- Activate/deactivate days

**Pay Period Settings**
- Change pay cycle frequency
- Set pay day of week
- Enable/disable auto-generation
- Configure first pay period

**Notification Settings** (Future)
- Daily reminder time
- Enable/disable notifications
- Shift reminder preferences
- Goal milestone notifications

---

## Analytics & Statistics

### Stats View

**Sections**
- Earned: Total earnings over time period
- Spent: Total expenses paid
- Saved: Total saved items
- Goals: Total goal progress

**Features**
- Date range picker (start and end dates)
- Line chart showing cumulative amounts
- List view of items in date range
- Section switching with segmented picker
- Horizontal data display with key metrics

**Calculations**
- Cumulative totals (running totals up to each day)
- Filtered by date range
- Grouped by item type
- Sorted chronologically

### Home View Analytics

**Quick Stats**
- Total earned (all time or period)
- Total allocated
- Total available
- Net money (earned - spent)

**Payoff Queue Preview**
- Top items in queue
- Progress indicators
- Quick navigation to full queue

**Wage Breakdown**
- Earnings by time period
- Comparison views
- Projection calculations

**Time Block Statistics**
- Top time blocks by duration
- Top time blocks by earnings
- Activity distribution
- Time allocation patterns

---

## Notifications & Reminders

### Notification System

**Daily Reminders**
- Configurable reminder time
- Prompts user to track shift
- Encourages daily engagement
- Optional notification

**Notification Permissions**
- Requested on app launch
- User can grant or deny
- Respects system Do Not Disturb
- Background notification support

**Future Notifications** (Planned)
- Shift start reminders
- Goal milestone celebrations
- Expense due date warnings
- Pay period completion alerts

---

## Integration Capabilities

### Calendar Integration

**Time Block Import**
- Import events from device calendars
- Convert to RecurringTimeBlock entities
- Support for recurring patterns
- Preserve calendar colors
- Two-way sync (future)

**Calendar Selection**
- Choose which calendars to sync
- Filter by calendar type
- Manage calendar permissions

### CloudKit Sync

**Multi-Device Support**
- Automatic sync across devices
- Conflict resolution
- Background sync
- Offline capability with sync on connection

**Sync Scope**
- All Core Data entities synced
- Settings and preferences
- User data and configurations
- Payoff queue and allocations

---

## Platform Requirements

### iOS Requirements

**Minimum Version**
- iOS 16.0 or later
- iPhone and iPad support
- Optimized for iPhone

**Device Capabilities**
- Core Data persistence
- CloudKit account required for sync
- Notification support
- Calendar access (optional)

### Performance Targets

**App Launch**
- Launch time: < 2 seconds
- Initial data load: < 1 second
- Smooth navigation transitions

**Real-Time Updates**
- Timer updates: 1 second intervals
- UI responsiveness: 60 FPS
- Calculation performance: < 10ms per update

**Data Operations**
- Shift creation: < 500ms
- Allocation calculation: < 100ms
- List loading: < 1 second for 100 items

---

## Success Metrics

### User Engagement

**Daily Active Users (DAU)**
- Target: Users open app daily to track shifts
- Measure: App launch events
- Goal: 70%+ of users track shifts daily

**Session Duration**
- Average session: 2-5 minutes
- Shift tracking sessions: 5-30 minutes
- Goal: Meaningful engagement per session

### Feature Adoption

**Core Features**
- Shift tracking: 90%+ of users
- Payoff queue: 70%+ of users
- Goals: 60%+ of users
- Time blocks: 40%+ of users

**Premium Conversion**
- Free to premium: 10-15% conversion rate
- Trial to paid: 30-40% conversion
- Retention: 60%+ monthly retention

### Financial Tracking Accuracy

**Data Quality**
- Shift accuracy: Users verify earnings match paychecks
- Allocation accuracy: Automatic allocations match user intent
- Goal progress: Users achieve goals using app

**User Satisfaction**
- App Store rating: 4.5+ stars
- User feedback: Positive sentiment
- Support tickets: Low volume, high resolution

---

## Appendix

### Key Terminology

- **Shift**: A work session with start and end times
- **TodayShift**: Active, real-time shift being tracked
- **Payoff Item**: Generic term for Expense or Goal
- **Allocation**: Money assigned from shift/saved item to expense/goal
- **Pay Period**: Time period grouping shifts (weekly, bi-weekly, monthly)
- **Time Block**: Activity segment within a shift
- **Payoff Queue**: Priority-ordered list of expenses and goals
- **Regular Schedule**: User's typical work schedule

### Data Flow Diagrams

**Shift to Allocation Flow**
1. User creates/completes shift
2. System calculates earnings
3. System applies percent-based expenses
4. System iterates payoff queue
5. System creates allocations
6. System updates item progress
7. System tracks remaining available

**TodayShift to Shift Flow**
1. User starts shift (creates TodayShift)
2. Real-time tracking with timer
3. User completes shift (reaches end time)
4. Banner appears, user taps Save
5. System converts TodayShift to Shift
6. System converts TemporaryAllocations to Allocations
7. TodayShift deleted, Shift saved

### Future Enhancements (Noted in Codebase)

**Planned Features**
- Enhanced debt tracking (interest rates, minimum payments)
- Smart payoff strategies (avalanche, snowball methods)
- Advanced deductions system (401k, insurance, etc.)
- Multiple wage rates (overtime, shift differentials)
- Schedule automation (auto-create shifts)
- Receipt scanning for expenses
- Bank account integration
- Advanced analytics and reporting
- Export capabilities (CSV, PDF)
- Widget support
- Apple Watch app

---

## Document Maintenance

This document should be updated whenever:
- New features are added
- Existing features are significantly modified
- Data models change
- User flows are updated
- Business logic changes
- Technical architecture evolves

**Version History**
- v1.0 (2025-01-27): Initial comprehensive PRD creation

---

**End of Document**

