extends Control

signal continue_pressed(zip_code: String)

var zip_edit: LineEdit
var error_label: Label
var continue_button: Button


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var panel := Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -280
	panel.offset_top = -170
	panel.offset_right = 280
	panel.offset_bottom = 170
	add_child(panel)

	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)

	var title := Label.new()
	title.text = "Vineyard Journal"
	title.add_theme_font_size_override("font_size", 36)
	box.add_child(title)

	var prompt := Label.new()
	prompt.text = "Enter the zip code for the vineyard."
	prompt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(prompt)

	zip_edit = LineEdit.new()
	zip_edit.placeholder_text = "Zip code"
	zip_edit.max_length = 10
	zip_edit.text_submitted.connect(func(_text: String) -> void: _submit())
	box.add_child(zip_edit)

	continue_button = Button.new()
	continue_button.text = "Continue"
	continue_button.pressed.connect(_submit)
	box.add_child(continue_button)

	error_label = Label.new()
	error_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	error_label.visible = false
	box.add_child(error_label)


func show_error(message: String) -> void:
	error_label.text = message
	error_label.visible = true
	set_busy(false)


func set_busy(busy: bool) -> void:
	continue_button.disabled = busy
	zip_edit.editable = not busy


func _submit() -> void:
	var zip_code := zip_edit.text.strip_edges()
	if zip_code.is_empty():
		show_error("Enter a zip code.")
		return
	error_label.visible = false
	set_busy(true)
	continue_pressed.emit(zip_code)
