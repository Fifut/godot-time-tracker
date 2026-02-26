@tool
extends VBoxContainer

signal on_clear_button_pressed(section_name)
signal on_edit_button_pressed(section_name)

# Node references
@onready var icon_texture : TextureRect = $Information/IconContainer/Icon
@onready var name_label : Label = $Information/NameLabel
@onready var elapsed_time_label : Label = $Information/ElapsedLabel
@onready var elapsed_hours_label: Label = $Information/HoursLabel
@onready var edit_button: Button = $Information/EditButton
@onready var clear_button : Button = $Information/ClearButton


# Public properties
@export var section_name : String = "" :
	set(value) :
		section_name = value
		_update_name()
	
@export var section_color : Color = Color.WHITE :
	set(value) :
		section_color = value
		_update_icon()
	
@export var elapsed_time : int = 0 :
	set(value) :
		elapsed_time = value
		_update_elapsed_time()

# Private properties
var _section_icon : Texture


func _ready() -> void:

	edit_button.pressed.connect(_on_edit_button_pressed)
	clear_button.pressed.connect(_on_clear_button_pressed)

	_update_theme()
	_update_icon()
	_update_name()
	_update_elapsed_time()


func clear_button_visibility(status: bool) -> void:
	edit_button.visible = status
	clear_button.visible = status


# Helpers
func _update_theme() -> void:
	if (!Engine.is_editor_hint || !is_inside_tree()):
		return
	
	match section_name:
		"2D": _section_icon = get_theme_icon("2D", "EditorIcons")
		"3D": _section_icon = get_theme_icon("3D", "EditorIcons")
		"Script": _section_icon = get_theme_icon("Script", "EditorIcons")
		"Game": _section_icon = get_theme_icon("Game", "EditorIcons")
		"AssetLib": _section_icon = get_theme_icon("AssetLib", "EditorIcons")
		"External": _section_icon = get_theme_icon("Window", "EditorIcons")
		"AFK": _section_icon = get_theme_icon("ViewportSpeed", "EditorIcons")
		_: _section_icon = get_theme_icon("Node", "EditorIcons")
		
	edit_button.icon = get_theme_icon("EditAddRemove", "EditorIcons")
	clear_button.icon = get_theme_icon("Remove", "EditorIcons")


func _update_icon() -> void:
	if (!is_inside_tree()):
		return
	
	icon_texture.texture = _section_icon
	icon_texture.modulate = section_color


func _update_name() -> void:
	if (!is_inside_tree()):
		return
	
	name_label.text = section_name


func _update_elapsed_time() -> void:
	if (!is_inside_tree()):
		return
	
	var days = floori(elapsed_time) / 60 / 60 / 24
	elapsed_time_label.text = str(days) + "d - " + Time.get_time_string_from_unix_time(elapsed_time)
	
	var hours = floori(elapsed_time) / 60 / 60
	elapsed_hours_label.text = "(" + str(hours) + "h)"


func _on_clear_button_pressed():
	on_clear_button_pressed.emit(section_name)


func _on_edit_button_pressed():
	on_edit_button_pressed.emit(section_name)
