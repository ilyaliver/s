extends Control

@onready var close_btn: Button = $PanelContainer/VBoxContainer/CloseBtn


func _ready() -> void:
	close_btn.pressed.connect(_on_close_pressed)


func _on_close_pressed() -> void:
	queue_free()
