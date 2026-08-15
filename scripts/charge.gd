class_name Charge

# A broken law and how many times it was broken.

var law: Law
var count: int


func _init(l: Law, c: int) -> void:
	law = l
	count = c
