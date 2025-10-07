import Foundation
#if canImport(HealthKit)
import HealthKit
#endif
import ANModelKit

#if canImport(HealthKit)

/// Authorization manager for HealthKit medication data access
///
/// This class handles requesting and checking authorization status for accessing
/// medication data through HealthKit. It follows Apple's per-object authorization
/// model introduced with the Medications API.
///
/// ## Usage
/// ```swift
/// let authManager = ANHealthKitAuthorization.shared
///
/// // Request authorization
/// do {
///     try await authManager.requestMedicationAuthorization()
///     // Authorization granted, can access medication data
/// } catch {
///     // Handle authorization error
/// }
/// ```
///
/// - Important: Always request authorization before attempting to read or write medication data.
/// - Note: HealthKit uses a per-object authorization model. Users can selectively grant access to specific medications.
@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
public actor ANHealthKitAuthorization {

	/// Shared singleton instance
	public static let shared = ANHealthKitAuthorization()

	/// The HealthKit store instance
	private let healthStore: HKHealthStore

	/// Private initializer for singleton
	private init() {
		self.healthStore = HKHealthStore()
	}

	// MARK: - Authorization Status

	/// Check if HealthKit is available on the current device
	///
	/// - Returns: `true` if HealthKit is available
	public var isHealthKitAvailable: Bool {
		return HKHealthStore.isHealthDataAvailable()
	}

	/// Get authorization status for medication data
	///
	/// - Returns: The authorization status for reading medications
	///
	/// Note: Due to privacy, HealthKit may return `.notDetermined` even after authorization has been requested.
	public func authorizationStatus() -> HKAuthorizationStatus {
		let medicationType = HKObjectType.userAnnotatedMedicationType()
		return healthStore.authorizationStatus(for: medicationType)
	}

	// MARK: - Request Authorization

	/// Request authorization to access medication data
	///
	/// This method requests permission to read medication and dose event data from HealthKit.
	/// The system will present an authorization dialog to the user.
	///
	/// - Parameters:
	///   - requestWrite: Whether to also request write permission (default: false)
	///
	/// - Throws: Error if authorization request fails
	///
	/// Example:
	/// ```swift
	/// try await authManager.requestMedicationAuthorization()
	/// ```
	public func requestMedicationAuthorization(requestWrite: Bool = false) async throws {
		guard isHealthKitAvailable else {
			throw ANHealthKitConversionError.healthKitNotAvailable
		}

		// Define types to read
		let medicationType = HKObjectType.userAnnotatedMedicationType()
		let doseEventType = HKObjectType.medicationDoseEventType()

		let typesToRead: Set<HKObjectType> = [medicationType, doseEventType]

		// Define types to write (if requested)
		let typesToWrite: Set<HKSampleType>? = requestWrite ? [doseEventType] : nil

		// Request authorization
		try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
	}

	/// Request authorization for specific medications
	///
	/// With HealthKit's per-object authorization model, users can grant access to specific medications.
	/// This method is useful when you need to ensure access to particular medications.
	///
	/// - Parameter medicationIdentifiers: Array of medication concept identifiers to request access for
	/// - Throws: Error if authorization request fails
	///
	/// Example:
	/// ```swift
	/// try await authManager.requestAuthorizationForMedications(["med-uuid-1", "med-uuid-2"])
	/// ```
	public func requestAuthorizationForMedications(_ medicationIdentifiers: [String]) async throws {
		// In practice, this would use HKHealthStore's per-object authorization API
		// For now, we request general medication authorization
		try await requestMedicationAuthorization()
	}

	// MARK: - Helper Methods

	/// Check if the app can read medication data
	///
	/// - Returns: `true` if authorization has been granted (or is undetermined)
	///
	/// Note: Due to HealthKit privacy, this may return `true` even if authorization was denied,
	/// as apps cannot definitively determine denial status.
	public func canReadMedications() -> Bool {
		guard isHealthKitAvailable else {
			return false
		}

		let status = authorizationStatus()
		return status == .sharingAuthorized || status == .notDetermined
	}

	/// Check if the app can write medication dose events
	///
	/// - Returns: `true` if write authorization has been granted
	public func canWriteDoseEvents() -> Bool {
		guard isHealthKitAvailable else {
			return false
		}

		let doseEventType = HKObjectType.medicationDoseEventType()
		let status = healthStore.authorizationStatus(for: doseEventType)
		return status == .sharingAuthorized
	}

	/// Get the underlying HKHealthStore instance
	///
	/// Use this when you need direct access to the HealthKit store for advanced operations.
	///
	/// - Returns: The HKHealthStore instance
	public func getHealthStore() -> HKHealthStore {
		return healthStore
	}
}

// MARK: - HealthKit Type Extensions

@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
extension HKObjectType {
	/// Get the user-annotated medication type
	static func userAnnotatedMedicationType() -> HKObjectType {
		// Placeholder - actual implementation would use:
		// return HKObjectType.userAnnotatedMedicationType()
		return HKObjectType.categoryType(forIdentifier: .sleepAnalysis)! // Temporary placeholder
	}

	/// Get the medication dose event type
	static func medicationDoseEventType() -> HKSampleType {
		// Placeholder - actual implementation would use:
		// return HKObjectType.medicationDoseEventType()
		return HKObjectType.categoryType(forIdentifier: .sleepAnalysis)! // Temporary placeholder
	}
}

#endif
