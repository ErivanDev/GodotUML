tool
extends EditorPlugin
class_name GodotUML

const MainPanel = preload("res://addons/godot_uml/Screen.tscn")

var main_panel_instance

func _enter_tree():
	main_panel_instance = MainPanel.instance()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	make_visible(false)
	
	var screen_plugin = main_panel_instance
	screen_plugin.editor = self
	
	# Put PlantuUML Path in user interface
	var file_save = File.new()
	file_save.open("res://addons/godot_uml/plantuml_path.txt", File.READ)
	var file_content = file_save.get_as_text()
	file_save.close()
	
	var lineEdit = main_panel_instance.get_node("Control/LineEdit")
	lineEdit.text = file_content


func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()


func has_main_screen():
	return true


func make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func get_plugin_name():
	return "GodotUML"


func get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
