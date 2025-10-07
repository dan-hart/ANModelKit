import Foundation

/// Types of events that can be logged for medication or dose: dose taken, reconciliation, symptom, or suspected side effect.
public enum ANEventType: String, Codable, CaseIterable, Equatable, Hashable, Sendable {
	case doseTaken = "dose_taken"
	case reconcile = "reconcile"
	case suspectedSideEffect = "suspected_side_effect"
}

/// Log status for dose events, matching HealthKit's HKMedicationDoseEvent log status.
public enum ANDoseLogStatus: String, Codable, CaseIterable, Equatable, Hashable, Sendable {
	/// The dose was taken as logged
	case taken
	/// The dose was explicitly skipped
	case skipped
	/// The dose reminder was snoozed for later
	case snoozed
}

/// Represents a logged event (such as a dose taken, or a reconciliation).
public struct ANEventConcept: Identifiable, Codable, Equatable, Hashable, Sendable {
	/// Unique identifier for this event
	public let id: UUID
	/// The type of event (e.g., dose taken, reconcile)
	public var eventType: ANEventType
	/// The medication concept involved in the event (optional)
	public var medication: ANMedicationConcept?
	/// The dose concept involved in the event (optional)
	public var dose: ANDoseConcept?
	/// The date of the event
	public var date: Date
	/// Optional note associated with the event
	public var note: String?

	// MARK: - HealthKit Integration Properties

	/// Log status for dose events (taken, skipped, snoozed)
	/// Maps to HealthKit's HKMedicationDoseEvent log status
	public var logStatus: ANDoseLogStatus?
	/// The scheduled dose amount (what was supposed to be taken)
	/// Used when the actual dose differs from the scheduled dose
	public var scheduledDoseAmount: Double?
	/// The scheduled dose unit (what unit was supposed to be taken)
	/// Used when the actual dose differs from the scheduled dose
	public var scheduledDoseUnit: ANUnitConcept?

	/// Initialize a new event concept
	public init(
		id: UUID = UUID(),
		eventType: ANEventType,
		medication: ANMedicationConcept? = nil,
		dose: ANDoseConcept? = nil,
		date: Date = Date(),
		note: String? = nil,
		logStatus: ANDoseLogStatus? = nil,
		scheduledDoseAmount: Double? = nil,
		scheduledDoseUnit: ANUnitConcept? = nil
	) {
		self.id = id
		self.eventType = eventType
		self.medication = medication
		self.dose = dose
		self.date = date
		self.note = note
		self.logStatus = logStatus
		self.scheduledDoseAmount = scheduledDoseAmount
		self.scheduledDoseUnit = scheduledDoseUnit
	}
	
	/// Create a redacted version with medication names removed
	public func redacted() -> ANEventConcept {
		return ANEventConcept(
			id: id,
			eventType: eventType,
			medication: medication?.redacted(),
			dose: dose,
			date: date,
			note: note,
			logStatus: logStatus,
			scheduledDoseAmount: scheduledDoseAmount,
			scheduledDoseUnit: scheduledDoseUnit
		)
	}
}

