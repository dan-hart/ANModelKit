import Foundation

/// Manages SF Symbol search, validation, and suggestions for medical and general use
public struct ANSymbolManager: Sendable {

	/// Metadata for each symbol in our database
	public struct SymbolMetadata: Codable, Equatable, Sendable {
		/// The SF Symbol name (e.g., "pills.fill")
		public let name: String

		/// Human-readable description of the symbol
		public let description: String

		/// Category for organization and filtering
		public let category: SymbolCategory

		/// Additional search terms for this symbol
		public let keywords: [String]

		/// Minimum iOS version where this symbol is available
		public let minimumVersion: String

		/// Available style variants (e.g., ["", "fill", "circle", "circle.fill"])
		public let variants: [String]

		public init(name: String, description: String, category: SymbolCategory,
					keywords: [String] = [], minimumVersion: String = "13.0",
					variants: [String] = [""]) {
			self.name = name
			self.description = description
			self.category = category
			self.keywords = keywords
			self.minimumVersion = minimumVersion
			self.variants = variants
		}
	}

	/// Categories for organizing symbols
	public enum SymbolCategory: String, Codable, CaseIterable, Sendable {
		case medical = "Medical"
		case health = "Health"
		case medication = "Medication"
		case time = "Time"
		case alerts = "Alerts"
		case general = "General"
		case shapes = "Shapes"
		case numbers = "Numbers"
		case nature = "Nature"
		case actions = "Actions"
	}

	/// Search result with relevance scoring
	public struct SearchResult: Sendable {
		public let symbol: SymbolMetadata
		public let relevanceScore: Double

		init(symbol: SymbolMetadata, relevanceScore: Double) {
			self.symbol = symbol
			self.relevanceScore = relevanceScore
		}
	}

	/// Singleton instance for accessing the symbol manager
	public static let shared = ANSymbolManager()

	private init() {}

	/// Search for symbols matching the query
	/// - Parameters:
	///   - query: The search text
	///   - category: Optional category filter
	///   - limit: Maximum number of results to return
	/// - Returns: Array of search results sorted by relevance
	public func searchSymbols(query: String, category: SymbolCategory? = nil, limit: Int = 20) -> [SearchResult] {
		let lowercaseQuery = query.lowercased()
		var results: [SearchResult] = []

		// Get symbols from database
		let symbols = category != nil
			? ANSymbolDatabase.symbols.filter { $0.category == category }
			: ANSymbolDatabase.symbols

		for symbol in symbols {
			var score: Double = 0

			// Exact name match (highest score)
			if symbol.name.lowercased() == lowercaseQuery {
				score = 100
			}
			// Name starts with query
			else if symbol.name.lowercased().hasPrefix(lowercaseQuery) {
				score = 80
			}
			// Name contains query
			else if symbol.name.lowercased().contains(lowercaseQuery) {
				score = 60
			}
			// Description contains query
			else if symbol.description.lowercased().contains(lowercaseQuery) {
				score = 40
			}
			// Keywords contain query
			else if symbol.keywords.contains(where: { $0.lowercased().contains(lowercaseQuery) }) {
				score = 30
			}
			// Fuzzy match on description
			else if fuzzyMatch(query: lowercaseQuery, in: symbol.description.lowercased()) {
				score = 20
			}

			if score > 0 {
				results.append(SearchResult(symbol: symbol, relevanceScore: score))
			}
		}

		// Sort by relevance score and limit results
		return Array(results.sorted { $0.relevanceScore > $1.relevanceScore }.prefix(limit))
	}

	/// Check if a symbol is available for a specific iOS version
	/// - Parameters:
	///   - symbolName: The SF Symbol name
	///   - iOSVersion: The iOS version to check against
	/// - Returns: true if the symbol is available, false otherwise
	public func isSymbolAvailable(_ symbolName: String, for iOSVersion: String) -> Bool {
		guard let symbol = getSymbolInfo(symbolName) else { return false }
		return compareVersions(iOSVersion, isAtLeast: symbol.minimumVersion)
	}

	/// Get suggested symbols based on medication name
	/// - Parameter medicationName: The name of the medication
	/// - Returns: Array of suggested symbols sorted by relevance
	public func getSuggestedSymbols(for medicationName: String) -> [SearchResult] {
		let lowercaseName = medicationName.lowercased()
		var suggestions: [SearchResult] = []

		// Check for specific medication types
		if lowercaseName.contains("pill") || lowercaseName.contains("tablet") ||
		   lowercaseName.contains("capsule") {
			if let symbol = getSymbolInfo("pills.fill") {
				suggestions.append(SearchResult(symbol: symbol, relevanceScore: 90))
			}
		}

		if lowercaseName.contains("inject") || lowercaseName.contains("insulin") {
			if let symbol = getSymbolInfo("syringe.fill") {
				suggestions.append(SearchResult(symbol: symbol, relevanceScore: 90))
			}
		}

		if lowercaseName.contains("drop") || lowercaseName.contains("liquid") {
			if let symbol = getSymbolInfo("drop.fill") {
				suggestions.append(SearchResult(symbol: symbol, relevanceScore: 90))
			}
		}

		if lowercaseName.contains("inhale") || lowercaseName.contains("puff") {
			if let symbol = getSymbolInfo("lungs.fill") {
				suggestions.append(SearchResult(symbol: symbol, relevanceScore: 90))
			}
		}

		if lowercaseName.contains("heart") || lowercaseName.contains("cardiac") {
			if let symbol = getSymbolInfo("heart.fill") {
				suggestions.append(SearchResult(symbol: symbol, relevanceScore: 90))
			}
		}

		// Add general medical symbols as fallback suggestions
		let fallbackSymbols = ["cross.case.fill", "pills", "medical.thermometer", "bandage.fill"]
		for symbolName in fallbackSymbols {
			if let symbol = getSymbolInfo(symbolName) {
				suggestions.append(SearchResult(symbol: symbol, relevanceScore: 50))
			}
		}

		// Remove duplicates and sort by relevance
		var uniqueSymbols = Set<String>()
		return suggestions.filter { result in
			if uniqueSymbols.contains(result.symbol.name) {
				return false
			}
			uniqueSymbols.insert(result.symbol.name)
			return true
		}.sorted { $0.relevanceScore > $1.relevanceScore }
	}

	/// Get information about a specific symbol
	/// - Parameter symbolName: The SF Symbol name
	/// - Returns: Symbol metadata if found
	public func getSymbolInfo(_ symbolName: String) -> SymbolMetadata? {
		return ANSymbolDatabase.symbols.first { $0.name == symbolName }
	}

	/// Get all symbols in a specific category
	/// - Parameter category: The category to filter by
	/// - Returns: Array of symbols in that category
	public func getSymbolsByCategory(_ category: SymbolCategory) -> [SymbolMetadata] {
		return ANSymbolDatabase.symbols.filter { $0.category == category }
	}

	/// Get all available categories
	/// - Returns: Array of all symbol categories
	public func getAllCategories() -> [SymbolCategory] {
		return SymbolCategory.allCases
	}

	// MARK: - Private Helpers

	/// Simple fuzzy matching algorithm
	private func fuzzyMatch(query: String, in text: String) -> Bool {
		var searchIndex = query.startIndex

		for char in text {
			if searchIndex < query.endIndex && char == query[searchIndex] {
				searchIndex = query.index(after: searchIndex)
			}
			if searchIndex == query.endIndex {
				return true
			}
		}

		return false
	}

	/// Compare iOS version strings
	private func compareVersions(_ version: String, isAtLeast minVersion: String) -> Bool {
		let versionComponents = version.split(separator: ".").compactMap { Int($0) }
		let minComponents = minVersion.split(separator: ".").compactMap { Int($0) }

		for i in 0..<max(versionComponents.count, minComponents.count) {
			let v = i < versionComponents.count ? versionComponents[i] : 0
			let m = i < minComponents.count ? minComponents[i] : 0

			if v > m {
				return true
			} else if v < m {
				return false
			}
		}

		return true // Versions are equal
	}
}