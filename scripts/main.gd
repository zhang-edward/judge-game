extends Control

func _ready() -> void:
	var suspect = Suspect.new("Bob")
	var timeline = Timeline.new(suspect)
	var evidence_arr = timeline.generate_evidence_list()

	print("===== Timeline:")
	for f in timeline.facts:
		print(f.render())

	print("\n===== Evidence:")
	for e in evidence_arr:
		print(e.render())
