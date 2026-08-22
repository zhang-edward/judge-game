class_name ReceiptItemRow
extends HBoxContainer

@onready var item_name: Label = $ItemName
@onready var price: Label = $Price
var price_val

func configure(item_name_value: String, price_value: float):
	item_name.text = item_name_value
	price_val = price_value
	price.text = "%.2f" % price_value
