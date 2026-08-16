extends Node

# The game's whole vocabulary in one place. Each value bundles its own display text
# and flags. The lists are @export so they show in the inspector; they are defined
# inline below. Look a value up by its id, e.g. Vocab.action(&"carry").

var actions: Array[ActionDef] = [
	ActionDef.new(&"sing", "Sang", "singing", false),
	ActionDef.new(&"dance", "Danced", "dancing", false),
	ActionDef.new(&"sleep", "Slept", "sleeping", false),
	ActionDef.new(&"shout", "Shouted", "shouting", false),
	ActionDef.new(&"possess", "Possessed", "possessing", true),
	ActionDef.new(&"carry", "Carried", "carrying", true),
	ActionDef.new(&"use", "Used", "using", true),
	ActionDef.new(&"purchase", "Purchased", "purchasing", true),
	ActionDef.new(&"sell", "Sold", "selling", true),
	ActionDef.new(&"take", "Took", "taking", true),
	ActionDef.new(&"give", "Gave", "giving", true),
]

var locations: Array[LocationDef] = [
	LocationDef.new(&"park", "in the park"),
	LocationDef.new(&"bank", "at the bank"),
	LocationDef.new(&"street", "on the street"),
	LocationDef.new(&"library", "in the library"),
]

var categories: Array[CategoryDef] = [
	CategoryDef.new(&"weapon", "weapons"),
	CategoryDef.new(&"animal", "animals"),
	CategoryDef.new(&"vehicle", "vehicles"),
	CategoryDef.new(&"food", "food"),
]


func action(id: StringName) -> ActionDef:
	for a in actions:
		if a.id == id:
			return a
	return null


func location(id: StringName) -> LocationDef:
	for l in locations:
		if l.id == id:
			return l
	return null


func category(id: StringName) -> CategoryDef:
	for c in categories:
		if c.id == id:
			return c
	return null
