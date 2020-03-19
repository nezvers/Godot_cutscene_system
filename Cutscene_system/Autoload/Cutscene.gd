extends Node

class Pattern:
	var pattern:Dictionary = {}
	func _init()->void:
		pass
	func clear()->void:
		pattern.clear()
	func start()->void:
		if !Cutscene.pattern.empty():			#check if cutscene is busy
			return
		Cutscene.start(pattern)
#************** Add to pattern functions ***************
	func add_wait(duration:float)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "wait",
			'cutscene_arguments' : duration
		}
	func add_call_method(object:Object, method:String, parameters:Array)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "call_method",
			'cutscene_arguments' : [object, method, parameters ]
		}
	func add_multi_call_method(method_list:Array)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "multi_call_method",
			'cutscene_arguments' : method_list
		}
	func add_interpolate_value(object: Object, property: NodePath, initial_val, final_val, duration: float, trans_type: int = 0, ease_type: int = 2, delay: float = 0)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "interpolate_value",
			'cutscene_arguments' : [object, property, initial_val, final_val, duration, trans_type, ease_type, delay]
		}
	func add_multi_interpolate_value(interpolate_list:Array)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "multi_interpolate_value",
			'cutscene_arguments' : interpolate_list
		}
	func add_move(relative:bool, global:bool, object:Object, position:Vector2, duration:float, delay:float)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "move",
			'cutscene_arguments' : [relative, global, object, position, duration, delay]
		}
	func add_multi_move(move_list:Array)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "move",
			'cutscene_arguments' : move_list
		}
	#Create an object that needs to be instanced
	func add_create_object(object: Object, parent:Node, global_pos: Vector2)->void:
		pattern[pattern.size()] = {
			'cutscene_method' : "move",
			'cutscene_arguments' : [object, parent, global_pos]
		}
	#Functions for multi versions
	func single_method(object:Object, method:String, parameters:Array)->Array:
		return [object, method, parameters]
	func single_interpolate_value(object: Object, property: NodePath, initial_val, final_val, duration: float, trans_type: int = 0, ease_type: int = 2, delay: float = 0)->Array:
		return[object, property, initial_val, final_val, duration, trans_type, ease_type, delay]
	func single_move(relative:bool, global:bool, object:Object, position:Vector2, duration:float, delay:float)->Array:
		return [relative, global, object, position]

signal cutscene_started
signal cutscene_ended

var pattern:Dictionary = {}
var index: int = -1			#for cycling through pattern order array
onready var timer:Timer = Timer.new()
onready var tween:Tween = Tween.new()
func _ready()->void:
	add_child(timer)
	timer.connect("timeout", self, "on_timeout")
	timer.one_shot = true
	add_child(tween)
	tween.connect("tween_all_completed", self, "on_tween_completed")

func on_timeout()->void:
	trigger_pattern()
func on_tween_completed()->void:
	trigger_pattern()

func start(msg:Dictionary)->void:
	if msg.empty():
		return
	pattern = msg.duplicate()
	trigger_pattern()
	emit_signal("cutscene_started")

func trigger_pattern()->void:
	index +=1
	if !pattern.has(index): #reached the end of pattern order
		clear_pattern()
		return
	var method: Dictionary = pattern[index]
	#for some reasons it doesn't work with callv() here
	call(method.cutscene_method, method.cutscene_arguments)

func clear_pattern()->void:
	index = -1
	pattern.clear()
	emit_signal("cutscene_ended")

#For single parameter change
func call_method(call:Array)->void:
	#instance			method		arguments in array
	call[0].callv(call[1], call[2])
	trigger_pattern()

#For multiple parameter change
func multi_call_method(multi_call:Array)->void:
	for call in multi_call:
		call[0].callv(call[1], call[2])
	trigger_pattern()

#Wait for next pattern entry
func wait(sec:float)->void:
	timer.wait_time = sec
	timer.start()

#Lerp the value
func interpolate_value(param:Array)->void:
	tween.interpolate_property(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7])
	tween.start()

func multi_interpolate_value(multi_param:Array)->void:
	for param in multi_param:
		tween.interpolate_property(param[0], param[1], param[2], param[3], param[4], param[5], param[6], param[7])
	tween.start()
#For moving characters
func move(param:Array)->void:
	var relative:bool = param[0]
	var global:bool = param[1]
	
	var instance = param[2]
	var property:String = "global_position" if global else "position"
	var start_pos = instance.global_position if global else instance.position
	var target_pos:Vector2 = param[3] if !relative else start_pos + param[3]
	var sec:float = param[4]
	tween.interpolate_property(instance, property, start_pos, target_pos, sec, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.start()
func multi_move(move_list:Array)->void:
	for param in move_list:
		var relative:bool = param[0]
		var global:bool = param[1]
		
		var instance = param[2]
		var property:String = "global_position" if global else "position"
		var start_pos = instance.global_position if global else instance.position
		var target_pos:Vector2 = param[3] if !relative else start_pos + param[3]
		var sec:float = param[4]
		tween.interpolate_property(instance, property, start_pos, target_pos, sec, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.start()
#Create object
func create_object(object: Object, parent:Node, global_pos: Vector2, method: NodePath = '', arguments: Array = [])->void:
	var instance = object.instance()
	parent.add_child(instance)
	instance.global_position = global_pos
	if !method.is_empty():
		instance.callv(method, arguments)
	trigger_pattern()





