class_name Cutscene
extends Control

signal finished

const STAGE_SPACING := 200.0

@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var stage: Node2D = %Stage

var _beats: Array[CutsceneBeat] = []
var _index := -1

func _ready() -> void:
	hide()

func play(beats: Array[CutsceneBeat]) -> void:
	_beats = beats
	_index = -1
	show()
	_advance()

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		get_viewport().set_input_as_handled()
		if dialogue_box.is_revealing():
			dialogue_box.finish_reveal()
		else:
			_advance()

func _advance() -> void:
	_index += 1
	if _index >= _beats.size():
		_finish()
		return
	var beat := _beats[_index]
	_clear_stage()
	_spawn_artifacts(beat.artifacts)
	dialogue_box.play(beat.text)

func _spawn_artifacts(artifacts: Array[ArtifactData]) -> void:
	var count := artifacts.size()
	var start_x := -STAGE_SPACING * (count - 1) / 2.0
	for i in count:
		var data := artifacts[i]
		var artifact := data.artifact_scene.instantiate() as Artifact
		stage.add_child(artifact)
		artifact.data = data
		artifact.position = Vector2(start_x + i * STAGE_SPACING, randf_range(-20, 20))
		artifact.rotation_degrees = randf_range(-5, 5)
		artifact.scale = Vector2(1, 1)
		artifact.render_evidence_into_artifact(data)
		artifact.set_grabbable(false)

func _clear_stage() -> void:
	for c in stage.get_children():
		c.queue_free()

func _finish() -> void:
	_clear_stage()
	hide()
	finished.emit()
