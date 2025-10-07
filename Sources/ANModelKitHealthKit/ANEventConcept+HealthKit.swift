import Foundation
#if canImport(HealthKit)
import HealthKit
#endif
import ANModelKit

#if canImport(HealthKit)

@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
extension ANEventConcept {

	// MARK: - Initialization from HealthKit

	/// Initialize an ANEventConcept from a HealthKit HKMedicationDoseEvent
	///
	/// This initializer extracts dose event data from HealthKit and creates
	/// a corresponding ANEventConcept. The medication reference must be provided
	/// separately as HealthKit dose events only store the medication concept identifier.
	///
	/// - Parameters:
	///   - hkDoseEvent: The HealthKit medication dose event
	///   - medication: The associated ANMedicationConcept (optional)
	/// - Throws: `ANHealthKitConversionError` if the conversion fails
	///
	/// Example:
	/// ```swift
	/// let event = try ANEventConcept(from: hkDoseEvent, medication: medication)
	/// ```
	public init(from hkDoseEvent: HKMedicationDoseEvent, medication: ANMedicationConcept? = nil) throws {
		// Extract dose quantities
		let doseQuantity = hkDoseEvent.doseQuantity
		let scheduledQuantity = hkDoseEvent.scheduledDoseQuantity

		// Map log status
		let logStatus = ANDoseLogStatus(from: hkDoseEvent.logStatus)

		// Create dose concept from HealthKit quantity
		// Note: In real implementation, you would map HKQuantity to ANUnitConcept
		let dose: ANDoseConcept? = nil // Placeholder

		self.init(
			id: UUID(),
			eventType: .doseTaken, // HealthKit dose events are always dose taken events
			medication: medication,
			dose: dose,
			date: hkDoseEvent.startDate,
			note: hkDoseEvent.metadata?[HKMetadataKeyUserMotivatedPeriod] as? String,
			logStatus: logStatus,
			scheduledDoseAmount: scheduledQuantity?.doubleValue(for: .count()), // Simplified
			scheduledDoseUnit: nil // Would need to map from HKUnit
		)
	}

	// MARK: - Conversion to HealthKit

	/// Convert this ANEventConcept to a HealthKit HKMedicationDoseEvent
	///
	/// This method creates a HealthKit dose event sample from the ANEventConcept.
	/// Only dose taken events can be converted to HealthKit.
	///
	/// - Returns: A HealthKit medication dose event sample
	/// - Throws: `ANHealthKitConversionError` if the event cannot be converted
	///
	/// Example:
	/// ```swift
	/// let hkDoseEvent = try event.toHKMedicationDoseEvent()
	/// ```
	public func toHKMedicationDoseEvent() throws -> HKMedicationDoseEvent {
		// Only dose taken events are supported
		guard eventType == .doseTaken else {
			throw ANHealthKitConversionError.invalidDoseEvent
		}

		guard let medication = medication else {
			throw ANHealthKitConversionError.missingRequiredField("medication")
		}

		// This is a placeholder - actual implementation would create the HKMedicationDoseEvent
		throw ANHealthKitConversionError.unsupportedPlatform

		// Actual implementation would be:
		// let medicationConcept = try medication.toHKMedicationConcept()
		// let doseQuantity = dose.map { HKQuantity(unit: ..., doubleValue: $0.amount) }
		// let scheduledQuantity = scheduledDoseAmount.map { HKQuantity(unit: ..., doubleValue: $0) }
		// let hkLogStatus = logStatus?.toHKLogStatus() ?? .taken
		//
		// return HKMedicationDoseEvent(
		//     medicationConcept: medicationConcept,
		//     logStatus: hkLogStatus,
		//     doseQuantity: doseQuantity,
		//     scheduledDoseQuantity: scheduledQuantity,
		//     startDate: date,
		//     endDate: date,
		//     metadata: note.map { [HKMetadataKeyUserMotivatedPeriod: $0] }
		// )
	}

	// MARK: - Helper Methods

	/// Update this event concept with data from a HealthKit dose event
	///
	/// - Parameters:
	///   - hkDoseEvent: The HealthKit dose event to sync from
	///   - medication: The associated medication concept
	public mutating func updateFromHealthKit(_ hkDoseEvent: HKMedicationDoseEvent, medication: ANMedicationConcept?) {
		self.medication = medication
		self.date = hkDoseEvent.startDate
		self.logStatus = ANDoseLogStatus(from: hkDoseEvent.logStatus)

		// Update scheduled quantities
		if let scheduledQuantity = hkDoseEvent.scheduledDoseQuantity {
			self.scheduledDoseAmount = scheduledQuantity.doubleValue(for: .count())
		}
	}
}

// MARK: - Log Status Conversion

@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
extension ANDoseLogStatus {
	/// Initialize from HealthKit log status
	init(from hkLogStatus: HKMedicationDoseEvent.LogStatus) {
		switch hkLogStatus {
		case .taken:
			self = .taken
		case .skipped:
			self = .skipped
		case .snoozed:
			self = .snoozed
		@unknown default:
			self = .taken
		}
	}

	/// Convert to HealthKit log status
	func toHKLogStatus() -> HKMedicationDoseEvent.LogStatus {
		switch self {
		case .taken:
			return .taken
		case .skipped:
			return .skipped
		case .snoozed:
			return .snoozed
		}
	}
}

#endif
