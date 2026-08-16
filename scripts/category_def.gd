class_name CategoryDef extends Resource

# An object category and how it reads in a sentence.

@export var id: StringName
@export var plural: String   # "weapons"


func _init(id_ := &"", plural_ := "") -> void:
	id = id_
	plural = plural_
