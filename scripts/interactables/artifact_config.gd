class_name ArtifactConfig
extends Resource

@export var workspace_scene: PackedScene
@export var desk_scene: PackedScene
@export var template_string = ""

func render(e: Evidence):
	template_string.replace("$action", e.action.past)
	if e.item != null:
		template_string.replace("$item", e.item.name)
	template_string.replace("$location", e.location.id)
