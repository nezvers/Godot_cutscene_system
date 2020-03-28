extends Area2D
class_name CutsceneTrigger


#will be used to reference player object
var triggering_object: Object = null
#New instance of cutscene pattern object
var pattern = PatternBuilder.new()

func _ready()->void:
	connect("body_entered", self, "_on_Trigger_body_entered")

#Used for testing queue_start
func log(txt:String)->void:
	print(txt)

#Press ENTER to give queued pattern
func _unhandled_input(event)->void:
	if event.is_action_pressed("ui_accept"):
		var tempPattern = PatternBuilder.new()
		tempPattern.add_call_method(self, "log", ["Queue started"])\
			.add_wait(0.2)\
			.add_call_method(self, "set", ["modulate", Color(randf(), randf(), randf(), 1.0)])\
			.add_wait(0.2)\
			.add_call_method(self, "set", ["modulate", Color(1, 1, 1, 1.0)])\
			.add_wait(0.2)\
			.add_call_method(self, "log", ["Queue ended"])\
			.done()
		tempPattern.queue_start()
		tempPattern.queue_free()


#Create pattern list
func set_pattern()->void:
	pattern.add_call_method(triggering_object, "set", ["can_move", false])\
		.add_wait(0.2)\
		.add_call_method(triggering_object, "set", ["position", Vector2(1280/2, 720/2)])\
		.add_wait(0.2)\
		.add_call_method(triggering_object, "set", ["modulate", Color(randf(), randf(), randf(), 1.0)])\
		.add_wait(0.2)\
		.add_call_method(triggering_object, "set", ["scale", Vector2(2,3)])\
		.add_wait(0.2)\
		.add_multi_call_method([#Array
			pattern.single_method(triggering_object, "set", ["position", Vector2(1280 * 0.75, 720 * 0.25)]),
			pattern.single_method(triggering_object, "set", ["modulate", Color(randf(), randf(), randf(), 1.0)]),
			pattern.single_method(triggering_object, "set", ["scale", Vector2(2,3)])
		])\
		.add_wait(0.2)\
		.add_interpolate_value(triggering_object, "modulate", Color.white, Color.blue, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)\
		.add_wait(0.2)\
		.add_multi_interpolate_value([#Array
			pattern.single_interpolate_value(triggering_object, "modulate", Color.white, Color.blue, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0),
			pattern.single_interpolate_value(triggering_object, "position", triggering_object.position, Vector2(800,600), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
		])\
		.add_wait(0.2)\
		.add_move(true, true, triggering_object, Vector2(-200, -100), 1, 0)\
		.add_call_method(triggering_object, "set", ["scale", Vector2(1,1)])\
		.add_call_method(triggering_object, "set", ["modulate", Color(1, 1, 1, 1)])\
		.add_wait(0.2)\
		.add_call_method(triggering_object, "set", ["can_move", true])\
		.done()


func _on_Trigger_body_entered(body):
	
	triggering_object = body
	pattern.clear()	#clear previous pattern list
	set_pattern()
	pattern.start()	#starts only if no active cutscene pattern




