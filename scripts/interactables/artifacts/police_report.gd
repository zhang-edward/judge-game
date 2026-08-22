class_name PoliceReport
extends Artifact

var template_string = "Suspect was seen at the $location $action a $item at $time"
@onready var suspect_body = $Paper/SuspectBody as Label
@onready var officer_body = $Paper/OfficerBody as Label
@onready var date_label = $Paper/DateBody as Label
@onready var evidence_label = %EvidenceLabel as Label

func render_evidence_into_artifact(e: Evidence):
	if e.location != null:
		template_string = template_string.replace("$location", e.location.id)
	else:
		template_string = template_string.replace(" at the $location", "")
	if e.item != null:
		template_string = template_string.replace("$item", e.item.name)
	else:
		template_string = template_string.replace(" a $item", " something")
	if e.action != null:
		template_string = template_string.replace("$action", e.action.gerund)
	else:
		template_string = template_string.replace("$action", "with")
	template_string = template_string.replace("$time", str(e.time) + ":00")
	suspect_body.text = e.suspect.name
	evidence_label.text = template_string
