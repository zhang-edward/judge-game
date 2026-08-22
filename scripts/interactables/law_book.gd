class_name LawBook
extends Draggable

@export var small_form_scene: PackedScene

const LAW_FONT = preload("res://assets/fonts/Alkhemikal.ttf")

var counterpart: LawBook
var home_zone: Area2D
var small_form: LawBook

func _ready() -> void:
	super._ready()
	set_grabbable(visible)
	zone_entered.connect(_on_zone_entered)

func initialize(laws: Array[Law], desk_parent: Node, workspace_zone: Area2D, desk_zone: Area2D) -> void:
	populate(laws)
	if small_form_scene != null:
		small_form = small_form_scene.instantiate() as LawBook
		desk_parent.add_child(small_form)
		small_form.position = Vector2(randf_range(12, 66), randf_range(12, 90))
		small_form.rotation_degrees = randf_range(-4, 4)
		link(small_form, workspace_zone, desk_zone)
		hide()
		set_grabbable(false)

func link(other: LawBook, my_zone: Area2D, other_zone: Area2D) -> void:
	counterpart = other
	home_zone = my_zone
	other.counterpart = self
	other.home_zone = other_zone

func populate(laws: Array[Law]) -> void:
	var left := get_node_or_null("TextureRect/HBoxContainer/VBoxContainer") as VBoxContainer
	var right := get_node_or_null("TextureRect/HBoxContainer/VBoxContainer2") as VBoxContainer
	if left == null or right == null:
		return
	for child in left.get_children():
		child.queue_free()
	for child in right.get_children():
		child.queue_free()
	var split := int(ceil(laws.size() / 2.0))
	for i in laws.size():
		var column := left if i < split else right
		var label := Label.new()
		label.modulate = Color(0, 0, 0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.add_theme_font_override("font", LAW_FONT)
		label.text = laws[i].render()
		column.add_child(label)

func _on_zone_entered(area: Area2D) -> void:
	if counterpart != null and area == counterpart.home_zone:
		_hand_off()

func _hand_off() -> void:
	cancel_drag()
	hide()
	set_grabbable(false)
	counterpart.show()
	counterpart.set_grabbable(true)
	counterpart.begin_drag(true)
