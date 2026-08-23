class_name CaseViewProfile
extends Node2D

@onready var sprite: Sprite2D = $Photo/Sprite2D

func configure_sprite(texture: Texture2D):
	sprite.texture = texture
