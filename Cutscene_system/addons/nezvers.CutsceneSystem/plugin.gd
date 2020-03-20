tool
extends EditorPlugin


const autoload_name = 'cutscene'
const autoload_path = "res://addons/nezvers.CutsceneSystem/Cutscene.gd"


func _enter_tree():
	add_autoload_singleton(autoload_name, autoload_path)


func _exit_tree():
	remove_autoload_singleton(autoload_name)


func has_main_screen():
	return false


func get_plugin_name():
	return "Cutscene System"

