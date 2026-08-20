class_name Main
extends Node

@onready var case_view: CaseView = $CanvasLayer/TempGameUI/Case
@onready var next_day_button: Button = $CanvasLayer/TempGameUI/NextDay
@onready var day_of_week: Label = $CanvasLayer/TempGameUI/DayOfWeek
@onready var artifact_manager: ArtifactManager = $ArtifactManager
@onready var flight_risk_label: Label = %FlightRisk
@onready var suspect_fled_alert: SuspectFledAlert = $CanvasLayer/SuspectFledAlert
@onready var submit_case: Button = %SubmitCase

var day_labels = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
var day_index := 0
var flight_risk_percentage := 0

var evidence: Array[Evidence] = []
var laws: Array[Law]
var case: Case
var suspect: Suspect
var charge: Charge

func _ready() -> void:
	suspect = Suspect.new(Vocab.suspect_names.pick_random())
	for i in range(0, 5):
		laws.append(Law.make_random())
	charge = Charge.new(laws.pick_random(), 1)
	case = Case.new(suspect, charge)
	receive_evidence_list()
	next_day_button.pressed.connect(progress_day)
	submit_case.pressed.connect(on_submit_case)
	
func receive_evidence_list():
	var timeline_for_day = Timeline.new(suspect, charge)
	evidence = timeline_for_day.generate_evidence_list()
	artifact_manager.render_artifacts()
	
func on_submit_case():
	var did_case_succeed = randi_range(1, 100) <= case.win_percentage
	if did_case_succeed:
		pass
	else:
		pass
	
func reset_case():
	suspect = Suspect.new(Vocab.suspect_names.pick_random())	
	charge = Charge.new(laws.pick_random(), 1)
	case = Case.new(suspect, charge)
	case_view.init_case()
	flight_risk_percentage = 0
	update_flight_risk_percentage()
	receive_evidence_list()

func progress_day():
	if suspect_fled_alert.visible:
		return
	var did_flee = randi_range(1, 100) < flight_risk_percentage
	if did_flee:
		suspect_fled_alert.show()
	else:
		flight_risk_percentage += 5 #todo: make this scale based on case strength
		update_flight_risk_percentage()
		receive_evidence_list()
		day_index = (day_index + 1) % day_labels.size()
		day_of_week.text = day_labels[day_index]

func update_flight_risk_percentage():
	flight_risk_label.text = "Flight risk: " + str(flight_risk_percentage) + "%"
