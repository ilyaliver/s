extends PanelContainer

class_name CardItem

@onready var rank_label: Label = $VBoxContainer/RankLabel
@onready var stars_label: Label = $VBoxContainer/CenterContainer/StarsLabel
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var bg_texture: TextureRect = $BgTexture

var card_data: Dictionary = {}


func _ready() -> void:
	custom_minimum_size = Vector2(120, 180)


func setup(data: Dictionary) -> void:
	card_data = data
	call_deferred("_update_display")


func _update_display() -> void:
	if card_data.is_empty():
		return

	var rank = GameManager.get_rank_by_id(card_data.get("rank_id", "F"))

	# Set rank label
	rank_label.text = rank["name"]

	# Set stars
	var stars := ""
	for i in range(rank["stars"]):
		stars += "*"
	stars_label.text = stars

	# Set name
	name_label.text = card_data.get("name", "Unknown")

	# Set level/constellation
	var constellation = card_data.get("constellation", 1)
	var level = card_data.get("level", 1)
	level_label.text = "C%d - %d" % [constellation, level]

	# Set background color based on rank
	var style := StyleBoxFlat.new()
	style.bg_color = rank["color"]
	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 24
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(1, 1, 1, 0.2)
	add_theme_stylebox_override("panel", style)

	# Set background image if available
	var bg_image_path = card_data.get("bg_image", "")
	if bg_image_path != "" and ResourceLoader.exists(bg_image_path):
		var tex = load(bg_image_path)
		if tex:
			bg_texture.texture = tex
			bg_texture.visible = true
	else:
		bg_texture.visible = false
