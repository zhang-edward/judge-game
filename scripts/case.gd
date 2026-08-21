class_name Case

# The collection of evidence_list that the player has submitted for a specific suspect
var evidence_list: Array[Evidence] = []

# Unfiled evidence for this case: the pile the player still has to sort onto the folder.
var available_evidence: Array[Evidence] = []
var charge: Charge
var suspect: Suspect
var win_percentage: float = 0.0
var flight_risk_percentage := 0

func _init(suspect_: Suspect, charge_: Charge) -> void:
	suspect = suspect_
	charge = charge_
	
func add_evidence(e: Evidence):
	evidence_list.append(e)
	win_percentage = Judge.score(evidence_list, charge, suspect)
	
func remove_evidence(e: Evidence):
	evidence_list.erase(e)
	win_percentage = Judge.score(evidence_list, charge, suspect)

# Regenerate this case's unfiled evidence pile from its own timeline.
func refresh_evidence():
	var timeline = Timeline.new(suspect, charge)
	available_evidence = timeline.generate_evidence_list()

func _to_string() -> String:
	var s = "The defendent stands accused of: \n"
	s += charge._to_string()
	return s

func reset():
	evidence_list = []
	win_percentage = 0.0
