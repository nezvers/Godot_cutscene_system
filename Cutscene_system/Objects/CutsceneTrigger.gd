extends Area2D
class_name CutsceneTrigger

var triggering_object: Object = null		#will be used to reference player object
var pattern = Cutscene.Pattern.new()		#New instance of cutscene pattern object

func _ready()->void:
	connect("body_entered", self, "_on_Trigger_body_entered")

#Create pattern list
func set_pattern()->void:
	pattern.add_call_method(triggering_object, "set", ["can_move", false])
	pattern.add_wait(0.2)
	pattern.add_call_method(triggering_object, "set", ["position", Vector2(1280/2, 720/2)])
	pattern.add_wait(0.2)
	pattern.add_call_method(triggering_object, "set", ["modulate", Color(randf(), randf(), randf(), 1.0)])
	pattern.add_wait(0.2)
	pattern.add_call_method(triggering_object, "set", ["scale", Vector2(2,3)])
	pattern.add_wait(0.2)
	pattern.add_multi_call_method([				#Array
		pattern.single_method(triggering_object, "set", ["position", Vector2(1280 * 0.75, 720 * 0.25)]),
		pattern.single_method(triggering_object, "set", ["modulate", Color(randf(), randf(), randf(), 1.0)]),
		pattern.single_method(triggering_object, "set", ["scale", Vector2(2,3)])
	])
	pattern.add_wait(0.2)
	pattern.add_interpolate_value(triggering_object, "modulate", Color.white, Color.blue, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	pattern.add_wait(0.2)
	pattern.add_multi_interpolate_value([		#Array
		pattern.single_interpolate_value(triggering_object, "modulate", Color.white, Color.blue, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0),
		pattern.single_interpolate_value(triggering_object, "position", triggering_object.position, Vector2(800,600), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.3)
	])
	pattern.add_wait(0.2)
	pattern.add_move(true, true, triggering_object, Vector2(-200, -100), 1, 0)
	pattern.add_call_method(triggering_object, "set", ["scale", Vector2(1,1)])
	pattern.add_call_method(triggering_object, "set", ["modulate", Color(1, 1, 1, 1)])
	pattern.add_wait(0.2)
	pattern.add_call_method(triggering_object, "set", ["can_move", true])

func _on_Trigger_body_entered(body):
	
	triggering_object = body
	pattern.clear()	#clear previous pattern list
	set_pattern()
	pattern.start()	#starts only if no active cutscene pattern




