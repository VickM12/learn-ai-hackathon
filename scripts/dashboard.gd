extends Control

signal open_entry
signal open_journal
signal open_weather
signal open_calendar
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
	var title := Label.new()
	title.text = "Vineyard Journal"
	title.add_theme_font_size_override("font_size", 36)
	box.add_child(title)

	place_label = Label.new()
	box.add_child(place_label)
	date_label = Label.new()
	date_label.add_theme_font_size_override("font_size", 28)
	box.add_child(date_label)

	var heading := Label.new()
	heading.text = "Today's weather"
	box.add_child(heading)
	temp_label = Label.new()
	box.add_child(temp_label)
	humidity_label = Label.new()
	box.add_child(humidity_label)

	error_label = Label.new()
	error_label.text = "The weather could not be loaded."
	error_label.visible = false
	box.add_child(error_label)
	retry_button = Button.new()
	retry_button.text = "Retry"
	retry_button.visible = false
	retry_button.pressed.connect(func() -> void: retry_requested.emit())
	box.add_child(retry_button)

	empty_label = Label.new()
	empty_label.text = "write an entry to get started"
	box.add_child(empty_label)

	readings_label = Label.new()
	readings_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(readings_label)

	_action(box, "New entry", open_entry)
	_action(box, "Past journals", open_journal)
	_action(box, "Weather", open_weather)
	_action(box, "Calendar", open_calendar)


func show_snapshot(place_name: String, date_key: String, temperature, humidity, entry: Dictionary, journal_empty: bool) -> void:
	place_label.text = place_name
	date_label.text = date_key
	temp_label.text = "Temperature  %s" % _num(temperature)
	humidity_label.text = "Humidity  %s" % _num(humidity)
	empty_label.visible = journal_empty
	if entry.is_empty():
		readings_label.text = "No journal entry for today yet."
	else:
		readings_label.text = "Today's entry — soil pH %s, sugar %s. %s" % [
			_num(entry.get("soil_ph")),
			_num(entry.get("sugar")),
			str(entry.get("notes", "")),
		]
	error_label.visible = false
	retry_button.visible = false


func show_weather_error() -> void:
	temp_label.text = "Temperature  —"
	humidity_label.text = "Humidity  —"
	error_label.visible = true
	retry_button.visible = true


func _num(value) -> String:
	if value == null:
		return "—"
	if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
		return String.num(float(value), 1)
	return str(value)


func _action(parent: VBoxContainer, text: String, which: Signal) -> void:
	var button := Button.new()
	button.text = text
	button.pressed.connect(func() -> void: which.emit())
	parent.add_child(button)


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
