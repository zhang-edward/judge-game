class_name Evidence

# One thing the defendant did.

var action: Vocab.Action
var location: Vocab.Location


func _init(a: Vocab.Action, l: Vocab.Location) -> void:
	action = a
	location = l
