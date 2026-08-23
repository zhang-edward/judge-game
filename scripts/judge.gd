class_name Judge

const OBJECT_POINTS := 1
const LOCATION_POINTS := 2
const ACTION_POINTS := 4
const TWO_ASPECT_POINTS := 5
const THREE_ASPECT_POINTS := 12
const IRRELEVANT_PENALTY := 1 # penalty per piece that proves no crime aspect
const MISMATCH_PENALTY := 4 # penalty per piece filed against the wrong suspect
const WIN_SCALE := 3.0 # points -> % chance to win

static func make_law_book() -> Array[Law]:
	var laws: Array[Law] = [
		Law.new(Vocab.action("sing"), null, Vocab.location("library")),
		Law.new(Vocab.action("sleep"), null, Vocab.location("bank")),
		Law.new(Vocab.action("shout"), null, Vocab.location("park")),
		Law.new(Vocab.action("carry"), Vocab.category("weapon")),
		Law.new(Vocab.action("possess"), Vocab.category("animal")),
		Law.new(Vocab.action("sell"), Vocab.category("food"), Vocab.location("street")),
	]
	return laws

# Score evidence against a charge, as a 0-100 % chance to win the case
static func score(evidence: Array[Evidence], charge: Charge, suspect: Suspect = null) -> float:
	if charge == null:
		return 0.0
	var result := build_buckets(evidence, charge.law, suspect)
	var buckets: Dictionary = result["buckets"]
	var total := 0.0
	for time in buckets:
		total += _bucket_points(buckets[time])
	total -= result["irrelevant"] * IRRELEVANT_PENALTY
	total -= result["mismatch"] * MISMATCH_PENALTY
	return clampf(total * WIN_SCALE, 0.0, 100.0)

static func build_buckets(evidence: Array[Evidence], law: Law, suspect: Suspect = null) -> Dictionary:
	var buckets := {}
	var irrelevant_count := 0
	var mismatch_count := 0
	for e in evidence:
		# Evidence is about a different suspect
		if suspect != null and e.suspect != suspect:
			mismatch_count += 1
			continue
		var aspects := _matched_aspects(e, law)
		if aspects.is_empty():
			irrelevant_count += 1
			continue
		for aspect in aspects:
			if not buckets.has(e.time):
				buckets[e.time] = {}
			buckets[e.time][aspect] = true
	return {"buckets": buckets, "irrelevant": irrelevant_count, "mismatch": mismatch_count}

# Which crime aspects a single piece of evidence matches
static func _matched_aspects(e: Evidence, law: Law) -> Array:
	var aspects := []
	if law.action != null and e.action == law.action:
		aspects.append("action")
	if law.category != null and e.has_category(law.category):
		aspects.append("object")
	if law.location != null and e.location == law.location:
		aspects.append("location")
	return aspects

# Points for one time bucket, scored by its best tier
static func _bucket_points(aspect_set: Dictionary) -> float:
	if aspect_set.size() >= 3:
		return THREE_ASPECT_POINTS
	if aspect_set.size() == 2:
		return TWO_ASPECT_POINTS
	if aspect_set.has("action"):
		return ACTION_POINTS
	if aspect_set.has("object"):
		return OBJECT_POINTS
	if aspect_set.has("location"):
		return LOCATION_POINTS
	return 0.0
