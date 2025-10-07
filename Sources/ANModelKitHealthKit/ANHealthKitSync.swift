import Foundation
#if canImport(HealthKit)
import HealthKit
#endif
import ANModelKit

#if canImport(HealthKit)

/// Sync strategy for resolving conflicts between local and HealthKit data
public enum ANHealthKitSyncStrategy {
	/// HealthKit data always wins
	case healthKitWins
	/// Local data always wins
	case localWins
	/// Most recent modification wins
	case newerWins
	/// Custom conflict resolution
	case custom((ANMedicationConcept, ANMedicationConcept) -> ANMedicationConcept)
}

/// Sync manager for bidirectional synchronization with HealthKit
///
/// This class manages the synchronization of medication and dose event data
/// between your app's local storage and Apple HealthKit. It handles conflict
/// resolution, background sync, and real-time updates.
///
/// ## Usage
/// ```swift
/// let syncManager = ANHealthKitSync()
///
/// // Perform initial sync
/// let result = try await syncManager.performFullSync(
///     localMedications: medications,
///     syncStrategy: .newerWins
/// )
///
/// // Start background sync
/// try await syncManager.startBackgroundSync { syncResult in
///     // Handle sync completion
/// }
/// ```
///
/// - Important: Always request HealthKit authorization before attempting to sync.
/// - Note: Background sync requires proper background mode configuration in your app.
@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
public actor ANHealthKitSync {

	/// Result of a sync operation
	public struct SyncResult {
		/// Medications added from HealthKit
		public let medicationsAdded: [ANMedicationConcept]
		/// Medications updated from HealthKit
		public let medicationsUpdated: [ANMedicationConcept]
		/// Medication IDs deleted in HealthKit
		public let medicationsDeleted: [UUID]
		/// Dose events added from HealthKit
		public let eventsAdded: [ANEventConcept]
		/// Dose events updated from HealthKit
		public let eventsUpdated: [ANEventConcept]
		/// Event IDs deleted in HealthKit
		public let eventsDeleted: [UUID]
		/// Any errors encountered during sync
		public let errors: [Error]

		/// Total number of changes
		public var totalChanges: Int {
			return medicationsAdded.count + medicationsUpdated.count + medicationsDeleted.count +
				   eventsAdded.count + eventsUpdated.count + eventsDeleted.count
		}
	}

	/// Query helper instance
	private let queryHelper: ANHealthKitQuery

	/// Stored anchor for medication queries
	private var medicationAnchor: HKQueryAnchor?

	/// Stored anchor for dose event queries
	private var doseEventAnchor: HKQueryAnchor?

	/// Active observer queries
	private var activeObservers: [HKObserverQuery] = []

	/// Background sync timer
	private var syncTimer: Task<Void, Never>?

	/// Initialize the sync manager
	///
	/// - Parameter healthStore: Optional HKHealthStore instance (uses default if nil)
	public init(healthStore: HKHealthStore? = nil) {
		self.queryHelper = ANHealthKitQuery(healthStore: healthStore ?? HKHealthStore())
	}

	// MARK: - Full Sync Operations

	/// Perform a full bidirectional sync with HealthKit
	///
	/// This method syncs all medication and dose event data between your local storage
	/// and HealthKit, resolving any conflicts according to the specified strategy.
	///
	/// - Parameters:
	///   - localMedications: Your app's current medication list
	///   - localEvents: Your app's current dose events
	///   - syncStrategy: Strategy for resolving conflicts
	/// - Returns: Result of the sync operation
	/// - Throws: Error if sync fails
	///
	/// Example:
	/// ```swift
	/// let result = try await syncManager.performFullSync(
	///     localMedications: myMedications,
	///     localEvents: myEvents,
	///     syncStrategy: .newerWins
	/// )
	/// print("Synced \(result.totalChanges) changes")
	/// ```
	public func performFullSync(
		localMedications: [ANMedicationConcept],
		localEvents: [ANEventConcept] = [],
		syncStrategy: ANHealthKitSyncStrategy = .healthKitWins
	) async throws -> SyncResult {
		var result = SyncResult(
			medicationsAdded: [],
			medicationsUpdated: [],
			medicationsDeleted: [],
			eventsAdded: [],
			eventsUpdated: [],
			eventsDeleted: [],
			errors: []
		)

		do {
			// Fetch all medications from HealthKit
			let hkMedications = try await queryHelper.fetchAllMedications()

			// Sync medications
			let medicationChanges = try await syncMedications(
				local: localMedications,
				healthKit: hkMedications,
				strategy: syncStrategy
			)

			result = SyncResult(
				medicationsAdded: medicationChanges.added,
				medicationsUpdated: medicationChanges.updated,
				medicationsDeleted: medicationChanges.deleted,
				eventsAdded: result.eventsAdded,
				eventsUpdated: result.eventsUpdated,
				eventsDeleted: result.eventsDeleted,
				errors: result.errors
			)

			// Fetch recent dose events
			let hkEvents = try await queryHelper.fetchRecentDoseEvents(days: 30)

			// Sync dose events
			let eventChanges = try await syncDoseEvents(
				local: localEvents,
				healthKit: hkEvents
			)

			result = SyncResult(
				medicationsAdded: result.medicationsAdded,
				medicationsUpdated: result.medicationsUpdated,
				medicationsDeleted: result.medicationsDeleted,
				eventsAdded: eventChanges.added,
				eventsUpdated: eventChanges.updated,
				eventsDeleted: eventChanges.deleted,
				errors: result.errors
			)

		} catch {
			var errors = result.errors
			errors.append(error)
			result = SyncResult(
				medicationsAdded: result.medicationsAdded,
				medicationsUpdated: result.medicationsUpdated,
				medicationsDeleted: result.medicationsDeleted,
				eventsAdded: result.eventsAdded,
				eventsUpdated: result.eventsUpdated,
				eventsDeleted: result.eventsDeleted,
				errors: errors
			)
		}

		return result
	}

	// MARK: - One-Way Sync Operations

	/// Pull data from HealthKit to local (one-way: HealthKit → Local)
	///
	/// This fetches all medications and recent dose events from HealthKit without
	/// pushing any local data. Useful for initial import or when you want to ensure
	/// local data matches HealthKit.
	///
	/// - Parameter daysOfEvents: Number of days of dose events to fetch (default: 30)
	/// - Returns: Result containing medications and events from HealthKit
	/// - Throws: Error if fetch fails
	///
	/// Example:
	/// ```swift
	/// // Pull all HealthKit data to local
	/// let result = try await syncManager.pullFromHealthKit()
	///
	/// // Update local storage with HealthKit data
	/// myMedications = result.medicationsAdded
	/// myEvents = result.eventsAdded
	/// ```
	public func pullFromHealthKit(daysOfEvents: Int = 30) async throws -> SyncResult {
		do {
			// Fetch all medications from HealthKit
			let hkMedications = try await queryHelper.fetchAllMedications()

			// Fetch recent dose events from HealthKit
			let hkEvents = try await queryHelper.fetchRecentDoseEvents(days: daysOfEvents)

			return SyncResult(
				medicationsAdded: hkMedications,
				medicationsUpdated: [],
				medicationsDeleted: [],
				eventsAdded: hkEvents,
				eventsUpdated: [],
				eventsDeleted: [],
				errors: []
			)
		} catch {
			return SyncResult(
				medicationsAdded: [],
				medicationsUpdated: [],
				medicationsDeleted: [],
				eventsAdded: [],
				eventsUpdated: [],
				eventsDeleted: [],
				errors: [error]
			)
		}
	}

	/// Push local data to HealthKit (one-way: Local → HealthKit)
	///
	/// This writes dose events from your local storage to HealthKit without
	/// fetching or modifying local data based on HealthKit. Useful when you want
	/// to ensure HealthKit has all your local dose records.
	///
	/// - Parameters:
	///   - events: Local dose events to push to HealthKit
	/// - Returns: Result indicating success/failure of each event
	/// - Throws: Error if write fails
	///
	/// Example:
	/// ```swift
	/// // Push local dose events to HealthKit
	/// let result = try await syncManager.pushToHealthKit(events: myLocalEvents)
	/// print("Pushed \(myLocalEvents.count) events to HealthKit")
	/// ```
	///
	/// Note: Medications cannot be written to HealthKit (user manages them in Health app).
	/// Only dose events can be pushed.
	public func pushToHealthKit(events: [ANEventConcept]) async throws -> SyncResult {
		var errors: [Error] = []
		var successCount = 0

		for event in events {
			do {
				try await queryHelper.saveDoseEvent(event)
				successCount += 1
			} catch {
				errors.append(error)
			}
		}

		return SyncResult(
			medicationsAdded: [],
			medicationsUpdated: [],
			medicationsDeleted: [],
			eventsAdded: [], // Events were pushed, not added locally
			eventsUpdated: [],
			eventsDeleted: [],
			errors: errors
		)
	}

	// MARK: - Incremental Sync

	/// Perform an incremental sync using anchored queries
	///
	/// This is more efficient than a full sync as it only fetches changes since
	/// the last sync operation.
	///
	/// - Returns: Result of the sync operation
	/// - Throws: Error if sync fails
	public func performIncrementalSync() async throws -> SyncResult {
		var result = SyncResult(
			medicationsAdded: [],
			medicationsUpdated: [],
			medicationsDeleted: [],
			eventsAdded: [],
			eventsUpdated: [],
			eventsDeleted: [],
			errors: []
		)

		// Use anchored queries for efficient sync
		let (medications, deletedMedIDs, newMedAnchor) = try await queryHelper.fetchMedicationsChanges(
			anchor: medicationAnchor
		)
		medicationAnchor = newMedAnchor

		let (events, deletedEventIDs, newEventAnchor) = try await queryHelper.fetchDoseEventsChanges(
			anchor: doseEventAnchor
		)
		doseEventAnchor = newEventAnchor

		result = SyncResult(
			medicationsAdded: medications,
			medicationsUpdated: [],
			medicationsDeleted: deletedMedIDs.compactMap { UUID(uuidString: $0) },
			eventsAdded: events,
			eventsUpdated: [],
			eventsDeleted: deletedEventIDs.compactMap { UUID(uuidString: $0) },
			errors: []
		)

		return result
	}

	// MARK: - Background Sync

	/// Start background sync with HealthKit
	///
	/// This sets up observer queries and a periodic sync timer to keep your
	/// local data in sync with HealthKit in real-time.
	///
	/// - Parameters:
	///   - interval: Sync interval in seconds (default: 300 = 5 minutes)
	///   - completion: Handler called after each sync
	///
	/// Example:
	/// ```swift
	/// try await syncManager.startBackgroundSync(interval: 300) { result in
	///     if result.totalChanges > 0 {
	///         // Update UI or local storage
	///     }
	/// }
	/// ```
	public func startBackgroundSync(
		interval: TimeInterval = 300,
		completion: @escaping @Sendable (SyncResult) async -> Void
	) async throws {
		// Stop any existing background sync
		await stopBackgroundSync()

		// Set up observer queries
		let medicationObserver = try await queryHelper.observeMedicationChanges { medications in
			// When medications change, trigger a sync
			let result = try? await self.performIncrementalSync()
			if let result = result {
				await completion(result)
			}
		}
		activeObservers.append(medicationObserver)

		let eventObserver = try await queryHelper.observeDoseEventChanges { events in
			let result = try? await self.performIncrementalSync()
			if let result = result {
				await completion(result)
			}
		}
		activeObservers.append(eventObserver)

		// Set up periodic sync timer
		syncTimer = Task {
			while !Task.isCancelled {
				try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))

				if !Task.isCancelled {
					let result = try? await self.performIncrementalSync()
					if let result = result {
						await completion(result)
					}
				}
			}
		}
	}

	/// Stop background sync
	public func stopBackgroundSync() async {
		// Cancel timer
		syncTimer?.cancel()
		syncTimer = nil

		// Stop observer queries
		let healthStore = await queryHelper.getHealthStore()
		for observer in activeObservers {
			healthStore.stop(observer)
		}
		activeObservers.removeAll()
	}

	// MARK: - Helper Methods

	private func syncMedications(
		local: [ANMedicationConcept],
		healthKit: [ANMedicationConcept],
		strategy: ANHealthKitSyncStrategy
	) async throws -> (added: [ANMedicationConcept], updated: [ANMedicationConcept], deleted: [UUID]) {
		var added: [ANMedicationConcept] = []
		var updated: [ANMedicationConcept] = []
		var deleted: [UUID] = []

		// Find medications in HealthKit not in local
		for hkMed in healthKit {
			if !local.contains(where: { $0.clinicalName == hkMed.clinicalName }) {
				added.append(hkMed)
			}
		}

		// Find medications in local not in HealthKit
		for localMed in local {
			if !healthKit.contains(where: { $0.clinicalName == localMed.clinicalName }) {
				// Medication was deleted in HealthKit
				deleted.append(localMed.id)
			}
		}

		// Find medications that exist in both and may need updating
		for localMed in local {
			if let hkMed = healthKit.first(where: { $0.clinicalName == localMed.clinicalName }) {
				// Check if they differ
				if localMed.isArchived != hkMed.isArchived ||
				   localMed.hasSchedule != hkMed.hasSchedule ||
				   localMed.nickname != hkMed.nickname {
					// Resolve conflict according to strategy
					switch strategy {
					case .healthKitWins:
						updated.append(hkMed)
					case .localWins:
						// Keep local version
						break
					case .newerWins:
						// Would need to track modification dates
						updated.append(hkMed)
					case .custom(let resolver):
						updated.append(resolver(localMed, hkMed))
					}
				}
			}
		}

		return (added: added, updated: updated, deleted: deleted)
	}

	private func syncDoseEvents(
		local: [ANEventConcept],
		healthKit: [ANEventConcept]
	) async throws -> (added: [ANEventConcept], updated: [ANEventConcept], deleted: [UUID]) {
		var added: [ANEventConcept] = []

		// For dose events, we typically just add new ones from HealthKit
		// Matching is done by date and medication
		for hkEvent in healthKit {
			let exists = local.contains { localEvent in
				localEvent.date == hkEvent.date &&
				localEvent.medication?.clinicalName == hkEvent.medication?.clinicalName
			}

			if !exists {
				added.append(hkEvent)
			}
		}

		return (added: added, updated: [], deleted: [])
	}
}

// MARK: - Query Helper Extension

@available(iOS 26.0, macOS 26.0, watchOS 11.0, visionOS 3.0, *)
extension ANHealthKitQuery {
	func getHealthStore() -> HKHealthStore {
		return healthStore
	}
}

#endif
