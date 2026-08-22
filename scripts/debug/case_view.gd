class_name CaseView
extends Node2D

const MENU_FONT := preload("res://assets/fonts/DePixelHalbfett.ttf")

@export var game: Main
@export var desk_mask: ColorRect
@export var workspace_mask: ColorRect

@onready var case_name_label: Label = %CaseNameLabel
@onready var charge_name_label: Label = %ChargeName
@onready var win_percentage: Label = %WinPercentage
@onready var flight_risk_label: Label = %FlightRisk
@onready var back_button: Button = %BackButton
@onready var evidence_list_TEMP: Label = $TempEvidenceLabel
@onready var folder_interior: Area2D = $FolderInterior
@onready var folder_exterior: Area2D = $FolderExterior
@onready var folder_view: Sprite2D = $FolderView
@onready var charge_menu: VBoxContainer = %ChargeMenu
@onready var charge_menu_panel: PanelContainer = %ChargeMenuPanel
@onready var charge_label_background: NinePatchRect = %ChargeLabelBackground

var current_case: Case
var charge_buttons := {}
var pulse_tween: Tween

func _ready() -> void:
	back_button.pressed.connect(close)
	charge_label_background.gui_input.connect(_on_charge_label_input)

func update_case_win_percentage():
	if current_case == null:
		return
	win_percentage.text = "% chance to win:\n " + str(current_case.win_percentage)

func open_for(c: Case):
	if charge_buttons.is_empty():
		_build_charge_menu()
	current_case = c
	case_name_label.text = c.suspect.name
	flight_risk_label.text = "Flight risk: " + str(c.flight_risk_percentage) + "%"
	charge_menu_panel.visible = false
	_sync_charge_selection()
	_update_charge_prompt()
	update_case_win_percentage()
	disable_outer_draggables()
	
	# Render evidence artifacts within folder
	for child in folder_view.get_children():
		if child is Artifact:
			child.queue_free()
	for e in c.evidence_list:
		var artifact_scene = game.artifact_manager.evidence_to_artifact_scene[e]
		var artifact = artifact_scene.instantiate() as Artifact
		folder_view.add_child(artifact)
		artifact.initialize(e, game.artifact_manager, false)
		artifact.is_within_case_view = true
		artifact.zone = folder_interior
		var rand_x = randi_range(-65, 0)
		var rand_y = randi_range(-40, 0)
		artifact.position = Vector2(rand_x, rand_y)
		artifact.entered_zone.connect(handle_zone_enter)
		artifact.dropped.connect(func(): handle_dropped(artifact))
	visible = true
	
func handle_zone_enter(area: Area2D, artifact: Artifact):
	if area == folder_exterior:
		artifact.modulate = Color(0.278, 0.278, 0.278, 1.0)
	else:
		artifact.modulate = Color(1, 1, 1)
		
func handle_dropped(artifact: Artifact):
	if artifact.hovered_zone == folder_exterior:
		artifact.cleanup()
		current_case.remove_evidence(artifact.evidence)
		game.artifact_manager.remove_evidence_from_case(artifact, current_case)

func disable_outer_draggables():
	for c in desk_mask.get_children():
		var doc = c as Draggable
		doc.set_grabbable(false)
	for c in workspace_mask.get_children():
		var doc = c as Draggable
		doc.set_grabbable(false)
		
func enable_outer_draggables():
	for c in desk_mask.get_children():
		var doc = c as Draggable
		doc.set_grabbable(doc.visible)
	for c in workspace_mask.get_children():
		var doc = c as Draggable
		doc.set_grabbable(doc.visible)

func close():
	enable_outer_draggables()
	_stop_pulse()
	visible = false

func _on_charge_label_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		charge_menu_panel.visible = not charge_menu_panel.visible

func _build_charge_menu():
	var group := ButtonGroup.new()
	_add_charge_button("No charge", null, group)
	for law in game.laws:
		_add_charge_button(law.render(), Charge.new(law, 1), group)

func _add_charge_button(text: String, charge: Charge, group: ButtonGroup):
	var button := Button.new()
	button.text = text
	button.toggle_mode = true
	button.button_group = group
	button.add_theme_font_override("font", MENU_FONT)
	button.add_theme_font_size_override("font_size", 12)
	button.pressed.connect(_on_charge_selected.bind(charge))
	charge_menu.add_child(button)
	charge_buttons[button] = charge

func _on_charge_selected(charge: Charge):
	current_case.set_charge(charge)
	_update_charge_prompt()
	update_case_win_percentage()

func _sync_charge_selection():
	for button in charge_buttons:
		button.set_pressed_no_signal(charge_buttons[button] == current_case.charge)

func _update_charge_prompt():
	charge_name_label.text = _charge_text()
	if current_case.charge == null:
		_start_pulse()
	else:
		_stop_pulse()

func _start_pulse():
	if pulse_tween != null and pulse_tween.is_running():
		return
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(charge_label_background, "modulate", Color(0.45, 0.45, 0.45), 0.6)
	pulse_tween.tween_property(charge_label_background, "modulate", Color(1, 1, 1), 0.6)

func _stop_pulse():
	if pulse_tween != null:
		pulse_tween.kill()
		pulse_tween = null
	charge_label_background.modulate = Color(1, 1, 1)

func _charge_text() -> String:
	if current_case.charge == null:
		return "Click to determine the charge"
	return current_case.charge.to_string()
