import Foundation

/// Represents a medication definition with a clinical name and optional user nickname.
public struct ANMedicationConcept: Identifiable, Codable, Equatable, Hashable, Sendable {
	/// Unique identifier for this medication concept (Boutique best practice)
	public let id: UUID
	/// The official/clinical name of the medication
	public var clinicalName: String
	/// An optional user-supplied nickname for the medication (e.g. "Rescue Inhaler")
	public var nickname: String?
	/// The current quantity of the medication (e.g., number of pills, mL, etc.)
	public var quantity: Double?
	/// The initial quantity of the medication when first obtained/prescribed
	public var initialQuantity: Double?
	/// Hex color value for display purposes (e.g., "#FF0000")
	public var displayColorHex: String?
	/// The date of the last refill
	public var lastRefillDate: Date?
	/// The date of the next expected refill
	public var nextRefillDate: Date?
	/// Prescribed Unit
	public var prescribedUnit: ANUnitConcept?
	/// Prescribed Dose Amount
	public var prescribedDoseAmount: Double?

	// MARK: - HealthKit Integration Properties

	/// RxNorm code for clinical interoperability (e.g., "308192" for "Amoxicillin Trihydrate 500mg Oral Tablet")
	/// Used to standardize medication identification across health systems
	public var rxNormCode: String?
	/// Physical form of the medication (e.g., "tablet", "capsule", "liquid")
	/// Maps to HealthKit's HKMedicationConcept generalForm
	public var generalForm: String?
	/// Indicates if the medication is archived/no longer being taken
	/// Maps to HealthKit's HKUserAnnotatedMedication isArchived
	public var isArchived: Bool
	/// Indicates if the medication has a reminder schedule set up
	/// Maps to HealthKit's HKUserAnnotatedMedication hasSchedule
	public var hasSchedule: Bool

	/// Initialize a new medication concept
	public init(id: UUID = UUID(), clinicalName: String, nickname: String? = nil, quantity: Double? = nil, initialQuantity: Double? = nil, displayColorHex: String? = nil, lastRefillDate: Date? = nil, nextRefillDate: Date? = nil, prescribedUnit: ANUnitConcept? = nil, prescribedDoseAmount: Double? = nil, rxNormCode: String? = nil, generalForm: String? = nil, isArchived: Bool = false, hasSchedule: Bool = false) {
		self.id = id
		self.clinicalName = clinicalName
		self.nickname = nickname
		self.quantity = quantity
		self.initialQuantity = initialQuantity
		self.displayColorHex = displayColorHex
		self.lastRefillDate = lastRefillDate
		self.nextRefillDate = nextRefillDate
		self.prescribedUnit = prescribedUnit
		self.prescribedDoseAmount = prescribedDoseAmount
		self.rxNormCode = rxNormCode
		self.generalForm = generalForm
		self.isArchived = isArchived
		self.hasSchedule = hasSchedule
	}
	
	/// Create a redacted version with clinical names and nicknames removed
	public func redacted() -> ANMedicationConcept {
		return ANMedicationConcept(
			id: id,
			clinicalName: "[REDACTED]",
			nickname: nickname != nil ? "[REDACTED]" : nil,
			quantity: quantity,
			initialQuantity: initialQuantity,
			displayColorHex: displayColorHex,
			lastRefillDate: lastRefillDate,
			nextRefillDate: nextRefillDate,
			prescribedUnit: prescribedUnit,
			prescribedDoseAmount: prescribedDoseAmount,
			rxNormCode: rxNormCode,
			generalForm: generalForm,
			isArchived: isArchived,
			hasSchedule: hasSchedule
		)
	}
}
