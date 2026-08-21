extends Document
class_name EvidenceDocument

signal added_to_case(case_file: CaseFile)
signal entered_zone(area: Area2D, doc: EvidenceDocument)

var hovered_zone: Area2D
var evidence: Evidence
var is_within_case_view := false

@onready var label: Label = %EvidenceLabel
@onready var hitbox: Area2D = $Hitbox

var case_file_ref: CaseFile

func initialize(e: Evidence, cfg: ArtifactConfig):
	evidence = e
	label.text = e.render()

func _ready() -> void:
	super._ready()
	set_grabbable(visible) # a copy authored hidden cannot be grabbed
	dropped.connect(try_add_to_case)

func try_add_to_case():
	for area in hitbox.get_overlapping_areas():
		print(area)
		if area.get_parent() is CaseFile:
			print("adding to case")
			added_to_case.emit(area.get_parent() as CaseFile)

# Hand off to the counterpart when the cursor enters the counterpart's zone.
func _on_zone_entered(area: Area2D) -> void:
	if is_within_case_view:
		hovered_zone = area
		entered_zone.emit(area, self)
	else:
		if area.get_parent() is CaseFile:
			case_file_ref = area.get_parent() as CaseFile
		else:
			case_file_ref = null

		if counterpart != null and area == counterpart.zone:
			_hand_off()

func _hand_off() -> void:
	cancel_drag()
	hide()
	set_grabbable(false)
	counterpart.show()
	counterpart.set_grabbable(true)
	counterpart.begin_drag(true) # appears centered on the cursor and takes over

func cleanup() -> void:
	print("cleanup")
	if counterpart != null:
		counterpart.queue_free()
	queue_free()
