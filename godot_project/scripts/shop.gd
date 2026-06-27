extends Control

@onready var content_container: VBoxContainer = $PanelContainer/VBoxContainer/ContentContainer
@onready var close_btn: Button = $PanelContainer/VBoxContainer/HeaderContainer/CloseBtn

var current_view: String = "packages"


func _ready() -> void:
	close_btn.pressed.connect(_on_close_pressed)
	_render_packages()


func _on_close_pressed() -> void:
	queue_free()


func _render_packages() -> void:
	current_view = "packages"

	for child in content_container.get_children():
		child.queue_free()

	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 16)
	grid.add_theme_constant_override("v_separation", 16)

	for pack in GameManager.SHOP_PACKAGES:
		var pack_btn := _create_package_button(pack)
		grid.add_child(pack_btn)

	content_container.add_child(grid)


func _create_package_button(pack: Dictionary) -> Button:
	var btn := Button.new()
	btn.text = pack["name"] + "\n" + str(pack["amount"]) + " o\n$" + str(pack["price"])
	if pack["bonus"] > 0:
		btn.text += "\n+" + str(pack["bonus"]) + " bonus"
	btn.pressed.connect(_on_package_selected.bind(pack["id"]))
	return btn


func _on_package_selected(pack_id: String) -> void:
	current_view = "payment"
	_render_payment_screen(pack_id)


func _render_payment_screen(pack_id: String) -> void:
	for child in content_container.get_children():
		child.queue_free()

	var pack: Dictionary
	for p in GameManager.SHOP_PACKAGES:
		if p["id"] == pack_id:
			pack = p
			break

	if pack.is_empty():
		return

	var vbox := VBoxContainer.new()

	# Back button
	var back_btn := Button.new()
	back_btn.text = "< Back"
	back_btn.pressed.connect(_render_packages)
	vbox.add_child(back_btn)

	# Package info
	var info_container := VBoxContainer.new()

	var title_label := Label.new()
	title_label.text = "Payment Amount"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_container.add_child(title_label)

	var price_label := Label.new()
	price_label.text = "$" + str(pack["price"])
	price_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_container.add_child(price_label)

	var total_label := Label.new()
	total_label.text = "Total: " + str(pack["amount"] + pack["bonus"]) + " o"
	total_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_container.add_child(total_label)

	vbox.add_child(info_container)

	# Payment methods
	var methods_label := Label.new()
	methods_label.text = "Select payment method:"
	vbox.add_child(methods_label)

	for method in GameManager.PAYMENT_METHODS:
		var method_btn := Button.new()
		method_btn.text = method["name"]
		method_btn.pressed.connect(_process_payment.bind(pack_id))
		vbox.add_child(method_btn)

	content_container.add_child(vbox)


func _process_payment(pack_id: String) -> void:
	GameManager.purchase_package(pack_id)
	queue_free()

	# Show notification
	var notification := _create_notification(pack_id)
	get_parent().add_child(notification)

	var tween := create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(notification.queue_free)


func _create_notification(pack_id: String) -> Control:
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER_TOP)
	panel.offset_top = 50
	panel.offset_left = -150
	panel.offset_right = 150
	panel.offset_bottom = 100

	var vbox := VBoxContainer.new()

	var title := Label.new()
	title.text = "Payment Successful"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var amount := Label.new()
	for pack in GameManager.SHOP_PACKAGES:
		if pack["id"] == pack_id:
			amount.text = "+" + str(pack["amount"] + pack["bonus"]) + " torches"
			break
	amount.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(amount)

	panel.add_child(vbox)
	return panel
