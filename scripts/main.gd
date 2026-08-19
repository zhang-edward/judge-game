extends Control

func _ready() -> void:
	var suspect = Suspect.new("Bob")
	var timeline = Timeline.new(suspect)
	var evidence_arr = timeline.generate_evidence_list()
	for e in evidence_arr:
		print(e.render())
