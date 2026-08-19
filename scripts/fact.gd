class_name Fact

var suspect: Suspect
var action: ActionDef
var item: ItemDef
var location: LocationDef
var time := 0

func _init(_suspect: Suspect,  _action: ActionDef, _item: ItemDef, _location: LocationDef, _time: int) -> void:
	suspect = _suspect
	action = _action
	item = _item
	location = _location
	time = _time
