import Foundation
import Testing
@testable import ANModelKit

@Suite("Medication dosing limits")
struct MedicationDosingLimitsTests {
	@Test("Existing initializer leaves dosing limits and notifications unset")
	func defaultsRemainUnset() {
		let medication = ANMedicationConcept(clinicalName: "Example")
		#expect(medication.minimumHoursBetweenDoses == nil)
		#expect(medication.maximumDailyDoseAmount == nil)
		#expect(medication.maximumDoseAmount == nil)
		#expect(medication.nextDoseNotificationEnabled == nil)
	}

	@Test("Legacy JSON decodes without dosing limits or notification preference")
	func legacyJSONDecodes() throws {
		let id = UUID()
		let json = """
		{"id":"\(id.uuidString)","clinicalName":"Example","quantity":12}
		"""
		let medication = try JSONDecoder().decode(ANMedicationConcept.self, from: Data(json.utf8))
		#expect(medication.id == id)
		#expect(medication.quantity == 12)
		#expect(medication.minimumHoursBetweenDoses == nil)
		#expect(medication.maximumDailyDoseAmount == nil)
		#expect(medication.maximumDoseAmount == nil)
		#expect(medication.nextDoseNotificationEnabled == nil)
		#expect(medication.isArchived == false)
	}

	@Test("Dosing values and notification preference survive Codable round trips", arguments: [true, false])
	func dosingValuesRoundTrip(notificationsEnabled: Bool) throws {
		let original = ANMedicationConcept(
			clinicalName: "Example",
			prescribedUnit: .tablet,
			prescribedDoseAmount: 1,
			minimumHoursBetweenDoses: 4,
			maximumDailyDoseAmount: 6,
			nextDoseNotificationEnabled: notificationsEnabled,
			maximumDoseAmount: 1.5
		)
		let data = try JSONEncoder().encode(original)
		let decoded = try JSONDecoder().decode(ANMedicationConcept.self, from: data)
		#expect(decoded == original)
		#expect(decoded.minimumHoursBetweenDoses == 4)
		#expect(decoded.maximumDailyDoseAmount == 6)
		#expect(decoded.maximumDoseAmount == 1.5)
		#expect(decoded.nextDoseNotificationEnabled == notificationsEnabled)
	}

	@Test("Each dosing limit can be saved independently")
	func independentLimitsRoundTrip() throws {
		let intervalOnly = ANMedicationConcept(clinicalName: "Example", minimumHoursBetweenDoses: 4)
		let maximumOnly = ANMedicationConcept(clinicalName: "Example", maximumDailyDoseAmount: 6)
		let perDoseOnly = ANMedicationConcept(clinicalName: "Example", maximumDoseAmount: 1.5)
		for original in [intervalOnly, maximumOnly, perDoseOnly] {
			let data = try JSONEncoder().encode(original)
			let decoded = try JSONDecoder().decode(ANMedicationConcept.self, from: data)
			#expect(decoded == original)
		}
		#expect(intervalOnly.maximumDailyDoseAmount == nil)
		#expect(maximumOnly.minimumHoursBetweenDoses == nil)
		#expect(perDoseOnly.maximumDailyDoseAmount == nil)
	}

	@Test("Redaction preserves dosing limits, units, and notification preference")
	func redactionPreservesDosingValues() {
		let original = ANMedicationConcept(
			clinicalName: "Example",
			nickname: "Private nickname",
			prescribedUnit: .tablet,
			prescribedDoseAmount: 1,
			minimumHoursBetweenDoses: 4,
			maximumDailyDoseAmount: 6,
			nextDoseNotificationEnabled: true,
			maximumDoseAmount: 1.5
		)
		var expected = original
		expected.clinicalName = "[REDACTED]"
		expected.nickname = "[REDACTED]"
		#expect(original.redacted() == expected)
	}

	@Test("A saved per-dose limit survives decoding, redaction, and re-encoding")
	func savedPerDoseLimitSurvivesRedactedRoundTrip() throws {
		let json = """
		{"id":"\(UUID().uuidString)","clinicalName":"Example","maximumDoseAmount":1.5}
		"""
		let medication = try JSONDecoder().decode(ANMedicationConcept.self, from: Data(json.utf8))
		let data = try JSONEncoder().encode(medication.redacted())
		let redacted = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
		#expect(redacted["clinicalName"] as? String == "[REDACTED]")
		#expect(redacted["maximumDoseAmount"] as? Double == 1.5)
	}

	@Test("Unset fields stay omitted from encoded JSON")
	func unsetFieldsAreOmitted() throws {
		let medication = ANMedicationConcept(clinicalName: "Example")
		let data = try JSONEncoder().encode(medication)
		let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
		#expect(json["minimumHoursBetweenDoses"] == nil)
		#expect(json["maximumDailyDoseAmount"] == nil)
		#expect(json["maximumDoseAmount"] == nil)
		#expect(json["nextDoseNotificationEnabled"] == nil)
	}
}
