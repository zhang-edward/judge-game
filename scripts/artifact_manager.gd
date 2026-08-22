class_name ArtifactManager
extends Node

@export var game: Main

@export var case_file_scene: PackedScene
@export var all_artifact_types: Array[PackedScene]

@export var desk_mask: ColorRect
@export var desk_zone: Area2D
@export var workspace_mask: ColorRect
@export var workspace_zone: Area2D
@export var law_book: LawBook

func init_law_book(laws: Array[Law]):
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

		# create copy so we don't mutate shared state
		var pool := c.available_evidence.duplicate()
		while not pool.is_empty():
			if _try_spawn_artifact_from_pool(pool) == null:
				break # no type could represent the remaining evidence

# Pick a random artifact type, then let it grab its valid evidence from the pool
# Null if no type can represent any of the remaining evidence
func _try_spawn_artifact_from_pool(pool: Array[Evidence]) -> ArtifactData:
	# create copy so we don't mutate shared state
	var types := all_artifact_types.duplicate()
	# try to spawn every artifact type in a random order
	types.shuffle()
	for scene in types:
		var artifact := scene.instantiate() as Artifact
		var grabbed := artifact.select_evidence(pool)
		if grabbed.is_empty():
			artifact.free()
			continue
		var data := ArtifactData.new()
		data.artifact_scene = scene
		data.evidence = grabbed
		for e in grabbed:
			pool.erase(e)
		_register_artifact(artifact, data)
		return data
	return null

static func pick_random_evidence(pool: Array[Evidence], min_count: int, max_count: int) -> Array[Evidence]:
	var shuffled := pool.duplicate()
	shuffled.shuffle()
	var count := mini(randi_range(min_count, max_count), shuffled.size())
	return shuffled.slice(0, count)

func spawn_artifact_for_data(data: ArtifactData, on_desk := false):
	var artifact := data.artifact_scene.instantiate() as Artifact
	_register_artifact(artifact, data, on_desk)

func _register_artifact(artifact: Artifact, data: ArtifactData, on_desk := false):
	workspace_mask.add_child(artifact)
	artifact.added_to_case.connect(func(c: CaseFile): add_evidence_to_case(artifact, c))
	artifact.initialize(data, self, !on_desk)
	if on_desk:
		artifact.show()
		artifact.position = Vector2(randi_range(25, 50), randi_range(25, 50))
		if game.case_view.visible:
			artifact.set_grabbable(false)

func add_evidence_to_case(artifact: Artifact, case_file: CaseFile):
	if game.case_status.visible or game.suspect_fled_alert.visible:
		return
	for e in artifact.data.evidence:
		case_file.case.add_evidence(e)
		case_file.case.available_evidence.erase(e)
	case_file.case.filed_data.append(artifact.data)
	artifact.cleanup()
	if game.case_view.visible and game.case_view.current_case == case_file.case:
		game.case_view.update_case_win_percentage()

func remove_evidence_from_case(artifact: Artifact, case: Case):
	for e in artifact.data.evidence:
		case.available_evidence.append(e)
	case.filed_data.erase(artifact.data)
	spawn_artifact_for_data(artifact.data, true)
	if game.case_view.visible and game.case_view.current_case == case:
		game.case_view.update_case_win_percentage()

func toggle_hitbox_for_all_case_files(is_enabled: bool):
	print("toggling all case files hitboxes: ", is_enabled)
	for artifact in workspace_mask.get_children():
		if artifact is CaseFile:
			var hitbox: CollisionShape2D = artifact.get_node("Hitbox/CollisionShape2D")
			hitbox.disabled = !is_enabled
