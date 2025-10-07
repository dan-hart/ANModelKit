import Foundation
#if canImport(HealthKit)
import HealthKit
#endif
import ANModelKit

#if canImport(HealthKit)

/// Query helper for retrieving medication and dose event data from HealthKit
///
/// This class provides convenient methods for querying HealthKit medication data
/// and converting it to ANModelKit types. It supports various query patterns including
/// simple queries, anchored queries for efficient syncing, and observer queries for
/// real-time updates.
///
/// ## Usage
/// ```swift
/// let queryHelper = ANHealthKitQuery(healthStore: healthStore)
///
/// // Fetch all active medications
/// let medications = try await queryHelper.fetchActiveMedications()
///
/// // Fetch dose events for a date range
/// let events = try await queryHelper.fetchDoseEvents(from: startDate, to: endDate)
/// ```
@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
public actor ANHealthKitQuery {

	/// The HealthKit store instance
	private let healthStore: HKHealthStore

	/// Initialize with a HealthKit store
	///
	/// - Parameter healthStore: The HKHealthStore instance to use for queries
	public init(healthStore: HKHealthStore) {
		self.healthStore = healthStore
	}

	/// Convenience initializer using the shared authorization manager
	public init() {
		self.healthStore = HKHealthStore()
	}

	// MARK: - Medication Queries

	/// Fetch all active (non-archived) medications from HealthKit
	///
	/// - Parameter limit: Optional limit on number of results (default: no limit)
	/// - Returns: Array of ANMedicationConcept objects
	/// - Throws: Error if query fails or authorization is missing
	///
	/// Example:
	/// ```swift
	/// let medications = try await queryHelper.fetchActiveMedications()
	/// ```
	public func fetchActiveMedications(limit: Int? = nil) async throws -> [ANMedicationConcept] {
		return try await fetchMedications(includeArchived: false, limit: limit)
	}

	/// Fetch all medications from HealthKit, including archived ones
	///
	/// - Parameter limit: Optional limit on number of results
	/// - Returns: Array of ANMedicationConcept objects
	/// - Throws: Error if query fails or authorization is missing
	public func fetchAllMedications(limit: Int? = nil) async throws -> [ANMedicationConcept] {
		return try await fetchMedications(includeArchived: true, limit: limit)
	}

	/// Fetch medications with custom filtering
	///
	/// - Parameters:
	///   - includeArchived: Whether to include archived medications
	///   - onlyWithSchedule: If true, only fetch medications with schedules
	///   - limit: Optional limit on number of results
	/// - Returns: Array of ANMedicationConcept objects
	/// - Throws: Error if query fails
	///
	/// Example:
	/// ```swift
	/// // Fetch only scheduled, active medications
	/// let scheduled = try await queryHelper.fetchMedications(
	///     includeArchived: false,
	///     onlyWithSchedule: true
	/// )
	/// ```
	public func fetchMedications(
		includeArchived: Bool = false,
		onlyWithSchedule: Bool = false,
		limit: Int? = nil
	) async throws -> [ANMedicationConcept] {
		// This is a placeholder implementation
		// Actual implementation would use HKUserAnnotatedMedicationQueryDescriptor

		// Example of what the real implementation would look like:
		// let queryDescriptor = HKUserAnnotatedMedicationQueryDescriptor()
		// if !includeArchived {
		//     queryDescriptor.predicate = HKQuery.predicateForUserAnnotatedMedications(isArchived: false)
		// }
		// if onlyWithSchedule {
		//     let schedulePredicate = HKQuery.predicateForUserAnnotatedMedications(hasSchedule: true)
		//     queryDescriptor.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
		//         queryDescriptor.predicate,
		//         schedulePredicate
		//     ])
		// }
		// if let limit = limit {
		//     queryDescriptor.limit = limit
		// }
		//
		// let results = try await queryDescriptor.results(for: healthStore)
		// return try results.map { try ANMedicationConcept(from: $0) }

		return [] // Placeholder
	}

	// MARK: - Dose Event Queries

	/// Fetch dose events for a specific date range
	///
	/// - Parameters:
	///   - startDate: Start of the date range
	///   - endDate: End of the date range
	///   - medicationID: Optional medication identifier to filter by
	///   - logStatus: Optional log status to filter by
	/// - Returns: Array of ANEventConcept objects
	/// - Throws: Error if query fails
	///
	/// Example:
	/// ```swift
	/// // Fetch all dose events from the past week
	/// let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
	/// let events = try await queryHelper.fetchDoseEvents(from: weekAgo, to: Date())
	/// ```
	public func fetchDoseEvents(
		from startDate: Date,
		to endDate: Date,
		medicationID: String? = nil,
		logStatus: ANDoseLogStatus? = nil
	) async throws -> [ANEventConcept] {
		// Placeholder implementation
		// Real implementation would:
		// 1. Create HKSampleQuery with date predicate
		// 2. Optionally add medication identifier predicate
		// 3. Optionally add log status predicate
		// 4. Execute query and convert results to ANEventConcept

		return [] // Placeholder
	}

	/// Fetch dose events for a specific medication
	///
	/// - Parameters:
	///   - medication: The medication to fetch events for
	///   - limit: Optional limit on number of results
	/// - Returns: Array of ANEventConcept objects
	/// - Throws: Error if query fails
	public func fetchDoseEvents(
		for medication: ANMedicationConcept,
		limit: Int? = nil
	) async throws -> [ANEventConcept] {
		// Placeholder - would use medication's rxNormCode or identifier to query
		return [] // Placeholder
	}

	/// Fetch recent dose events (last 7 days by default)
	///
	/// - Parameter days: Number of days to look back (default: 7)
	/// - Returns: Array of ANEventConcept objects
	/// - Throws: Error if query fails
	public func fetchRecentDoseEvents(days: Int = 7) async throws -> [ANEventConcept] {
		let endDate = Date()
		let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate) ?? endDate

		return try await fetchDoseEvents(from: startDate, to: endDate)
	}

	// MARK: - Anchored Queries for Sync

	/// Perform an anchored query for medications
	///
	/// Anchored queries are efficient for syncing as they only return changes since
	/// the last query. Store the returned anchor and use it for the next query.
	///
	/// - Parameter anchor: The anchor from the previous query (nil for initial query)
	/// - Returns: Tuple of (new/updated medications, deleted medication IDs, new anchor)
	/// - Throws: Error if query fails
	///
	/// Example:
	/// ```swift
	/// var anchor: HKQueryAnchor? = nil
	/// let (medications, deletedIDs, newAnchor) = try await queryHelper.fetchMedicationsChanges(anchor: anchor)
	/// anchor = newAnchor // Store for next sync
	/// ```
	public func fetchMedicationsChanges(
		anchor: HKQueryAnchor?
	) async throws -> (medications: [ANMedicationConcept], deletedIDs: [String], anchor: HKQueryAnchor) {
		// Placeholder for anchored query implementation
		return ([], [], HKQueryAnchor(fromValue: 0))
	}

	/// Perform an anchored query for dose events
	///
	/// - Parameter anchor: The anchor from the previous query
	/// - Returns: Tuple of (new/updated events, deleted event IDs, new anchor)
	/// - Throws: Error if query fails
	public func fetchDoseEventsChanges(
		anchor: HKQueryAnchor?
	) async throws -> (events: [ANEventConcept], deletedIDs: [String], anchor: HKQueryAnchor) {
		// Placeholder for anchored query implementation
		return ([], [], HKQueryAnchor(fromValue: 0))
	}

	// MARK: - Observer Queries

	/// Start observing medication changes in HealthKit
	///
	/// This sets up an observer query that calls the provided handler whenever
	/// medication data changes in HealthKit.
	///
	/// - Parameter updateHandler: Closure called when medications are updated
	/// - Returns: The HKObserverQuery instance (keep a strong reference to it)
	///
	/// Example:
	/// ```swift
	/// let observerQuery = try await queryHelper.observeMedicationChanges { medications in
	///     // Handle medication changes
	/// }
	/// // Later, to stop observing:
	/// healthStore.stop(observerQuery)
	/// ```
	public func observeMedicationChanges(
		updateHandler: @escaping @Sendable ([ANMedicationConcept]) async -> Void
	) async throws -> HKObserverQuery {
		// Placeholder - actual implementation would create and execute HKObserverQuery
		let medicationType = HKObjectType.userAnnotatedMedicationType()

		let query = HKObserverQuery(sampleType: medicationType as! HKSampleType, predicate: nil) { query, completionHandler, error in
			Task {
				// When changes detected, fetch updated medications
				let medications = try? await self.fetchActiveMedications()
				await updateHandler(medications ?? [])
				completionHandler()
			}
		}

		healthStore.execute(query)
		return query
	}

	/// Start observing dose event changes in HealthKit
	///
	/// - Parameter updateHandler: Closure called when dose events are updated
	/// - Returns: The HKObserverQuery instance
	public func observeDoseEventChanges(
		updateHandler: @escaping @Sendable ([ANEventConcept]) async -> Void
	) async throws -> HKObserverQuery {
		let doseEventType = HKObjectType.medicationDoseEventType()

		let query = HKObserverQuery(sampleType: doseEventType, predicate: nil) { query, completionHandler, error in
			Task {
				let events = try? await self.fetchRecentDoseEvents()
				await updateHandler(events ?? [])
				completionHandler()
			}
		}

		healthStore.execute(query)
		return query
	}

	// MARK: - Write Operations

	/// Save a dose event to HealthKit
	///
	/// - Parameter event: The ANEventConcept to save
	/// - Throws: Error if save fails or authorization is missing
	///
	/// Example:
	/// ```swift
	/// let event = ANEventConcept(
	///     eventType: .doseTaken,
	///     medication: medication,
	///     dose: dose,
	///     logStatus: .taken
	/// )
	/// try await queryHelper.saveDoseEvent(event)
	/// ```
	public func saveDoseEvent(_ event: ANEventConcept) async throws {
		let hkDoseEvent = try event.toHKMedicationDoseEvent()
		try await healthStore.save(hkDoseEvent)
	}

	/// Save multiple dose events to HealthKit
	///
	/// - Parameter events: Array of ANEventConcept objects to save
	/// - Throws: Error if save fails
	public func saveDoseEvents(_ events: [ANEventConcept]) async throws {
		let hkEvents = try events.map { try $0.toHKMedicationDoseEvent() }
		try await healthStore.save(hkEvents)
	}

	/// Delete a dose event from HealthKit
	///
	/// - Parameter event: The ANEventConcept to delete
	/// - Throws: Error if delete fails
	public func deleteDoseEvent(_ event: ANEventConcept) async throws {
		// Would need to track HKMedicationDoseEvent UUID for deletion
		// Placeholder implementation
	}
}

#endif
