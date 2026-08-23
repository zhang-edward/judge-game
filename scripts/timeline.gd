class_name Timeline

var facts: Array[Fact] = []
var suspect: Suspect

func _init(_suspect: Suspect, laws: Array[Law]):
	suspect = _suspect
	var num_crimes = randi_range(1, 3)
	var times = Array(range(13))
	times.shuffle()
	var crime_times = times.slice(0, num_crimes)
	var illegal_locations = laws.map(func (l): return l.location)
	var legal_locations = Vocab.locations.filter(func (l): return !illegal_locations.has(l))
	legal_locations.shuffle()
	var all_locations = [suspect.crime.location] + legal_locations.slice(0, 2)
	for i in range(0, 12):
		var rand_item
		var rand_action
		var rand_loc
		if crime_times.has(i):
			var crime = suspect.crime
			rand_item = Vocab.random_item_in_category(crime.category)
			rand_loc = crime.location
			rand_action = crime.action
			var fact = Fact.new(suspect, rand_action, rand_item, rand_loc, i)
		else:
			rand_item = Vocab.items.pick_random()
			rand_action = rand_item.supported_actions.pick_random()
			rand_loc = all_locations.pick_random()
		facts.append(Fact.new(suspect, rand_action, rand_item, rand_loc, i))

func generate_evidence_list() -> Array[Evidence]:
	var evidence_arr: Array[Evidence] = []
	for f in facts:
		var num_evidence = randi_range(1, 3)
		for i in range(0, num_evidence):
			var evidence = create_evidence(f)
			var add_to_evidence_arr = randi_range(0, 2) == 0
			if add_to_evidence_arr:
				evidence_arr.append(evidence)
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
