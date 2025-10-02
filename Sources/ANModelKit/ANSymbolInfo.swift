import Foundation

/// Represents SF Symbol configuration for a medication
public struct ANSymbolInfo: Codable, Equatable, Hashable, Sendable {
	/// The SF Symbol name (e.g., "pills.fill", "star.fill")
	public var name: String

	/// Minimum iOS version required for this symbol (e.g., "17.0")
	/// If nil, the symbol is available on all supported iOS versions
	public var minimumVersion: String?

	/// Alternative symbol name to use if the primary symbol is unavailable
	/// This provides graceful fallback for older iOS versions
	public var fallbackName: String?

	/// Initialize a new symbol configuration
	/// - Parameters:
	///   - name: The SF Symbol name
	///   - minimumVersion: Optional iOS version requirement
	///   - fallbackName: Optional fallback symbol name
	public init(name: String, minimumVersion: String? = nil, fallbackName: String? = nil) {
		self.name = name
		self.minimumVersion = minimumVersion
		self.fallbackName = fallbackName
	}

	/// Returns the appropriate symbol name based on iOS availability
	/// - Parameter currentVersion: The current iOS version (defaults to current device version)
	/// - Returns: The primary symbol name if available, otherwise the fallback name
	public func availableSymbolName(for currentVersion: String? = nil) -> String {
		// If no minimum version is specified, the primary symbol is always available
		guard let minimumVersion = minimumVersion else {
			return name
		}

		// If we can't determine the current version, return primary name
		guard let currentVersion = currentVersion else {
			return name
		}

		// Compare versions and return appropriate symbol
		if isVersionAvailable(minimumVersion, currentVersion: currentVersion) {
			return name
		} else {
			return fallbackName ?? name
		}
	}

	/// Helper method to compare version strings
	private func isVersionAvailable(_ requiredVersion: String, currentVersion: String) -> Bool {
		let requiredComponents = requiredVersion.split(separator: ".").compactMap { Int($0) }
		let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }

		for i in 0..<max(requiredComponents.count, currentComponents.count) {
			let required = i < requiredComponents.count ? requiredComponents[i] : 0
			let current = i < currentComponents.count ? currentComponents[i] : 0

			if current > required {
				return true
			} else if current < required {
				return false
			}
		}

		return true // Versions are equal
	}
}