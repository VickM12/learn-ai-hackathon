extends Control

signal retry_requested

var place_label: Label
var date_label: Label
var temp_label: Label
var humidity_label: Label
var readings_label: Label
var empty_label: Label
var error_label: Label
var retry_button: Button


func _ready() -> void:
	var box := _page(self)
	box.add_theme_constant_override("separation", 18)

	var masthead := HBoxContainer.new()
	masthead.add_theme_constant_override("separation", 20)
	box.add_child(masthead)

	var title_block := VBoxContainer.new()
	title_block.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_block.add_theme_constant_override("separation", 2)
	masthead.add_child(title_block)

	var title := Label.new()
	title.text = "Vineyard Journal"
	title.add_theme_font_size_override("font_size", 42)
	title_block.add_child(title)

	place_label = Label.new()
	place_label.add_theme_color_override("font_color", Color("765737"))
	title_block.add_child(place_label)
	date_label = Label.new()
	date_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	date_label.add_theme_font_size_override("font_size", 22)
	date_label.add_theme_color_override("font_color", Color("765737"))
	masthead.add_child(date_label)

	var rule := HSeparator.new()
	box.add_child(rule)

	var cards := GridContainer.new()
	cards.columns = 2
	cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cards.add_theme_constant_override("h_separation", 18)
	box.add_child(cards)

	var weather_box := _card(cards, "Today's weather")
	temp_label = Label.new()
	temp_label.add_theme_font_size_override("font_size", 35)
	weather_box.add_child(temp_label)
	humidity_label = Label.new()
	humidity_label.add_theme_color_override("font_color", Color("765737"))
	weather_box.add_child(humidity_label)

	error_label = Label.new()
	error_label.text = "The weather could not be loaded."
	error_label.visible = false
	error_label.add_theme_color_override("font_color", Color("8b3127"))
	weather_box.add_child(error_label)
	retry_button = Button.new()
	retry_button.text = "Retry"
	retry_button.visible = false
	retry_button.pressed.connect(func() -> void: retry_requested.emit())
	weather_box.add_child(retry_button)

	var journal_box := _card(cards, "Today's journal")
	empty_label = Label.new()
	empty_label.text = "No entry yet.\nOpen New entry when you have a reading or observation."
	empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	empty_label.add_theme_color_override("font_color", Color("765737"))
	journal_box.add_child(empty_label)

	readings_label = Label.new()
	readings_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	journal_box.add_child(readings_label)

	var hint := Label.new()
	hint.text = "Use the folder tabs above to add an entry or explore your history."
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.add_theme_color_override("font_color", Color("765737"))
	box.add_child(hint)


func show_snapshot(place_name: String, date_key: String, temperature, humidity, entry: Dictionary, journal_empty: bool) -> void:
	place_label.text = place_name
	date_label.text = date_key
	temp_label.text = "%s°F" % _num(temperature)
	humidity_label.text = "%s%% relative humidity" % _num(humidity)
	empty_label.visible = journal_empty
	if entry.is_empty():
		empty_label.visible = true
		readings_label.visible = false
	else:
		empty_label.visible = false
		readings_label.visible = true
		readings_label.text = "Soil pH  %s\nSugar  %s\n\n%s" % [
			_num(entry.get("soil_ph")),
			_num(entry.get("sugar")),
			str(entry.get("notes", "")),
		]
	error_label.visible = false
	retry_button.visible = false


func show_weather_error() -> void:
	temp_label.text = "—°F"
	humidity_label.text = "Humidity unavailable"
	error_label.visible = true
	retry_button.visible = true


func _num(value) -> String:
	if value == null:
		return "—"
	if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
		return String.num(float(value), 1)
	return str(value)


func _card(parent: GridContainer, heading_text: String) -> VBoxContainer:
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size.y = 235
	var style := StyleBoxFlat.new()
	style.bg_color = Color("fbf3df")
	style.border_color = Color("c3a675")
	style.set_border_width_all(1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 24
	style.content_margin_top = 20
	style.content_margin_right = 24
	style.content_margin_bottom = 20
	card.add_theme_stylebox_override("panel", style)
	parent.add_child(card)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	card.add_child(content)
	var heading := Label.new()
	heading.text = heading_text
	heading.add_theme_font_size_override("font_size", 24)
	content.add_child(heading)
	return content


func _page(host: Control) -> VBoxContainer:
	host.set_anchors_preset(Control.PRESET_FULL_RECT)
	var scroll := ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	host.add_child(scroll)
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 10)
	scroll.add_child(box)
	return box
