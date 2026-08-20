extends Document
class_name EvidenceDocument

signal added_to_case(case_file: CaseFile)

var evidence: Evidence

@onready var label: Label = %EvidenceLabel

var case_file_ref: CaseFile

func initialize(e: Evidence):
	evidence = e
	label.text = e.render()

func _ready() -> void:
	super._ready()
	set_grabbable(visible) # a copy authored hidden cannot be grabbed
	dropped.connect(try_add_to_case)

func try_add_to_case():
	print("case: ", case_file_ref)
	if case_file_ref != null:
		added_to_case.emit(case_file_ref)
		

# Hand off to the counterpart when the cursor enters the counterpart's zone.
func _on_zone_entered(area: Area2D) -> void:
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
	counterpart.queue_free()
	queue_free()
