class_name ActionDef extends Resource

# An action and everything we say about it.

@export var id: StringName
@export var past: String        # "Carried"
@export var gerund: String      # "carrying"


func _init(id_ := &"", past_ := "", gerund_ := "") -> void:
	id = id_
	past = past_
	gerund = gerund_
