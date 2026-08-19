class_name Law

# A rule. It always names an action. It can also require the object to be in a
# category and/or the act to happen in a location. null means "don't care".

var action: ActionDef
var category: CategoryDef = null
var location: LocationDef = null

func _init(action_: ActionDef, category_: CategoryDef = null, location_: LocationDef = null) -> void:
	action = action_
	category = category_
	location = location_

static func make_random() -> Law:
	# Generate a random item first, then choose category - this makes sure we have a law that applies
	# to at least 1 item in that category
	var rand_item = Vocab.items.pick_random()
	var category_from_item = rand_item.categories.pick_random()
	var rand_action = rand_item.supported_actions.pick_random()
	var rand_location = Vocab.locations.pick_random() if randf() > 0.5 else null

	return Law.new(rand_action, category_from_item, rand_location)


func is_broken_by(fact: Fact) -> bool:
	if fact.action != action:
		return false
	if category != null and not fact.has_category(category):
		return false
	if location != null and fact.location != location:
		return false
	return true


func render() -> String:
	var rendered_sentence = "No"

	if action != null:
		rendered_sentence += " " + action.gerund
	else:
		if category == null:
			rendered_sentence += " being"
		else:
			rendered_sentence += " having"
	if category != null:
		rendered_sentence += " " + category.plural
	if location != null:
		rendered_sentence += " " + location.phrase

	return rendered_sentence
