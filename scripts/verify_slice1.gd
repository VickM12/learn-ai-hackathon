extends SceneTree

const JournalStore = preload("res://scripts/journal_store.gd")
const WeatherClient = preload("res://scripts/weather_client.gd")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var client := WeatherClient.new()
	root.add_child(client)
	var place: Dictionary = await client.geocode_zip("44024")
	if place.is_empty():
		push_error("geocode failed")
		quit(1)
		return
	if str(place.get("country_code", "")) != "US":
		push_error("geocode was not US")
		quit(1)
		return
	var matched := false
	for code in place.get("postcodes", []):
		if str(code) == "44024":
			matched = true
	if not matched:
		push_error("postcode 44024 missing")
		quit(1)
		return

	var store = JournalStore.new()
	store.path = "user://slice1_verify.json"
	var key := JournalStore.today_key()
	var entry := {
		"temperature": 70.0,
		"humidity": 40.0,
		"soil_ph": 6.4,
		"sugar": null,
		"notes": "slice1 verify",
	}
	var data := {"entries": {}}
	data["entries"][key] = entry
	if not store.save_data(data):
		push_error("save failed")
		quit(1)
		return
	var loaded: Dictionary = store.load_data()
	var saved = loaded.get("entries", {}).get(key, {})
	if typeof(saved) != TYPE_DICTIONARY or str(saved.get("notes", "")) != "slice1 verify":
		push_error("reload failed")
		quit(1)
		return
	print("PLACE %s" % str(place.get("name", "")))
	print("SAVED %s" % JSON.stringify(saved))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(store.path))
	quit(0)
