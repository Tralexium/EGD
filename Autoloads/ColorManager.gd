extends Node

signal changed_color_pack
signal finished_color_fade

export var fade_dur := 1.0
export(Array, Resource) var color_pack_array

var current_color_pack : ColorPack
var primary_color : Color
var complimentary_color : Color
var light_color : Color
var dark_color : Color
var darker_color : Color

onready var n_Tween : Tween = $Tween


func _ready() -> void:
	current_color_pack = color_pack_array[0]
	primary_color = current_color_pack.primary_color
	complimentary_color = current_color_pack.complimentary_color
	light_color = current_color_pack.light_color
	dark_color = current_color_pack.dark_color
	darker_color = current_color_pack.darker_color


func _start_color_fade() -> void:
	emit_signal("changed_color_pack")
	n_Tween.interpolate_property(self, "primary_color", primary_color, current_color_pack.primary_color, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(self, "complimentary_color", complimentary_color, current_color_pack.complimentary_color, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(self, "light_color", light_color, current_color_pack.light_color, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(self, "dark_color", dark_color, current_color_pack.dark_color, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(self, "darker_color", darker_color, current_color_pack.darker_color, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.start()
	
	yield(n_Tween, "tween_all_completed")
	emit_signal("finished_color_fade")


func change_color_pack(_color_pack: ColorPack) -> void:
	if _color_pack in color_pack_array:
		if current_color_pack != _color_pack:
			current_color_pack = _color_pack
			_start_color_fade()
	else:
		assert(false, "ColorPack '" + _color_pack.resource_name + "' not found!")
