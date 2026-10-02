extends RefCounted

var path: String = "user://journal.json"


static func today_key() -> String:
	var date := Time.get_date_dict_from_system()
	return "%04d-%02d-%02d" % [date.year, date.month, date.day]


func load_data() -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"entries": {}}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"entries": {}}
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"entries": {}}
	if typeof(parsed.get("entries")) != TYPE_DICTIONARY:
		parsed["entries"] = {}
	return parsed


func save_data(data: Dictionary) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not write %s" % path)
		return false
	file.store_string(JSON.stringify(data, "\t"))
	return true


func has_zip(data: Dictionary) -> bool:
	return not str(data.get("zip", "")).strip_edges().is_empty()


func entry_count(data: Dictionary) -> int:
	var entries = data.get("entries", {})
	if typeof(entries) != TYPE_DICTIONARY:
		return 0
	return entries.size()
