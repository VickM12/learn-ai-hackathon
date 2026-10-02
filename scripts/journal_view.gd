extends Control

const TrendChart = preload("res://scripts/trend_chart.gd")
const DateRangePicker = preload("res://scripts/date_range_picker.gd")

var list: VBoxContainer
var detail: Label
var chart: Control
var range_picker: VBoxContainer
var all_entries: Dictionary = {}
var all_weather_by_date: Dictionary = {}


func _ready() -> void:
	var box := _page(self)
	var title := Label.new()
	title.text = "Past journals"
	title.add_theme_font_size_override("font_size", 32)
	box.add_child(title)
	range_picker = DateRangePicker.new()
	box.add_child(range_picker)
	detail = Label.new()
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.text = "Choose an entry to see that day's weather beside it."
	box.add_child(detail)
	var chart_label := Label.new()
	chart_label.text = "Soil pH"
	box.add_child(chart_label)
	chart = TrendChart.new()
	box.add_child(chart)
	list = VBoxContainer.new()
	list.add_theme_constant_override("separation", 8)
	box.add_child(list)
	range_picker.range_changed.connect(_render_range)


func show_entries(entries: Dictionary, weather_by_date: Dictionary) -> void:
	all_entries = entries.duplicate(true)
	all_weather_by_date = weather_by_date.duplicate(true)
	_render_range(range_picker.start_date, range_picker.end_date)


func _render_range(start_date: String, end_date: String) -> void:
	for child in list.get_children():
		child.queue_free()
	var keys: Array = []
	for key in all_entries.keys():
		var date_key := str(key)
		if _in_range(date_key, start_date, end_date):
			keys.append(date_key)
	keys.sort()
	var soil: Array = []
	if keys.is_empty():
		var empty := Label.new()
		empty.text = "No journal entries in this range."
		list.add_child(empty)
	for key in keys:
		var entry_for_chart = all_entries[key]
		if typeof(entry_for_chart) != TYPE_DICTIONARY:
			continue
		if entry_for_chart.get("soil_ph") != null:
			soil.append(float(entry_for_chart["soil_ph"]))
	var display_keys := keys.duplicate()
	display_keys.reverse()
	for key in display_keys:
		var entry_for_list = all_entries[key]
		if typeof(entry_for_list) != TYPE_DICTIONARY:
			continue
		var button := Button.new()
		button.text = "%s  —  soil %s, sugar %s" % [key, _num(entry_for_list.get("soil_ph")), _num(entry_for_list.get("sugar"))]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var date_key := str(key)
		button.pressed.connect(func() -> void: _show_detail(date_key, entry_for_list, all_weather_by_date))
		list.add_child(button)
	chart.set_series(soil, Color("557a46"))
	if keys.is_empty():
		detail.text = "No journal entries in this range."


func _in_range(date_key: String, start_date: String, end_date: String) -> bool:
	if not start_date.is_empty() and date_key < start_date:
		return false
	if not end_date.is_empty() and date_key > end_date:
		return false
	return true


func _show_detail(date_key: String, entry: Dictionary, weather_by_date: Dictionary) -> void:
	var weather = weather_by_date.get(date_key, {})
	var weather_line := "Weather for this day is not in the loaded range."
	if typeof(weather) == TYPE_DICTIONARY and not weather.is_empty():
		weather_line = "Weather %s°F, humidity %s%%." % [_num(weather.get("temperature")), _num(weather.get("humidity"))]
	detail.text = "%s\n%s\nSoil pH %s. Sugar %s.\n%s" % [
		date_key,
		weather_line,
		_num(entry.get("soil_ph")),
		_num(entry.get("sugar")),
		str(entry.get("notes", "")),
	]


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
