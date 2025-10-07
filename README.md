# ANModelKit

[![Swift 6.2](https://img.shields.io/badge/swift-6.2-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20visionOS-lightgrey.svg)](https://github.com/apple/swift-package-manager)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-support-yellow.svg)](https://buymeacoffee.com/codedbydan)

A Swift package providing robust data models for medication tracking and dose logging applications. ANModelKit offers type-safe, privacy-focused models designed for healthcare and medication management apps.

## ⚠️ Important Medical Disclaimer

> **This library is for informational and organizational purposes only and should not be used as a substitute for professional medical advice, diagnosis, or treatment. Always consult with a qualified healthcare professional regarding medication management and dosing decisions.**

> **ANModelKit does not provide medical advice, drug interaction checking, or dosing recommendations. It is a data modeling framework only.**

## Features

- ✅ **Modern Swift 6**: Built with Swift 6.2 and modern concurrency support
- ✅ **Privacy-First**: Built-in redaction capabilities for sensitive medical data
- ✅ **Type-Safe Models**: Strongly typed medication, dose, and event concepts
- ✅ **Multi-Platform**: iOS 17+, macOS 14+, watchOS 10+, tvOS 17+, visionOS 1+
- ✅ **Comprehensive Units**: 30+ standardized medication units with clinical descriptions
- ✅ **Event Tracking**: Support for dose tracking, reconciliation, and side effect logging
- ✅ **Boutique Compatible**: Uses UUID identifiers following Boutique best practices
- ✅ **Fully Tested**: Comprehensive test coverage with 25+ unit tests
- ✅ **Zero Dependencies**: Pure Swift with Foundation only
- 🆕 **HealthKit Integration**: Optional module for iOS 26+ HealthKit Medications API
- 🆕 **RxNorm Support**: Clinical interoperability with standardized medication codes
- 🆕 **Bidirectional Sync**: Keep data in sync with Apple Health app

## Installation

### Swift Package Manager

Add ANModelKit to your project via Xcode or by adding it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/dan-hart/ANModelKit.git", from: "1.0.0")
]

// For HealthKit integration, also add:
.product(name: "ANModelKitHealthKit", package: "ANModelKit")
```

## Quick Start

```swift
import ANModelKit

// Create a medication concept
let albuterol = ANMedicationConcept(
    clinicalName: "Albuterol Sulfate",
    nickname: "Rescue Inhaler",
    quantity: 200.0,
    prescribedUnit: .puff,
    prescribedDoseAmount: 2.0
)

// Create a dose concept
let dose = ANDoseConcept(amount: 2.0, unit: .puff)

// Log a dose taken event
let doseEvent = ANEventConcept(
    eventType: .doseTaken,
    medication: albuterol,
    dose: dose,
    date: Date()
)

// Privacy: Create redacted versions for sharing/analytics
let redactedMedication = albuterol.redacted()
print(redactedMedication.clinicalName) // "[REDACTED]"
print(redactedMedication.quantity) // 200.0 (non-sensitive data preserved)
```

## Core Models

### ANMedicationConcept

Represents a medication with clinical information and user customization:

```swift
public struct ANMedicationConcept: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: UUID
    public var clinicalName: String
    public var nickname: String?
    public var quantity: Double?
    public var lastRefillDate: Date?
    public var nextRefillDate: Date?
    public var prescribedUnit: ANUnitConcept?
    public var prescribedDoseAmount: Double?
}
```

**Key Features:**
- Unique UUID identifier (Boutique compatible)
- Clinical name and optional user nickname
- Inventory tracking with quantities and refill dates
- Prescribed dosing information
- Privacy-focused `redacted()` method

### ANDoseConcept

Represents a specific dose amount and unit:

```swift
public struct ANDoseConcept: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: UUID
    public var amount: Double
    public var unit: ANUnitConcept
}
```

**Use Cases:**
- Logging actual doses taken
- Storing prescribed dose information
- Dose calculations and conversions

### ANEventConcept

Tracks medication-related events with flexible event types:

```swift
public struct ANEventConcept: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: UUID
    public var eventType: ANEventType
    public var medication: ANMedicationConcept?
    public var dose: ANDoseConcept?
    public var date: Date
}
```

**Supported Event Types:**
- `.doseTaken` - Record when a dose was administered
- `.reconcile` - Medication reconciliation events
- `.suspectedSideEffect` - Track potential adverse reactions

### ANUnitConcept

Comprehensive medication units with clinical context:

```swift
public enum ANUnitConcept: String, Codable, CaseIterable {
    case milligram, gram, microgram, unit, tablet, capsule, 
         chewable, lozenge, suppository, milliliter, liter,
         teaspoon, drop, sachet, puff, actuation, nebule,
         vial, patch, application, spray, strip, film, 
         dose, ampule
}
```

**Features:**
- 30+ standardized medication units
- Clinical descriptions for each unit
- Standard medical abbreviations
- Singular/plural display names
- Common units subset for UI pickers

## Advanced Usage

### Privacy and Data Protection

ANModelKit includes built-in privacy features for handling sensitive medical data:

```swift
let medication = ANMedicationConcept(
    clinicalName: "Sensitive Medication Name",
    nickname: "Personal Nickname"
)

// Create redacted version for analytics or sharing
let redacted = medication.redacted()
// Clinical name and nickname are redacted, but structure preserved
```

### Comprehensive Unit System

```swift
// Access unit metadata
let unit = ANUnitConcept.milligram
print(unit.displayName) // "Milligram"
print(unit.abbreviation) // "mg"
print(unit.clinicalDescription) // "A metric unit of mass commonly used for medication dosing."

// Localization-ready pluralization
print(unit.displayName(for: 1)) // "Milligram"
print(unit.displayName(for: 2)) // "Milligrams"

// UI Integration
let commonUnits = ANUnitConcept.commonUnits // For pickers and common scenarios
let allUnits = ANUnitConcept.selectableUnits // Complete list
```

### Event Tracking Patterns

```swift
// Track a dose taken
let doseEvent = ANEventConcept(
    eventType: .doseTaken,
    medication: medication,
    dose: ANDoseConcept(amount: 10.0, unit: .milligram)
)

// Log medication reconciliation
let reconcileEvent = ANEventConcept(
    eventType: .reconcile,
    medication: medication,
    date: Date()
)

// Track suspected side effect
let sideEffectEvent = ANEventConcept(
    eventType: .suspectedSideEffect,
    medication: medication
)
```

## Testing

ANModelKit includes comprehensive test coverage:

```bash
# Run all tests
swift test

# Test specific functionality
swift test --filter "ANMedicationConcept"
swift test --filter "ANUnitConcept"
swift test --filter "ANEventConcept"
```

**Test Coverage:**
- ✅ Model initialization and relationships  
- ✅ Codable serialization/deserialization
- ✅ Privacy redaction functionality
- ✅ Unit system completeness and correctness
- ✅ Event type handling
- ✅ Edge cases and error conditions

## Integration Examples

### SwiftUI Integration

```swift
import SwiftUI
import ANModelKit

struct MedicationRowView: View {
    let medication: ANMedicationConcept
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(medication.nickname ?? medication.clinicalName)
                .font(.headline)
            
            if let unit = medication.prescribedUnit,
               let amount = medication.prescribedDoseAmount {
                Text("Prescribed: \\(amount, specifier: "%.1f") \\(unit.abbreviation)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
```

### Core Data Integration

```swift
import CoreData
import ANModelKit

// Convert ANModelKit models to Core Data entities
extension MedicationEntity {
    func updateFromConcept(_ concept: ANMedicationConcept) {
        self.id = concept.id
        self.clinicalName = concept.clinicalName
        self.nickname = concept.nickname
        self.quantity = concept.quantity ?? 0
        self.prescribedUnitRaw = concept.prescribedUnit?.rawValue
        self.prescribedDoseAmount = concept.prescribedDoseAmount ?? 0
    }
    
    func toConcept() -> ANMedicationConcept {
        return ANMedicationConcept(
            id: self.id ?? UUID(),
            clinicalName: self.clinicalName ?? "",
            nickname: self.nickname,
            quantity: self.quantity > 0 ? self.quantity : nil,
            prescribedUnit: prescribedUnitRaw.map { ANUnitConcept(rawValue: $0) } ?? nil,
            prescribedDoseAmount: prescribedDoseAmount > 0 ? prescribedDoseAmount : nil
        )
    }
}
```

## Requirements

### Core Package
- **Swift**: 6.2+
- **Platforms**: iOS 17.0+ / macOS 14.0+ / watchOS 10.0+ / tvOS 17.0+ / visionOS 1.0+
- **Dependencies**: None (Foundation only)

### HealthKit Integration (Optional)
- **Swift**: 6.2+
- **Platforms**: iOS 26.0+ / watchOS 13.0+ / visionOS 3.0+
- **Dependencies**: ANModelKit, HealthKit framework
- **Note**: Requires HealthKit entitlement in your app

## Architecture Notes

ANModelKit follows several key design principles:

1. **Privacy by Design**: Sensitive medical data can be easily redacted
2. **Type Safety**: Strong typing prevents common medication tracking errors
3. **Extensibility**: Enum-based designs allow for future expansion
4. **Integration Friendly**: Works well with Core Data, Boutique, and other persistence layers
5. **Platform Agnostic**: Pure data models with no UI dependencies

## API Stability

ANModelKit follows semantic versioning. The public API is considered stable for 1.x releases:

- ✅ **Stable**: All public model structures and methods
- ✅ **Stable**: ANUnitConcept cases and properties
- ✅ **Stable**: ANEventType cases
- ⚠️ **Additive**: New units or event types may be added in minor releases

## License

ANModelKit is released under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines

1. Maintain test coverage above 95%
2. Follow Swift API Design Guidelines
3. Add clinical descriptions for new medication units
4. Consider privacy implications for new fields
5. Ensure backward compatibility

## Support

- **Issues**: [GitHub Issues](https://github.com/dan-hart/ANModelKit/issues)
- **Medical Disclaimers**: Always consult healthcare professionals for medical advice
- **Privacy**: Review privacy handling before storing sensitive medical data

## HealthKit Integration

ANModelKit provides optional HealthKit integration through the `ANModelKitHealthKit` module, enabling seamless synchronization with Apple's Health app medication data (iOS 26+).

### Setup

1. **Add HealthKit Capability**
   - In Xcode, add HealthKit capability to your target
   - Enable "Clinical Health Records" in capabilities

2. **Update Info.plist**
   ```xml
   <key>NSHealthShareUsageDescription</key>
   <string>We need access to your medication data to track your doses</string>
   <key>NSHealthUpdateUsageDescription</key>
   <string>We need to save dose events to your Health app</string>
   ```

3. **Import the Module**
   ```swift
   import ANModelKit
   import ANModelKitHealthKit
   ```

### Authorization

Request authorization before accessing HealthKit medication data:

```swift
#if canImport(HealthKit)
import ANModelKitHealthKit

let auth = ANHealthKitAuthorization.shared

do {
    try await auth.requestMedicationAuthorization()
    print("Authorization granted")
} catch {
    print("Authorization failed: \(error)")
}
#endif
```

### Reading Medications from HealthKit

```swift
let queryHelper = ANHealthKitQuery()

// Fetch active medications
let medications = try await queryHelper.fetchActiveMedications()

// Fetch all medications including archived
let allMedications = try await queryHelper.fetchAllMedications()

// Fetch only medications with schedules
let scheduled = try await queryHelper.fetchMedications(
    includeArchived: false,
    onlyWithSchedule: true
)
```

### Reading Dose Events

```swift
// Fetch dose events for a date range
let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
let events = try await queryHelper.fetchDoseEvents(from: weekAgo, to: Date())

// Fetch dose events for specific medication
let medEvents = try await queryHelper.fetchDoseEvents(for: medication)

// Fetch recent dose events (last 7 days)
let recentEvents = try await queryHelper.fetchRecentDoseEvents()
```

### Writing Dose Events

```swift
let event = ANEventConcept(
    eventType: .doseTaken,
    medication: medication,
    dose: dose,
    logStatus: .taken
)

try await queryHelper.saveDoseEvent(event)
```

### Synchronization Options

ANModelKit provides flexible sync patterns for different use cases:

| Sync Type | Direction | Method | Use Case |
|-----------|-----------|--------|----------|
| **Pull** | HealthKit → Local | `pullFromHealthKit()` | Import from Health app, initial setup |
| **Push** | Local → HealthKit | `pushToHealthKit()` | Backup dose events, migration |
| **Bidirectional** | ↔️ Both ways | `performFullSync()` | Keep everything in sync |

#### One-Way Sync: Pull from HealthKit → Local

Fetch HealthKit data without pushing local changes:

```swift
let syncManager = ANHealthKitSync()

// Pull all medications and recent dose events from HealthKit
let result = try await syncManager.pullFromHealthKit(daysOfEvents: 30)

// Update local storage with HealthKit data
myMedications = result.medicationsAdded
myEvents = result.eventsAdded

print("Pulled \(result.medicationsAdded.count) medications from HealthKit")
print("Pulled \(result.eventsAdded.count) dose events from HealthKit")
```

**Use cases:**
- Initial app setup/onboarding
- User wants to import from Health app
- Ensuring local data matches HealthKit

#### One-Way Sync: Push from Local → HealthKit

Push local dose events to HealthKit without fetching:

```swift
// Push local dose events to HealthKit
let result = try await syncManager.pushToHealthKit(events: myLocalEvents)

if result.errors.isEmpty {
    print("Successfully pushed \(myLocalEvents.count) events to HealthKit")
} else {
    print("Failed to push \(result.errors.count) events")
}
```

**Use cases:**
- Backup local data to HealthKit
- Migrating from another app
- Ensuring HealthKit has complete history

**Note:** Only dose events can be pushed. Medications are managed by the user in the Health app.

#### Bidirectional Sync

Keep your local data in sync with HealthKit in both directions:

```swift
let syncManager = ANHealthKitSync()

// Perform full bidirectional sync
let result = try await syncManager.performFullSync(
    localMedications: myMedications,
    localEvents: myEvents,
    syncStrategy: .newerWins
)

print("Synced \(result.totalChanges) changes")
print("Added: \(result.medicationsAdded.count) medications")
print("Updated: \(result.medicationsUpdated.count) medications")

// Start background sync
try await syncManager.startBackgroundSync(interval: 300) { syncResult in
    if syncResult.totalChanges > 0 {
        // Update your local storage
        await updateLocalData(with: syncResult)
    }
}
```

**Sync strategies:**
- `.healthKitWins` - HealthKit data always takes priority
- `.localWins` - Local data always takes priority
- `.newerWins` - Most recent modification wins
- `.custom((local, healthKit) -> ANMedicationConcept)` - Custom resolution logic

### Background Sync with Observer Queries

Monitor real-time changes from HealthKit:

```swift
let observerQuery = try await queryHelper.observeMedicationChanges { medications in
    // Handle medication changes
    await updateUI(with: medications)
}

// Later, to stop observing:
healthStore.stop(observerQuery)
```

### Converting Between ANModelKit and HealthKit

```swift
// ANMedicationConcept → HealthKit
#if canImport(HealthKit)
let hkMedication = try medication.toHKMedicationConcept()
#endif

// HealthKit → ANMedicationConcept
let anMedication = try ANMedicationConcept(from: hkUserAnnotatedMedication)

// Update existing medication from HealthKit
medication.updateFromHealthKit(hkUserAnnotatedMedication)

// Check if medication matches HealthKit data
if medication.matches(hkUserAnnotatedMedication) {
    // Same medication
}
```

### RxNorm Codes for Clinical Interoperability

```swift
let medication = ANMedicationConcept(
    clinicalName: "Amoxicillin Trihydrate 500mg Oral Tablet",
    rxNormCode: "308192",  // RxNorm code for standardization
    generalForm: "tablet"   // Physical form
)

// HealthKit will use the RxNorm code for matching and interoperability
```

### Platform Availability

HealthKit integration is only available on platforms that support HealthKit:

```swift
#if canImport(HealthKit)
if ANModelKitHealthKit.isHealthKitAvailable {
    // HealthKit features available
} else {
    // Fall back to local-only storage
}
#endif
```

### Best Practices

1. **Always check authorization status** before attempting HealthKit operations
2. **Use incremental sync** for efficiency with `performIncrementalSync()`
3. **Handle per-object authorization**: Users can selectively share medications
4. **Store sync anchors** to avoid re-fetching unchanged data
5. **Implement conflict resolution**: Choose appropriate `ANHealthKitSyncStrategy`
6. **Test on actual devices**: HealthKit doesn't work in simulator for all features
7. **Respect user privacy**: Only request the minimum necessary permissions

---

**Disclaimer**: This software is provided "as is" without warranty of any kind. The authors and contributors are not responsible for any consequences of using this software. Always consult with healthcare professionals for medical advice and medication management.