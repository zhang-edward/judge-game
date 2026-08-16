class_name LocationDef extends Resource

# A location and how it reads in a sentence.

@export var id: StringName
@export var phrase: String   # "in the park"


func _init(id_ := &"", phrase_ := "") -> void:
	id = id_
	phrase = phrase_
