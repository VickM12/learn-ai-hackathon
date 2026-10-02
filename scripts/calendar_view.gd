extends Control

var month_label: Label
var grid: GridContainer
var detail: Label
var year: int
var month: int
var today_key: String = ""
var entries: Dictionary = {}
var weather_by_date: Dictionary = {}


func _ready() -> void:
	var box := _page(self)
	var title := Label.new()
	title.text = "Calendar"
	title.add_theme_font_size_override("font_size", 32)
	box.add_child(title)
	var nav := HBoxContainer.new()
	var previous := Button.new()
	previous.text = "Previous"
	previous.pressed.connect(func() -> void: _shift_month(-1))
	var next := Button.new()
	next.text = "Next"
	next.pressed.connect(func() -> void: _shift_month(1))
	month_label = Label.new()
	month_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav.add_child(previous)
	nav.add_child(month_label)
	nav.add_child(next)
	box.add_child(nav)
	grid = GridContainer.new()
	grid.columns = 7
	box.add_child(grid)
	detail = Label.new()
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.text = "Choose a day. This does not create a new entry."
	box.add_child(detail)
	var now := Time.get_date_dict_from_system()
	year = int(now.year)
	month = int(now.month)


func show_context(date_key: String, saved_entries: Dictionary, weather: Dictionary) -> void:
	today_key = date_key
	entries = saved_entries
	weather_by_date = weather
	_render()


func _shift_month(delta: int) -> void:
	month += delta
	if month < 1:
		month = 12
		year -= 1
	elif month > 12:
		month = 1
		year += 1
	_render()


func _render() -> void:
	month_label.text = "%04d-%02d" % [year, month]
	for child in grid.get_children():
		child.queue_free()
	for name in ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]:
		var label := Label.new()
		label.text = name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(label)
	var first := Time.get_unix_time_from_datetime_dict({
		"year": year, "month": month, "day": 1,
		"hour": 12, "minute": 0, "second": 0,
	})
	var weekday := int(Time.get_date_dict_from_unix_time(int(first)).weekday)
	for _blank in weekday:
		grid.add_child(Control.new())
	for day in _days_in_month(year, month):
		var date_key := "%04d-%02d-%02d" % [year, month, day]
		var button := Button.new()
		button.text = str(day)
		if entries.has(date_key):
			button.text = "%s *" % day
		button.pressed.connect(func() -> void: _select(date_key))
		grid.add_child(button)


func _select(date_key: String) -> void:
	var entry = entries.get(date_key, {})
	var weather = weather_by_date.get(date_key, {})
	var weather_line := "Weather for this day is not in the loaded range."
	if typeof(weather) == TYPE_DICTIONARY and not weather.is_empty():
		weather_line = "Weather %s°F, humidity %s%%." % [_num(weather.get("temperature")), _num(weather.get("humidity"))]
	var entry_line := "No journal entry."
	if typeof(entry) == TYPE_DICTIONARY and not entry.is_empty():
		entry_line = "Soil pH %s. Sugar %s. %s" % [_num(entry.get("soil_ph")), _num(entry.get("sugar")), str(entry.get("notes", ""))]
	var note := ""
	if date_key != today_key:
		note = "Viewing this day does not change today's entry."
	detail.text = "%s\n%s\n%s\n%s" % [date_key, weather_line, entry_line, note]


func _days_in_month(which_year: int, which_month: int) -> int:
	if which_month == 2:
		var leap := (which_year % 4 == 0 and which_year % 100 != 0) or which_year % 400 == 0
		return 29 if leap else 28
	if which_month == 4 or which_month == 6 or which_month == 9 or which_month == 11:
		return 30
	return 31


func _num(value) -> String:
	if value == null:
		return "—"
	if typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT:
		return String.num(float(value), 1)
	return str(value)


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
