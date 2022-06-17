tool
extends EditorPlugin


func _enter_tree():
	add_tool_menu_item("Parse to UML", self, "_on_parsing_request")


func _exit_tree():
	pass


func _on_parsing_request(_arg):
	var uml_parser = preload("res://addons/godot_uml/parser.gd").new()
	uml_parser.get_gd_scripts()
