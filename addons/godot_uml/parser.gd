tool
extends Object

class_name UMLParser

func get_gd_scripts():
	
	var gd_scripts = dir_content("res://", ".gd")
	var format_string_plant_uml = """
@startuml
	{inheritance_data}
	{class_data}
@enduml
	"""
	
	var class_data = ""
	var inheritance_list = []

	for path in gd_scripts:
		class_data += parse_plant_uml(path, inheritance_list)
		
	var inheritance_list_string = PoolStringArray(inheritance_list).join("\n")
		
	var final_text = format_string_plant_uml.format({
		"inheritance_data": inheritance_list_string,
		"class_data": class_data
	})
	
	var file_save = File.new()
	file_save.open("res://addons/godot_uml/data/plantuml.txt", File.WRITE)
	file_save.store_string(final_text)
	file_save.close()
	
	OS.execute("addons/godot_uml/run_plantuml.bat", [], false, [], true, true)
		
		
func parse_plant_uml(gdscript_class_path : String, inheritance_list : Array):
	### Init parsing
	var file_class : File = File.new()
	var format_string_plant_uml_class = """
	
	class {class_name} {
			{methods}
			{attributes}
	}
	
	"""
	
	var class_name_string : String = ""
	var class_name_inheritance_string : String = ""
	var methods_string : String = ""
	var attributes_string : String = ""
	
	file_class.open(gdscript_class_path, File.READ)
	
	### Parse class script file
	var line : String = file_class.get_line()
	
	while not file_class.eof_reached():
		if line.begins_with("class_name "):
			class_name_string = line.get_slice(" ", 1)
			
		elif line.begins_with("extends "):
			class_name_inheritance_string = line.get_slice(" ", 1)
			
		elif line.begins_with("var "):
			attributes_string += "\n" + line.get_slice(" ", 1) + "\n"
			
			
		line = file_class.get_line()
	
	
	### Parse data to plant UML
	if class_name_string == "":
		class_name_string = gdscript_class_path.get_file().get_slice(".", 0)
		
	if class_name_inheritance_string != "":
		inheritance_list.append(class_name_inheritance_string + " <|-- " + class_name_string)
	
	return format_string_plant_uml_class.format({
		"class_name": class_name_string,
		"methods": methods_string,
		"attributes": attributes_string
	})

func dir_content(path, extension):
	var files_path = []
	var dir = Directory.new()
	dir.open(path)

	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
#		print(file_name)

		while file_name != "":
			if dir.current_is_dir():
#				print(dir.get_current_dir().plus_file(file_name))
				files_path.append_array(dir_content(dir.get_current_dir().plus_file(file_name), extension))
			else:
				if file_name.ends_with(extension):
					files_path.append(dir.get_current_dir().plus_file(file_name))
					
			file_name = dir.get_next()

	return files_path
