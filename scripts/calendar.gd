class_name Calendar
extends Sprite2D

var curr_day_index := 0
var day_labels = ["Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"]

@onready var day_of_week: Label = $DayOfWeek as Label
@onready var tooltip: Label = $Tooltip as Label
@onready var button: Button = $Button as Button

signal next_day

func _ready() -> void:
	button.pressed.connect(on_press_button)
	button.mouse_entered.connect(show_tooltip)
	button.mouse_exited.connect(hide_tooltip)
	day_of_week.text = day_labels[curr_day_index % day_labels.size()]
	
func show_tooltip():
	tooltip.show()
	
func hide_tooltip():
	tooltip.hide()
	
func on_press_button():
	curr_day_index += 1
	day_of_week.text = day_labels[curr_day_index % day_labels.size()]
	next_day.emit()
