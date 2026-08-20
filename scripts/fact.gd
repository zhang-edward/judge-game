class_name Fact

var suspect: Suspect
var action: ActionDef
var item: ItemDef
var location: LocationDef
var time := 0

func _init(_suspect: Suspect, _action: ActionDef, _item: ItemDef, _location: LocationDef, _time: int) -> void:
	suspect = _suspect
	action = _action
	item = _item
	location = _location
	time = _time

	assert(action != null, "Fact must have action")
	assert(item != null, "Fact must have object")
	assert(location != null, "Fact must have location")

func render() -> String:
	var rendered_sentence = "[" + str(time) + "] \t"
	rendered_sentence += suspect.name;
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
