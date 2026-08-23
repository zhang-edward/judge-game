extends Node

# The game's whole vocabulary in one place. Each value bundles its own display text
# and flags. The lists are @export so they show in the inspector; they are defined
# inline below. Look a value up by its id, e.g. Vocab.action(&"carry").

var location_names: Array[String] = [
	"bank",
	"beach",
	"campground",
	"city",
	"farm",
	"forest",
	"lake",
	"laundromat",
	"library",
	"motel",
	"park",
	"stadium",
	"street",
	"theater",
	"zoo"
]

var item_names: Array[String] = [
	"airplane",
	"banana",
	"battle_axe",
	"bazooka",
	"broccoli",
	"cannon",
	"canteloupe",
	"car",
	"cat",
	"cheese",
	"crocodile",
	"dog",
	"elephant",
	"e_scooter",
	"giraffe",
	"gorilla",
	"grenade",
	"gun",
	"hamburger",
	"helicopter",
	"horse",
	"jaguar",
	"jeep",
	"jetski",
	"lion",
	"meatball",
	"monkey",
	"mortar_launcher",
	"motorboat",
	"motorcycle",
	"pie",
	"pizza",
	"rat",
	"rhino",
	"rocket_launcher",
	"salad",
	"sandwich",
	"shark",
	"skateboard",
	"sword",
	"tank",
	"tiger",
	"truck"
]

var day_names = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
var male_suspect_names = [
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
	"Andrew",
	"Paul",
	"Joshua",
	"Kenneth",
	"Kevin",
	"Brian",
	"George",
	"Timothy",
	"Ronald",
	"Edward",
	"Jason",
	"Jeffrey",
	"Ryan",
	"Jacob",
	"Gary",
	"Nicholas",
	"Eric",
	"Jonathan",
	"Stephen",
	"Larry",
	"Justin",
	"Scott",
	"Brandon",
	"Benjamin",
	"Samuel",
	"Gregory",
	"Alexander",
	"Frank",
	"Patrick",
	"Raymond",
	"Jack",
	"Dennis",
	"Jerry"
]

var female_suspect_names = [
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
	"Dorothy",
	"Melissa",
	"Deborah",
	"Stephanie",
	"Rebecca",
	"Sharon",
	"Laura",
	"Cynthia",
	"Kathleen",
	"Amy",
	"Angela",
	"Shirley",
	"Anna",
	"Brenda",
	"Pamela",
	"Emma",
	"Nicole",
	"Helen",
	"Samantha",
	"Katherine",
	"Christine",
	"Debra",
	"Rachel",
	"Carolyn",
	"Janet",
	"Catherine",
	"Maria",
	"Heather"
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
