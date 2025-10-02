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
		let symbolInfo = ANSymbolInfo(name: "pills.fill", minimumVersion: "14.0", fallbackName: "pills")

		let med = ANMedicationConcept(
			clinicalName: "Metformin",
			nickname: "Diabetes Med",
			quantity: 180.0,
			initialQuantity: 200.0,
			displayColorHex: "#3366CC",
			lastRefillDate: refillDate,
			nextRefillDate: nextRefillDate,
			prescribedUnit: unit,
			prescribedDoseAmount: 500.0,
			symbolInfo: symbolInfo
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
		#expect(med.symbolInfo?.name == "pills.fill")
		#expect(med.symbolInfo?.minimumVersion == "14.0")
		#expect(med.symbolInfo?.fallbackName == "pills")
	}
	
	@Test("ANMedicationConcept redacted functionality")
	func testMedicationRedacted() async throws {
		let symbolInfo = ANSymbolInfo(name: "heart.fill", minimumVersion: "13.0")
		let med = ANMedicationConcept(
			clinicalName: "Sensitive Drug Name",
			nickname: "My Secret Med",
			quantity: 30.0,
			initialQuantity: 60.0,
			displayColorHex: "#FF5722",
			symbolInfo: symbolInfo
		)

		let redacted = med.redacted()
		#expect(redacted.clinicalName == "[REDACTED]")
		#expect(redacted.nickname == "[REDACTED]")
		#expect(redacted.quantity == 30.0) // Non-sensitive data preserved
		#expect(redacted.initialQuantity == 60.0) // Non-sensitive data preserved
		#expect(redacted.displayColorHex == "#FF5722") // Non-sensitive data preserved
		#expect(redacted.symbolInfo?.name == "heart.fill") // Symbol info preserved
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

@Suite("ANSymbolInfo Tests")
struct ANSymbolInfoTests {
	@Test("ANSymbolInfo initialization and properties")
	func testSymbolInfoInit() async throws {
		let symbol = ANSymbolInfo(name: "pills.fill", minimumVersion: "14.0", fallbackName: "pills")
		#expect(symbol.name == "pills.fill")
		#expect(symbol.minimumVersion == "14.0")
		#expect(symbol.fallbackName == "pills")
	}

	@Test("ANSymbolInfo with minimal initialization")
	func testSymbolInfoMinimal() async throws {
		let symbol = ANSymbolInfo(name: "heart")
		#expect(symbol.name == "heart")
		#expect(symbol.minimumVersion == nil)
		#expect(symbol.fallbackName == nil)
	}

	@Test("ANSymbolInfo Codable")
	func testSymbolInfoCodable() async throws {
		let original = ANSymbolInfo(name: "syringe.fill", minimumVersion: "14.0", fallbackName: "syringe")
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()

		let data = try encoder.encode(original)
		let decoded = try decoder.decode(ANSymbolInfo.self, from: data)

		#expect(decoded.name == original.name)
		#expect(decoded.minimumVersion == original.minimumVersion)
		#expect(decoded.fallbackName == original.fallbackName)
	}

	@Test("ANSymbolInfo availableSymbolName with version check")
	func testAvailableSymbolName() async throws {
		let symbol = ANSymbolInfo(name: "pills.fill", minimumVersion: "14.0", fallbackName: "pills")

		// Test with higher version (should return primary)
		#expect(symbol.availableSymbolName(for: "15.0") == "pills.fill")

		// Test with lower version (should return fallback)
		#expect(symbol.availableSymbolName(for: "13.0") == "pills")

		// Test with exact version (should return primary)
		#expect(symbol.availableSymbolName(for: "14.0") == "pills.fill")

		// Test without minimum version (should always return primary)
		let noMinSymbol = ANSymbolInfo(name: "star", fallbackName: "star.fill")
		#expect(noMinSymbol.availableSymbolName(for: "13.0") == "star")
		#expect(noMinSymbol.availableSymbolName(for: "17.0") == "star")
	}
}

@Suite("ANSymbolManager Tests")
struct ANSymbolManagerTests {
	@Test("ANSymbolManager singleton access")
	func testSingletonAccess() async throws {
		let manager = ANSymbolManager.shared
		#expect(manager != nil)
	}

	@Test("Symbol search by exact name")
	func testSearchByExactName() async throws {
		let manager = ANSymbolManager.shared
		let results = manager.searchSymbols(query: "pills.fill")
		#expect(results.count > 0)
		#expect(results.first?.symbol.name == "pills.fill")
		#expect(results.first?.relevanceScore == 100) // Exact match
	}

	@Test("Symbol search by partial name")
	func testSearchByPartialName() async throws {
		let manager = ANSymbolManager.shared
		let results = manager.searchSymbols(query: "pill")
		#expect(results.count > 0)
		// Should find "pills" and "pills.fill"
		let names = results.map { $0.symbol.name }
		#expect(names.contains("pills") || names.contains("pills.fill"))
	}

	@Test("Symbol search by description")
	func testSearchByDescription() async throws {
		let manager = ANSymbolManager.shared
		let results = manager.searchSymbols(query: "morning")
		#expect(results.count > 0)
		// Should find sun/sunrise symbols based on description
		let found = results.contains { result in
			result.symbol.name.contains("sun") || result.symbol.name.contains("sunrise")
		}
		#expect(found)
	}

	@Test("Symbol search by keywords")
	func testSearchByKeywords() async throws {
		let manager = ANSymbolManager.shared
		let results = manager.searchSymbols(query: "injection")
		#expect(results.count > 0)
		// Should find syringe symbols
		let found = results.contains { $0.symbol.name.contains("syringe") }
		#expect(found)
	}

	@Test("Symbol search with category filter")
	func testSearchWithCategoryFilter() async throws {
		let manager = ANSymbolManager.shared
		let results = manager.searchSymbols(query: "fill", category: .medication)
		#expect(results.count > 0)
		// All results should be in medication category
		for result in results {
			#expect(result.symbol.category == .medication)
		}
	}

	@Test("Get suggested symbols for medication names")
	func testGetSuggestedSymbols() async throws {
		let manager = ANSymbolManager.shared

		// Test pill-related medication
		let pillResults = manager.getSuggestedSymbols(for: "Aspirin Tablet")
		#expect(pillResults.count > 0)
		#expect(pillResults.first?.symbol.name == "pills.fill")

		// Test injection-related medication
		let injectionResults = manager.getSuggestedSymbols(for: "Insulin Injection")
		#expect(injectionResults.count > 0)
		#expect(injectionResults.first?.symbol.name == "syringe.fill")

		// Test liquid medication
		let liquidResults = manager.getSuggestedSymbols(for: "Cough Syrup Liquid")
		#expect(liquidResults.count > 0)
		#expect(liquidResults.first?.symbol.name == "drop.fill")
	}

	@Test("Get symbol info by name")
	func testGetSymbolInfo() async throws {
		let manager = ANSymbolManager.shared
		let info = manager.getSymbolInfo("heart.fill")
		#expect(info != nil)
		#expect(info?.name == "heart.fill")
		#expect(info?.category == .health)
	}

	@Test("Get symbols by category")
	func testGetSymbolsByCategory() async throws {
		let manager = ANSymbolManager.shared

		let medicalSymbols = manager.getSymbolsByCategory(.medical)
		#expect(medicalSymbols.count > 0)
		for symbol in medicalSymbols {
			#expect(symbol.category == .medical)
		}

		let timeSymbols = manager.getSymbolsByCategory(.time)
		#expect(timeSymbols.count > 0)
		for symbol in timeSymbols {
			#expect(symbol.category == .time)
		}
	}

	@Test("Check symbol availability by version")
	func testIsSymbolAvailable() async throws {
		let manager = ANSymbolManager.shared

		// Pills.fill requires iOS 14.0
		#expect(manager.isSymbolAvailable("pills.fill", for: "14.0"))
		#expect(manager.isSymbolAvailable("pills.fill", for: "15.0"))
		#expect(!manager.isSymbolAvailable("pills.fill", for: "13.0"))

		// Heart is available from iOS 13.0
		#expect(manager.isSymbolAvailable("heart", for: "13.0"))
		#expect(manager.isSymbolAvailable("heart", for: "17.0"))
	}

	@Test("Get all categories")
	func testGetAllCategories() async throws {
		let manager = ANSymbolManager.shared
		let categories = manager.getAllCategories()
		#expect(categories.count == ANSymbolManager.SymbolCategory.allCases.count)
		#expect(categories.contains(.medical))
		#expect(categories.contains(.medication))
		#expect(categories.contains(.health))
		#expect(categories.contains(.time))
	}
}

@Suite("ANSymbolDatabase Tests")
struct ANSymbolDatabaseTests {
	@Test("Database contains expected symbols")
	func testDatabaseContainsExpectedSymbols() async throws {
		let symbols = ANSymbolDatabase.symbols
		#expect(symbols.count > 50) // Should have a substantial number of symbols

		// Check for specific important medical symbols
		let expectedSymbols = ["pills", "pills.fill", "syringe", "syringe.fill",
							   "heart", "heart.fill", "drop", "drop.fill"]

		for expectedName in expectedSymbols {
			let found = symbols.contains { $0.name == expectedName }
			#expect(found, "Expected to find symbol: \(expectedName)")
		}
	}

	@Test("All symbols have descriptions")
	func testAllSymbolsHaveDescriptions() async throws {
		let symbols = ANSymbolDatabase.symbols
		for symbol in symbols {
			#expect(!symbol.description.isEmpty)
			#expect(symbol.description.count > 10) // Description should be meaningful
		}
	}

	@Test("All symbols have valid categories")
	func testAllSymbolsHaveValidCategories() async throws {
		let symbols = ANSymbolDatabase.symbols
		let validCategories = Set(ANSymbolManager.SymbolCategory.allCases)

		for symbol in symbols {
			#expect(validCategories.contains(symbol.category))
		}
	}

	@Test("Symbol metadata structure")
	func testSymbolMetadataStructure() async throws {
		// Test a specific symbol's metadata
		let pillSymbol = ANSymbolDatabase.symbols.first { $0.name == "pills.fill" }
		#expect(pillSymbol != nil)
		#expect(pillSymbol?.category == .medication)
		#expect(pillSymbol?.minimumVersion == "14.0")
		#expect(pillSymbol?.description.contains("pill") == true)
		#expect(pillSymbol?.keywords.contains("medicine") == true)
	}

	@Test("Database includes general purpose symbols")
	func testGeneralPurposeSymbols() async throws {
		let symbols = ANSymbolDatabase.symbols

		// Check for general symbols that can be used with medications
		let generalSymbols = ["star", "star.fill", "flag", "flag.fill",
							  "arrow.up", "arrow.down", "checkmark.circle"]

		for symbolName in generalSymbols {
			let found = symbols.contains { $0.name == symbolName }
			#expect(found, "Expected to find general symbol: \(symbolName)")
		}
	}

	@Test("Database includes time-related symbols")
	func testTimeRelatedSymbols() async throws {
		let symbols = ANSymbolDatabase.symbols

		// Check for time/schedule symbols
		let timeSymbols = ["clock", "alarm", "moon", "sun.max", "calendar"]

		for symbolName in timeSymbols {
			let found = symbols.contains { $0.name == symbolName }
			#expect(found, "Expected to find time symbol: \(symbolName)")
		}
	}
}
