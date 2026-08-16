class_name Item

# A concrete object the defendant handled. It can belong to several categories, so
# a guard dog is both an animal and a weapon.

var name: String
var categories: Array[CategoryDef]


func _init(name_: String, categories_: Array[CategoryDef]) -> void:
	name = name_
	categories = categories_
