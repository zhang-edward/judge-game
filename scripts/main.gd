class_name Main
extends Node

@onready var case_view: CaseView = %CaseView
@onready var next_day_button: Button = $TempUI/TempGameUI/NextDay
@onready var day_of_week: Label = $TempUI/TempGameUI/DayOfWeek
@onready var artifact_manager: ArtifactManager = $ArtifactManager
@onready var suspect_fled_alert: SuspectFledAlert = $TempUI/SuspectFledAlert
@onready var case_status: CaseStatus = $TempUI/CaseStatus
@onready var submit_case: Button = %SubmitCase
@onready var reputation_label: Label = $TempUI/TempGameUI/Reputation

const CASE_COUNT := 1

var day_labels = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
var day_index := 0
var reputation_score := 0

var laws: Array[Law]
var cases: Array[Case] = []

# Cases that fled on the current day, shown one alert at a time.
var _fled_queue: Array[Case] = []

func _ready() -> void:
	for i in range(0, 5):
		laws.append(Law.make_random())
	# Distinct suspect names so the folders never share a name.
	var names := Vocab.suspect_names.duplicate()
	names.shuffle()
	for i in range(0, CASE_COUNT):
		var suspect := Suspect.new(names[i % names.size()])
		var c := Case.new(suspect)
		c.refresh_evidence()
		cases.append(c)
	artifact_manager.render_artifacts()
	artifact_manager.init_law_book(laws)
	next_day_button.pressed.connect(progress_day)
	submit_case.pressed.connect(on_submit_case)

	case_view.opened.connect(func(): artifact_manager.toggle_hitbox_for_all_case_files(false))
	case_view.closed.connect(func(): artifact_manager.toggle_hitbox_for_all_case_files(true))

# Redraw the desk from the current set of cases.
func receive_evidence_list():
	artifact_manager.render_artifacts()

func on_submit_case():
	var c := case_view.current_case
	if c == null:
		return
	var did_case_succeed = randi_range(1, 100) <= c.win_percentage
	if did_case_succeed:
		case_status.show_case_outcome(c, CaseStatus.CaseOutcome.VICTORY)
	else:
		case_status.show_case_outcome(c, CaseStatus.CaseOutcome.DEFEAT)

func handle_case_outcome(c: Case, case_outcome: CaseStatus.CaseOutcome):
	if case_outcome == CaseStatus.CaseOutcome.VICTORY:
		reputation_score += CaseStatus.REP_REWARD
	elif case_outcome == CaseStatus.CaseOutcome.DEFEAT:
		reputation_score = max(0, reputation_score - CaseStatus.REP_PENALTY)
	reputation_label.text = "Rep: " + str(reputation_score)

# Remove resolved case and redraw 
func resolve_case(c: Case):
	cases.erase(c)
	if case_view.visible and case_view.current_case == c:
		case_view.close()
	receive_evidence_list()

func progress_day():
	if suspect_fled_alert.visible or case_status.visible:
		return
	var fled: Array[Case] = []
	for c in cases:
		var did_flee = randi_range(1, 100) < c.flight_risk_percentage
		if did_flee:
			fled.append(c)
		else:
			c.flight_risk_percentage += 5 # todo: make this scale based on case strength
			c.refresh_evidence()
	day_index = (day_index + 1) % day_labels.size()
	day_of_week.text = day_labels[day_index]
	receive_evidence_list()
	_fled_queue = fled
	_show_next_fled()

func _show_next_fled():
	if _fled_queue.is_empty():
		return
	suspect_fled_alert.show_for(_fled_queue[0])

func on_fled_continue():
	if _fled_queue.is_empty():
		return
	var c: Case = _fled_queue.pop_front()
	resolve_case(c)
	_show_next_fled()
