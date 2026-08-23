class_name CutsceneBuilder

const SECTION_ORDER := ["l", "a", "o", "ol", "al", "ao", "aol"]

const OPENERS := [
	"As you can see, Your Honor,",
	"We have substantive proof that",
	"The record clearly shows that",
	"It is beyond all doubt that",
	"Let the court note that",
	"The prosecution submits that",
	"Witness after witness confirms that",
]

static func build(c: Case, success: bool) -> Array[CutsceneBeat]:
	var beats: Array[CutsceneBeat] = []
	var suspect_name := c.suspect.name

	beats.append(CutsceneBeat.new("The defendant stands accused of " + _crime_text(c) + "."))

	if c.charge != null:
		var sections := _group_artifacts_by_section(c, c.charge.law)
		var openers := OPENERS.duplicate()
		openers.shuffle()
		for key in SECTION_ORDER:
			if not sections.has(key) or sections[key].is_empty():
				continue
			var line := _next_opener(openers) + " " + _claim_for(key, suspect_name, c.charge.law) + "."
			beats.append(CutsceneBeat.new(line, sections[key]))
		var irrelevant := _irrelevant_artifacts(c, sections)
		if not irrelevant.is_empty():
			beats.append(CutsceneBeat.new(_irrelevant_text(suspect_name, irrelevant.size()), irrelevant))

	beats.append(CutsceneBeat.new("..."))
	beats.append(CutsceneBeat.new("..."))
	beats.append(CutsceneBeat.new("Final verdict..."))
	beats.append(CutsceneBeat.new("Guilty!" if success else "Innocent!"))
	return beats

static func _group_artifacts_by_section(c: Case, law: Law) -> Dictionary:
	var buckets: Dictionary = Judge.build_buckets(c.evidence_list, law, c.suspect)["buckets"]
	print(buckets)
	var sections := {}
	print(c.filed_data.size())
	for data in c.filed_data:
		for e in data.evidence:
			print(e)
			if e.suspect != c.suspect:
				continue
			if Judge._matched_aspects(e, law).is_empty():
				continue
			if not buckets.has(e.time):
				continue
			var key := _section_key(buckets[e.time])
			if not sections.has(key):
				var arr: Array[ArtifactData] = []
				sections[key] = arr
			if not sections[key].has(data):
				sections[key].append(data)
	return sections

static func _irrelevant_artifacts(c: Case, sections: Dictionary) -> Array[ArtifactData]:
	var placed: Array[ArtifactData] = []
	for key in sections:
		for data in sections[key]:
			if not placed.has(data):
				placed.append(data)
	var result: Array[ArtifactData] = []
	for data in c.filed_data:
		if not placed.has(data):
			result.append(data)
	return result

static func _irrelevant_text(suspect_name: String, count: int) -> String:
	if count <= 1:
		return "The defense raises a small point, Your Honor: this document proves nothing against %s." % suspect_name
	if count <= 3:
		return "The defense objects. Several of these documents prove nothing against %s." % suspect_name
	return "The defense objects strongly, Your Honor! This case is padded with %d documents that prove nothing against %s!" % [count, suspect_name]

static func _section_key(aspects: Dictionary) -> String:
	var key := ""
	if aspects.has("action"):
		key += "a"
	if aspects.has("object"):
		key += "o"
	if aspects.has("location"):
		key += "l"
	return key

static func _next_opener(pool: Array) -> String:
	if pool.is_empty():
		pool.append_array(OPENERS)
		pool.shuffle()
	return pool.pop_back()

static func _claim_for(key: String, suspect_name: String, law: Law) -> String:
	var loc := _location_name(law.location)
	var act := law.action.gerund if law.action != null else ""
	var obj := law.category.plural if law.category != null else ""
	var options: Array[String] = []
	match key:
		"l":
			options = [
				"%s frequents %s" % [suspect_name, loc],
				"%s is a regular at %s" % [suspect_name, loc],
				"%s is often seen around %s" % [suspect_name, loc],
			]
		"a":
			options = [
				"%s frequently engages in %s" % [suspect_name, act],
				"%s has made a habit of %s" % [suspect_name, act],
				"%s is no stranger to %s" % [suspect_name, act],
			]
		"o":
			options = [
				"%s associates with %s" % [suspect_name, obj],
				"%s surrounds themself with %s" % [suspect_name, obj],
				"%s is rarely seen without %s" % [suspect_name, obj],
			]
		"ol":
			options = [
				"%s keeps %s at %s" % [suspect_name, obj, loc],
				"%s brings %s to %s" % [suspect_name, obj, loc],
				"%s is seen with %s at %s" % [suspect_name, obj, loc],
			]
		"al":
			options = [
				"%s is repeatedly %s at %s" % [suspect_name, act, loc],
				"%s makes a habit of %s at %s" % [suspect_name, act, loc],
				"%s is caught %s at %s" % [suspect_name, act, loc],
			]
		"ao":
			options = [
				"%s is %s %s" % [suspect_name, act, obj],
				"%s is frequently %s %s" % [suspect_name, act, obj],
				"%s makes a habit of %s %s" % [suspect_name, act, obj],
			]
		"aol":
			options = [
				"%s is %s %s at %s" % [suspect_name, act, obj, loc],
				"%s was caught %s %s at %s" % [suspect_name, act, obj, loc],
				"%s is brazenly %s %s at %s" % [suspect_name, act, obj, loc],
			]
	if options.is_empty():
		return ""
	return options.pick_random()

static func _location_name(loc: LocationDef) -> String:
	if loc == null:
		return ""
	return "the " + String(loc.id)

static func _crime_text(c: Case) -> String:
	if c.charge == null:
		return "an unnamed crime"
	return c.charge.to_string()
