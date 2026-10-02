extends Control

const JournalStore = preload("res://scripts/journal_store.gd")
const WeatherClient = preload("res://scripts/weather_client.gd")
const ZipScene = preload("res://scenes/zip_prompt.tscn")
const TodayScene = preload("res://scenes/today.tscn")

var store = JournalStore.new()
var data: Dictionary = {}
var zip_ui: Control
var today_ui: Control
var weather_client: Node


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var background := ColorRect.new()
	background.color = Color("3b2416")
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var theme_resource: Theme = load("res://theme/vineyard_theme.tres")
	if theme_resource != null:
		theme = theme_resource.duplicate()
	var font := FontFile.new()
	if font.load_dynamic_font("res://theme/EBGaramond-Regular.ttf") == OK:
		theme.default_font = font

	data = store.load_data()
	zip_ui = ZipScene.instantiate()
	today_ui = TodayScene.instantiate()
	add_child(zip_ui)
	add_child(today_ui)
	zip_ui.continue_pressed.connect(_on_zip_submitted)
	today_ui.retry_requested.connect(_load_weather)
	today_ui.save_requested.connect(_on_save)
	_show_state()


func _show_state() -> void:
	var has_zip: bool = store.has_zip(data)
	zip_ui.visible = not has_zip
	today_ui.visible = has_zip
	if not has_zip:
		return
	var key := JournalStore.today_key()
	var entries: Dictionary = data.get("entries", {})
	var entry = entries.get(key, {})
	if typeof(entry) != TYPE_DICTIONARY:
		entry = {}
	today_ui.show_day(key, entry, store.entry_count(data) == 0, str(data.get("place_name", "")))
	_load_weather()


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
		today_ui.show_weather_error()
		return
	today_ui.fill_weather(current.get("temperature_2m"), current.get("relative_humidity_2m"))


func _on_save(fields: Dictionary) -> void:
	var key := JournalStore.today_key()
	if typeof(data.get("entries")) != TYPE_DICTIONARY:
		data["entries"] = {}
	data["entries"][key] = fields
	store.save_data(data)


func _client() -> Node:
	if weather_client != null and is_instance_valid(weather_client):
		return weather_client
	weather_client = WeatherClient.new()
	add_child(weather_client)
	return weather_client
