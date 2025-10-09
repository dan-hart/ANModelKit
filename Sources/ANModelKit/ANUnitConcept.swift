import Foundation

/// Standardized units for medication doses.
public enum ANUnitConcept: String, Codable, CaseIterable, Equatable, Hashable, Sendable {
	case milligram
	case gram
	case microgram
	case unit
	case tablet
	case capsule
	case chewable
	case lozenge
	case suppository
	case milliliter
	case liter
	case teaspoon
	case drop
	case sachet
	case puff
	case nebule
	case injection
	case tablespoon
	case pen
	case inhaler
	case vial
	case patch
	case application
	case spray
	case strip
	case film
	case dose
	case ampule
	case bowl
	case joint
	case dab

	/// A user-facing string for display in UI.
	public var displayName: String {
		switch self {
		case .milligram: return "Milligram"
		case .gram: return "Gram"
		case .microgram: return "Microgram"
		case .unit: return "Unit"
		case .tablet: return "Tablet"
		case .capsule: return "Capsule"
		case .chewable: return "Chewable"
		case .lozenge: return "Lozenge"
		case .suppository: return "Suppository"
		case .milliliter: return "Milliliter"
		case .liter: return "Liter"
		case .teaspoon: return "Teaspoon"
		case .drop: return "Drop"
		case .sachet: return "Sachet"
		case .puff: return "Puff"
		case .nebule: return "Nebule"
		case .injection: return "Injection"
		case .tablespoon: return "Tablespoon"
		case .pen: return "Pen"
		case .inhaler: return "Inhaler"
		case .vial: return "Vial"
		case .patch: return "Patch"
		case .application: return "Application"
		case .spray: return "Spray"
		case .strip: return "Strip"
		case .film: return "Film"
		case .dose: return "Dose"
		case .ampule: return "Ampule"
		case .bowl: return "Bowl"
		case .joint: return "Joint"
		case .dab: return "Dab"
		}
	}

	/// Returns a localizable display name for this unit based on count.
	///
	/// - Parameters:
	///   - count: The quantity of units.
	///   - locale: The locale for localization; defaults to current locale.
	/// - Returns: A singular or plural form of the display name, prepared for localization.
	///
	/// This function is designed to be localization-ready. For now, it handles basic English pluralization,
	/// appending 's' for plurals except for irregular cases.
	public func displayName(for count: Int, locale: Locale = .current) -> String {
		switch self {
		case .milligram: return count == 1 ? "Milligram" : "Milligrams"
		case .gram: return count == 1 ? "Gram" : "Grams"
		case .microgram: return count == 1 ? "Microgram" : "Micrograms"
		case .unit: return count == 1 ? "Unit" : "Units"
		case .tablet: return count == 1 ? "Tablet" : "Tablets"
		case .capsule: return count == 1 ? "Capsule" : "Capsules"
		case .chewable: return count == 1 ? "Chewable" : "Chewables"
		case .lozenge: return count == 1 ? "Lozenge" : "Lozenges"
		case .suppository: return count == 1 ? "Suppository" : "Suppositories"
		case .milliliter: return count == 1 ? "Milliliter" : "Milliliters"
		case .liter: return count == 1 ? "Liter" : "Liters"
		case .teaspoon: return count == 1 ? "Teaspoon" : "Teaspoons"
		case .drop: return count == 1 ? "Drop" : "Drops"
		case .sachet: return count == 1 ? "Sachet" : "Sachets"
		case .puff: return count == 1 ? "Puff" : "Puffs"
		case .nebule: return count == 1 ? "Nebule" : "Nebules"
		case .injection: return count == 1 ? "Injection" : "Injections"
		case .tablespoon: return count == 1 ? "Tablespoon" : "Tablespoons"
		case .pen: return count == 1 ? "Pen" : "Pens"
		case .inhaler: return count == 1 ? "Inhaler" : "Inhalers"
		case .vial: return count == 1 ? "Vial" : "Vials"
		case .patch: return count == 1 ? "Patch" : "Patches"
		case .application: return count == 1 ? "Application" : "Applications"
		case .spray: return count == 1 ? "Spray" : "Sprays"
		case .strip: return count == 1 ? "Strip" : "Strips"
		case .film: return count == 1 ? "Film" : "Films"
		case .dose: return count == 1 ? "Dose" : "Doses"
		case .ampule: return count == 1 ? "Ampule" : "Ampules"
		case .bowl: return count == 1 ? "Bowl" : "Bowls"
		case .joint: return count == 1 ? "Joint" : "Joints"
		case .dab: return count == 1 ? "Dab" : "Dabs"
		}
	}

	/// Abbreviation for medical or clinical use (e.g., "mg" for milligrams).
	public var abbreviation: String {
		switch self {
		case .milligram: return "mg"
		case .gram: return "g"
		case .microgram: return "mcg"
		case .unit: return "unit"
		case .tablet: return "tab"
		case .capsule: return "cap"
		case .chewable: return "chew"
		case .lozenge: return "loz"
		case .suppository: return "supp"
		case .milliliter: return "mL"
		case .liter: return "L"
		case .teaspoon: return "tsp"
		case .drop: return "gtt"
		case .sachet: return "sach"
		case .puff: return "puff"
		case .nebule: return "neb"
		case .injection: return "inj"
		case .tablespoon: return "tbsp"
		case .pen: return "pen"
		case .inhaler: return "inh"
		case .vial: return "vial"
		case .patch: return "patch"
		case .application: return "app"
		case .spray: return "spr"
		case .strip: return "strip"
		case .film: return "film"
		case .dose: return "dose"
		case .ampule: return "amp"
		case .bowl: return "bowl"
		case .joint: return "joint"
		case .dab: return "dab"
		}
	}

	/// A brief clinical description for each unit.
	public var clinicalDescription: String {
		switch self {
		case .milligram: return "A metric unit of mass commonly used for medication dosing."
		case .gram: return "A metric unit of mass, used for larger medication doses."
		case .microgram: return "A small metric unit of mass for precise dosing."
		case .unit: return "A standardized quantity used for some biological medications."
		case .tablet: return "Solid oral medication, typically swallowed whole or split."
		case .capsule: return "Solid oral medication in a gelatin shell."
		case .chewable: return "A tablet designed to be chewed before swallowing."
		case .lozenge: return "A medicated tablet dissolving slowly in the mouth."
		case .suppository: return "Solid medication inserted into the rectum, vagina, or urethra."
		case .milliliter: return "A metric unit of volume for liquid medications."
		case .liter: return "A metric unit for larger liquid medication volumes."
		case .teaspoon: return "A small volume, approximately 5 mL, often used in pediatrics."
		case .drop: return "A single drop, used for eye, ear, or nasal medications."
		case .sachet: return "A small packet containing powder or granules."
		case .puff: return "A single actuation of an inhaler."
		case .nebule: return "A unit-dose container for nebulizer medications."
		case .injection: return "A dose delivered via needle into muscle, vein, or subcutaneous tissue."
		case .tablespoon: return "A household volume measurement, approximately 15 mL."
		case .pen: return "A pre-filled injection device, commonly used for insulin or biologics."
		case .inhaler: return "A dose delivered via dry powder inhaler device."
		case .vial: return "A small bottle for injectable or inhalation medications."
		case .patch: return "A medicated adhesive applied to the skin."
		case .application: return "A single use of a topical product (cream, ointment, gel, etc.)."
		case .spray: return "A single metered dose delivered as a spray."
		case .strip: return "A thin film placed in the mouth for absorption."
		case .film: return "A medicated film for buccal or sublingual absorption."
		case .dose: return "A general dosage unit when no specific type applies."
		case .ampule: return "A sealed glass container for a single dose of medication."
		case .bowl: return "A measured amount of cannabis flower consumed via pipe or water pipe."
		case .joint: return "A cannabis cigarette containing a measured amount of cannabis flower."
		case .dab: return "A concentrated cannabis extract consumed via vaporization or dabbing."
		}
	}

	/// All selectable units for use in UI (e.g., Picker).
	public static var selectableUnits: [ANUnitConcept] { allCases }

	/// The most common medication units for use in UI pickers and dose entry screens.
	public static var commonUnits: [ANUnitConcept] {
		[
			.milligram,
			.milliliter,
			.unit,
			.tablet,
			.capsule,
			.puff,
			.drop,
			.dose,
			.injection,
			.tablespoon,
			.pen
		]
	}

	// MARK: - Unit Properties

	/// Indicates if this unit is weight-based (mass measurement)
	public var isWeightBased: Bool {
		switch self {
		case .milligram, .gram, .microgram:
			return true
		default:
			return false
		}
	}

	/// Indicates if this unit is volume-based (liquid measurement)
	public var isVolumeBased: Bool {
		switch self {
		case .milliliter, .liter, .teaspoon, .tablespoon, .drop:
			return true
		default:
			return false
		}
	}

	/// Indicates if this unit is count-based (discrete items)
	public var isCountBased: Bool {
		switch self {
		case .tablet, .capsule, .chewable, .lozenge, .suppository, .puff, .nebule,
			 .injection, .pen, .inhaler, .vial, .patch, .application, .spray, .strip,
			 .film, .dose, .ampule, .sachet, .bowl, .joint, .dab, .unit:
			return true
		default:
			return false
		}
	}

}
