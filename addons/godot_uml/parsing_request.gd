tool
extends Control
class_name ParsingRequest

var editor

func _on_parsing_request():
	var plantuml_path = get_node("Control/LineEdit").text
	
	var uml_parser = preload("res://addons/godot_uml/parser.gd").new()
	uml_parser.get_gd_scripts(plantuml_path)
	
	var editor_file_system = editor.get_editor_interface().get_resource_filesystem()
	editor_file_system.scan_sources()


func _on_set_plantuml_path():
	var plantuml_path = get_node("Control/LineEdit").text
	
	var file_save = File.new()
	file_save.open("res://addons/godot_uml/plantuml_path.txt", File.WRITE)
	file_save.store_string(plantuml_path)
	file_save.close()
