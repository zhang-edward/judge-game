class_name Artifact
extends Draggable

@export var small_form_scene: PackedScene

signal added_to_case(case_file: CaseFile)
signal entered_zone(area: Area2D, artifact: Artifact)

var artifact_manager: ArtifactManager
var small_form: ArtifactSmall
var data: ArtifactData
var case_file_ref: CaseFile
var zone: Area2D
var is_within_case_view := false
var hovered_zone: Area2D

func initialize(g: ArtifactData, manager: ArtifactManager, with_small_form := true):
	data = g
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
		
	if data != null and not data.evidence.is_empty():
		render_evidence_into_artifact(data)

func render_evidence_into_artifact(data: ArtifactData):
	pass

func select_evidence(pool: Array[Evidence]) -> Array[Evidence]:
	return ArtifactManager.pick_random_evidence(pool, 1, 1)

func _ready() -> void:
	super._ready()
	set_grabbable(visible) # a copy authored hidden cannot be grabbed
	dropped.connect(try_add_to_case)
	zone_entered.connect(_on_zone_entered)
	zone_exited.connect(_on_zone_exited)

func try_add_to_case():
	if case_file_ref != null:
		var target := case_file_ref
		_set_case_file_ref(null)
		added_to_case.emit(target)

# Set the case file this artifact would be filed into, and highlight it as a drop target.
func _set_case_file_ref(cf: CaseFile) -> void:
	if cf == case_file_ref:
		return
	if case_file_ref != null and is_instance_valid(case_file_ref):
		case_file_ref.set_drop_highlight(false)
	case_file_ref = cf
	if case_file_ref != null:
		case_file_ref.set_drop_highlight(true)

func _on_zone_entered(area: Area2D) -> void:
	print("Entered new zone: " + str(area))
	if is_within_case_view:
		hovered_zone = area
		entered_zone.emit(area, self)
	else:
		if area.get_parent() is CaseFile && self is not CaseFile:
			_set_case_file_ref(area.get_parent() as CaseFile)
		else:
			_set_case_file_ref(null)
	if small_form != null and area == small_form.zone:
		_hand_off()

func _on_zone_exited(area: Area2D) -> void:
	print("Exited zone:", area)
	if area.get_parent() is CaseFile:
		_set_case_file_ref(null)


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
