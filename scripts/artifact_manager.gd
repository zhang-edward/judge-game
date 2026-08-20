class_name ArtifactManager
extends Node

@export var game: Main
@export var artifact_scene: PackedScene
@export var artifact_folder: Node

func _ready() -> void:
	game.game_initialized.connect(render_artifacts)

func render_artifacts():
	for e in game.evidence:
		var artifact: DebugEvidenceRow = artifact_scene.instantiate()
		artifact_folder.add_child(artifact)
		artifact.initialize(e)
		artifact.add_to_case_button.pressed.connect(
			func():
				game.case.add_evidence(e)
				game.evidence.erase(e)
				artifact.queue_free()
		)
