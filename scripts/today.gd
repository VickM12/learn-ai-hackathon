extends Control

signal retry_requested
signal save_requested(fields: Dictionary)

var date_label: Label
var place_label: Label
var empty_label: Label
var error_label: Label
var invalid_label: Label
var saved_label: Label
var retry_button: Button
var temp_edit: LineEdit
var humidity_edit: LineEdit
var soil_edit: LineEdit
var sugar_edit: LineEdit
var notes_edit: TextEdit


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 48)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_right", 48)
	margin.add_theme_constant_override("margin_bottom", 36)
	add_child(margin)

	var panel := Panel.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(panel)

	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)

	var title := Label.new()
	title.text = "Vineyard Journal"
	title.add_theme_font_size_override("font_size", 36)
	box.add_child(title)

	place_label = Label.new()
	box.add_child(place_label)

	date_label = Label.new()
	date_label.add_theme_font_size_override("font_size", 28)
	box.add_child(date_label)

	empty_label = Label.new()
	empty_label.text = "write an entry to get started"
	box.add_child(empty_label)

	error_label = Label.new()
	error_label.text = "The weather could not be loaded."
	error_label.visible = false
	box.add_child(error_label)

	retry_button = Button.new()
	retry_button.text = "Retry"
	retry_button.visible = false
	retry_button.pressed.connect(func() -> void: retry_requested.emit())
	box.add_child(retry_button)

	temp_edit = _add_field(box, "Temperature")
	humidity_edit = _add_field(box, "Humidity")
	soil_edit = _add_field(box, "Soil pH")
	sugar_edit = _add_field(box, "Sugar content")

	var notes_name := Label.new()
	notes_name.text = "Notes and observations"
	box.add_child(notes_name)
	notes_edit = TextEdit.new()
	notes_edit.custom_minimum_size = Vector2(0, 140)
	notes_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(notes_edit)

	invalid_label = Label.new()
	invalid_label.text = "Enter a number or leave the field blank."
	invalid_label.visible = false
	box.add_child(invalid_label)

	var save_button := Button.new()
	save_button.text = "Save"
	save_button.pressed.connect(_save)
	box.add_child(save_button)

	saved_label = Label.new()
	saved_label.text = "Saved."
	saved_label.visible = false
	box.add_child(saved_label)


func _add_field(parent: VBoxContainer, label_text: String) -> LineEdit:
	var name_label := Label.new()
	name_label.text = label_text
	parent.add_child(name_label)
	var edit := LineEdit.new()
	parent.add_child(edit)
	return edit


func show_day(date_key: String, entry: Dictionary, journal_empty: bool, place_name: String) -> void:
	date_label.text = date_key
	place_label.text = place_name
	empty_label.visible = journal_empty
	saved_label.visible = false
	invalid_label.visible = false
	temp_edit.text = _format_value(entry.get("temperature"))
	humidity_edit.text = _format_value(entry.get("humidity"))
	soil_edit.text = _format_value(entry.get("soil_ph"))
	sugar_edit.text = _format_value(entry.get("sugar"))
	notes_edit.text = str(entry.get("notes", ""))


func fill_weather(temperature, humidity) -> void:
	if temp_edit.text.strip_edges().is_empty() and temperature != null:
		temp_edit.text = _format_value(temperature)
	if humidity_edit.text.strip_edges().is_empty() and humidity != null:
		humidity_edit.text = _format_value(humidity)
	error_label.visible = false
	retry_button.visible = false


func show_weather_error() -> void:
	error_label.visible = true
	retry_button.visible = true


func _save() -> void:
	invalid_label.visible = false
	var parsed := {}
	var valid := true
	valid = _read_number(temp_edit, "temperature", parsed) and valid
	valid = _read_number(humidity_edit, "humidity", parsed) and valid
	valid = _read_number(soil_edit, "soil_ph", parsed) and valid
	valid = _read_number(sugar_edit, "sugar", parsed) and valid
	if not valid:
		invalid_label.visible = true
		saved_label.visible = false
		return
	parsed["notes"] = notes_edit.text
	saved_label.visible = true
	empty_label.visible = false
	save_requested.emit(parsed)


func _read_number(edit: LineEdit, key: String, into: Dictionary) -> bool:
	var text := edit.text.strip_edges()
	if text.is_empty():
		into[key] = null
		return true
	if not text.is_valid_float():
		return false
	into[key] = text.to_float()
	return true


func _format_value(value) -> String:
	if value == null:
		return ""
	if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
		return String.num(float(value), 1)
	return str(value)
