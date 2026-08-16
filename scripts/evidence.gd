class_name Evidence

# One thing the defendant did: an action in a location, optionally with an item.

var action: ActionDef
var location: LocationDef
var item: Item = null   # null for standalone actions like singing


func _init(a: ActionDef, l: LocationDef, item_: Item = null) -> void:
	action = a
	location = l
	item = item_


func has_category(category: CategoryDef) -> bool:
	return item != null and item.categories.has(category)
