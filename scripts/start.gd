class_name Start
extends Node2D

@onready var button: Button = %Button

func _ready() -> void:
	button.pressed.connect(start_game)
	
func start_game():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
