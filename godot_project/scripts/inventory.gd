extends Control

@onready var grid_container: GridContainer = $PanelContainer/VBoxContainer/ScrollContainer/GridContainer
@onready var empty_label: Label = $PanelContainer/VBoxContainer/ScrollContainer/EmptyLabel
@onready var back_btn: Button = $PanelContainer/VBoxContainer/HeaderContainer/BackBtn

const CARD_SCENE: PackedScene = preload("res://scenes/card_item.tscn")


func _ready() -> void:
	_populate_inventory()
	back_btn.pressed.connect(_on_back_pressed)


func _populate_inventory() -> void:
	for child in grid_container.get_children():
		child.queue_free()

	var sorted_inventory = GameManager.get_inventory_sorted()

	if sorted_inventory.is_empty():
		empty_label.visible = true
		grid_container.visible = false
		return

	empty_label.visible = false
	grid_container.visible = true

	for card_data in sorted_inventory:
		var card = CARD_SCENE.instantiate()
		card.setup(card_data)
		grid_container.add_child(card)


func _on_back_pressed() -> void:
	queue_free()
