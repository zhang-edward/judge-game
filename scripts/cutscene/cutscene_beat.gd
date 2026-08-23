class_name CutsceneBeat

var text: String
var artifacts: Array[ArtifactData] = []

func _init(text_: String, artifacts_: Array[ArtifactData] = []) -> void:
	text = text_
	artifacts = artifacts_
