import Foundation
import Testing
@testable import ANModelKit

@Suite("ANModelKit Model Tests")
struct ANModelKitModelTests {
	@Test("ANMedicationConcept initialization")
	func testMedicationConceptInit() async throws {
		let med = ANMedicationConcept(clinicalName: "Albuterol", nickname: "Rescue Inhaler")
		#expect(med.clinicalName == "Albuterol")
		#expect(med.nickname == "Rescue Inhaler")
		#expect(type(of: med.id) == UUID.self)
	}
	
	@Test("ANMedicationConcept full initialization")
	func testMedicationConceptFullInit() async throws {
		let refillDate = Date()
		let nextRefillDate = Calendar.current.date(byAdding: .day, value: 30, to: refillDate)!
		let unit = ANUnitConcept.milligram
		
		let med = ANMedicationConcept(
			clinicalName: "Metformin",
			nickname: "Diabetes Med",
			quantity: 180.0,
			initialQuantity: 200.0,
			displayColorHex: "#3366CC",
			lastRefillDate: refillDate,
			nextRefillDate: nextRefillDate,
			prescribedUnit: unit,
			prescribedDoseAmount: 500.0
		)
		
		#expect(med.clinicalName == "Metformin")
		#expect(med.nickname == "Diabetes Med")
		#expect(med.quantity == 180.0)
		#expect(med.initialQuantity == 200.0)
		#expect(med.displayColorHex == "#3366CC")
		#expect(med.lastRefillDate == refillDate)
		#expect(med.nextRefillDate == nextRefillDate)
		#expect(med.prescribedUnit == unit)
		#expect(med.prescribedDoseAmount == 500.0)
	}
	
	@Test("ANMedicationConcept redacted functionality")
	func testMedicationRedacted() async throws {
		let med = ANMedicationConcept(
			clinicalName: "Sensitive Drug Name",
			nickname: "My Secret Med",
			quantity: 30.0,
			initialQuantity: 60.0,
			displayColorHex: "#FF5722"
		)

		let redacted = med.redacted()
		#expect(redacted.clinicalName == "[REDACTED]")
		#expect(redacted.nickname == "[REDACTED]")
		#expect(redacted.quantity == 30.0) // Non-sensitive data preserved
		#expect(redacted.initialQuantity == 60.0) // Non-sensitive data preserved
		#expect(redacted.displayColorHex == "#FF5722") // Non-sensitive data preserved
		#expect(redacted.id == med.id) // ID preserved
	}
	
	@Test("ANMedicationConcept redacted with nil nickname")
	func testMedicationRedactedNilNickname() async throws {
		let med = ANMedicationConcept(clinicalName: "Test Drug", nickname: nil)
		let redacted = med.redacted()
		#expect(redacted.nickname == nil)
	}
	
	@Test("ANMedicationConcept Codable")
	func testMedicationCodable() async throws {
		let original = ANMedicationConcept(clinicalName: "Test Med", nickname: "Test", quantity: 30.0, initialQuantity: 50.0, displayColorHex: "#4CAF50")
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()

		let data = try encoder.encode(original)
		let decoded = try decoder.decode(ANMedicationConcept.self, from: data)

		#expect(decoded.id == original.id)
		#expect(decoded.clinicalName == original.clinicalName)
		#expect(decoded.nickname == original.nickname)
		#expect(decoded.quantity == original.quantity)
		#expect(decoded.initialQuantity == original.initialQuantity)
		#expect(decoded.displayColorHex == original.displayColorHex)
	}
	
	@Test("ANMedicationConcept initialQuantity functionality")
	func testMedicationInitialQuantity() async throws {
		let med = ANMedicationConcept(
			clinicalName: "Test Medication",
			quantity: 15.0,
			initialQuantity: 30.0
		)

		#expect(med.quantity == 15.0)
		#expect(med.initialQuantity == 30.0)

		// Test with nil initialQuantity
		let medNoInitial = ANMedicationConcept(clinicalName: "Test Med 2")
		#expect(medNoInitial.initialQuantity == nil)
	}

	@Test("ANMedicationConcept displayColorHex functionality")
	func testMedicationDisplayColorHex() async throws {
		let med = ANMedicationConcept(
			clinicalName: "Test Medication",
			displayColorHex: "#9C27B0"
		)

		#expect(med.displayColorHex == "#9C27B0")

		// Test with nil displayColorHex
		let medNoColor = ANMedicationConcept(clinicalName: "Test Med 2")
		#expect(medNoColor.displayColorHex == nil)

		// Test different hex formats
		let medShortHex = ANMedicationConcept(clinicalName: "Test Med 3", displayColorHex: "#F00")
		#expect(medShortHex.displayColorHex == "#F00")
	}

	@Test("ANDoseConcept initialization")
	func testDoseConceptInit() async throws {
		let dose = ANDoseConcept(amount: 2, unit: ANUnitConcept.puff)
		#expect(dose.amount == 2)
		#expect(dose.unit == ANUnitConcept.puff)
		#expect(type(of: dose.id) == UUID.self)
	}
	
	@Test("ANDoseConcept with custom ID")
	func testDoseConceptCustomID() async throws {
		let customId = UUID()
		let dose = ANDoseConcept(id: customId, amount: 5.5, unit: .milliliter)
		#expect(dose.id == customId)
		#expect(dose.amount == 5.5)
		#expect(dose.unit == .milliliter)
	}
	
	@Test("ANDoseConcept Codable")
	func testDoseConceptCodable() async throws {
		let original = ANDoseConcept(amount: 10.0, unit: .tablet)
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		let data = try encoder.encode(original)
		let decoded = try decoder.decode(ANDoseConcept.self, from: data)
		
		#expect(decoded.id == original.id)
		#expect(decoded.amount == original.amount)
		#expect(decoded.unit == original.unit)
	}
	
	@Test("ANEventConcept initialization and relationships")
	func testEventConceptInit() async throws {
		let med = ANMedicationConcept(clinicalName: "Ibuprofen", nickname: nil)
		let dose = ANDoseConcept(amount: 400, unit: ANUnitConcept.milligram)
		let event = ANEventConcept(eventType: .doseTaken, medication: med, dose: dose, date: Date())
		#expect(event.eventType == .doseTaken)
		#expect(event.medication?.clinicalName == "Ibuprofen")
		#expect(event.dose?.amount == 400)
		#expect(event.dose?.unit == ANUnitConcept.milligram)
		#expect(type(of: event.id) == UUID.self)
	}
	
	@Test("ANEventConcept minimal initialization")
	func testEventConceptMinimal() async throws {
		let event = ANEventConcept(eventType: .reconcile)
		#expect(event.eventType == .reconcile)
		#expect(event.medication == nil)
		#expect(event.dose == nil)
		// Date should be close to now (within 1 second)
		#expect(abs(event.date.timeIntervalSinceNow) < 1.0)
	}
	
	@Test("ANEventConcept redacted functionality")
	func testEventRedacted() async throws {
		let med = ANMedicationConcept(clinicalName: "Secret Med", nickname: "Hidden")
		let dose = ANDoseConcept(amount: 2.0, unit: .puff)
		let event = ANEventConcept(
			eventType: .doseTaken,
			medication: med,
			dose: dose
		)
		
		let redacted = event.redacted()
		#expect(redacted.eventType == .doseTaken)
		#expect(redacted.medication?.clinicalName == "[REDACTED]")
		#expect(redacted.medication?.nickname == "[REDACTED]")
		#expect(redacted.dose?.amount == 2.0) // Dose not redacted
		#expect(redacted.id == event.id)
	}
	
	@Test("ANEventConcept Codable")
	func testEventConceptCodable() async throws {
		let med = ANMedicationConcept(clinicalName: "Test", nickname: nil)
		let dose = ANDoseConcept(amount: 1.0, unit: .tablet)
		let original = ANEventConcept(eventType: .doseTaken, medication: med, dose: dose)
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		let data = try encoder.encode(original)
		let decoded = try decoder.decode(ANEventConcept.self, from: data)
		
		#expect(decoded.id == original.id)
		#expect(decoded.eventType == original.eventType)
		#expect(decoded.medication?.clinicalName == original.medication?.clinicalName)
		#expect(decoded.dose?.amount == original.dose?.amount)
	}
}

@Suite("ANUnitConcept Tests")
struct ANUnitConceptTests {
	@Test("All cases are present and CaseIterable works correctly")
	func testAllCases() async throws {
		let allCases = ANUnitConcept.allCases
		// Expected known units to be present (ANUnitConcept enum cases)
		let expectedUnits: Set<ANUnitConcept> = [.milligram, .tablet, .liter, .puff, .milliliter]
		for unit in expectedUnits {
			#expect(allCases.contains(unit))
		}
		#expect(allCases.count >= expectedUnits.count)
	}
	
	@Test("selectableUnits returns all cases") 
	func testSelectableUnits() async throws {
		let selectable = ANUnitConcept.selectableUnits
		#expect(Set(selectable) == Set(ANUnitConcept.allCases))
	}
	
	@Test("commonUnits contains expected subset")
	func testCommonUnits() async throws {
		let common = ANUnitConcept.commonUnits
		let expectedCommon: Set<ANUnitConcept> = [.milligram, .milliliter, .unit, .tablet, .capsule, .puff, .drop, .dose, .injection, .tablespoon, .pen]
		#expect(Set(common) == expectedCommon)
	}
	
	@Test("displayName returns non-empty strings")
	func testDisplayName() async throws {
		for unit in ANUnitConcept.allCases {
			#expect(!unit.displayName.isEmpty)
		}
	}
	
	@Test("displayName for count handles singular/plural correctly")
	func testDisplayNameForCount() async throws {
		let unit = ANUnitConcept.tablet
		#expect(unit.displayName(for: 1) == "Tablet")
		#expect(unit.displayName(for: 2) == "Tablets")
		#expect(unit.displayName(for: 0) == "Tablets")
		
		let unit2 = ANUnitConcept.suppository
		#expect(unit2.displayName(for: 1) == "Suppository")
		#expect(unit2.displayName(for: 2) == "Suppositories")
	}
	
	@Test("abbreviation returns non-empty strings")
	func testAbbreviation() async throws {
		for unit in ANUnitConcept.allCases {
			#expect(!unit.abbreviation.isEmpty)
		}
		
		// Test specific abbreviations
		#expect(ANUnitConcept.milligram.abbreviation == "mg")
		#expect(ANUnitConcept.milliliter.abbreviation == "mL")
		#expect(ANUnitConcept.microgram.abbreviation == "mcg")
		#expect(ANUnitConcept.drop.abbreviation == "gtt")
		#expect(ANUnitConcept.bowl.abbreviation == "bowl")
		#expect(ANUnitConcept.joint.abbreviation == "joint")
		#expect(ANUnitConcept.dab.abbreviation == "dab")
		#expect(ANUnitConcept.injection.abbreviation == "inj")
		#expect(ANUnitConcept.tablespoon.abbreviation == "tbsp")
		#expect(ANUnitConcept.pen.abbreviation == "pen")
		#expect(ANUnitConcept.inhaler.abbreviation == "inh")
	}
	
	@Test("clinicalDescription returns non-empty strings")
	func testClinicalDescription() async throws {
		for unit in ANUnitConcept.allCases {
			#expect(!unit.clinicalDescription.isEmpty)
			#expect(unit.clinicalDescription.count > 10) // Should be descriptive
		}
	}
	
	@Test("Codable round-trip retains correct unit") 
	func testCodableRoundTrip() async throws {
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		for unit in ANUnitConcept.allCases {
			let data = try encoder.encode(unit)
			let decoded = try decoder.decode(ANUnitConcept.self, from: data)
			#expect(decoded == unit)
		}
	}

	@Test("Medical marijuana dose units functionality")
	func testMedicalMarijuanaDoseUnits() async throws {
		// Test bowl unit
		let bowl = ANUnitConcept.bowl
		#expect(bowl.displayName == "Bowl")
		#expect(bowl.displayName(for: 1) == "Bowl")
		#expect(bowl.displayName(for: 2) == "Bowls")
		#expect(bowl.abbreviation == "bowl")
		#expect(bowl.clinicalDescription.contains("cannabis flower"))

		// Test joint unit
		let joint = ANUnitConcept.joint
		#expect(joint.displayName == "Joint")
		#expect(joint.displayName(for: 1) == "Joint")
		#expect(joint.displayName(for: 2) == "Joints")
		#expect(joint.abbreviation == "joint")
		#expect(joint.clinicalDescription.contains("cannabis cigarette"))

		// Test dab unit
		let dab = ANUnitConcept.dab
		#expect(dab.displayName == "Dab")
		#expect(dab.displayName(for: 1) == "Dab")
		#expect(dab.displayName(for: 2) == "Dabs")
		#expect(dab.abbreviation == "dab")
		#expect(dab.clinicalDescription.contains("concentrated cannabis"))

		// Test they are included in selectableUnits
		#expect(ANUnitConcept.selectableUnits.contains(.bowl))
		#expect(ANUnitConcept.selectableUnits.contains(.joint))
		#expect(ANUnitConcept.selectableUnits.contains(.dab))
	}

	@Test("New pharmaceutical dose units functionality")
	func testNewPharmaceuticalDoseUnits() async throws {
		// Test injection unit
		let injection = ANUnitConcept.injection
		#expect(injection.displayName == "Injection")
		#expect(injection.displayName(for: 1) == "Injection")
		#expect(injection.displayName(for: 2) == "Injections")
		#expect(injection.abbreviation == "inj")
		#expect(injection.clinicalDescription.contains("needle"))

		// Test tablespoon unit
		let tablespoon = ANUnitConcept.tablespoon
		#expect(tablespoon.displayName == "Tablespoon")
		#expect(tablespoon.displayName(for: 1) == "Tablespoon")
		#expect(tablespoon.displayName(for: 2) == "Tablespoons")
		#expect(tablespoon.abbreviation == "tbsp")
		#expect(tablespoon.clinicalDescription.contains("15 mL"))

		// Test pen unit
		let pen = ANUnitConcept.pen
		#expect(pen.displayName == "Pen")
		#expect(pen.displayName(for: 1) == "Pen")
		#expect(pen.displayName(for: 2) == "Pens")
		#expect(pen.abbreviation == "pen")
		#expect(pen.clinicalDescription.contains("pre-filled"))

		// Test inhaler unit
		let inhaler = ANUnitConcept.inhaler
		#expect(inhaler.displayName == "Inhaler")
		#expect(inhaler.displayName(for: 1) == "Inhaler")
		#expect(inhaler.displayName(for: 2) == "Inhalers")
		#expect(inhaler.abbreviation == "inh")
		#expect(inhaler.clinicalDescription.contains("dry powder"))

		// Test they are included in selectableUnits
		#expect(ANUnitConcept.selectableUnits.contains(.injection))
		#expect(ANUnitConcept.selectableUnits.contains(.tablespoon))
		#expect(ANUnitConcept.selectableUnits.contains(.pen))
		#expect(ANUnitConcept.selectableUnits.contains(.inhaler))
	}
}

@Suite("ANEventType Tests")
struct ANEventTypeTests {
	@Test("Codable round-trip retains correct event type") 
	func testCodableRoundTrip() async throws {
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		for eventType in ANEventType.allCases {
			let data = try encoder.encode(eventType)
			let decoded = try decoder.decode(ANEventType.self, from: data)
			#expect(decoded == eventType)
		}
	}
	
	@Test("Equatable and Hashable uniqueness of all cases")
	func testEquatableHashable() async throws {
		let allCases = ANEventType.allCases
		var set = Set<ANEventType>()
		for eventType in allCases {
			set.insert(eventType)
		}
		#expect(set.count == allCases.count)
	}
}
