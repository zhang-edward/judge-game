class_name CaseStatus
extends PanelContainer

@export var game: Main
@onready var outcome_title: Label = $VBoxContainer/Label
@onready var reputation_gain: Label = $VBoxContainer/Label2
@onready var continue_button = $VBoxContainer/Button
var case_outcome: CaseOutcome
var current_case: Case

static var REP_REWARD: int = 100
static var REP_PENALTY: int = 50

enum CaseOutcome {
	VICTORY,
	DEFEAT
}

func _ready() -> void:
	continue_button.pressed.connect(on_case_complete)

func show_case_outcome(c: Case, outcome: CaseOutcome):
	current_case = c
	case_outcome = outcome
	if outcome == CaseOutcome.VICTORY:
		outcome_title.text = "Case Won!"
		reputation_gain.text = "+" + str(REP_REWARD) + " Reputation"
	else:
		outcome_title.text = "Case Lost..."
		reputation_gain.text = "-" + str(REP_PENALTY) + " Reputation"
	show()
	
func is_game_over():
	var rn = game.rep_nameplate
	var will_surpass_threshold = rn.rep_progress_bar.value + REP_REWARD >= rn.rep_progress_bar.max_value
	return will_surpass_threshold and rn.curr_rank == RepNameplate.LawyerRank.ACE_ATTORNEY

func on_case_complete():
	hide()
	if is_game_over():
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		game.handle_case_outcome(current_case, case_outcome)
		game.resolve_case(current_case)
