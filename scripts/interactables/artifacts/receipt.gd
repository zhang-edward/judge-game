class_name Receipt
extends Artifact

@export var receipt_item_row_scene: PackedScene
@onready var item_list: VBoxContainer = $Paper/ItemList
@onready var total_amount: Label = $Paper/Amount
@onready var purchaser: Label = $Paper/Purchaser

var random_prices = [1.59, 3.59, 5.99, 12.99, 19.99, 34.99, 44.99, 59.99, 99.59]

# A receipt only shows a purchased item, so it can only represent item-only evidence.
func select_evidence(pool: Array[Evidence]) -> Array[Evidence]:
	var candidates: Array[Evidence] = []
	for e in pool:
		if e.action == null and e.location == null and e.item != null:
			candidates.append(e)
	var result: Array[Evidence] = []
	if not candidates.is_empty():
		result.append(candidates.pick_random())
	return result

func render_evidence_into_artifact(data: ArtifactData):
	var e = data.evidence[0]
	var evidence_item_name = ""
	var total_price = 0.0
	if e.item != null:
		evidence_item_name = e.item.name
		var evidence_row = generate_receipt_item_row(evidence_item_name)
		total_price += evidence_row.price_val
	# Don't include other items of the same category
	var c = Vocab.get_item_categories(evidence_item_name)
	var valid_items = Vocab.items.filter(func (def): return get_intersection(c, def.categories).is_empty())
	var num_items = randi_range(4, 9)
	for i in range(0, num_items):
		var random_item: ItemDef = valid_items.pick_random()
		var row = generate_receipt_item_row(random_item.name)
		total_price += row.price_val
	total_amount.text = "%.2f" % total_price
	purchaser.text = e.suspect.name + " CREDIT"
	
func get_intersection(arr1: Array, arr2: Array):
	var intersection = []
	for i in arr1:
		if arr2.has(i):
			intersection.append(i)
	return intersection
			
	
func generate_receipt_item_row(item_name: String):
	var item_row = receipt_item_row_scene.instantiate() as ReceiptItemRow
	var price = random_prices[item_name.length() % random_prices.size()]
	item_list.add_child(item_row)
	item_row.configure(item_name, price)
	return item_row
