class_name WitnessStatement
extends Artifact

var template_string = "I saw $suspect in the $location at $time. They were $action a $item."

@onready var evidence_label: Label = %EvidenceLabel
@onready var statement_of_body: Label = $Paper/StatementOfBody
@onready var date_body: Label = $Paper/DateBody

func render_evidence_into_artifact(e: Evidence):
	template_string = template_string.replace("$suspect", e.suspect.name)
	if e.action != null:
		template_string = template_string.replace("$action", e.action.gerund)
	else:
		if e.item == null:
			template_string = template_string.replace(" They were $action a $item.", "")
		else:
			template_string = template_string.replace("were $action", "had")
	if e.item != null:
		template_string = template_string.replace("$item", e.item.name)
	else:
		if e.action != null:
			template_string = template_string.replace("a $item", "something")
	if e.location != null:
		template_string = template_string.replace("$location", e.location.id)
	else:
		template_string = template_string.replace(" in the $location", "")
	template_string = template_string.replace("$time", str(e.time) + ":00")
	evidence_label.text = template_string
	var eyewitness_name := ""
	if e.misc_data.has("eyewitness_name"):
		eyewitness_name = e.misc_data["eyewitness_name"]
	else:
		eyewitness_name = Vocab.suspect_names.pick_random()
		e.misc_data["eyewitness_name"] = eyewitness_name
	statement_of_body.text = eyewitness_name
