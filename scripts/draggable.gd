extends Control
class_name Draggable

@export var grab_through_children := true

var _dragging := false
var _grab_offset := Vector2.ZERO

func _ready() -> void:
	print("hi")
	mouse_filter = Control.MOUSE_FILTER_STOP
	if grab_through_children:
		for child in _all_descendants(self):
			if child is Control:
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			_grab_offset = global_position - get_global_mouse_position()
			get_parent().move_child(self, -1)
		else:
			_dragging = false
		accept_event()
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() + _grab_offset
		accept_event()


func _all_descendants(node: Node) -> Array[Node]:
	var out: Array[Node] = []
	for child in node.get_children():
		out.append(child)
		out.append_array(_all_descendants(child))
	return out
