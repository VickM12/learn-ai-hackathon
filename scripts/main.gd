extends Control

const JournalStore = preload("res://scripts/journal_store.gd")
const WeatherClient = preload("res://scripts/weather_client.gd")
const ZipScene = preload("res://scenes/zip_prompt.tscn")
const DashboardScene = preload("res://scenes/dashboard.tscn")
const TodayScene = preload("res://scenes/today.tscn")
const JournalScene = preload("res://scenes/journal.tscn")
const WeatherScene = preload("res://scenes/weather.tscn")
const CalendarScene = preload("res://scenes/calendar.tscn")

var store = JournalStore.new()
var data: Dictionary = {}
var weather_client: Node
var weather_by_date: Dictionary = {}
var current_temp = null
var current_humidity = null
var zip_ui: Control
var pages := {}
var tab_buttons := {}
var content: Control


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var background := ColorRect.new()
	background.color = Color("3b2416")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	_apply_theme()

	data = store.load_data()
	zip_ui = ZipScene.instantiate()
	add_child(zip_ui)
	zip_ui.continue_pressed.connect(_on_zip_submitted)

	var margin := MarginContainer.new()
	margin.name = "JournalFrame"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["margin_left", "margin_top", "margin_right", "margin_bottom"]:
		margin.add_theme_constant_override(side, 28)
	add_child(margin)

	var panel := Panel.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(panel)

	var column := VBoxContainer.new()
	column.set_anchors_preset(Control.PRESET_FULL_RECT)
	column.add_theme_constant_override("separation", 8)
	panel.add_child(column)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	column.add_child(tabs)
	var group := ButtonGroup.new()
	for pair in [["Dashboard", "dashboard"], ["New entry", "entry"], ["Past journals", "journal"], ["Weather", "weather"], ["Calendar", "calendar"]]:
		var button := Button.new()
		button.text = pair[0]
		button.toggle_mode = true
		button.button_group = group
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_show_tab.bind(pair[1]))
		tabs.add_child(button)
		tab_buttons[pair[1]] = button

	content = Control.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(content)

	pages = {
		"dashboard": DashboardScene.instantiate(),
		"entry": TodayScene.instantiate(),
		"journal": JournalScene.instantiate(),
		"weather": WeatherScene.instantiate(),
		"calendar": CalendarScene.instantiate(),
	}
	for page in pages.values():
		page.set_anchors_preset(Control.PRESET_FULL_RECT)
		page.visible = false
		content.add_child(page)

	pages["dashboard"].open_entry.connect(func() -> void: _show_tab("entry"))
	pages["dashboard"].open_journal.connect(func() -> void: _show_tab("journal"))
	pages["dashboard"].open_weather.connect(func() -> void: _show_tab("weather"))
	pages["dashboard"].open_calendar.connect(func() -> void: _show_tab("calendar"))
	pages["dashboard"].retry_requested.connect(_load_weather)
	pages["entry"].retry_requested.connect(_load_weather)
	pages["entry"].save_requested.connect(_on_save)
	_show_state()


func _apply_theme() -> void:
	var theme_resource: Theme = load("res://theme/vineyard_theme.tres")
	if theme_resource != null:
		theme = theme_resource.duplicate()
	var font := FontFile.new()
	if font.load_dynamic_font("res://theme/EBGaramond-Regular.ttf") == OK:
		theme.default_font = font


func _show_state() -> void:
	var has_zip: bool = store.has_zip(data)
	zip_ui.visible = not has_zip
	get_node("JournalFrame").visible = has_zip
	if not has_zip:
		return
	_refresh_entry_form()
	_show_tab("dashboard")
	_load_weather()


func _show_tab(tab_id: String) -> void:
	for key in pages.keys():
		pages[key].visible = key == tab_id
	if tab_buttons.has(tab_id):
		tab_buttons[tab_id].set_pressed_no_signal(true)
	if tab_id == "journal":
		pages["journal"].show_entries(data.get("entries", {}), weather_by_date)
	elif tab_id == "weather":
		_refresh_weather_page()
	elif tab_id == "calendar":
		pages["calendar"].show_context(JournalStore.today_key(), data.get("entries", {}), weather_by_date)
	elif tab_id == "dashboard":
		_refresh_dashboard()


func _refresh_dashboard() -> void:
	var key := JournalStore.today_key()
	var entry = data.get("entries", {}).get(key, {})
	if typeof(entry) != TYPE_DICTIONARY:
		entry = {}
	pages["dashboard"].show_snapshot(
		str(data.get("place_name", "")),
		key,
		current_temp,
		current_humidity,
		entry,
		store.entry_count(data) == 0
	)


func _refresh_entry_form() -> void:
	var key := JournalStore.today_key()
	var entry = data.get("entries", {}).get(key, {})
	if typeof(entry) != TYPE_DICTIONARY:
		entry = {}
	pages["entry"].show_day(key, entry, false, str(data.get("place_name", "")))


func _refresh_weather_page() -> void:
	var client := _client()
	pages["weather"].show_weather(
		JournalStore.today_key(),
		current_temp,
		current_humidity,
		client.daily_rows(client.last_forecast)
	)


func _on_zip_submitted(zip_code: String) -> void:
	var client := _client()
	var place: Dictionary = await client.geocode_zip(zip_code)
	if place.is_empty():
		zip_ui.show_error("That zip code could not be matched to a US place. Check it and try again.")
		return
	data["zip"] = zip_code.strip_edges()
	data["place_name"] = str(place.get("name", ""))
	data["latitude"] = float(place.get("latitude", 0.0))
	data["longitude"] = float(place.get("longitude", 0.0))
	if typeof(data.get("entries")) != TYPE_DICTIONARY:
		data["entries"] = {}
	store.save_data(data)
	_show_state()


func _load_weather() -> void:
	if not store.has_zip(data):
		return
	var client := _client()
	var forecast: Dictionary = await client.fetch_forecast(
		float(data.get("latitude", 0.0)),
		float(data.get("longitude", 0.0))
	)
	var current = forecast.get("current", {})
	if forecast.is_empty() or typeof(current) != TYPE_DICTIONARY:
		current_temp = null
		current_humidity = null
		weather_by_date = {}
		pages["dashboard"].show_weather_error()
		pages["entry"].show_weather_error()
		return
	current_temp = current.get("temperature_2m")
	current_humidity = current.get("relative_humidity_2m")
	weather_by_date = {}
	for row in client.daily_rows(forecast):
		weather_by_date[row["date"]] = row
	pages["entry"].fill_weather(current_temp, current_humidity)
	if pages["dashboard"].visible:
		_refresh_dashboard()
	if pages["weather"].visible:
		_refresh_weather_page()
	if pages["journal"].visible:
		pages["journal"].show_entries(data.get("entries", {}), weather_by_date)
	if pages["calendar"].visible:
		pages["calendar"].show_context(JournalStore.today_key(), data.get("entries", {}), weather_by_date)


func _on_save(fields: Dictionary) -> void:
	var key := JournalStore.today_key()
	if typeof(data.get("entries")) != TYPE_DICTIONARY:
		data["entries"] = {}
	data["entries"][key] = fields
	store.save_data(data)
	_show_tab("dashboard")


func _client() -> Node:
	if weather_client != null and is_instance_valid(weather_client):
		return weather_client
	weather_client = WeatherClient.new()
	add_child(weather_client)
	return weather_client
