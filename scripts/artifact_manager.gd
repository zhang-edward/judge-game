class_name ArtifactManager
extends Node

@export var game: Main

@export var case_file_scene: PackedScene
@export var law_book_scene: PackedScene
@export var all_artifact_types: Array[PackedScene]
@export var item_only_artifact_types: Array[PackedScene]
@export var one_prop_only_artifact_types: Array[PackedScene]

var law_book: LawBook

@export var desk_mask: ColorRect
@export var desk_zone: Area2D
@export var workspace_mask: ColorRect
@export var workspace_zone: Area2D

# Stores a mapping to a piece of evidence to the type of artifact that the evidence is rendered as
var evidence_to_artifact_scene: Dictionary[Evidence, PackedScene]

func spawn_law_book(laws: Array[Law]):
	if law_book_scene == null:
		return
	law_book = law_book_scene.instantiate() as LawBook
	workspace_mask.add_child(law_book)
	law_book.initialize(laws, desk_mask, workspace_zone, desk_zone)

func clear_previous_artifacts():
	for c in desk_mask.get_children():
		if is_instance_valid(c) and not _is_law_book(c):
			c.queue_free()
	for c in workspace_mask.get_children():
		if is_instance_valid(c) and not _is_law_book(c):
			c.queue_free()

func _is_law_book(node: Node) -> bool:
	return law_book != null and (node == law_book or node == law_book.small_form)

func render_artifacts():
	clear_previous_artifacts()
	# Spawn in artifacts for ALL cases
	for c in game.cases:
		# Spawn in case file
		var case_file = case_file_scene.instantiate() as CaseFile
		workspace_mask.add_child(case_file)
		case_file.setup_case(c)
		case_file.initialize(null, self)
		case_file.open_case_info.connect(game.case_view.open_for.bind(c))
		case_file.visible = false

		# Spawn in artifacts for this case's evidence
		for e in c.available_evidence:
			var artifact_scene
			if e.action == null and e.location == null:
				artifact_scene = item_only_artifact_types.pick_random()
			else:
				artifact_scene = all_artifact_types.pick_random()
			evidence_to_artifact_scene[e] = artifact_scene
			spawn_artifact_for_evidence(e, artifact_scene)

func evidence_has_only_one_property(e: Evidence):
	var props = [e.action, e.item, e.location]
	var num_non_null_props := 0
	for p in props:
		if p != null:
			num_non_null_props += 1
	return num_non_null_props == 1
			

func spawn_artifact_for_evidence(e: Evidence, artifact_scene: PackedScene, on_desk := false):
	var artifact = artifact_scene.instantiate() as Artifact
	workspace_mask.add_child(artifact)
	artifact.added_to_case.connect(func(c: CaseFile): add_evidence_to_case(artifact, c))
	artifact.initialize(e, self)
	if on_desk:
		artifact.show()
		artifact.small_form.hide()
		artifact.position = Vector2(randi_range(25, 50), randi_range(25, 50))

func add_evidence_to_case(artifact: Artifact, case_file: CaseFile):
	var e = artifact.evidence
	if game.case_status.visible or game.suspect_fled_alert.visible:
		return
	case_file.case.add_evidence(e)
	case_file.case.available_evidence.erase(e)
	artifact.cleanup()
	if game.case_view.visible and game.case_view.current_case == case_file.case:
		game.case_view.update_case_win_percentage()

func remove_evidence_from_case(artifact: Artifact, case: Case):
	var e = artifact.evidence
	case.available_evidence.append(e)
	spawn_artifact_for_evidence(e, evidence_to_artifact_scene[e], true)
	if game.case_view.visible and game.case_view.current_case == case:
		game.case_view.update_case_win_percentage()
