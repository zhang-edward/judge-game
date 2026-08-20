class_name CaseView
extends Node2D

@export var game: Main
@onready var charge_name_label: Label = %ChargeName
@onready var win_percentage: Label = %WinPercentage
@onready var back_button: Button = %BackButton
@onready var evidence_list_TEMP: Label = $TempEvidenceLabel

func _ready() -> void:
	back_button.pressed.connect(toggle_visible)
	await game.ready
	init_case()

func update_case_win_percentage():
	win_percentage.text = "% chance to win:\n " + str(game.case.win_percentage)

func init_case():
	charge_name_label.text = game.case.charge.to_string()
	update_case_win_percentage()

func toggle_visible():
	visible = !visible

	# render evidence temporarily in a label
	var s = ""
	for e in game.case.evidence_list:
		s += e.render() + "\n"
	evidence_list_TEMP.text = s
