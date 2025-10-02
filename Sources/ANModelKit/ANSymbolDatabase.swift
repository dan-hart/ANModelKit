import Foundation

/// Static database of SF Symbols for medical and general use
public enum ANSymbolDatabase {

	/// Complete collection of curated symbols with descriptions
	public static let symbols: [ANSymbolManager.SymbolMetadata] = [

		// MARK: - Medical & Medication Symbols

		ANSymbolManager.SymbolMetadata(
			name: "pills",
			description: "Two pill capsules, ideal for oral medications and tablets",
			category: .medication,
			keywords: ["medicine", "tablet", "capsule", "oral", "pharmaceutical"],
			minimumVersion: "14.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "pills.fill",
			description: "Filled pill capsules, perfect for solid oral medications",
			category: .medication,
			keywords: ["medicine", "tablet", "capsule", "oral", "drug"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "syringe",
			description: "Medical syringe for injectable medications and vaccines",
			category: .medication,
			keywords: ["injection", "vaccine", "insulin", "shot", "needle"],
			minimumVersion: "14.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "syringe.fill",
			description: "Filled syringe icon for injectable medications",
			category: .medication,
			keywords: ["injection", "vaccine", "insulin", "shot", "immunization"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "bandage",
			description: "Adhesive bandage for wound care and topical medications",
			category: .medical,
			keywords: ["wound", "injury", "first aid", "patch", "adhesive"],
			minimumVersion: "15.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "bandage.fill",
			description: "Filled bandage for topical treatments and wound care",
			category: .medical,
			keywords: ["wound", "topical", "patch", "adhesive", "dressing"],
			minimumVersion: "15.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "cross.case",
			description: "Medical kit with cross symbol for emergency medications",
			category: .medical,
			keywords: ["emergency", "first aid", "medical kit", "rescue", "healthcare"],
			minimumVersion: "14.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "cross.case.fill",
			description: "Filled medical kit for emergency or rescue medications",
			category: .medical,
			keywords: ["emergency", "first aid", "rescue", "urgent", "medical"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "medical.thermometer",
			description: "Thermometer for fever medications and temperature monitoring",
			category: .medical,
			keywords: ["fever", "temperature", "illness", "sick", "flu"],
			minimumVersion: "15.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "stethoscope",
			description: "Stethoscope representing medical care and prescriptions",
			category: .medical,
			keywords: ["doctor", "physician", "medical", "healthcare", "prescription"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "facemask",
			description: "Face mask for respiratory medications or protection",
			category: .medical,
			keywords: ["respiratory", "breathing", "protection", "covid", "mask"],
			minimumVersion: "15.0",
			variants: ["", "fill"]
		),

		// MARK: - Health & Body Symbols

		ANSymbolManager.SymbolMetadata(
			name: "heart",
			description: "Heart symbol for cardiovascular medications",
			category: .health,
			keywords: ["cardiac", "cardiovascular", "blood pressure", "cardio"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill", "slash", "slash.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "heart.fill",
			description: "Filled heart for heart and cardiovascular medications",
			category: .health,
			keywords: ["cardiac", "cardiovascular", "love", "health", "cardio"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "heart.text.square",
			description: "Heart with text for cardiac medication notes",
			category: .health,
			keywords: ["cardiac", "notes", "prescription", "medical record"],
			minimumVersion: "14.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "lungs",
			description: "Lungs symbol for respiratory medications",
			category: .health,
			keywords: ["respiratory", "breathing", "asthma", "inhaler", "pulmonary"],
			minimumVersion: "14.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "lungs.fill",
			description: "Filled lungs for respiratory and breathing medications",
			category: .health,
			keywords: ["respiratory", "breathing", "asthma", "copd", "inhaler"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "brain",
			description: "Brain symbol for neurological medications",
			category: .health,
			keywords: ["neurological", "mental", "cognitive", "neurology", "psychiatric"],
			minimumVersion: "15.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "brain.head.profile",
			description: "Head profile with brain for mental health medications",
			category: .health,
			keywords: ["mental health", "psychiatric", "psychology", "cognitive"],
			minimumVersion: "15.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "eye",
			description: "Eye symbol for ophthalmic medications and eye drops",
			category: .health,
			keywords: ["vision", "ophthalmic", "eye drops", "optical", "sight"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill", "slash", "slash.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "ear",
			description: "Ear symbol for ear drops and hearing medications",
			category: .health,
			keywords: ["hearing", "ear drops", "auditory", "otic"],
			minimumVersion: "15.0",
			variants: ["", "fill"]
		),

		// MARK: - Liquid & Topical Symbols

		ANSymbolManager.SymbolMetadata(
			name: "drop",
			description: "Water droplet for liquid medications and drops",
			category: .medication,
			keywords: ["liquid", "drops", "eye drops", "ear drops", "oral liquid"],
			minimumVersion: "14.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "drop.fill",
			description: "Filled droplet for liquid medications and solutions",
			category: .medication,
			keywords: ["liquid", "solution", "suspension", "drops", "fluid"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "humidity",
			description: "Humidity drops for nasal sprays and inhalants",
			category: .medication,
			keywords: ["spray", "nasal", "mist", "inhale", "nebulizer"],
			minimumVersion: "15.0",
			variants: ["", "fill"]
		),

		// MARK: - Time & Schedule Symbols

		ANSymbolManager.SymbolMetadata(
			name: "clock",
			description: "Clock for time-sensitive medications",
			category: .time,
			keywords: ["time", "schedule", "timing", "hourly", "timed"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "clock.fill",
			description: "Filled clock for scheduled medication times",
			category: .time,
			keywords: ["schedule", "time", "routine", "daily", "timing"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "alarm",
			description: "Alarm clock for medication reminders",
			category: .time,
			keywords: ["reminder", "alert", "notification", "wake", "morning"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "timer",
			description: "Timer for countdown to next dose",
			category: .time,
			keywords: ["countdown", "interval", "duration", "timing"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "calendar",
			description: "Calendar for scheduled medications",
			category: .time,
			keywords: ["schedule", "date", "appointment", "monthly", "weekly"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "calendar.circle",
			description: "Calendar in circle for periodic medications",
			category: .time,
			keywords: ["schedule", "periodic", "routine", "regular"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "moon",
			description: "Moon symbol for nighttime medications",
			category: .time,
			keywords: ["night", "evening", "bedtime", "pm", "sleep"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "moon.fill",
			description: "Filled moon for bedtime or evening medications",
			category: .time,
			keywords: ["night", "sleep", "bedtime", "evening", "pm"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "sun.max",
			description: "Bright sun for morning medications",
			category: .time,
			keywords: ["morning", "day", "daytime", "am", "sunrise"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "sunrise",
			description: "Sunrise for early morning medications",
			category: .time,
			keywords: ["morning", "dawn", "early", "am", "wake"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		// MARK: - Alert & Warning Symbols

		ANSymbolManager.SymbolMetadata(
			name: "exclamationmark.triangle",
			description: "Warning triangle for medications with precautions",
			category: .alerts,
			keywords: ["warning", "caution", "alert", "important", "danger"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "exclamationmark.triangle.fill",
			description: "Filled warning for high-risk medications",
			category: .alerts,
			keywords: ["warning", "danger", "critical", "caution", "risk"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "exclamationmark.circle",
			description: "Circular alert for important medication notes",
			category: .alerts,
			keywords: ["alert", "attention", "notice", "important"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "bell",
			description: "Bell for medication notifications",
			category: .alerts,
			keywords: ["notification", "reminder", "alert", "ring"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill", "slash", "slash.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "bell.fill",
			description: "Filled bell for active medication reminders",
			category: .alerts,
			keywords: ["reminder", "notification", "alert", "active"],
			minimumVersion: "13.0"
		),

		// MARK: - General Purpose Symbols

		ANSymbolManager.SymbolMetadata(
			name: "star",
			description: "Star to mark favorite or important medications",
			category: .general,
			keywords: ["favorite", "important", "priority", "special", "bookmark"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill", "square", "square.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "star.fill",
			description: "Filled star for priority medications",
			category: .general,
			keywords: ["priority", "important", "favorite", "essential"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "flag",
			description: "Flag to mark or highlight medications",
			category: .general,
			keywords: ["mark", "highlight", "attention", "note", "tag"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "flag.fill",
			description: "Filled flag for flagged medications",
			category: .general,
			keywords: ["flagged", "marked", "tagged", "highlight"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "bookmark",
			description: "Bookmark for saved medications",
			category: .general,
			keywords: ["save", "mark", "remember", "note"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "tag",
			description: "Tag for labeling medications",
			category: .general,
			keywords: ["label", "category", "organize", "classify"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		// MARK: - Action Symbols

		ANSymbolManager.SymbolMetadata(
			name: "arrow.up",
			description: "Up arrow for increasing dosage",
			category: .actions,
			keywords: ["increase", "up", "more", "higher", "raise"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill", "square", "square.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "arrow.up.circle",
			description: "Up arrow in circle for dosage increase",
			category: .actions,
			keywords: ["increase", "raise", "up", "more"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "arrow.down",
			description: "Down arrow for decreasing dosage",
			category: .actions,
			keywords: ["decrease", "down", "less", "lower", "reduce"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill", "square", "square.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "arrow.down.circle",
			description: "Down arrow in circle for dosage decrease",
			category: .actions,
			keywords: ["decrease", "reduce", "down", "less"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "arrow.clockwise",
			description: "Circular arrow for refill or repeat medications",
			category: .actions,
			keywords: ["refill", "repeat", "renew", "cycle", "rotate"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "checkmark",
			description: "Checkmark for completed doses",
			category: .actions,
			keywords: ["complete", "done", "taken", "finished", "success"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill", "square", "square.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "checkmark.circle",
			description: "Checkmark in circle for taken medications",
			category: .actions,
			keywords: ["taken", "complete", "done", "success"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "checkmark.circle.fill",
			description: "Filled checkmark circle for completed doses",
			category: .actions,
			keywords: ["completed", "taken", "done", "confirmed"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "xmark",
			description: "X mark for skipped or missed doses",
			category: .actions,
			keywords: ["skip", "miss", "cancel", "no", "stop"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill", "square", "square.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "xmark.circle",
			description: "X in circle for skipped medications",
			category: .actions,
			keywords: ["skipped", "missed", "not taken", "cancel"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "plus",
			description: "Plus sign for adding medications",
			category: .actions,
			keywords: ["add", "new", "plus", "more", "increase"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill", "square", "square.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "minus",
			description: "Minus sign for removing medications",
			category: .actions,
			keywords: ["remove", "subtract", "less", "delete"],
			minimumVersion: "13.0",
			variants: ["", "circle", "circle.fill", "square", "square.fill"]
		),

		// MARK: - Nature Symbols

		ANSymbolManager.SymbolMetadata(
			name: "leaf",
			description: "Leaf for natural or herbal medications",
			category: .nature,
			keywords: ["natural", "herbal", "organic", "plant", "holistic"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "leaf.fill",
			description: "Filled leaf for plant-based medications",
			category: .nature,
			keywords: ["herbal", "natural", "organic", "botanical"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "bolt",
			description: "Lightning bolt for energy supplements",
			category: .nature,
			keywords: ["energy", "stimulant", "power", "boost", "vitamin"],
			minimumVersion: "13.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "bolt.fill",
			description: "Filled bolt for energy or stimulant medications",
			category: .nature,
			keywords: ["energy", "stimulant", "caffeine", "boost"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "sparkles",
			description: "Sparkles for new or special medications",
			category: .nature,
			keywords: ["new", "special", "magic", "clean", "fresh"],
			minimumVersion: "13.0"
		),

		// MARK: - Shape Symbols

		ANSymbolManager.SymbolMetadata(
			name: "circle",
			description: "Circle shape for visual categorization",
			category: .shapes,
			keywords: ["shape", "round", "dot", "point"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "circle.fill",
			description: "Filled circle for marking medications",
			category: .shapes,
			keywords: ["dot", "point", "marker", "bullet"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "square",
			description: "Square shape for visual categorization",
			category: .shapes,
			keywords: ["shape", "box", "category"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "square.fill",
			description: "Filled square for marking medications",
			category: .shapes,
			keywords: ["box", "block", "marker"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "triangle",
			description: "Triangle shape for visual categorization",
			category: .shapes,
			keywords: ["shape", "point", "arrow"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "triangle.fill",
			description: "Filled triangle for marking medications",
			category: .shapes,
			keywords: ["marker", "point", "arrow"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "diamond",
			description: "Diamond shape for special medications",
			category: .shapes,
			keywords: ["shape", "special", "unique", "gem"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "diamond.fill",
			description: "Filled diamond for premium medications",
			category: .shapes,
			keywords: ["special", "premium", "unique"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "hexagon",
			description: "Hexagon shape for visual categorization",
			category: .shapes,
			keywords: ["shape", "six", "category"],
			minimumVersion: "14.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "hexagon.fill",
			description: "Filled hexagon for marking medications",
			category: .shapes,
			keywords: ["marker", "shape", "category"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "capsule",
			description: "Capsule shape matching medication form",
			category: .shapes,
			keywords: ["pill", "medication", "shape", "oval"],
			minimumVersion: "14.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "capsule.fill",
			description: "Filled capsule shape for medications",
			category: .shapes,
			keywords: ["pill", "medication", "tablet"],
			minimumVersion: "14.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "cross",
			description: "Cross shape for medical categorization",
			category: .shapes,
			keywords: ["medical", "health", "plus", "add"],
			minimumVersion: "14.0",
			variants: ["", "fill", "circle", "circle.fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "cross.fill",
			description: "Filled cross for medical categories",
			category: .shapes,
			keywords: ["medical", "health", "hospital"],
			minimumVersion: "14.0"
		),

		// MARK: - Number Symbols

		ANSymbolManager.SymbolMetadata(
			name: "1.circle",
			description: "Number 1 in circle for once-daily medications",
			category: .numbers,
			keywords: ["one", "once", "daily", "first"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "1.circle.fill",
			description: "Filled number 1 for once-daily dosing",
			category: .numbers,
			keywords: ["one", "once", "single", "daily"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "2.circle",
			description: "Number 2 in circle for twice-daily medications",
			category: .numbers,
			keywords: ["two", "twice", "bid", "second"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "2.circle.fill",
			description: "Filled number 2 for twice-daily dosing",
			category: .numbers,
			keywords: ["two", "twice", "bid", "double"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "3.circle",
			description: "Number 3 in circle for three-times-daily medications",
			category: .numbers,
			keywords: ["three", "tid", "triple", "third"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "3.circle.fill",
			description: "Filled number 3 for three-times-daily dosing",
			category: .numbers,
			keywords: ["three", "tid", "triple"],
			minimumVersion: "13.0"
		),

		ANSymbolManager.SymbolMetadata(
			name: "4.circle",
			description: "Number 4 in circle for four-times-daily medications",
			category: .numbers,
			keywords: ["four", "qid", "fourth"],
			minimumVersion: "13.0",
			variants: ["", "fill"]
		),

		ANSymbolManager.SymbolMetadata(
			name: "4.circle.fill",
			description: "Filled number 4 for four-times-daily dosing",
			category: .numbers,
			keywords: ["four", "qid", "quad"],
			minimumVersion: "13.0"
		)
	]
}