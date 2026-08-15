class_name Judge

static func make_law_book() -> Array[Law]:
	var laws: Array[Law] = [
		Law.new(Vocab.Action.SING, Vocab.Location.LIBRARY, "No singing in the library."),
		Law.new(Vocab.Action.SLEEP, Vocab.Location.BANK, "No sleeping at the bank."),
		Law.new(Vocab.Action.SHOUT, Vocab.Location.PARK, "No shouting in the park."),
	]
	return laws


static func make_case(evidence_count: int = 5) -> Array[Evidence]:
	var actions := Vocab.Action.values()
	var locations := Vocab.Location.values()
	var evidence: Array[Evidence] = []
	for i in evidence_count:
		evidence.append(Evidence.new(actions.pick_random(), locations.pick_random()))
	return evidence


# For each law, count how many pieces of evidence break it. Return one Charge per
# law that was broken at least once.
static func evaluate(evidence: Array[Evidence], law_book: Array[Law]) -> Array[Charge]:
	var charges: Array[Charge] = []
	for law in law_book:
		var count := 0
		for e in evidence:
			if law.is_broken_by(e):
				count += 1
		if count > 0:
			charges.append(Charge.new(law, count))
	return charges


# e.g. "Sang in the park."
static func evidence_sentence(e: Evidence) -> String:
	return "%s %s." % [Vocab.ACTION_PAST[e.action], Vocab.LOCATION_PHRASE[e.location]]


# e.g. "3 counts of illegal singing in the park."
static func charge_sentence(c: Charge) -> String:
	var word := "count" if c.count == 1 else "counts"
	return "%d %s of illegal %s %s." % [
		c.count,
		word,
		Vocab.ACTION_GERUND[c.law.action],
		Vocab.LOCATION_PHRASE[c.law.location],
	]
