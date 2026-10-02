extends Control

const TrendChart = preload("res://scripts/trend_chart.gd")

var today_label: Label
var forecast_list: VBoxContainer
var history_list: VBoxContainer
var temp_chart: Control
var humidity_chart: Control


func _ready() -> void:
	var box := _page(self)
	var title := Label.new()
	title.text = "Weather"
	title.add_theme_font_size_override("font_size", 32)
	box.add_child(title)
	today_label = Label.new()
	today_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(today_label)
	box.add_child(_heading("This week"))
	forecast_list = VBoxContainer.new()
	box.add_child(forecast_list)
	box.add_child(_heading("Recent days"))
	history_list = VBoxContainer.new()
	box.add_child(history_list)
	box.add_child(_heading("Temperature"))
	temp_chart = TrendChart.new()
	box.add_child(temp_chart)
	box.add_child(_heading("Humidity"))
	humidity_chart = TrendChart.new()
	box.add_child(humidity_chart)
	var credit := Label.new()
	credit.text = "Weather data by Open-Meteo.com, CC BY 4.0."
	credit.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(credit)


func show_weather(today_key: String, current_temp, current_humidity, rows: Array) -> void:
	today_label.text = "%s — %s°F, humidity %s%%." % [today_key, _num(current_temp), _num(current_humidity)]
	_clear(forecast_list)
	_clear(history_list)
	var temps: Array = []
	var humidities: Array = []
	for row in rows:
		if typeof(row) != TYPE_DICTIONARY:
			continue
		var day := str(row.get("date", ""))
		var line := "%s   %s°F   %s%%" % [day, _num(row.get("temperature")), _num(row.get("humidity"))]
		var label := Label.new()
		label.text = line
		if day >= today_key:
			forecast_list.add_child(label)
		else:
			history_list.add_child(label)
		if row.get("temperature") != null:
			temps.append(float(row["temperature"]))
		if row.get("humidity") != null:
			humidities.append(float(row["humidity"]))
	if forecast_list.get_child_count() == 0:
		var empty := Label.new()
		empty.text = "No forecast loaded."
		forecast_list.add_child(empty)
	if history_list.get_child_count() == 0:
		var empty_history := Label.new()
		empty_history.text = "No recent days loaded."
		history_list.add_child(empty_history)
	temp_chart.set_series(temps, Color("b35c32"))
	humidity_chart.set_series(humidities, Color("3f7182"))


func _heading(text: String) -> Label:
	var label := Label.new()
	label.text = text
	return label


func _clear(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()


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
	box.add_theme_constant_override("separation", 8)
	scroll.add_child(box)
	return box
