tool
extends SlideElement

export(Array, PackedScene) var bulletpoints : Array setget set_bulletpoints

var fade_in_dur := 1.0
var move_offset := 96
var instanced_bulletpoints : Array
onready var n_Bulletpoints: VBoxContainer = $Bulletpoints
onready var n_Tween: Tween = $Tween


func _ready() -> void:
	if not Engine.editor_hint:
		n_Bulletpoints.self_modulate = Color.transparent


func set_bulletpoints(new_value: Array) -> void:
	if not n_Bulletpoints:
		return  # this prevents an error when opening this scene inside the editor

	if n_Bulletpoints.get_child_count() > 0:
		for old_bulletpoint in n_Bulletpoints.get_children():
			old_bulletpoint.queue_free()
	
	bulletpoints = new_value
	if bulletpoints.size() > 0:
		for new_bulletpoint in bulletpoints:
			if new_bulletpoint:
				var _bulletpoint_instance = new_bulletpoint.instance()
				n_Bulletpoints.add_child(_bulletpoint_instance)
				assert(_bulletpoint_instance is BulletPoint, "This is not a BulletPoint Node!")


func activate_element() -> void:
	if is_active or Engine.editor_hint:
		return
		
	is_active = true
	n_Tween.interpolate_property(n_Bulletpoints, "self_modulate", Color.transparent, ColorManager.light_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Bulletpoints, "margin_left", n_Bulletpoints.margin_left + move_offset, n_Bulletpoints.margin_left, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	emit_signal("element_finished_intro")
