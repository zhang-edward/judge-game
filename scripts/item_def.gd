class_name ItemDef
extends Resource

# A concrete object the defendant handled. It can belong to several categories, so
# a guard dog is both an animal and a weapon.
@export var id: StringName
@export var name: String
@export var categories: Array[CategoryDef]
@export var supported_actions: Array[ActionDef]

func _init(id_ := &"", name_: String = "", categories_: Array[CategoryDef] = []) -> void:
	id = id_
	name = name_
	categories = categories_
