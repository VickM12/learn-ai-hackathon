extends VBoxContainer

signal range_changed(start_date: String, end_date: String)

var include_next := false
var start_date := ""
var end_date := ""

var preset: OptionButton
var custom_row: HBoxContainer
var from_edit: LineEdit
var to_edit: LineEdit
var error_label: Label


func _ready() -> void:
	add_theme_constant_override("separation", 8)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	add_child(row)

	var label := Label.new()
	label.text = "Date range"
	row.add_child(label)

	preset = OptionButton.new()
	preset.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preset.add_item("Past 7 days")
	preset.add_item("Past 30 days")
	preset.add_item("Past 90 days")
	if include_next:
		preset.add_item("Next 7 days")
	preset.add_item("All loaded" if include_next else "All entries")
	preset.add_item("Custom range")
	preset.selected = 1
	preset.item_selected.connect(_on_preset_selected)
	row.add_child(preset)

	custom_row = HBoxContainer.new()
	custom_row.visible = false
	custom_row.add_theme_constant_override("separation", 8)
	add_child(custom_row)

	from_edit = LineEdit.new()
	from_edit.placeholder_text = "From: YYYY-MM-DD"
	from_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_row.add_child(from_edit)

	to_edit = LineEdit.new()
	to_edit.placeholder_text = "To: YYYY-MM-DD"
	to_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_row.add_child(to_edit)

	var apply := Button.new()
	apply.text = "Apply"
	apply.pressed.connect(_apply_custom)
	custom_row.add_child(apply)

	error_label = Label.new()
	error_label.visible = false
	error_label.add_theme_color_override("font_color", Color("8b3127"))
	add_child(error_label)

	_set_past_days(30)


func _on_preset_selected(index: int) -> void:
	var text := preset.get_item_text(index)
	custom_row.visible = text == "Custom range"
	error_label.visible = false
	match text:
		"Past 7 days":
			_set_past_days(7)
		"Past 30 days":
			_set_past_days(30)
		"Past 90 days":
			_set_past_days(90)
		"Next 7 days":
			_set_range(_date_offset(0), _date_offset(6))
		"All loaded", "All entries":
			_set_range("", "")
		"Custom range":
			from_edit.text = start_date if not start_date.is_empty() else _date_offset(-29)
			to_edit.text = end_date if not end_date.is_empty() else _date_offset(0)
			from_edit.grab_focus()


func _set_past_days(days: int) -> void:
	_set_range(_date_offset(-(days - 1)), _date_offset(0))


func _apply_custom() -> void:
	var from := from_edit.text.strip_edges()
	var to := to_edit.text.strip_edges()
	if not _looks_like_date(from) or not _looks_like_date(to):
		_show_error("Use dates in YYYY-MM-DD format.")
		return
	if from > to:
		_show_error("The start date must be before the end date.")
		return
	error_label.visible = false
	_set_range(from, to)


func _set_range(from: String, to: String) -> void:
	start_date = from
	end_date = to
	range_changed.emit(start_date, end_date)


func _date_offset(days: int) -> String:
	var seconds := int(Time.get_unix_time_from_system()) + days * 86400
	return Time.get_date_string_from_unix_time(seconds)


func _looks_like_date(value: String) -> bool:
	var pattern := RegEx.new()
	pattern.compile("^\\d{4}-\\d{2}-\\d{2}$")
	return pattern.search(value) != null


func _show_error(message: String) -> void:
	error_label.text = message
	error_label.visible = true
