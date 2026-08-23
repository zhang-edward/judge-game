class_name CaseFile
extends Artifact

signal open_case_info()

const DROP_HIGHLIGHT_SCALE := 1.1
const DROP_HIGHLIGHT_DURATION := 0.1

var case: Case

var _base_scale := Vector2.ONE
var _highlight_tween: Tween

@onready var case_name_label: Label = %CaseNameLabel
@onready var case_charge_label: Label = %CaseChargeLabel

func _ready() -> void:
	super._ready()
	_base_scale = scale

# Grow slightly while a document is hovering over this file as a drop target.
func set_drop_highlight(active: bool) -> void:
	if _highlight_tween != null and _highlight_tween.is_valid():
		_highlight_tween.kill()
	var target := _base_scale * DROP_HIGHLIGHT_SCALE if active else _base_scale
	_highlight_tween = create_tween()
	_highlight_tween.tween_property(self, "scale", target, DROP_HIGHLIGHT_DURATION)

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

func initialize(g: ArtifactData, manager: ArtifactManager, with_small_form := true):
	super.initialize(g, manager, with_small_form)
	if small_form != null:
		small_form.position = Vector2(randf_range(8, 60), randf_range(105, 145))
		small_form.rotation_degrees = randf_range(-4, 4)

func _on_zone_entered(area: Area2D) -> void:
	super._on_zone_entered(area)
	print(area.name)
