class_name WitnessStatement
extends Artifact

@onready var evidence_label: Label = %EvidenceLabel
@onready var statement_of_body: Label = $Paper/StatementOfBody
@onready var date_body: Label = $Paper/DateBody

func render_evidence_into_artifact(data: ArtifactData):
	var lines: Array[String] = []
	for e in data.evidence:
		lines.append(_sentence_for(e))
	evidence_label.text = "\n\n".join(lines)
	statement_of_body.text = _eyewitness_name(data)

func _sentence_for(e: Evidence) -> String:
	var s = "I saw $suspect in the $location at $time. They were $action a $item."
	s = s.replace("$suspect", e.suspect.name)
	if e.action != null:
		s = s.replace("$action", e.action.gerund)
	else:
		if e.item == null:
			s = s.replace(" They were $action a $item.", "")
		else:
			s = s.replace("were $action", "had")
	if e.item != null:
		s = s.replace("$item", e.item.name)
	else:
		if e.action != null:
			s = s.replace("a $item", "something")
	if e.location != null:
		s = s.replace("$location", e.location.id)
	else:
		s = s.replace(" in the $location", "")
	s = s.replace("$time", str(e.time) + ":00")
	return s

# One eyewitness reports the whole statement; keep the name stable on the data.
func _eyewitness_name(data: ArtifactData) -> String:
	if data.misc_data.has("eyewitness_name"):
		return data.misc_data["eyewitness_name"]
	var all_suspect_names = Vocab.male_suspect_names + Vocab.female_suspect_names
	var eyewitness_name: String = all_suspect_names.pick_random()
	data.misc_data["eyewitness_name"] = eyewitness_name
	return eyewitness_name
