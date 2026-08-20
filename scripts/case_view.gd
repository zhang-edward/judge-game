class_name CaseView
extends Node

@export var game: Main
@onready var charge_name_label: Label = %ChargeName
@onready var win_percentage: Label = %WinPercentage

func _ready() -> void:
	await game.ready
	init_case()

func update_case_win_percentage():
	win_percentage.text = "% chance to win: " + str(game.case.win_percentage)

func init_case():
	charge_name_label.text = game.case.to_string() + "\n\n"
	update_case_win_percentage()
