class_name DebugEvidenceRow
extends Artifact

@onready var label: Label = %Label
@onready var add_to_case_button: Button = %Button

func initialize(e: Evidence) -> void:
	super.initialize(e)
	label.text = e.render()