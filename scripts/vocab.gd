class_name Vocab

enum Action {
	SING,
	DANCE,
	SLEEP,
	SHOUT,
}

enum Location {
	PARK,
	BANK,
	STREET,
	LIBRARY,
}

# Past tense, for evidence sentences: "Sang in the park."
const ACTION_PAST := {
	Action.SING: "Sang",
	Action.DANCE: "Danced",
	Action.SLEEP: "Slept",
	Action.SHOUT: "Shouted",
}

# "-ing" form, for charge sentences: "illegal singing in the park".
const ACTION_GERUND := {
	Action.SING: "singing",
	Action.DANCE: "dancing",
	Action.SLEEP: "sleeping",
	Action.SHOUT: "shouting",
}

# Location with its preposition, used by both kinds of sentence.
const LOCATION_PHRASE := {
	Location.PARK: "in the park",
	Location.BANK: "at the bank",
	Location.STREET: "on the street",
	Location.LIBRARY: "in the library",
}
