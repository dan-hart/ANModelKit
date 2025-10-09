import Foundation

/// Represents a medication definition with a clinical name and optional user nickname.
public struct ANMedicationConcept: Identifiable, Equatable, Hashable, Sendable {
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
	/// SF Symbol configuration for visual representation
	public var symbolInfo: ANSymbolInfo?

	// MARK: - Additional Properties

	/// RxNorm code for clinical interoperability (e.g., "308192" for "Amoxicillin Trihydrate 500mg Oral Tablet")
	/// Used to standardize medication identification across health systems
	public var rxNormCode: String?
	/// Indicates if the medication is archived/no longer being taken
	public var isArchived: Bool

	/// Initialize a new medication concept
	public init(id: UUID = UUID(), clinicalName: String, nickname: String? = nil, quantity: Double? = nil, initialQuantity: Double? = nil, displayColorHex: String? = nil, lastRefillDate: Date? = nil, nextRefillDate: Date? = nil, prescribedUnit: ANUnitConcept? = nil, prescribedDoseAmount: Double? = nil, symbolInfo: ANSymbolInfo? = nil, rxNormCode: String? = nil, isArchived: Bool = false) {
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
		self.symbolInfo = symbolInfo
		self.rxNormCode = rxNormCode
		self.isArchived = isArchived
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
			symbolInfo: symbolInfo,
			rxNormCode: rxNormCode,
			isArchived: isArchived
		)
	}
}

// MARK: - Codable
extension ANMedicationConcept: Codable {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		id = try container.decode(UUID.self, forKey: .id)
		clinicalName = try container.decode(String.self, forKey: .clinicalName)
		nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
		quantity = try container.decodeIfPresent(Double.self, forKey: .quantity)
		initialQuantity = try container.decodeIfPresent(Double.self, forKey: .initialQuantity)
		displayColorHex = try container.decodeIfPresent(String.self, forKey: .displayColorHex)
		lastRefillDate = try container.decodeIfPresent(Date.self, forKey: .lastRefillDate)
		nextRefillDate = try container.decodeIfPresent(Date.self, forKey: .nextRefillDate)
		prescribedUnit = try container.decodeIfPresent(ANUnitConcept.self, forKey: .prescribedUnit)
		prescribedDoseAmount = try container.decodeIfPresent(Double.self, forKey: .prescribedDoseAmount)
		symbolInfo = try container.decodeIfPresent(ANSymbolInfo.self, forKey: .symbolInfo)
		rxNormCode = try container.decodeIfPresent(String.self, forKey: .rxNormCode)

		// Provide default value for backwards compatibility with older JSON formats
		isArchived = try container.decodeIfPresent(Bool.self, forKey: .isArchived) ?? false
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(id, forKey: .id)
		try container.encode(clinicalName, forKey: .clinicalName)
		try container.encodeIfPresent(nickname, forKey: .nickname)
		try container.encodeIfPresent(quantity, forKey: .quantity)
		try container.encodeIfPresent(initialQuantity, forKey: .initialQuantity)
		try container.encodeIfPresent(displayColorHex, forKey: .displayColorHex)
		try container.encodeIfPresent(lastRefillDate, forKey: .lastRefillDate)
		try container.encodeIfPresent(nextRefillDate, forKey: .nextRefillDate)
		try container.encodeIfPresent(prescribedUnit, forKey: .prescribedUnit)
		try container.encodeIfPresent(prescribedDoseAmount, forKey: .prescribedDoseAmount)
		try container.encodeIfPresent(symbolInfo, forKey: .symbolInfo)
		try container.encodeIfPresent(rxNormCode, forKey: .rxNormCode)
		try container.encode(isArchived, forKey: .isArchived)
	}

	private enum CodingKeys: String, CodingKey {
		case id
		case clinicalName
		case nickname
		case quantity
		case initialQuantity
		case displayColorHex
		case lastRefillDate
		case nextRefillDate
		case prescribedUnit
		case prescribedDoseAmount
		case symbolInfo
		case rxNormCode
		case isArchived
	}
}
