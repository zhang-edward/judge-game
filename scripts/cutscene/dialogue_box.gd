class_name DialogueBox
extends PanelContainer

signal reveal_finished

const CHARS_PER_SECOND := 45.0
const DIALOGUE_SOUND := preload("res://assets/sfx/dialogue.wav")

@onready var label: Label = %Label

var _revealing := false
var _tween: Tween
var _sfx: AudioStreamPlayer

func _ready() -> void:
	_sfx = AudioStreamPlayer.new()
	add_child(_sfx)
	_sfx.stream = DIALOGUE_SOUND
	_sfx.finished.connect(_on_sfx_finished)

func _on_sfx_finished() -> void:
	if _revealing:
		_sfx.play()

func play(text: String) -> void:
	if _tween != null:
		_tween.kill()
	label.text = text
	label.visible_characters = 0
	_revealing = true
	_sfx.play()
	_tween = create_tween()
	_tween.tween_property(label, "visible_characters", text.length(), text.length() / CHARS_PER_SECOND)
	_tween.finished.connect(_on_reveal_done)

func is_revealing() -> bool:
	return _revealing

func finish_reveal() -> void:
	if not _revealing:
		return
	if _tween != null:
		_tween.kill()
	label.visible_characters = -1
	_on_reveal_done()

func _on_reveal_done() -> void:
	_revealing = false
	_sfx.stop()
	reveal_finished.emit()
