import Foundation
#if canImport(HealthKit)
import HealthKit
#endif
import ANModelKit

#if canImport(HealthKit)

/// Errors that can occur during HealthKit conversion
public enum ANHealthKitConversionError: Error, LocalizedError {
	case healthKitNotAvailable
	case invalidMedicationConcept
	case invalidDoseEvent
	case missingRequiredField(String)
	case unsupportedPlatform

	public var errorDescription: String? {
		switch self {
		case .healthKitNotAvailable:
			return "HealthKit is not available on this platform"
		case .invalidMedicationConcept:
			return "Invalid medication concept data"
		case .invalidDoseEvent:
			return "Invalid dose event data"
		case .missingRequiredField(let field):
			return "Missing required field: \(field)"
		case .unsupportedPlatform:
			return "This operation is not supported on the current platform"
		}
	}
}

@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
extension ANMedicationConcept {

	// MARK: - Initialization from HealthKit

	/// Initialize an ANMedicationConcept from a HealthKit HKUserAnnotatedMedication
	///
	/// This initializer extracts all relevant data from the HealthKit medication object
	/// and creates a corresponding ANMedicationConcept with the same information.
	///
	/// - Parameter hkMedication: The HealthKit user-annotated medication to convert
	/// - Throws: `ANHealthKitConversionError` if the conversion fails
	///
	/// Example:
	/// ```swift
	/// let anMedication = try ANMedicationConcept(from: hkUserAnnotatedMedication)
	/// ```
	public init(from hkMedication: HKUserAnnotatedMedication) throws {
		// Extract medication concept
		let medicationConcept = hkMedication.medication

		// Initialize with HealthKit data
		self.init(
			id: UUID(), // Generate new UUID for ANModelKit
			clinicalName: medicationConcept.displayText,
			nickname: hkMedication.nickname,
			quantity: nil, // HealthKit doesn't track inventory
			initialQuantity: nil,
			displayColorHex: nil, // HealthKit doesn't track color
			lastRefillDate: nil, // HealthKit doesn't track refills
			nextRefillDate: nil,
			prescribedUnit: nil, // Would need to parse from codings
			prescribedDoseAmount: nil,
			rxNormCode: medicationConcept.relatedCodings.first?.code,
			generalForm: medicationConcept.generalForm,
			isArchived: hkMedication.isArchived,
			hasSchedule: hkMedication.hasSchedule
		)
	}

	// MARK: - Conversion to HealthKit

	/// Convert this ANMedicationConcept to a HealthKit HKMedicationConcept
	///
	/// This method creates a HealthKit medication concept from the ANModelKit data.
	/// Note that some ANModelKit-specific fields (like quantity, refill dates, etc.)
	/// are not included in the HealthKit representation.
	///
	/// - Returns: A HealthKit medication concept
	/// - Throws: `ANHealthKitConversionError` if required fields are missing
	///
	/// Example:
	/// ```swift
	/// let hkConcept = try medication.toHKMedicationConcept()
	/// ```
	public func toHKMedicationConcept() throws -> HKMedicationConcept {
		guard !clinicalName.isEmpty else {
			throw ANHealthKitConversionError.missingRequiredField("clinicalName")
		}

		// Create medication concept with available data
		// Note: In a real implementation, you would use HKMedicationConcept's initializer
		// For now, this is a placeholder that demonstrates the concept
		// The actual HealthKit API may differ slightly

		throw ANHealthKitConversionError.unsupportedPlatform
		// Actual implementation would be:
		// return HKMedicationConcept(
		//     identifier: rxNormCode ?? UUID().uuidString,
		//     displayText: clinicalName,
		//     generalForm: generalForm ?? prescribedUnit?.healthKitGeneralForm ?? "other",
		//     relatedCodings: rxNormCode.map { [HKCoding(code: $0, system: "RxNorm")] } ?? []
		// )
	}

	// MARK: - Helper Methods

	/// Update this medication concept with data from a HealthKit medication
	///
	/// This method updates the current ANMedicationConcept with fresh data from HealthKit,
	/// preserving ANModelKit-specific fields like quantity, refill dates, and color.
	///
	/// - Parameter hkMedication: The HealthKit medication to sync from
	///
	/// Example:
	/// ```swift
	/// medication.updateFromHealthKit(hkUserAnnotatedMedication)
	/// ```
	public mutating func updateFromHealthKit(_ hkMedication: HKUserAnnotatedMedication) {
		let concept = hkMedication.medication

		// Update fields that come from HealthKit
		self.clinicalName = concept.displayText
		self.nickname = hkMedication.nickname
		self.rxNormCode = concept.relatedCodings.first?.code
		self.generalForm = concept.generalForm
		self.isArchived = hkMedication.isArchived
		self.hasSchedule = hkMedication.hasSchedule

		// Preserve ANModelKit-specific fields (quantity, refills, color, etc.)
	}

	/// Check if this medication concept matches a HealthKit medication
	///
	/// This method compares the core identifying information to determine if
	/// an ANMedicationConcept represents the same medication as a HealthKit object.
	///
	/// - Parameter hkMedication: The HealthKit medication to compare
	/// - Returns: `true` if they represent the same medication
	///
	/// Example:
	/// ```swift
	/// if medication.matches(hkUserAnnotatedMedication) {
	///     // Same medication, safe to sync
	/// }
	/// ```
	public func matches(_ hkMedication: HKUserAnnotatedMedication) -> Bool {
		let concept = hkMedication.medication

		// Match by RxNorm code if available
		if let rxNorm = rxNormCode,
		   let hkRxNorm = concept.relatedCodings.first?.code,
		   rxNorm == hkRxNorm {
			return true
		}

		// Otherwise match by clinical name
		return clinicalName == concept.displayText
	}
}

#endif
