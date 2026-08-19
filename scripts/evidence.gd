class_name Evidence

# One thing the defendant did: an action in a location, optionally with an item.
var suspect: Suspect
var action: ActionDef
var location: LocationDef
var item: ItemDef = null # null for standalone actions like singing
var time: int

func _init(s: Suspect, t: int, a: ActionDef, l: LocationDef, item_: ItemDef = null) -> void:
	suspect = s
	time = t
	action = a
	location = l
	item = item_

func has_category(category: CategoryDef) -> bool:
	return item != null and item.categories.has(category)

func render() -> String:
	var rendered_sentence = "[" + str(time) + "] \t"
	rendered_sentence += suspect.name
	if action != null:
		rendered_sentence += " " + action.past
	else:
		if item == null:
			rendered_sentence += " was"
		else:
			rendered_sentence += " had"
	if item != null:
		rendered_sentence += " a " + item.name
	else:
		if action != null:
			rendered_sentence += " something"
	if location != null:
		rendered_sentence += " " + location.phrase
	return rendered_sentence
