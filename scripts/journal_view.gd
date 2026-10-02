extends Control

const TrendChart = preload("res://scripts/trend_chart.gd")

var list: VBoxContainer
var detail: Label
var chart: Control


func _ready() -> void:
	var box := _page(self)
	var title := Label.new()
	title.text = "Past journals"
	title.add_theme_font_size_override("font_size", 32)
	box.add_child(title)
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


func show_entries(entries: Dictionary, weather_by_date: Dictionary) -> void:
	for child in list.get_children():
		child.queue_free()
	var keys: Array = entries.keys()
	keys.sort()
	keys.reverse()
	var soil: Array = []
	if keys.is_empty():
		var empty := Label.new()
		empty.text = "No journal entries yet."
		list.add_child(empty)
	for key in keys:
		var entry = entries[key]
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		if entry.get("soil_ph") != null:
			soil.append(float(entry["soil_ph"]))
		var button := Button.new()
		button.text = "%s  —  soil %s, sugar %s" % [key, _num(entry.get("soil_ph")), _num(entry.get("sugar"))]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var date_key := str(key)
		button.pressed.connect(func() -> void: _show_detail(date_key, entry, weather_by_date))
		list.add_child(button)
	chart.set_series(soil)
	if keys.is_empty():
		detail.text = "No journal entries yet."


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
