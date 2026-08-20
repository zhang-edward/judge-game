@abstract class_name Artifact
extends Node
# Represents a physical artifact that the player can inspect, that displays a piece of evidence

var evidence: Evidence

func initialize(e: Evidence) -> void:
	evidence = e
