extends Control

const LawRow := preload("res://law_row.tscn")

var law_book: Array[Law] = []
var evidence: Array[Evidence] = []
var score := 0

var count_inputs: Array[SpinBox] = []   # one per law, same order as law_book

@onready var evidence_label: Label = %EvidenceLabel
@onready var law_list: VBoxContainer = %LawList
@onready var result_label: Label = %ResultLabel
@onready var score_label: Label = %ScoreLabel
@onready var submit_button: Button = %SubmitButton
@onready var next_button: Button = %NextButton

func _ready() -> void:
	law_book = Judge.make_law_book()
	_build_law_rows()
	_new_case()
	_show_score()
	
	submit_button.pressed.connect(_on_submit);
	next_button.pressed.connect(_new_case);


# One row per law. The text comes straight from the law book, so nothing is duplicated.
func _build_law_rows() -> void:
	for law in law_book:
		var row := LawRow.instantiate()
		var desc: Label = row.get_node("Desc")
		desc.text = law.description
		law_list.add_child(row)
		var count: SpinBox = row.get_node("Count")
		count_inputs.append(count)


func _new_case() -> void:
	evidence = Judge.make_case()

	var lines := []
	for e in evidence:
		lines.append("•  " + Judge.evidence_sentence(e))
	evidence_label.text = "\n".join(lines)

	for spin in count_inputs:
		spin.value = 0
	result_label.text = ""


func _on_submit() -> void:
	var truth := Judge.evaluate(evidence, law_book)

	# Look up the true count for each law (0 if it was never broken)
	var true_count := {}
	for charge in truth:
		true_count[charge.law] = charge.count

	# +1 for each law ruled correctly, -1 for mistake
	var correct := 0
	for i in law_book.size():
		var actual: int = true_count.get(law_book[i], 0)
		if int(count_inputs[i].value) == actual:
			correct += 1
	var wrong := law_book.size() - correct
	score += correct - wrong
	_show_score()

	result_label.text = _verdict_text(truth, correct)


func _verdict_text(truth: Array[Charge], correct: int) -> String:
	var header := "You ruled %d of %d laws correctly." % [correct, law_book.size()]
	if truth.is_empty():
		return header + "\nActual charges: none. The defendant walks free."
	var lines := ["Actual charges:"]
	for charge in truth:
		lines.append("•  " + Judge.charge_sentence(charge))
	return header + "\n" + "\n".join(lines)


func _show_score() -> void:
	score_label.text = "Score: %d" % score
