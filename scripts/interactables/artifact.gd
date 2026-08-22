class_name Artifact
extends Draggable

@export var small_form_scene: PackedScene

signal added_to_case(case_file: CaseFile)
signal entered_zone(area: Area2D, artifact: Artifact)

var artifact_manager: ArtifactManager
var small_form: ArtifactSmall
var evidence: Evidence
var case_file_ref: CaseFile
var zone: Area2D
var is_within_case_view := false
var hovered_zone: Area2D

func initialize(e: Evidence, manager: ArtifactManager, with_small_form := true):
	evidence = e
	artifact_manager = manager
	zone = artifact_manager.workspace_zone
	
	# If this artifact has a small form counterpart, spawn it in
	if small_form_scene and with_small_form:
		small_form = small_form_scene.instantiate() as ArtifactSmall
		artifact_manager.desk_mask.add_child(small_form)
		small_form.position = Vector2(randf_range(12, 66), randf_range(12, 90))
		small_form.rotation_degrees = randf_range(-4, 4)
		small_form.parent_artifact = self
		small_form.zone = artifact_manager.desk_zone
		hide()
		
	if evidence != null:
		render_evidence_into_artifact(evidence)

func render_evidence_into_artifact(evidence: Evidence):
	pass

func _ready() -> void:
	super._ready()
	set_grabbable(visible) # a copy authored hidden cannot be grabbed
	dropped.connect(try_add_to_case)
	zone_entered.connect(_on_zone_entered)

func try_add_to_case():
	if case_file_ref != null:
		added_to_case.emit(case_file_ref)

func _on_zone_entered(area: Area2D) -> void:
	if is_within_case_view:
		hovered_zone = area
		entered_zone.emit(area, self)
	else:
		if area.get_parent() is CaseFile:
			case_file_ref = area.get_parent() as CaseFile
		else:
			case_file_ref = null
	if small_form != null and area == small_form.zone:
		_hand_off()

func _hand_off() -> void:
	cancel_drag()
	hide()
	set_grabbable(false)
	small_form.show()
	small_form.set_grabbable(true)
	small_form.begin_drag(true) # appears centered on the cursor and takes over

func cleanup() -> void:
	if small_form != null:
		small_form.queue_free()
	queue_free()
