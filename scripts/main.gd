extends Node

func _ready() -> void:
	var suspect = Suspect.new("Bob")
	var laws = []
	for i in range(0, 5):
		laws.append(Law.make_random())
	var charge = Charge.new(laws.pick_random(), 1)
	var timeline = Timeline.new(suspect, charge)
	var evidence_arr = timeline.generate_evidence_list()

	print("===== Laws:")
	for l in laws:
		print(l.render())

	print("\n===== Timeline:")
	for f in timeline.facts:
		print(f.render())

	print("\n===== Evidence:")
	for e in evidence_arr:
		print(e.render())
