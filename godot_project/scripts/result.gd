extends Control

@onready var grid_container: GridContainer = $PanelContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var confirm_btn: Button = $PanelContainer/VBoxContainer/ConfirmBtn
@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleLabel

const CARD_SCENE: PackedScene = preload("res://scenes/card_item.tscn")

var cards_data: Array = []


func setup(cards: Array) -> void:
	cards_data = cards
	call_deferred("_populate_results")


func _ready() -> void:
	confirm_btn.pressed.connect(_on_confirm_pressed)


func _populate_results() -> void:
	for child in grid_container.get_children():
		child.queue_free()

	if cards_data.size() == 1:
		title_label.text = "ITEM OBTAINED"
		grid_container.columns = 1
	else:
		title_label.text = "ITEMS OBTAINED"
		grid_container.columns = min(cards_data.size(), 5)

	for card_data in cards_data:
		var card = CARD_SCENE.instantiate()
		card.setup(card_data)
		grid_container.add_child(card)


func _on_confirm_pressed() -> void:
	queue_free()
