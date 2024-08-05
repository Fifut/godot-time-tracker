@tool
extends EditorPlugin

const STORED_SECTIONS_PATH : String = "res://project_time_traker.json"
const AFK_TIMEOUT : float = 300.0

var _dock_instance : Control
var _timer_afk : Timer

var _main_screen : String = "3D"


func _enter_tree():
	_timer_afk = Timer.new()
	_timer_afk.wait_time = AFK_TIMEOUT
	_timer_afk.autostart = true
	_timer_afk.one_shot = true
	_timer_afk.timeout.connect(_on_timer_afk_timeout)
	add_child(_timer_afk)
	
	_dock_instance = preload("res://addons/project-time-tracker/TrackerDock.tscn").instantiate()
	_dock_instance.name = "Project Time Tracker"
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, _dock_instance)
	
	_load_sections()
	
	main_screen_changed.connect(_on_main_screen_changed)
	get_editor_interface().set_main_screen_editor("3D")


func _exit_tree():
	remove_control_from_docks(_dock_instance)
	_dock_instance.queue_free()


func _make_visible(visible):
	if _dock_instance:
		_dock_instance.visible = visible


func _save_external_data():
	_store_sections()


func _get_plugin_icon():
	return preload("res://addons/project-time-tracker/icon.png")


func _load_sections() -> void:
	if (!FileAccess.file_exists(STORED_SECTIONS_PATH)):
		return
	
	var file = FileAccess.open(STORED_SECTIONS_PATH, FileAccess.READ)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Failed to open file '" + STORED_SECTIONS_PATH + "' for reading: Error code " + str(error))
		return
	
	var json = JSON.new()
	var parse_result = json.parse_string(file.get_as_text())
	var parse_error = json.get_error_message()
	if (parse_error != ""):
		printerr("Failed to parse tracked sections: Error code " + parse_error)
	else:
		_dock_instance.restore_tracked_sections(parse_result)
	
	file.close()


func _store_sections() -> void:
	var tracked_sections = _dock_instance.get_tracked_sections()
	var stored_string = JSON.stringify(tracked_sections, "  ")
	
	var file = FileAccess.open(STORED_SECTIONS_PATH, FileAccess.WRITE)
	var error = FileAccess.get_open_error()
	if (error != OK):
		printerr("Failed to open file '" + STORED_SECTIONS_PATH + "' for writing: Error code " + str(error))
		return
	
	file.store_string(stored_string)
	error = file.get_error()
	if (error != OK):
		printerr("Failed to store tracked sections: Error code " + str(error))
	
	file.close()


func _on_main_screen_changed(main_screen: String) -> void:
	if (_dock_instance && is_instance_valid(_dock_instance)):
		_dock_instance.set_main_view(main_screen)
		_main_screen = main_screen


func _on_timer_afk_timeout() -> void:
	if (_dock_instance && is_instance_valid(_dock_instance)):
		_dock_instance.set_main_view("AFK")


func _input(event):
	if (_dock_instance && is_instance_valid(_dock_instance)):
		if event:
			_dock_instance.set_main_view(_main_screen)
			_timer_afk.start()


func _process(delta):
	if (_dock_instance && is_instance_valid(_dock_instance)):
		for id in DisplayServer.get_window_list():
			if DisplayServer.window_is_focused(id):
				return
				
		_dock_instance.set_main_view("External")
		_timer_afk.stop()
