class_name ArtifactSmall
extends Draggable

var zone: Area2D # the zone Area2D this copy lives in
var parent_artifact: Artifact

func _ready() -> void:
	super._ready()
	set_grabbable(visible) # a copy authored hidden cannot be grabbed
	zone_entered.connect(_on_zone_entered)

# Hand off to the counterpart when the cursor enters the counterpart's zone.
func _on_zone_entered(area: Area2D) -> void:
	if parent_artifact != null and area == parent_artifact.zone:
		_hand_off()

func _hand_off() -> void:
	cancel_drag()
	hide()
	set_grabbable(false)
	parent_artifact.show()
	parent_artifact.set_grabbable(true)
	parent_artifact.begin_drag(true) # appears centered on the cursor and takes over
