class_name CutsceneBuilder

const SECTION_ORDER := ["l", "a", "o", "ol", "al", "ao", "aol"]

static func build(c: Case, success: bool) -> Array[CutsceneBeat]:
	var beats: Array[CutsceneBeat] = []
	var suspect_name := c.suspect.name

	beats.append(CutsceneBeat.new("The defendant stands accused of " + _crime_text(c) + "."))

	if c.charge != null:
		var sections := _group_artifacts_by_section(c, c.charge.law)
		for key in SECTION_ORDER:
			if not sections.has(key) or sections[key].is_empty():
				continue
			beats.append(CutsceneBeat.new(_section_text(key, suspect_name, c.charge.law), sections[key]))
		var irrelevant := _irrelevant_artifacts(c, sections)
		if not irrelevant.is_empty():
			beats.append(CutsceneBeat.new(_irrelevant_text(suspect_name), irrelevant))

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

static func _irrelevant_text(suspect_name: String) -> String:
	return "The defense objects, Your Honor. This evidence proves nothing against %s." % suspect_name

static func _section_key(aspects: Dictionary) -> String:
	var key := ""
	if aspects.has("action"):
		key += "a"
	if aspects.has("object"):
		key += "o"
	if aspects.has("location"):
		key += "l"
	return key

static func _section_text(key: String, suspect_name: String, law: Law) -> String:
	var loc := _location_name(law.location)
	var act := law.action.gerund if law.action != null else ""
	var obj := law.category.plural if law.category != null else ""
	match key:
		"l":
			return "As you can see, Your Honor, the suspect, %s, has been proven to frequent %s." % [suspect_name, loc]
		"a":
			return "We have substantive proof that %s frequently engages in %s." % [suspect_name, act]
		"o":
			return "The suspect, %s, associates heavily with %s." % [suspect_name, obj]
		"ol":
			return "Records place %s with %s at %s, time and again." % [suspect_name, obj, loc]
		"al":
			return "Witnesses confirm %s was repeatedly %s at %s." % [suspect_name, act, loc]
		"ao":
			return "We can show %s %s while handling %s." % [suspect_name, act, obj]
		"aol":
			return "Most damning of all, %s was caught %s %s at %s." % [suspect_name, act, obj, loc]
	return ""

static func _location_name(loc: LocationDef) -> String:
	if loc == null:
		return ""
	return "the " + String(loc.id)

static func _crime_text(c: Case) -> String:
	if c.charge == null:
		return "an unnamed crime"
	return c.charge.to_string()
