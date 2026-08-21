class_name ArtifactManager
extends Node

@export var game: Main
@export var artifact_scene: PackedScene

@export var case_file_config: ArtifactConfig
@export var artifact_config: ArtifactConfig

@export var desk_mask: ColorRect
@export var desk_zone: Area2D
@export var workspace_mask: ColorRect
@export var workspace_zone: Area2D

# Stores a mapping to a piece of evidence to the type of artifact that the evidence is rendered as
var evidence_to_artifact_config: Dictionary[Evidence, ArtifactConfig]

# Every document spawned by render_artifacts (both zone copies), so we can
# tear them all down before rebuilding.
var _spawned_docs: Array[Node] = []

func render_artifacts():
	for d in _spawned_docs:
		if is_instance_valid(d):
			d.queue_free()
	_spawned_docs.clear()

	# Spawn in artifacts for ALL cases
	for c in game.cases:
		# Spawn in case file
		var case_file_docs = spawn_document(case_file_config)
		var case_file_workspace_doc = case_file_docs[0] as CaseFile
		case_file_workspace_doc.initialize(c)
		case_file_workspace_doc.open_case_info.connect(game.case_view.open_for.bind(c))
		case_file_workspace_doc.visible = false

		var case_file_desk_doc = case_file_docs[1]
		case_file_desk_doc.position = Vector2(randf_range(8, 60), randf_range(105, 145))
		case_file_desk_doc.rotation_degrees = randf_range(-4, 4)

		# Spawn in artifacts for this case's evidence
		for e in c.available_evidence:
			evidence_to_artifact_config[e] = artifact_config
			spawn_artifact_for_evidence(e, artifact_config)

func spawn_artifact_for_evidence(e: Evidence, artifact: ArtifactConfig, on_desk := false):
	var docs = spawn_document(artifact_config)

	var workspace_doc = docs[0] as EvidenceDocument
	workspace_doc.initialize(e, artifact)
	workspace_doc.visible = on_desk
	workspace_doc.added_to_case.connect(func(c: CaseFile): add_evidence_to_case(workspace_doc, c))
	workspace_doc.position = Vector2(50, 50)
	workspace_doc.set_grabbable(!game.case_view.visible)

	var desk_doc = docs[1]
	desk_doc.position = Vector2(randf_range(12, 66), randf_range(12, 90))
	desk_doc.visible = !on_desk
	desk_doc.rotation_degrees = randf_range(-4, 4)
	desk_doc.set_grabbable(!game.case_view.visible)

func spawn_document(cfg: ArtifactConfig):
	var workspace_doc = cfg.workspace_scene.instantiate() as Document
	workspace_mask.add_child(workspace_doc)
	workspace_doc.zone = workspace_zone

	var desk_doc = cfg.desk_scene.instantiate() as Document
	desk_mask.add_child(desk_doc)
	desk_doc.zone = desk_zone

	desk_doc.counterpart = workspace_doc
	workspace_doc.counterpart = desk_doc

	_spawned_docs.append(workspace_doc)
	_spawned_docs.append(desk_doc)
	return [workspace_doc, desk_doc]

func add_evidence_to_case(evidence_doc: EvidenceDocument, case_file: CaseFile):
	var e = evidence_doc.evidence
	if game.case_status.visible or game.suspect_fled_alert.visible:
		return
	case_file.case.add_evidence(e)
	case_file.case.available_evidence.erase(e)
	evidence_doc.cleanup()
	if game.case_view.visible and game.case_view.current_case == case_file.case:
		game.case_view.update_case_win_percentage()

func remove_evidence_from_case(evidence_doc: EvidenceDocument, case: Case):
	var e = evidence_doc.evidence
	spawn_artifact_for_evidence(e, evidence_to_artifact_config[e], true)
	case.available_evidence.append(e)
	if game.case_view.visible and game.case_view.current_case == case:
		game.case_view.update_case_win_percentage()
