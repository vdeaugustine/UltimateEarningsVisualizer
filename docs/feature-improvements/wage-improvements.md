# Wage Feature Improvements Analysis

## Current Wage System Overview

### Data Model
The wage system in UltimateEarningsVisualizer is built around a Core Data `Wage` entity with the following key attributes:
- **amount**: Base wage amount (hourly rate or annual salary)
- **isSalary**: Boolean flag indicating wage type
- **includeTaxes**: Whether tax calculations are enabled
- **federalTaxPercentage**: Federal tax rate
- **stateTaxPercentage**: State tax rate
- **hoursPerDay**: Default hours per day (8)
- **daysPerWeek**: Default days per week (5)
- **weeksPerYear**: Default weeks per year (52)

### Wage Types
Currently supports only two wage types:
1. **Hourly**: Direct hourly rate
2. **Salary**: Annual salary converted to hourly equivalent

### Calculation Methods
The system provides extensive wage calculations through the `ExtendWage` extension:
- **Time-based conversions**: perSecond, perMinute, hourly, perDay, perWeek, perMonth, perYear
- **Tax calculations**: Federal and state tax multipliers
- **Salary-to-hourly conversion**: Uses work assumptions (hours/day, days/week, weeks/year)

### Integration Points
1. **Shifts**: Calculate earnings based on duration × wage.perSecond
2. **TimeBlocks**: Similar calculation using duration × wage.perSecond
3. **TodayShift**: Real-time earnings tracking during active shifts
4. **User**: Central wage management through User.wage relationship

## Current Limitations

### 1. Limited Wage Flexibility
- **Single Rate System**: Only one wage rate at a time
- **No Overtime Support**: No automatic overtime calculations
- **No Shift Differentials**: Cannot handle night/weekend premiums
- **No Multiple Jobs**: Cannot track different rates for different jobs/clients

### 2. Basic Tax Handling
- **Flat Percentage Only**: No progressive tax brackets
- **No Pre-tax Deductions**: Cannot handle 401k, health insurance, etc.
- **Limited Tax Types**: Only federal and state, no local/city taxes
- **No Tax Withholding Tables**: Uses simple percentage calculation

### 3. Lack of Historical Tracking
- **No Wage History**: Cannot track wage changes over time
- **No Rate Effective Dates**: Changes apply globally to all calculations
- **No Retroactive Adjustments**: Cannot handle back pay scenarios

### 4. Missing Advanced Features
- **No Commission/Bonus Support**: Only handles base wage
- **No Tips Integration**: Cannot track tipped wages
- **No Piece Rate**: Cannot handle per-unit payment
- **No Salary Bands**: No min/max range tracking

### 5. UI/UX Limitations
- **Complex Navigation**: Wage editing requires multiple taps
- **Limited Visualization**: No charts showing wage trends
- **No Quick Actions**: Cannot easily toggle between wage scenarios
- **Confusing Tax Toggle**: Tax inclusion toggle affects all calculations

## Enhancement Recommendations

### Priority 1: Multiple Wage Rates (High Impact)

#### Implementation Details
1. **Create WageRate Entity**
   ```swift
   entity WageRate {
       amount: Double
       type: String // "regular", "overtime", "weekend", "night"
       effectiveDate: Date
       expirationDate: Date?
       conditions: String? // JSON for complex rules
       wage: Wage (relationship)
   }
   ```

2. **Modify Shift Calculations**
   - Add logic to detect overtime hours (>8/day or >40/week)
   - Apply appropriate rates based on shift timing
   - Support custom overtime rules

3. **UI Enhancements**
   - Add "Wage Rates" section in wage settings
   - Visual timeline showing rate changes
   - Quick toggle between different rate scenarios

### Priority 2: Advanced Tax System (High Impact)

#### Implementation Details
1. **Create TaxConfiguration Entity**
   ```swift
   entity TaxConfiguration {
       type: String // "federal", "state", "local"
       brackets: Data // JSON array of tax brackets
       standardDeduction: Double
       allowances: Int
       effectiveDate: Date
   }
   ```

2. **Pre-tax Deductions Support**
   - Add deduction types (401k, health, etc.)
   - Calculate taxable income after deductions
   - Show gross vs net earnings clearly

3. **Tax Calculation Engine**
   - Implement progressive tax bracket calculations
   - Support tax withholding tables
   - Annual tax projection features

### Priority 3: Wage History Tracking (Medium Impact)

#### Implementation Details
1. **Create WageHistory Entity**
   ```swift
   entity WageHistory {
       amount: Double
       effectiveDate: Date
       endDate: Date?
       reason: String?
       user: User
   }
   ```

2. **Historical Calculations**
   - Apply correct wage rate based on shift date
   - Handle retroactive pay adjustments
   - Generate wage progression reports

3. **UI Features**
   - Wage timeline visualization
   - Compare earnings across periods
   - Raise/promotion tracking

### Priority 4: Commission & Bonus Support (Medium Impact)

#### Implementation Details
1. **Extend Wage Model**
   - Add commission percentage field
   - Support tiered commission structures
   - Track bonus eligibility criteria

2. **Create Bonus Entity**
   ```swift
   entity Bonus {
       amount: Double
       type: String // "performance", "holiday", "signing"
       date: Date
       taxable: Bool
   }
   ```

3. **Earnings Integration**
   - Include bonuses in pay period calculations
   - Show commission projections
   - Track YTD bonus earnings

### Priority 5: Enhanced UI/UX (Low Impact, High User Satisfaction)

#### Implementation Details
1. **Quick Actions Widget**
   - Swipe actions for common wage operations
   - Today widget showing current rate
   - Quick overtime toggle

2. **Wage Dashboard**
   - Visual breakdown of all compensation types
   - Earnings projections and scenarios
   - Tax impact visualizations

3. **Smart Notifications**
   - Overtime threshold alerts
   - Wage review reminders
   - Tax withholding suggestions

## Implementation Roadmap

### Phase 1 (Weeks 1-2)
- Design and implement WageRate entity
- Basic overtime calculation support
- UI for managing multiple rates

### Phase 2 (Weeks 3-4)
- Advanced tax system implementation
- Pre-tax deductions support
- Tax projection features

### Phase 3 (Weeks 5-6)
- Wage history tracking
- Historical reporting features
- Retroactive adjustment support

### Phase 4 (Weeks 7-8)
- Commission and bonus features
- Enhanced UI/UX improvements
- Performance optimization

## Impact on Existing Features

### Shifts
- Minimal breaking changes
- Enhanced calculation accuracy
- Better earnings breakdown

### Allocations
- More accurate available income calculations
- Better tax-aware allocation suggestions

### Goals
- Improved savings projections
- More realistic timeline estimates

### Reports
- Richer earnings analytics
- Tax liability tracking
- Compensation trend analysis

## Technical Considerations

### Data Migration
- Preserve existing wage data
- Create default "regular" rate from current wage
- Maintain calculation consistency

### Performance
- Index wage lookup queries
- Cache frequently used calculations
- Optimize tax bracket lookups

### Testing Requirements
- Comprehensive unit tests for all calculation scenarios
- Integration tests for wage history
- UI tests for new wage management flows

## Conclusion

The current wage system provides basic functionality but lacks the flexibility needed for real-world wage scenarios. The proposed improvements would transform it into a comprehensive compensation management system that handles complex wage structures, accurate tax calculations, and historical tracking. Implementation should focus on maintaining backward compatibility while gradually introducing advanced features that users can opt into as needed.