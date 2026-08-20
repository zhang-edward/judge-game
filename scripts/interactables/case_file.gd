class_name CaseFile
extends Document

signal open_case_info()

var case: Case

@onready var case_name_label: Label = %CaseNameLabel
@onready var case_charge_label: Label = %CaseChargeLabel

func _on_hitbox_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	super._on_hitbox_input(_viewport, event, _shape_idx)
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed):
		open_case_info.emit()

func initialize(c: Case):
	case = c
	case_name_label.text = case.suspect.name
	case_charge_label.text = case.charge.to_string()
