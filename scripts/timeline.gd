class_name Timeline

var facts: Array[Fact] = []
var suspect: Suspect

func _init(_suspect: Suspect, charge: Charge):
	suspect = _suspect
	var crime_index = randi_range(0, 24)
	print("CRIME COMMITTED AT " + str(crime_index))
	for i in range(0, 24):
		if i == crime_index:
			var law = charge.law
			facts.append(Fact.new(suspect, law.action, Vocab.random_item_in_category(law.category), law.location, i))
		var rand_item = Vocab.items.pick_random()
		var rand_action = rand_item.supported_actions.pick_random()
		var rand_loc = Vocab.locations.pick_random()
		facts.append(Fact.new(suspect, rand_action, rand_item, rand_loc, i))

func generate_evidence_list() -> Array[Evidence]:
	var evidence_arr: Array[Evidence] = []
	for f in facts:
		var num_evidence = randi_range(1, 3)
		for i in range(0, num_evidence):
			evidence_arr.append(create_evidence(f))
	return evidence_arr

func create_evidence(f: Fact) -> Evidence:
	var action = null
	var item = null
	var loc = null
	var i = randi_range(0, 6)
	match i:
		0:
			action = f.action
		1:
			item = f.item
		2:
			loc = f.location
		3:
			action = f.action
			item = f.item
		4:
			action = f.action
			loc = f.location
		5:
			item = f.item
			loc = f.location
		6:
			action = f.action
			item = f.item
			loc = f.location
	return Evidence.new(suspect, f.time, action, loc, item)
