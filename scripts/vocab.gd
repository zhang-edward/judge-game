extends Node

# The game's whole vocabulary in one place. Each value bundles its own display text
# and flags. The lists are @export so they show in the inspector; they are defined
# inline below. Look a value up by its id, e.g. Vocab.action(&"carry").

var location_names: Array[String] = [
	"bank",
	"library",
	"park",
	"street"
]

var item_names: Array[String] = [
	"dog",
	"gun",
	"sword"
]

var items: Array[ItemDef] = []
var locations: Array[LocationDef] = []

func _ready() -> void:
	for i in item_names:
		items.append(load("res://resources/items/" + i + ".tres"))
	for l in location_names:
		locations.append(load("res://resources/locations/" + l + ".tres"))
		
func location(id: StringName) -> LocationDef:
	for l in locations:
		if l.id == id:
			return l
	return null

func random_item_in_category(c: CategoryDef) -> ItemDef:
	var potential_items = []
	for item in items:
		if item.categories.has(c):
			potential_items.append(item)
	return potential_items.pick_random()
