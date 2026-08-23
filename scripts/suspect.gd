class_name Suspect

var name := ""
var flight_risk_percentage := 0
var avatar_type: AvatarType
var crime: Law

enum AvatarType {
	MALE,
	FEMALE
}

var male_prefix = "res://assets/sprites/male-avatar"
var female_prefix = "res://assets/sprites/female-avatar"
var avatar_texture: Texture2D

func _init(_name: String, _avatar_type: AvatarType, _crime: Law) -> void:
	name = _name
	avatar_type = _avatar_type
	crime = _crime
	var path_prefix = male_prefix if avatar_type == AvatarType.MALE else female_prefix
	avatar_texture = load(path_prefix + "-" + str(randi_range(1, 4)) + ".png")
