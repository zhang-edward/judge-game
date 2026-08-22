class_name CaseView
extends Node2D

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

var current_case: Case

func _ready() -> void:
	back_button.pressed.connect(close)

func update_case_win_percentage():
	if current_case == null:
		return
	win_percentage.text = "% chance to win:\n " + str(current_case.win_percentage)

func open_for(c: Case):
	current_case = c
	case_name_label.text = c.suspect.name
	charge_name_label.text = c.charge.to_string()
	flight_risk_label.text = "Flight risk: " + str(c.flight_risk_percentage) + "%"
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
		var doc = c as ArtifactSmall
		doc.set_grabbable(false)
	for c in workspace_mask.get_children():
		var doc = c as Artifact
		doc.set_grabbable(false)
		
func enable_outer_draggables():
	for c in desk_mask.get_children():
		var doc = c as ArtifactSmall
		doc.set_grabbable(doc.visible)
	for c in workspace_mask.get_children():
		var doc = c as Artifact
		doc.set_grabbable(doc.visible)

func close():
	enable_outer_draggables()
	visible = false
