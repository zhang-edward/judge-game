class_name LawBook
extends Draggable

@export var small_form_scene: PackedScene
@export var is_small_form: bool

const LAW_FONT = preload("res://assets/fonts/PixelOperator-Bold.ttf")

@onready var prev_page_button: TextureButton = %PrevPageButton
@onready var next_page_button: TextureButton = %NextPageButton

var counterpart: LawBook
var home_zone: Area2D
var small_form: LawBook

var page_index: int = 0

func _ready() -> void:
	super._ready()
	set_grabbable(visible)
	zone_entered.connect(_on_zone_entered)
	if !is_small_form:
		prev_page_button.pressed.connect(on_prev_page)
		next_page_button.pressed.connect(on_next_page)

func on_next_page() -> void:
	var cur_page = get_node("Page" + str(page_index))
	cur_page.visible = false
	page_index += 1
	var new_page = get_node("Page" + str(page_index))
	new_page.visible = true

	next_page_button.visible = page_index != 2
	prev_page_button.visible = page_index != 0
	_play(PICKUP_SOUNDS)

func on_prev_page() -> void:
	var cur_page = get_node("Page" + str(page_index))
	cur_page.visible = false
	page_index -= 1
	var new_page = get_node("Page" + str(page_index))
	new_page.visible = true

	next_page_button.visible = page_index != 2
	prev_page_button.visible = page_index != 0
	_play(PICKUP_SOUNDS)

func initialize(laws: Array[Law], desk_parent: Node, workspace_zone: Area2D, desk_zone: Area2D) -> void:
	populate(laws)
	if small_form_scene != null:
		small_form = small_form_scene.instantiate() as LawBook
		desk_parent.add_child(small_form)
		small_form.position = Vector2(randf_range(12, 66), randf_range(12, 90))
		small_form.rotation_degrees = randf_range(-4, 4)
		small_form.hide()
		link(small_form, workspace_zone, desk_zone)

func link(other: LawBook, my_zone: Area2D, other_zone: Area2D) -> void:
	counterpart = other
	home_zone = my_zone
	other.counterpart = self
	other.home_zone = other_zone

func populate(laws: Array[Law]) -> void:
	var laws_container := %LawsContainer as VBoxContainer
	for child in laws_container.get_children():
		child.queue_free()

	for i in laws.size():
		var label := Label.new()
		label.modulate = Color(0, 0, 0, 0.7)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.add_theme_font_override("font", LAW_FONT)
		label.add_theme_font_size_override("font_size", 15)
		label.text = laws[i].render()
		laws_container.add_child(label)

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
