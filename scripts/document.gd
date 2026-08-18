extends Draggable
class_name Document

@export var zone: Area2D # the zone Area2D this copy lives in
@export var counterpart: Document # the copy in the other zone


func _ready() -> void:
	super._ready()
	set_grabbable(visible) # a copy authored hidden cannot be grabbed
	zone_entered.connect(_on_zone_entered)


# Hand off to the counterpart when the cursor enters the counterpart's zone.
func _on_zone_entered(area: Area2D) -> void:
	if counterpart != null and area == counterpart.zone:
		_hand_off()


func _hand_off() -> void:
	cancel_drag()
	hide()
	set_grabbable(false)
	counterpart.show()
	counterpart.set_grabbable(true)
	counterpart.begin_drag(true) # appears centered on the cursor and takes over
