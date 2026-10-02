extends VBoxContainer

signal range_changed(start_date: String, end_date: String)

var include_next := false
var start_date := ""
var end_date := ""

var preset: OptionButton
var custom_row: HBoxContainer
var from_button: Button
var to_button: Button
var error_label: Label
var calendar_panel: PanelContainer
var calendar_grid: GridContainer
var calendar_month_label: Label
var calendar_instruction: Label
var calendar_year: int
var calendar_month: int
var selecting := "start"


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

	from_button = Button.new()
	from_button.text = "Start date"
	from_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	from_button.pressed.connect(_open_calendar.bind("start"))
	custom_row.add_child(from_button)

	to_button = Button.new()
	to_button.text = "End date"
	to_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	to_button.pressed.connect(_open_calendar.bind("end"))
	custom_row.add_child(to_button)

	var apply := Button.new()
	apply.text = "Apply range"
	apply.pressed.connect(_apply_custom)
	custom_row.add_child(apply)

	_build_calendar()

	error_label = Label.new()
	error_label.visible = false
	error_label.add_theme_color_override("font_color", Color("8b3127"))
	add_child(error_label)

	_set_past_days(30)


func _on_preset_selected(index: int) -> void:
	var text := preset.get_item_text(index)
	custom_row.visible = text == "Custom range"
	calendar_panel.visible = false
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
			start_date = start_date if not start_date.is_empty() else _date_offset(-29)
			end_date = end_date if not end_date.is_empty() else _date_offset(0)
			_update_date_buttons()
			_open_calendar("start")


func _set_past_days(days: int) -> void:
	_set_range(_date_offset(-(days - 1)), _date_offset(0))


func _apply_custom() -> void:
	if start_date.is_empty() or end_date.is_empty():
		_show_error("Choose both a start date and an end date.")
		return
	if start_date > end_date:
		_show_error("The start date must be before the end date.")
		return
	error_label.visible = false
	calendar_panel.visible = false
	_set_range(start_date, end_date)


func _set_range(from: String, to: String) -> void:
	start_date = from
	end_date = to
	range_changed.emit(start_date, end_date)


func _date_offset(days: int) -> String:
	var seconds := int(Time.get_unix_time_from_system()) + days * 86400
	return Time.get_date_string_from_unix_time(seconds)


func _build_calendar() -> void:
	calendar_panel = PanelContainer.new()
	calendar_panel.visible = false
	var style := StyleBoxFlat.new()
	style.bg_color = Color("fbf3df")
	style.border_color = Color("c3a675")
	style.set_border_width_all(1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 16
	style.content_margin_top = 14
	style.content_margin_right = 16
	style.content_margin_bottom = 16
	calendar_panel.add_theme_stylebox_override("panel", style)
	add_child(calendar_panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	calendar_panel.add_child(box)

	calendar_instruction = Label.new()
	calendar_instruction.text = "Choose the start date"
	calendar_instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(calendar_instruction)

	var navigation := HBoxContainer.new()
	box.add_child(navigation)
	var previous := Button.new()
	previous.text = "‹"
	previous.pressed.connect(_shift_month.bind(-1))
	navigation.add_child(previous)
	calendar_month_label = Label.new()
	calendar_month_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	calendar_month_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	calendar_month_label.add_theme_font_size_override("font_size", 22)
	navigation.add_child(calendar_month_label)
	var next := Button.new()
	next.text = "›"
	next.pressed.connect(_shift_month.bind(1))
	navigation.add_child(next)

	calendar_grid = GridContainer.new()
	calendar_grid.columns = 7
	calendar_grid.add_theme_constant_override("h_separation", 4)
	calendar_grid.add_theme_constant_override("v_separation", 4)
	box.add_child(calendar_grid)


func _open_calendar(target: String) -> void:
	selecting = target
	var selected := start_date if target == "start" else end_date
	if selected.is_empty():
		selected = _date_offset(0)
	calendar_year = selected.substr(0, 4).to_int()
	calendar_month = selected.substr(5, 2).to_int()
	calendar_instruction.text = "Choose the %s date" % target
	calendar_panel.visible = true
	_render_calendar()


func _shift_month(amount: int) -> void:
	calendar_month += amount
	if calendar_month < 1:
		calendar_month = 12
		calendar_year -= 1
	elif calendar_month > 12:
		calendar_month = 1
		calendar_year += 1
	_render_calendar()


func _render_calendar() -> void:
	calendar_month_label.text = "%s %d" % [_month_name(calendar_month), calendar_year]
	for child in calendar_grid.get_children():
		child.queue_free()
	for weekday in ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]:
		var heading := Label.new()
		heading.text = weekday
		heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		heading.custom_minimum_size.x = 42
		calendar_grid.add_child(heading)

	var first_unix := Time.get_unix_time_from_datetime_dict({
		"year": calendar_year,
		"month": calendar_month,
		"day": 1,
		"hour": 12,
		"minute": 0,
		"second": 0,
	})
	var weekday_offset := int(Time.get_date_dict_from_unix_time(int(first_unix)).weekday)
	for _blank in weekday_offset:
		var spacer := Control.new()
		spacer.custom_minimum_size = Vector2(42, 38)
		calendar_grid.add_child(spacer)

	for day in _days_in_month(calendar_year, calendar_month):
		var date_key := "%04d-%02d-%02d" % [calendar_year, calendar_month, day]
		var day_button := Button.new()
		day_button.text = str(day)
		day_button.custom_minimum_size = Vector2(42, 38)
		if date_key == start_date:
			day_button.text = "%d S" % day
		if date_key == end_date:
			day_button.text = "%d E" % day
		day_button.pressed.connect(_pick_date.bind(date_key))
		calendar_grid.add_child(day_button)


func _pick_date(date_key: String) -> void:
	error_label.visible = false
	if selecting == "start":
		start_date = date_key
		if not end_date.is_empty() and end_date < start_date:
			end_date = start_date
		_update_date_buttons()
		_open_calendar("end")
	else:
		if not start_date.is_empty() and date_key < start_date:
			_show_error("The end date must be on or after the start date.")
			return
		end_date = date_key
		_update_date_buttons()
		calendar_panel.visible = false


func _update_date_buttons() -> void:
	from_button.text = "Start: %s" % start_date
	to_button.text = "End: %s" % end_date


func _days_in_month(year: int, month: int) -> int:
	if month == 2:
		var leap := (year % 4 == 0 and year % 100 != 0) or year % 400 == 0
		return 29 if leap else 28
	if month == 4 or month == 6 or month == 9 or month == 11:
		return 30
	return 31


func _month_name(month: int) -> String:
	return [
		"", "January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December",
	][month]


func _show_error(message: String) -> void:
	error_label.text = message
	error_label.visible = true
