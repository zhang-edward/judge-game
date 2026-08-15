class_name Law

# A rule: doing this action in this place is illegal.

var action: Vocab.Action
var location: Vocab.Location
var description: String


func _init(a: Vocab.Action, l: Vocab.Location, desc: String) -> void:
	action = a
	location = l
	description = desc


# Does this single piece of evidence break the law?
func is_broken_by(e: Evidence) -> bool:
	return e.action == action and e.location == location
