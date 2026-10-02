extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var today: Control = load("res://scenes/today.tscn").instantiate()
	var theme_resource: Theme = load("res://theme/vineyard_theme.tres")
	if theme_resource != null:
		today.theme = theme_resource.duplicate()
	var font := FontFile.new()
	if font.load_dynamic_font("res://theme/EBGaramond-Regular.ttf") == OK:
		today.theme.default_font = font
	today.position = Vector2.ZERO
	today.size = Vector2(980, 760)
	root.add_child(today)
	await process_frame
	await process_frame
	var save := today.find_child("SaveButton", true, false)
	var scroll := today.find_child("JournalScroll", true, false) as ScrollContainer
	if save == null or scroll == null:
		push_error("Save or scroll missing")
		quit(1)
		return
	var content_height: float = scroll.get_child(0).get_combined_minimum_size().y
	print("CONTENT_H ", content_height)
	print("SCROLL_H ", scroll.size.y)
	if content_height <= scroll.size.y:
		push_error("journal page still fits without scrolling, so Save can be clipped")
		quit(1)
		return
	quit(0)
