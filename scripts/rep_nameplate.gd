class_name RepNameplate
extends Sprite2D

@onready var rep_progress_bar: ProgressBar = $ProgressBar
@onready var rep_rank: Label = $Node2D/RepRank
@onready var rep_amount: Label = $RepAmount
@onready var button: Button = $Button

signal on_promo(new_title: String)

enum LawyerRank {
	INTERN,
	ASSOCIATE,
	PARTNER,
	ACE_ATTORNEY
}

const rank_readable_map = {
	LawyerRank.INTERN: "Intern",
	LawyerRank.ASSOCIATE: "Associate",
	LawyerRank.PARTNER: "Partner",
	LawyerRank.ACE_ATTORNEY: "Ace Attorney"
}

const BASE_THRESHOLD = 200
var curr_rank: LawyerRank = LawyerRank.INTERN

func _ready() -> void:
	var rank_level: int = curr_rank
	rep_progress_bar.max_value = BASE_THRESHOLD
	button.mouse_entered.connect(show_progress_info)
	button.mouse_exited.connect(hide_progress_info)
	update_rank_label_progress()

func show_progress_info():
	rep_progress_bar.show()
	rep_amount.show()
	
func hide_progress_info():
	rep_progress_bar.hide()
	rep_amount.hide()

func add_rep_progress(rep_progress):
	rep_progress_bar.value += rep_progress
	if rep_progress_bar.value >= rep_progress_bar.max_value:
		curr_rank = (curr_rank + 1) as LawyerRank
		rep_progress_bar.value = 0
		rep_progress_bar.max_value = BASE_THRESHOLD * pow(2, (curr_rank as int))
		on_promo.emit(rank_readable_map[curr_rank])
	update_rank_label_progress()

func update_rank_label_progress():
	rep_amount.text = "Rep: " + str(int(rep_progress_bar.value)) + "/" + str(int(rep_progress_bar.max_value))
	var rank_str = rank_readable_map[curr_rank]
	rep_rank.text = rank_str
