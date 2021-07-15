tool
extends SlideElement

export(Array, Curve) var bulletpoint_texts setget set_bulletpoint_texts

var fade_in_dur := 0.7
var move_offset := 96
var instanced_bulletpoints : Array
var is_ready := false
var bulletpoint_scene := preload("res://Scenes/SlideShows/Slide Elements/Slide Element Nested Scenes/SlideBulletpoint.tscn")
onready var n_Bulletpoints: VBoxContainer = $Bulletpoints
onready var n_Tween: Tween = $Tween


func _ready() -> void:
	is_ready = true
	
	if not Engine.editor_hint:
		n_Bulletpoints.modulate = Color.transparent


func set_bulletpoint_texts(new_value: Array) -> void:
	bulletpoint_texts = new_value
	if not is_ready:
		yield(self, "ready")

	if n_Bulletpoints.get_child_count() > 0:
		for old_bulletpoint in n_Bulletpoints.get_children():
			old_bulletpoint.queue_free()
	
	var _bulletpoint_y_size := 0
	if bulletpoint_texts.size() > 0:
		for bulletpoint_text in bulletpoint_texts:
			if bulletpoint_text is BulletpointText:
				var _bulletpoint_instance : Bulletpoint = bulletpoint_scene.instance()
				_bulletpoint_instance.bulletpoint_text = bulletpoint_text.bulletpoint_text
				n_Bulletpoints.add_child(_bulletpoint_instance)
				_bulletpoint_y_size = _bulletpoint_instance.rect_size.y
			else:
				assert(!bulletpoint_text, "This resource is not a BulletpointText!")
	self.rect_min_size.y = (n_Bulletpoints.get_constant("separation") + _bulletpoint_y_size) * bulletpoint_texts.size()


func activate_element() -> void:
	if is_active or Engine.editor_hint:
		return
		
	is_active = true
	n_Tween.interpolate_property(n_Bulletpoints, "modulate", Color.transparent, ColorManager.light_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Bulletpoints, "margin_left", n_Bulletpoints.margin_left + move_offset, n_Bulletpoints.margin_left, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	emit_signal("element_finished_intro")
