class_name CaseStatus
extends PanelContainer

@export var game: Main
@onready var outcome_title: Label = $VBoxContainer/Label
@onready var reputation_gain: Label = $VBoxContainer/Label2
@onready var continue_button = $VBoxContainer/Button
var case_outcome: CaseOutcome

static var REP_REWARD: int = 100
static var REP_PENALTY: int = 50

enum CaseOutcome {
	VICTORY,
	DEFEAT
}

func _ready() -> void:
	continue_button.pressed.connect(on_case_complete)

func show_case_outcome(outcome: CaseOutcome):
	case_outcome = outcome
	if outcome == CaseOutcome.VICTORY:
		outcome_title.text = "Case Won!"
		reputation_gain.text = "+" + str(REP_REWARD) + " Reputation"
	else:
		outcome_title.text = "Case Lost..."
		reputation_gain.text = "-" + str(REP_PENALTY) + " Reputation"
	show()

func on_case_complete():
	hide()
	game.handle_case_outcome(case_outcome)
	game.reset_case()
