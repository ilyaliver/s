extends Control

@onready var crystals_label: Label = $MainContainer/Header/CrystalsContainer/CrystalsLabel
@onready var inventory_count_label: Label = $MainContainer/Header/InventoryBtn/InventoryCountLabel
@onready var ex_pity_label: Label = $MainContainer/BannerContainer/BannerRight/PityContainer/ExPityLabel
@onready var s_pity_label: Label = $MainContainer/BannerContainer/BannerRight/PityContainer/SPityLabel
@onready var banner_status_label: Label = $MainContainer/BannerContainer/BannerLeft/BannerStatusContainer/BannerStatusLabel
@onready var pull_1_btn: Button = $MainContainer/BottomContainer/PullButtonsContainer/Pull1Btn
@onready var pull_10_btn: Button = $MainContainer/BottomContainer/PullButtonsContainer/Pull10Btn
@onready var sound_btn: Button = $MainContainer/Header/LogoContainer/SoundBtn
@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer

var inventory_scene: PackedScene = preload("res://scenes/inventory.tscn")
var shop_scene: PackedScene = preload("res://scenes/shop.tscn")
var result_scene: PackedScene = preload("res://scenes/result.tscn")
var rules_scene: PackedScene = preload("res://scenes/rules.tscn")
var ai_credits_scene: PackedScene = preload("res://scenes/ai_credits.tscn")


func _ready() -> void:
	GameManager.crystals_changed.connect(_on_crystals_changed)
	GameManager.inventory_changed.connect(_on_inventory_changed)
	GameManager.pity_changed.connect(_on_pity_changed)
	GameManager.pull_completed.connect(_on_pull_completed)

	_update_ui()
	_try_play_music()


func _update_ui() -> void:
	crystals_label.text = str(GameManager.crystals)

	var pull_cost = GameManager.PULL_COST
	pull_1_btn.disabled = GameManager.crystals < pull_cost
	pull_10_btn.disabled = GameManager.crystals < pull_cost * 10

	if pull_1_btn.disabled:
		pull_1_btn.modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		pull_1_btn.modulate = Color(1.0, 1.0, 1.0, 1.0)

	if pull_10_btn.disabled:
		pull_10_btn.modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		pull_10_btn.modulate = Color(1.0, 1.0, 1.0, 1.0)

	inventory_count_label.text = str(GameManager.inventory.size())
	_on_pity_changed(GameManager.EX_PITY_LIMIT - GameManager.ex_pity_counter, GameManager.S_PITY_LIMIT - GameManager.s_pity_counter, GameManager.guaranteed_ex_next)


func _on_crystals_changed(amount: int) -> void:
	crystals_label.text = str(amount)
	_update_ui()


func _on_inventory_changed() -> void:
	inventory_count_label.text = str(GameManager.inventory.size())


func _on_pity_changed(ex_remaining: int, s_remaining: int, guaranteed: bool) -> void:
	ex_pity_label.text = "%d/%d" % [ex_remaining, GameManager.EX_PITY_LIMIT]
	s_pity_label.text = "%d/%d" % [s_remaining, GameManager.S_PITY_LIMIT]

	if guaranteed:
		ex_pity_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
		banner_status_label.text = "ВНИМАНИЕ: Обнаружена аномалия S+. Следующий сигнал EX будет 100% целевым."
		banner_status_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.3))
	else:
		ex_pity_label.add_theme_color_override("font_color", Color(1.0, 0.75, 0.3))
		banner_status_label.text = "Каждые 90 поисков гарантируют предмет ранга EX. Аномалия S+ включает 100% гарант."
		banner_status_label.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))


func _on_pull_completed(cards: Array) -> void:
	_show_result(cards)


func _try_play_music() -> void:
	if audio_stream and GameManager.sound_enabled:
		audio_stream.play()


func _on_pull_1_btn_pressed() -> void:
	GameManager.do_pull(1)


func _on_pull_10_btn_pressed() -> void:
	GameManager.do_pull(10)


func _on_inventory_btn_pressed() -> void:
	var inv = inventory_scene.instantiate()
	add_child(inv)


func _on_shop_btn_pressed() -> void:
	var shop = shop_scene.instantiate()
	add_child(shop)


func _on_rules_btn_pressed() -> void:
	var rules = rules_scene.instantiate()
	add_child(rules)


func _on_ai_credits_btn_pressed() -> void:
	var ai = ai_credits_scene.instantiate()
	add_child(ai)


func _on_sound_btn_pressed() -> void:
	GameManager.sound_enabled = !GameManager.sound_enabled
	if audio_stream:
		if GameManager.sound_enabled:
			audio_stream.stream_paused = false
			audio_stream.play()
			sound_btn.text = "*"
		else:
			audio_stream.stream_paused = true
			sound_btn.text = "x"


func _on_reset_btn_pressed() -> void:
	GameManager.reset_progress()


func _show_result(cards: Array) -> void:
	var result = result_scene.instantiate()
	result.setup(cards)
	add_child(result)
