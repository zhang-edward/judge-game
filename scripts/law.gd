class_name Law

# A rule. It always names an action. It can also require the object to be in a
# category and/or the act to happen in a location. null means "don't care".

var action: ActionDef
var description: String
var category: CategoryDef = null
var location: LocationDef = null


func _init(action_: ActionDef, description_: String, category_: CategoryDef = null, location_: LocationDef = null) -> void:
	action = action_
	description = description_
	category = category_
	location = location_


func is_broken_by(e: Evidence) -> bool:
	if e.action != action:
		return false
	if category != null and not e.has_category(category):
		return false
	if location != null and e.location != location:
		return false
	return true
