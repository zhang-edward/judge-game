class_name Charge

# A broken law and how many times it was broken.

var law: Law
var count: int

func _init(l: Law, c: int) -> void:
	law = l
	count = c

func _to_string() -> String:
	var rendered_sentence = "Illegal"

	if law.action != null:
		rendered_sentence += " " + law.action.gerund
	else:
		if law.category == null:
			rendered_sentence += " being"
		else:
			rendered_sentence += " possession"
	if law.category != null:
		rendered_sentence += " of " + law.category.plural
	if law.location != null:
		rendered_sentence += " " + law.location.phrase

	return rendered_sentence
