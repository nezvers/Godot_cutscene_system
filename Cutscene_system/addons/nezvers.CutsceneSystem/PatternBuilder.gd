extends Node
class_name PatternBuilder


var pattern := {}


func clear() -> void:
	pattern.clear()


func start()->void:
	#check if cutscene is busy
	if not cutscene.pattern.empty():
		return
	
	cutscene.start(pattern)


#************** Add to pattern functions ***************

func add_wait(duration:float) -> PatternBuilder:
	pattern[pattern.size()] = {
		'cutscene_method' : "wait",
		'cutscene_arguments' : duration
	}
	
	return self


func add_call_method(object:Object, method:String, parameters:Array) -> PatternBuilder:
	pattern[pattern.size()] = {
		'cutscene_method' : "call_method",
		'cutscene_arguments' : [object, method, parameters ]
	}
	
	return self


func add_multi_call_method(method_list:Array) -> PatternBuilder:
	
	pattern[pattern.size()] = {
		'cutscene_method' : "multi_call_method",
		'cutscene_arguments' : method_list
	}
	
	return self


func add_interpolate_value(
	object: Object, property: NodePath, initial_val,
	 final_val, duration: float, trans_type: int = 0,
	 ease_type: int = 2, delay: float = 0) -> PatternBuilder:
	
	pattern[pattern.size()] = {
		'cutscene_method' : "interpolate_value",
		'cutscene_arguments' : [object, property, initial_val, final_val, duration, trans_type, ease_type, delay]
	}
	
	return self


func add_multi_interpolate_value(interpolate_list:Array) -> PatternBuilder:
	
	pattern[pattern.size()] = {
		'cutscene_method' : "multi_interpolate_value",
		'cutscene_arguments' : interpolate_list
	}
	
	return self


func add_move(relative:bool, global:bool,
		 object:Object, position:Vector2,
		 duration:float, delay:float) -> PatternBuilder:
	
	pattern[pattern.size()] = {
		'cutscene_method' : "move",
		'cutscene_arguments' : [relative, global, object, position, duration, delay]
	}
	
	return self


func add_multi_move(move_list:Array) -> PatternBuilder:
	
	pattern[pattern.size()] = {
		'cutscene_method' : "move",
		'cutscene_arguments' : move_list
	}
	
	return self


#Create an object that needs to be instanced
func add_create_object(object: Object, parent:Node, global_pos: Vector2) -> PatternBuilder:
	
	pattern[pattern.size()] = {
		'cutscene_method' : "move",
		'cutscene_arguments' : [object, parent, global_pos]
	}
	
	return self


#Functions for multi versions
func single_method(object:Object, method:String, parameters:Array)->Array:
	return [object, method, parameters]


func single_interpolate_value(object: Object, property: NodePath, initial_val, final_val, duration: float, trans_type: int = 0, ease_type: int = 2, delay: float = 0)->Array:
	return[object, property, initial_val, final_val, duration, trans_type, ease_type, delay]


func single_move(relative:bool, global:bool, object:Object, position:Vector2, duration:float, delay:float)->Array:
	return [relative, global, object, position]


# for finishing chain function 
func done() -> void:
	pass
