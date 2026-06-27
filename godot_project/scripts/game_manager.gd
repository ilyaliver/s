extends Node

# Data classes for cards
const RANKS := [
	{"id": "EX", "name": "EX", "stars": 6, "color": Color(1.0, 0.27, 0.33)},
	{"id": "SSS", "name": "SSS", "stars": 5, "color": Color(1.0, 0.61, 0.0)},
	{"id": "SS", "name": "SS", "stars": 5, "color": Color(0.9, 0.5, 0.09)},
	{"id": "S_PLUS", "name": "S+", "stars": 5, "color": Color(0.8, 0.27, 0.27)},
	{"id": "S", "name": "S", "stars": 5, "color": Color(0.95, 0.77, 0.06)},
	{"id": "A", "name": "A", "stars": 4, "color": Color(0.69, 0.48, 0.77)},
	{"id": "B", "name": "B", "stars": 3, "color": Color(0.33, 0.6, 0.78)},
	{"id": "C", "name": "C", "stars": 3, "color": Color(0.28, 0.79, 0.69)},
	{"id": "D", "name": "D", "stars": 2, "color": Color(0.32, 0.75, 0.5)},
	{"id": "E", "name": "E", "stars": 2, "color": Color(0.65, 0.67, 0.69)},
	{"id": "F", "name": "F", "stars": 1, "color": Color(0.47, 0.49, 0.5)}
]

const UNIQUE_CARDS_POOL := {
	"EX": [
		{"card_id": "ex_pulsar", "name": "Изумрудный Пульсар", "bg_image": ""},
		{"card_id": "ex_dawn", "name": "Сверхновая Заря", "bg_image": ""},
		{"card_id": "ex_quasar", "name": "Эхо Квазара", "bg_image": ""}
	],
	"SSS": [
		{"card_id": "sss_orion", "name": "Орион-9", "bg_image": ""},
		{"card_id": "sss_void", "name": "Спектр Пустоты", "bg_image": ""},
		{"card_id": "sss_horizon", "name": "Горизонт Событий", "bg_image": ""}
	],
	"SS": [
		{"card_id": "ss_andromeda", "name": "Глаз Андромеды", "bg_image": ""},
		{"card_id": "ss_wind", "name": "Sol-Ветер", "bg_image": ""},
		{"card_id": "ss_storm", "name": "Магнитная Буря", "bg_image": ""}
	],
	"S_PLUS": [
		{"card_id": "splus_anomaly", "name": "Аномальный Код", "bg_image": ""},
		{"card_id": "splus_breach", "name": "Системный Взлом", "bg_image": ""}
	],
	"S": [
		{"card_id": "s_chronos", "name": "Хронос", "bg_image": ""},
		{"card_id": "s_nebula", "name": "Туманность Небула", "bg_image": ""},
		{"card_id": "s_centauri", "name": "Альфа Центавра", "bg_image": ""}
	],
	"A": [
		{"card_id": "a_io", "name": "Спутник Ио", "bg_image": ""},
		{"card_id": "a_europa", "name": "Ледяная Европа", "bg_image": ""},
		{"card_id": "a_callisto", "name": "Каллисто", "bg_image": ""},
		{"card_id": "a_ganymede", "name": "Ганимед", "bg_image": ""}
	],
	"B": [
		{"card_id": "b_vega", "name": "Звезда Вега", "bg_image": ""},
		{"card_id": "b_sirius", "name": "Сириус А", "bg_image": ""},
		{"card_id": "b_altair", "name": "Альтаир", "bg_image": ""},
		{"card_id": "b_capella", "name": "Капелла", "bg_image": ""}
	],
	"C": [
		{"card_id": "c_titan", "name": "Спутник Титан", "bg_image": ""},
		{"card_id": "c_enceladus", "name": "Энцелад", "bg_image": ""},
		{"card_id": "c_mimas", "name": "Мимас", "bg_image": ""},
		{"card_id": "c_rhea", "name": "Рея", "bg_image": ""}
	],
	"D": [
		{"card_id": "d_phobos", "name": "Фобос", "bg_image": ""},
		{"card_id": "d_deimos", "name": "Деймос", "bg_image": ""},
		{"card_id": "d_charon", "name": "Харон", "bg_image": ""},
		{"card_id": "d_ceres", "name": "Церера", "bg_image": ""}
	],
	"E": [
		{"card_id": "e_sat", "name": "Космический Мусор", "bg_image": "res://assets/e_new.jpg"}
	],
	"F": [
		{"card_id": "f_engine", "name": "Заброшенная планета", "bg_image": "res://assets/f_new.jpg"}
	]
}

const SHOP_PACKAGES := [
	{"id": "pack1", "amount": 120, "price": 0.99, "bonus": 0, "name": "Факел Нова"},
	{"id": "pack2", "amount": 600, "price": 4.99, "bonus": 60, "name": "Горсть Факелов"},
	{"id": "pack3", "amount": 1960, "price": 14.99, "bonus": 520, "name": "Сумка Факелов"},
	{"id": "pack4", "amount": 3960, "price": 29.99, "bonus": 1200, "name": "Сейф Факелов"},
	{"id": "pack5", "amount": 6560, "price": 49.99, "bonus": 3200, "name": "Запасы Корпорации"},
	{"id": "pack6", "amount": 12960, "price": 99.99, "bonus": 6200, "name": "Ядро Галактики"}
]

const PAYMENT_METHODS := [
	{"id": "pm1", "name": "Нейтринный Камень", "icon": "card"},
	{"id": "pm2", "name": "Карман Чёрной Дыры", "icon": "phone"},
	{"id": "pm3", "name": "Туннельный Поток", "icon": "galaxy"}
]

const PULL_COST := 160
const S_PITY_LIMIT := 50
const EX_PITY_LIMIT := 90

# Game state
var crystals: int = 999999999
var inventory: Array = []
var s_pity_counter: int = 0
var ex_pity_counter: int = 0
var guaranteed_ex_next: bool = false
var sound_enabled: bool = true

signal crystals_changed(amount: int)
signal inventory_changed()
signal pity_changed(ex_remaining: int, s_remaining: int, guaranteed: bool)
signal pull_completed(cards: Array)

const SAVE_PATH := "user://warp_sim_save.json"


func _ready() -> void:
	load_progress()


func get_rank_by_id(rank_id: String) -> Dictionary:
	for rank in RANKS:
		if rank["id"] == rank_id:
			return rank
	return RANKS[-1]


func save_progress() -> void:
	var save_data := {
		"crystals": crystals,
		"inventory": inventory,
		"s_pity_counter": s_pity_counter,
		"ex_pity_counter": ex_pity_counter,
		"guaranteed_ex_next": guaranteed_ex_next
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()


func load_progress() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string := file.get_as_text()
			file.close()
			var json := JSON.new()
			if json.parse(json_string) == OK:
				var data = json.data
				crystals = data.get("crystals", 999999999)
				inventory = data.get("inventory", [])
				s_pity_counter = data.get("s_pity_counter", 0)
				ex_pity_counter = data.get("ex_pity_counter", 0)
				guaranteed_ex_next = data.get("guaranteed_ex_next", false)
	sanitize_inventory()
	emit_all_signals()


func reset_progress() -> void:
	crystals = 999999999
	inventory = []
	s_pity_counter = 0
	ex_pity_counter = 0
	guaranteed_ex_next = false
	save_progress()
	emit_all_signals()


func emit_all_signals() -> void:
	crystals_changed.emit(crystals)
	inventory_changed.emit()
	pity_changed.emit(EX_PITY_LIMIT - ex_pity_counter, S_PITY_LIMIT - s_pity_counter, guaranteed_ex_next)


func sanitize_inventory() -> void:
	var clean_inventory := []
	for item in inventory:
		var card_id = item.get("card_id", "")
		var rank_id = item.get("rank_id", "F")
		var name = item.get("name", "")
		var bg_image = item.get("bg_image", "")

		if card_id == "":
			var pool = UNIQUE_CARDS_POOL.get(rank_id, UNIQUE_CARDS_POOL["F"])
			var matched = pool[0]
			for p in pool:
				if p["name"] == name:
					matched = p
					break
			card_id = matched["card_id"]
			name = matched["name"]
			bg_image = matched["bg_image"]

		var existing_idx := -1
		for i in range(clean_inventory.size()):
			if clean_inventory[i]["card_id"] == card_id:
				existing_idx = i
				break

		if existing_idx >= 0:
			clean_inventory[existing_idx]["level"] += item.get("level", 1)
			if item.get("constellation", 1) > 1:
				clean_inventory[existing_idx]["constellation"] += (item["constellation"] - 1)
			while clean_inventory[existing_idx]["level"] > 25:
				if clean_inventory[existing_idx]["constellation"] < 5:
					clean_inventory[existing_idx]["level"] -= 25
					clean_inventory[existing_idx]["constellation"] += 1
				else:
					clean_inventory[existing_idx]["level"] = 25
					break
		else:
			clean_inventory.append({
				"card_id": card_id,
				"name": name,
				"bg_image": bg_image,
				"rank_id": rank_id,
				"level": item.get("level", 1),
				"constellation": item.get("constellation", 1)
			})
	inventory = clean_inventory


func register_card_to_inventory(card_template: Dictionary) -> Dictionary:
	for existing in inventory:
		if existing["card_id"] == card_template["card_id"]:
			if existing["constellation"] == 5 and existing["level"] == 25:
				crystals += 1600
				crystals_changed.emit(crystals)
				return existing.duplicate()
			else:
				existing["level"] += 1
				if existing["level"] > 25:
					if existing["constellation"] < 5:
						existing["level"] = 1
						existing["constellation"] += 1
					else:
						existing["level"] = 25
				return existing.duplicate()

	var new_card := {
		"card_id": card_template["card_id"],
		"name": card_template["name"],
		"bg_image": card_template["bg_image"],
		"rank_id": card_template["rank_id"],
		"level": 1,
		"constellation": 1
	}
	inventory.append(new_card)
	return new_card.duplicate()


func pull_single_card() -> Dictionary:
	s_pity_counter += 1
	ex_pity_counter += 1
	var selected_rank_id := ""

	if ex_pity_counter >= EX_PITY_LIMIT:
		if guaranteed_ex_next:
			selected_rank_id = "EX"
			guaranteed_ex_next = false
		else:
			if randf() < 0.5:
				selected_rank_id = "EX"
				guaranteed_ex_next = false
			else:
				selected_rank_id = "S_PLUS"
				guaranteed_ex_next = true
		ex_pity_counter = 0
		s_pity_counter = 0
	elif s_pity_counter >= S_PITY_LIMIT:
		selected_rank_id = "S"
		s_pity_counter = 0
	else:
		var rand := randf() * 100.0
		var cum := 0.0
		var chances := {
			"EX": 0.1, "SSS": 0.4, "SS": 1.0, "S": 2.5, "A": 6.0,
			"B": 10.0, "C": 15.0, "D": 20.0, "E": 20.0, "F": 25.0
		}
		for rank in RANKS:
			if rank["id"] == "S_PLUS":
				continue
			cum += chances.get(rank["id"], 0.0)
			if rand <= cum:
				selected_rank_id = rank["id"]
				break

		if selected_rank_id == "":
			selected_rank_id = "F"

		if selected_rank_id == "EX":
			ex_pity_counter = 0
			s_pity_counter = 0
			guaranteed_ex_next = false
		else:
			var rank_idx := RANKS.find(get_rank_by_id(selected_rank_id))
			var s_idx := RANKS.find(get_rank_by_id("S"))
			if rank_idx <= s_idx:
				s_pity_counter = 0

	var target_pool = UNIQUE_CARDS_POOL.get(selected_rank_id, UNIQUE_CARDS_POOL["F"])
	var random_template = target_pool[randi() % target_pool.size()]

	return {
		"card_id": random_template["card_id"],
		"name": random_template["name"],
		"bg_image": random_template["bg_image"],
		"rank_id": selected_rank_id
	}


func do_pull(amount: int) -> Array:
	var total_cost := PULL_COST * amount
	if crystals < total_cost:
		return []

	crystals -= total_cost
	crystals_changed.emit(crystals)

	var pull_snapshots := []
	for i in range(amount):
		var card_template := pull_single_card()
		var updated_state := register_card_to_inventory(card_template)
		pull_snapshots.append(updated_state)

	pull_snapshots.sort_custom(func(a, b):
		var rank_a = RANKS.find(get_rank_by_id(a["rank_id"]))
		var rank_b = RANKS.find(get_rank_by_id(b["rank_id"]))
		return rank_a < rank_b
	)

	pity_changed.emit(EX_PITY_LIMIT - ex_pity_counter, S_PITY_LIMIT - s_pity_counter, guaranteed_ex_next)
	inventory_changed.emit()
	save_progress()
	pull_completed.emit(pull_snapshots)

	return pull_snapshots


func purchase_package(pack_id: String) -> void:
	for pack in SHOP_PACKAGES:
		if pack["id"] == pack_id:
			var total := pack["amount"] + pack["bonus"]
			crystals += total
			crystals_changed.emit(crystals)
			save_progress()
			break


func get_inventory_sorted() -> Array:
	var sorted := inventory.duplicate()
	sorted.sort_custom(func(a, b):
		var rank_a = RANKS.find(get_rank_by_id(a["rank_id"]))
		var rank_b = RANKS.find(get_rank_by_id(b["rank_id"]))
		if rank_a != rank_b:
			return rank_a < rank_b
		return a["name"] < b["name"]
	)
	return sorted
