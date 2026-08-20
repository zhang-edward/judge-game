class_name SuspectFledAlert
extends PanelContainer

@export var game: Main
@onready var continue_button: Button = $VBoxContainer/Button

var fled_case: Case

func _ready() -> void:
	continue_button.pressed.connect(on_continue)

func show_for(c: Case):
	fled_case = c
	show()

func on_continue():
	hide()
	game.on_fled_continue()
