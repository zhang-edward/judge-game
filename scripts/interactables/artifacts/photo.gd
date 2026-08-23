class_name Photo
extends Artifact

@onready var description = $PhotoFrame/Description
@onready var time_taken = $PhotoFrame/TimeTaken

var template_string = "\"Shows $suspect $action a $item at the $location.\""

func render_evidence_into_artifact(data: ArtifactData):
	var evidence = data.evidence[0]
	template_string = template_string.replace("$suspect", evidence.suspect.name)
	if evidence.action != null:
		template_string = template_string.replace("$action", evidence.action.gerund)
	else:
		if evidence.item != null:
			template_string = template_string.replace("$action", "with")
		else:
			template_string = template_string.replace(" $action a $item", "")
	if evidence.item != null:
		template_string = template_string.replace("$item", evidence.item.name)
	else:
		template_string = template_string.replace(" a $item", " something")
	if evidence.location != null:
		template_string = template_string.replace("$location", evidence.location.id)
	else:
		template_string = template_string.replace(" at the $location", "")
	description.text = template_string
	time_taken.text = "Taken at " + str(evidence.time) + ":00"
