tool
extends Sprite

signal player_entered_warp
signal player_exited_warp

export(PackedScene) var slideshow_scene : PackedScene
export(String, MULTILINE) var slideshow_name := "Slideshow Name" setget set_slideshow_name

var is_ready := false
var opening_slideshow := false
var fade_dur := 0.7
var slideshow_instance : Control
onready var n_Name: Label = $Name
onready var n_Tween: Tween = $Tween


func _ready() -> void:
	is_ready = true
	
	if not Engine.editor_hint:
		self_modulate = ColorManager.primary_color
		n_Name.self_modulate = Color.transparent


func set_slideshow_name(new_value: String) -> void:
	slideshow_name = new_value
	if not is_ready:
		yield(self, "ready")
	
	n_Name.text = slideshow_name


func _on_TitleVisibilityArea_body_entered(body: Node) -> void:
	if n_Tween.is_active():
		n_Tween.stop_all()
	n_Tween.interpolate_property(n_Name, "self_modulate", n_Name.self_modulate, ColorManager.light_color, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(self, "scale", scale, Vector2(0.6, 0.6), fade_dur, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	n_Tween.start()


func _on_TitleVisibilityArea_body_exited(body: Node) -> void:
	if n_Tween.is_active():
		n_Tween.stop_all()
	n_Tween.interpolate_property(n_Name, "self_modulate", n_Name.self_modulate, Color.transparent, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(self, "scale", scale, Vector2(0.5, 0.5), fade_dur, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	n_Tween.start()


func _on_WarpArea_body_entered(body: Node) -> void:
	if opening_slideshow:
		return
	opening_slideshow = true
	emit_signal("player_entered_warp")
	
	if n_Tween.is_active():
		n_Tween.stop_all()
	
	# Freeze the player and save the ground location
	
	n_Tween.interpolate_property(n_Name, "self_modulate", n_Name.self_modulate, Color.transparent, fade_dur / 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(self, "scale", scale, Vector2(10, 10), fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	slideshow_instance = slideshow_scene.instance()
	slideshow_instance.connect("slideshow_ended", self, "_on_Slideshow_ended")
	get_tree().find_node("SlideshowLayer").add_child()


func _on_Slideshow_ended() -> void:
	emit_signal("player_exited_warp")
	n_Tween.interpolate_property(n_Name, "self_modulate", n_Name.self_modulate, ColorManager.light_color, fade_dur / 2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, fade_dur / 2)
	n_Tween.interpolate_property(self, "scale", scale, Vector2(0.5, 0.5), fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	opening_slideshow = false
