class_name Main
extends Node

signal game_initialized()

var evidence: Array[Evidence] = []
var laws: Array[Law]
var case: Case

func _ready() -> void:
	var suspect = Suspect.new("Bob")
	for i in range(0, 5):
		laws.append(Law.make_random())
	var charge = Charge.new(laws.pick_random(), 1)
	case = Case.new(suspect, charge)
	var timeline = Timeline.new(suspect, charge)

	evidence = timeline.generate_evidence_list()

	print("===== Laws:")
	for l in laws:
		print(l.render())

	print("\n===== Timeline:")
	for f in timeline.facts:
		print(f.render())

	print("\n===== Evidence:")
	for e in evidence:
		print(e.render())

	game_initialized.emit()
