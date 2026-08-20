class_name SuspectFledAlert
extends PanelContainer

@export var game: Main
@onready var continue_button: Button = $VBoxContainer/Button

func _ready() -> void:
	continue_button.pressed.connect(on_continue)

func on_continue():
	hide()
	game.reset_case()
