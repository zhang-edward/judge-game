class_name PromotionAlert
extends PanelContainer

@onready var promo_description: RichTextLabel = $VBoxContainer/PromoDescription
@onready var button: Button = $VBoxContainer/Button

func _ready() -> void:
	button.pressed.connect(dismiss_alert)

func show_promo_alert(new_title: String):
	show()
	promo_description.text = "You've been promoted to [color=green]" + new_title + "[/color]"

func dismiss_alert():
	hide()
