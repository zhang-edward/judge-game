class_name CaseFile
extends Artifact

signal open_case_info()

var case: Case

@onready var case_name_label: Label = %CaseNameLabel
@onready var case_charge_label: Label = %CaseChargeLabel

func _on_hitbox_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	super._on_hitbox_input(_viewport, event, _shape_idx)
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed):
		open_case_info.emit()

func setup_case(c: Case):
	case = c
	case.charge_changed.connect(_refresh_charge_label)
	case_name_label.text = case.suspect.name
	_refresh_charge_label()

func _refresh_charge_label():
	case_charge_label.text = case.charge.to_string() if case.charge != null else "No charge filed"

func initialize(e: Evidence, manager: ArtifactManager, with_small_form := true):
	super.initialize(e, manager, with_small_form)
	if small_form != null:
		small_form.position = Vector2(randf_range(8, 60), randf_range(105, 145))
		small_form.rotation_degrees = randf_range(-4, 4)
