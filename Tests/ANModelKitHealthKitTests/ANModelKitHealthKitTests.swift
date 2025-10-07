import XCTest
#if canImport(HealthKit)
import HealthKit
#endif
@testable import ANModelKit
@testable import ANModelKitHealthKit

final class ANModelKitHealthKitTests: XCTestCase {

	// MARK: - Module Tests

	func testHealthKitAvailabilityCheck() {
		#if canImport(HealthKit)
		XCTAssertTrue(ANModelKitHealthKit.isHealthKitAvailable)
		#else
		XCTAssertFalse(ANModelKitHealthKit.isHealthKitAvailable)
		#endif
	}

	func testModuleVersion() {
		XCTAssertEqual(ANModelKitHealthKit.version, "1.0.0")
	}

	// MARK: - ANDoseLogStatus Tests

	func testDoseLogStatusCases() {
		XCTAssertEqual(ANDoseLogStatus.allCases.count, 3)
		XCTAssertTrue(ANDoseLogStatus.allCases.contains(.taken))
		XCTAssertTrue(ANDoseLogStatus.allCases.contains(.skipped))
		XCTAssertTrue(ANDoseLogStatus.allCases.contains(.snoozed))
	}

	func testDoseLogStatusCodable() throws {
		let status = ANDoseLogStatus.taken
		let encoded = try JSONEncoder().encode(status)
		let decoded = try JSONDecoder().decode(ANDoseLogStatus.self, from: encoded)
		XCTAssertEqual(status, decoded)
	}

	// MARK: - ANMedicationConcept HealthKit Properties

	func testMedicationConceptHealthKitProperties() {
		let medication = ANMedicationConcept(
			clinicalName: "Test Medication",
			rxNormCode: "123456",
			generalForm: "tablet",
			isArchived: false,
			hasSchedule: true
		)

		XCTAssertEqual(medication.rxNormCode, "123456")
		XCTAssertEqual(medication.generalForm, "tablet")
		XCTAssertEqual(medication.isArchived, false)
		XCTAssertEqual(medication.hasSchedule, true)
	}

	func testMedicationConceptDefaultHealthKitProperties() {
		let medication = ANMedicationConcept(clinicalName: "Test")

		XCTAssertNil(medication.rxNormCode)
		XCTAssertNil(medication.generalForm)
		XCTAssertEqual(medication.isArchived, false)
		XCTAssertEqual(medication.hasSchedule, false)
	}

	func testMedicationConceptRedactionPreservesHealthKitProperties() {
		let medication = ANMedicationConcept(
			clinicalName: "Sensitive Med",
			rxNormCode: "999999",
			generalForm: "capsule",
			isArchived: true,
			hasSchedule: false
		)

		let redacted = medication.redacted()

		XCTAssertEqual(redacted.clinicalName, "[REDACTED]")
		XCTAssertEqual(redacted.rxNormCode, "999999")
		XCTAssertEqual(redacted.generalForm, "capsule")
		XCTAssertEqual(redacted.isArchived, true)
		XCTAssertEqual(redacted.hasSchedule, false)
	}

	// MARK: - ANEventConcept HealthKit Properties

	func testEventConceptLogStatus() {
		let event = ANEventConcept(
			eventType: .doseTaken,
			logStatus: .taken
		)

		XCTAssertEqual(event.logStatus, .taken)
	}

	func testEventConceptScheduledDose() {
		let event = ANEventConcept(
			eventType: .doseTaken,
			scheduledDoseAmount: 10.0,
			scheduledDoseUnit: .milligram
		)

		XCTAssertEqual(event.scheduledDoseAmount, 10.0)
		XCTAssertEqual(event.scheduledDoseUnit, .milligram)
	}

	func testEventConceptRedactionPreservesHealthKitProperties() {
		let medication = ANMedicationConcept(clinicalName: "Test Med")
		let event = ANEventConcept(
			eventType: .doseTaken,
			medication: medication,
			logStatus: .skipped,
			scheduledDoseAmount: 5.0,
			scheduledDoseUnit: .tablet
		)

		let redacted = event.redacted()

		XCTAssertEqual(redacted.medication?.clinicalName, "[REDACTED]")
		XCTAssertEqual(redacted.logStatus, .skipped)
		XCTAssertEqual(redacted.scheduledDoseAmount, 5.0)
		XCTAssertEqual(redacted.scheduledDoseUnit, .tablet)
	}

	// MARK: - ANUnitConcept HealthKit Utilities

	func testUnitConceptIsWeightBased() {
		XCTAssertTrue(ANUnitConcept.milligram.isWeightBased)
		XCTAssertTrue(ANUnitConcept.gram.isWeightBased)
		XCTAssertTrue(ANUnitConcept.microgram.isWeightBased)
		XCTAssertFalse(ANUnitConcept.tablet.isWeightBased)
		XCTAssertFalse(ANUnitConcept.milliliter.isWeightBased)
	}

	func testUnitConceptIsVolumeBased() {
		XCTAssertTrue(ANUnitConcept.milliliter.isVolumeBased)
		XCTAssertTrue(ANUnitConcept.liter.isVolumeBased)
		XCTAssertTrue(ANUnitConcept.teaspoon.isVolumeBased)
		XCTAssertTrue(ANUnitConcept.tablespoon.isVolumeBased)
		XCTAssertFalse(ANUnitConcept.tablet.isVolumeBased)
		XCTAssertFalse(ANUnitConcept.milligram.isVolumeBased)
	}

	func testUnitConceptIsCountBased() {
		XCTAssertTrue(ANUnitConcept.tablet.isCountBased)
		XCTAssertTrue(ANUnitConcept.capsule.isCountBased)
		XCTAssertTrue(ANUnitConcept.puff.isCountBased)
		XCTAssertFalse(ANUnitConcept.milligram.isCountBased)
		XCTAssertFalse(ANUnitConcept.milliliter.isCountBased)
	}

	func testUnitConceptHealthKitGeneralForm() {
		XCTAssertEqual(ANUnitConcept.tablet.healthKitGeneralForm, "tablet")
		XCTAssertEqual(ANUnitConcept.capsule.healthKitGeneralForm, "capsule")
		XCTAssertEqual(ANUnitConcept.milliliter.healthKitGeneralForm, "liquid")
		XCTAssertEqual(ANUnitConcept.puff.healthKitGeneralForm, "inhaler")
		XCTAssertEqual(ANUnitConcept.patch.healthKitGeneralForm, "patch")
		XCTAssertEqual(ANUnitConcept.injection.healthKitGeneralForm, "injection")
	}

	// MARK: - Codable Tests

	func testMedicationConceptCodableWithHealthKitProperties() throws {
		let medication = ANMedicationConcept(
			clinicalName: "Amoxicillin",
			rxNormCode: "308192",
			generalForm: "tablet",
			isArchived: false,
			hasSchedule: true
		)

		let encoded = try JSONEncoder().encode(medication)
		let decoded = try JSONDecoder().decode(ANMedicationConcept.self, from: encoded)

		XCTAssertEqual(decoded.clinicalName, medication.clinicalName)
		XCTAssertEqual(decoded.rxNormCode, medication.rxNormCode)
		XCTAssertEqual(decoded.generalForm, medication.generalForm)
		XCTAssertEqual(decoded.isArchived, medication.isArchived)
		XCTAssertEqual(decoded.hasSchedule, medication.hasSchedule)
	}

	func testEventConceptCodableWithHealthKitProperties() throws {
		let event = ANEventConcept(
			eventType: .doseTaken,
			logStatus: .taken,
			scheduledDoseAmount: 10.0,
			scheduledDoseUnit: .milligram
		)

		let encoded = try JSONEncoder().encode(event)
		let decoded = try JSONDecoder().decode(ANEventConcept.self, from: encoded)

		XCTAssertEqual(decoded.eventType, event.eventType)
		XCTAssertEqual(decoded.logStatus, event.logStatus)
		XCTAssertEqual(decoded.scheduledDoseAmount, event.scheduledDoseAmount)
		XCTAssertEqual(decoded.scheduledDoseUnit, event.scheduledDoseUnit)
	}

	// MARK: - Error Tests

	#if canImport(HealthKit)
	func testHealthKitConversionErrorDescriptions() {
		XCTAssertNotNil(ANHealthKitConversionError.healthKitNotAvailable.errorDescription)
		XCTAssertNotNil(ANHealthKitConversionError.invalidMedicationConcept.errorDescription)
		XCTAssertNotNil(ANHealthKitConversionError.invalidDoseEvent.errorDescription)
		XCTAssertNotNil(ANHealthKitConversionError.missingRequiredField("test").errorDescription)
		XCTAssertNotNil(ANHealthKitConversionError.unsupportedPlatform.errorDescription)
	}
	#endif
}
