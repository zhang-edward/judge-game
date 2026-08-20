class_name Case

# The collection of evidence_list that the player has submitted for a specific suspect

var evidence_list: Array[Evidence] = []
var charge: Charge
var suspect: Suspect

func _init(suspect_: Suspect, charge_: Charge) -> void:
	suspect = suspect_
	charge = charge_


func add_evidence(e: Evidence):
	evidence_list.append(e)

# Score all evidence_list this case contains against the charge
func score() -> float:
	# TODO
	return 0.0

func _to_string() -> String:
	var s = "The defendent stands accused of: \n"
	s += charge._to_string()
	return s
