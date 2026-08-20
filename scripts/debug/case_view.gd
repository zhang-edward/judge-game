class_name CaseView
extends Node2D

@export var game: Main
@onready var case_name_label: Label = %CaseNameLabel
@onready var charge_name_label: Label = %ChargeName
@onready var win_percentage: Label = %WinPercentage
@onready var flight_risk_label: Label = %FlightRisk
@onready var back_button: Button = %BackButton
@onready var evidence_list_TEMP: Label = $TempEvidenceLabel

var current_case: Case

func _ready() -> void:
	back_button.pressed.connect(close)

func update_case_win_percentage():
	if current_case == null:
		return
	win_percentage.text = "% chance to win:\n " + str(current_case.win_percentage)

func open_for(c: Case):
	current_case = c
	case_name_label.text = c.suspect.name
	charge_name_label.text = c.charge.to_string()
	flight_risk_label.text = "Flight risk: " + str(c.flight_risk_percentage) + "%"
	update_case_win_percentage()

	# render evidence temporarily in a label
	var s = ""
	for e in c.evidence_list:
		s += e.render() + "\n"
	evidence_list_TEMP.text = s

	visible = true

func close():
	visible = false
