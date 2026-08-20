class_name Judge

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


# e.g. "Carried a knife in the park." or "Sang in the park."
static func evidence_sentence(e: Evidence) -> String:
	if e.item == null:
		return "%s %s." % [e.action.past, e.location.phrase]
	return "%s %s %s." % [e.action.past, _item_phrase(e.item), e.location.phrase]


# e.g. "3 counts of illegal carrying of weapons."
static func charge_sentence(c: Charge) -> String:
	var word := "count" if c.count == 1 else "counts"
	return "%d %s of %s." % [c.count, word, _offence(c.law)]


# What a law forbids, e.g. "illegal selling of food on the street".
static func _offence(law: Law) -> String:
	var text := "illegal %s" % law.action.gerund
	if law.category != null:
		text += " of %s" % law.category.plural
	if law.location != null:
		text += " %s" % law.location.phrase
	return text


# e.g. "a knife", "an apple".
static func _item_phrase(item: ItemDef) -> String:
	var article := "an" if _starts_with_vowel(item.name) else "a"
	return "%s %s" % [article, item.name]


static func _starts_with_vowel(word: String) -> bool:
	return not word.is_empty() and "aeiou".contains(word[0].to_lower())
