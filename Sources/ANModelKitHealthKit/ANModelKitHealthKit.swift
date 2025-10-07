import Foundation
#if canImport(HealthKit)
import HealthKit
#endif
import ANModelKit

/// ANModelKitHealthKit provides seamless integration between ANModelKit and Apple's HealthKit Medications API.
///
/// This module extends ANModelKit's core medication tracking models with HealthKit-specific functionality,
/// enabling bidirectional synchronization with the Health app's medication data.
///
/// ## Key Features
/// - Convert between ANModelKit and HealthKit medication types
/// - Authorization management for medication data access
/// - Query helpers for retrieving medication and dose events
/// - Sync manager for keeping data in sync with Health app
///
/// ## Platform Support
/// - iOS 26.0+
/// - watchOS 13.0+
/// - visionOS 3.0+
///
/// ## Usage
/// ```swift
/// import ANModelKit
/// import ANModelKitHealthKit
///
/// // Convert ANMedicationConcept to HealthKit
/// #if canImport(HealthKit)
/// let hkMedication = try medication.toHKUserAnnotatedMedication()
/// #endif
/// ```
///
/// - Important: This module requires HealthKit framework and is only available on platforms that support HealthKit.
/// - Note: All HealthKit operations require proper authorization. See `ANHealthKitAuthorization` for details.
public struct ANModelKitHealthKit {
	/// The version of the ANModelKitHealthKit library
	public static let version = "1.0.0"

	/// Indicates whether HealthKit is available on the current platform
	public static var isHealthKitAvailable: Bool {
		#if canImport(HealthKit)
		return true
		#else
		return false
		#endif
	}
}
