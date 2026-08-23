class_name DialogueBox
extends PanelContainer

signal reveal_finished

const CHARS_PER_SECOND := 45.0

@onready var label: Label = %Label

var _revealing := false
var _tween: Tween

func play(text: String) -> void:
	if _tween != null:
		_tween.kill()
	label.text = text
	label.visible_characters = 0
	_revealing = true
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
	reveal_finished.emit()
