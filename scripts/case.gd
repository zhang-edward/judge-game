class_name Case

# The collection of evidence_list that the player has submitted for a specific suspect

var evidence_list: Array[Evidence] = []
var charge: Charge
var suspect: Suspect
var win_percentage: float = 0.0

func _init(suspect_: Suspect, charge_: Charge) -> void:
	suspect = suspect_
	charge = charge_

func add_evidence(e: Evidence):
	evidence_list.append(e)
	win_percentage = Judge.score(evidence_list, charge)

func _to_string() -> String:
	var s = "The defendent stands accused of: \n"
	s += charge._to_string()
	return s

func reset():
	evidence_list = []
	win_percentage = 0.0
