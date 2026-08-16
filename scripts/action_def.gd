class_name ActionDef extends Resource

# An action and everything we say about it.

@export var id: StringName
@export var past: String        # "Carried"
@export var gerund: String      # "carrying"
@export var takes_object: bool  # needs an item, e.g. carry vs. sing


func _init(id_ := &"", past_ := "", gerund_ := "", takes_object_ := false) -> void:
	id = id_
	past = past_
	gerund = gerund_
	takes_object = takes_object_
