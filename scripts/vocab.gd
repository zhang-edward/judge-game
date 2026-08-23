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

var day_names = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
var suspect_names = [
	"James",
	"John",
	"Robert",
	"Michael",
	"William",
	"David",
	"Richard",
	"Joseph",
	"Thomas",
	"Charles",
	"Christopher",
	"Daniel",
	"Matthew",
	"Anthony",
	"Mark",
	"Donald",
	"Steven",
	"Paul",
	"Andrew",
	"Joshua",
	"Kenneth",
	"Kevin",
	"Brian",
	"George",
	"Timothy",
	"Mary",
	"Patricia",
	"Jennifer",
	"Linda",
	"Elizabeth",
	"Barbara",
	"Susan",
	"Jessica",
	"Sarah",
	"Karen",
	"Lisa",
	"Nancy",
	"Betty",
	"Sandra",
	"Margaret",
	"Ashley",
	"Kimberly",
	"Emily",
	"Donna",
	"Michelle",
	"Carol",
	"Amanda",
	"Melissa",
	"Deborah"
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

func get_item_def(item_name: String):
	for item in items:
		if item.name == item_name:
			return item
	return null
	
func get_item_categories(item_name: String):
	return get_item_def(item_name).categories

func random_item_in_category(c: CategoryDef) -> ItemDef:
	var potential_items = []
	for item in items:
		if item.categories.has(c):
			potential_items.append(item)
	return potential_items.pick_random()
