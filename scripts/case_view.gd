class_name CaseView
extends Node

@export var game: Main
@onready var label: Label = %Label

func _process(_delta: float) -> void:
	label.text = game.case.to_string() + "\n\n"
	label.text += str(game.case.evidence_list.size()) + " pieces of evidence\n"
	label.text += "% chance to win: " + str(game.case.score())
