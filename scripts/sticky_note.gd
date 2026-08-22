class_name StickyNote
extends Node2D

@onready var label: Label = $NinePatchRect/Label
@onready var body: Label = $NinePatchRect/Body

func configure_text(label_value: String, body_value: String):
	label.text = label_value
	body.text = body_value
