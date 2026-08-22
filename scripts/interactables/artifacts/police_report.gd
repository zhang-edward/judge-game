class_name PoliceReport
extends Artifact

var template_string = "Suspect was seen at the $location $action a $item at $time"
@onready var suspect_body = $Paper/SuspectBody as Label
@onready var officer_body = $Paper/OfficerBody as Label
@onready var date_label = $Paper/DateBody as Label
@onready var evidence_label = %EvidenceLabel as Label

func render_evidence_into_artifact(data: ArtifactData):
	var lines: Array[String] = []
	for e in data.evidence:
		var s = template_string
		if e.location != null:
			s = s.replace("$location", e.location.id)
		else:
			s = s.replace(" at the $location", "")
		if e.item != null:
			s = s.replace("$item", e.item.name)
		else:
			s = s.replace(" a $item", " something")
		if e.action != null:
			s = s.replace("$action", e.action.gerund)
		else:
			s = s.replace("$action", "with")
		s = s.replace("$time", str(e.time) + ":00")
		lines.append(s)
	evidence_label.text = "\n\n".join(lines)
	suspect_body.text = data.evidence[0].suspect.name
