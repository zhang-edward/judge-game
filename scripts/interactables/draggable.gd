extends Node2D
class_name Draggable

@export var zone_group := "zone"

const PICKUP_SOUNDS: Array[AudioStream] = [
	preload("res://assets/sfx/paper.wav"),
	preload("res://assets/sfx/paper2.wav"),
]
const PUTDOWN_SOUNDS: Array[AudioStream] = [
	preload("res://assets/sfx/paper_down.wav"),
	preload("res://assets/sfx/paper_down2.wav"),
]
const PITCH_VARIATION := 0.1

signal grabbed
signal dropped
signal zone_entered(area: Area2D)
signal zone_exited(area: Area2D)

var dragging := false

var _grab_offset := Vector2.ZERO
var _current_zones: Array[Area2D] = []
var _baseline_pending := false

# Every draggable clicked on the current frame. Godot delivers the click to each
# overlapping hitbox, so we gather them and grab only the frontmost.
static var _click_candidates: Array[Draggable] = []

@onready var _hitbox: Area2D = $Hitbox

var _sfx: AudioStreamPlayer


func _ready() -> void:
	# Required so the Area2D hitbox receives mouse clicks.
	get_viewport().physics_object_picking = true
	_hitbox.input_event.connect(_on_hitbox_input)
	_sfx = AudioStreamPlayer.new()
	add_child(_sfx)
	dropped.connect(func(): _play(PUTDOWN_SOUNDS))


func _play(streams: Array[AudioStream]) -> void:
	if streams.is_empty():
		return
	_sfx.stream = streams.pick_random()
	_sfx.pitch_scale = randf_range(1.0 - PITCH_VARIATION, 1.0 + PITCH_VARIATION)
	_sfx.play()


func _on_hitbox_input(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	if _click_candidates.is_empty():
		call_deferred("_grab_frontmost_candidate")
	_click_candidates.append(self)
	get_viewport().set_input_as_handled()


# Grab the frontmost draggable among those clicked this frame. Siblings draw
# later-on-top, so the highest child index is the one rendered in front.
func _grab_frontmost_candidate() -> void:
	var top: Draggable = null
	for d in _click_candidates:
		if top == null or d.get_index() > top.get_index():
			top = d
	_click_candidates.clear()
	if top != null:
		top.begin_drag()


# Start a drag programmatically. center_on_cursor=true snaps this node to the
# cursor with zero offset (e.g. on handoff). center_on_curosr=false keeps the grab offset
func begin_drag(center_on_cursor := false) -> void:
	dragging = true
	_baseline_pending = true
	if center_on_cursor:
		global_position = get_global_mouse_position()
		_grab_offset = Vector2.ZERO
	else:
		_grab_offset = global_position - get_global_mouse_position()
	get_parent().move_child(self, -1) # draw on top of its siblings
	grabbed.emit()
	if not center_on_cursor: # a handoff snaps to the cursor; don't replay the pickup sound
		_play(PICKUP_SOUNDS)


# Stop dragging without emitting `dropped` (used by a subclass handing off).
func cancel_drag() -> void:
	dragging = false


# Whether this node's hitbox can be clicked.
func set_grabbable(enabled: bool) -> void:
	_hitbox.input_pickable = enabled


func _process(_delta: float) -> void:
	if not dragging:
		return
	global_position = get_global_mouse_position() + _grab_offset
	# Poll for release so a fast drag that leaves the hitbox still stops cleanly.
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_end_drag()


func _physics_process(_delta: float) -> void:
	if not dragging:
		return

	var zones := _zones_at_cursor()
	if _baseline_pending:
		# Record the zones we started in without emitting, so only later crossings count as enter/exit
		_current_zones = zones
		_baseline_pending = false
		return
	for area in zones:
		if area not in _current_zones:
			zone_entered.emit(area)
	for area in _current_zones:
		if area not in zones:
			zone_exited.emit(area)
	_current_zones = zones


func _end_drag() -> void:
	dragging = false
	dropped.emit()


# Every zone (Area2D in `zone_group`) the mouse cursor is currently over.
func _zones_at_cursor() -> Array[Area2D]:
	var result: Array[Area2D] = []
	var params := PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	for hit in get_world_2d().direct_space_state.intersect_point(params):
		var area := hit.collider as Area2D
		if area != null and area.is_in_group(zone_group):
			result.append(area)
	return result
