extends Node2D

var fade_dur := 0.5
var slideshow_instance : Control
var initial_pos_GMTK := Vector2.ZERO
var initial_pos_GDC := Vector2.ZERO
var initial_pos_Godot := Vector2.ZERO
var initial_pos_Neko := Vector2.ZERO
var icon_offset := Vector2(0, 256)
onready var n_Name: Label = $Name
onready var n_GMTK: Sprite = $GMTK
onready var n_GDC: Sprite = $GDC
onready var n_Godot: Sprite = $Godot
onready var n_Neko: Sprite = $Neko
onready var n_Tween: Tween = $Tween


func _ready() -> void:
	n_Name.self_modulate = Color.transparent
	n_GMTK.self_modulate = Color.transparent
	n_GDC.self_modulate = Color.transparent
	n_Godot.self_modulate = Color.transparent
	n_Neko.self_modulate = Color.transparent
	initial_pos_GMTK = n_GMTK.position
	initial_pos_GDC = n_GDC.position
	initial_pos_Godot = n_Godot.position
	initial_pos_Neko = n_Neko.position


func _on_TitleVisibilityArea_body_entered(body: Node) -> void:
	if n_Tween.is_active():
		yield(n_Tween, "tween_all_completed")
	
	n_Tween.interpolate_property(n_Name, "self_modulate", n_Name.self_modulate, ColorManager.light_color, fade_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	n_Tween.interpolate_property(n_GMTK, "self_modulate", n_GMTK.self_modulate, Color.white, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur)
	n_Tween.interpolate_property(n_GMTK, "position", initial_pos_GMTK + icon_offset, initial_pos_GMTK, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur)
	
	n_Tween.interpolate_property(n_GDC, "self_modulate", n_GDC.self_modulate, Color.white, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur*1.2)
	n_Tween.interpolate_property(n_GDC, "position", initial_pos_GDC + icon_offset, initial_pos_GDC, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur*1.2)
	
	n_Tween.interpolate_property(n_Godot, "self_modulate", n_Godot.self_modulate, Color.white, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur*1.4)
	n_Tween.interpolate_property(n_Godot, "position", initial_pos_Godot + icon_offset, initial_pos_Godot, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur*1.4)
	
	n_Tween.interpolate_property(n_Neko, "self_modulate", n_Neko.self_modulate, Color.white, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur*1.6)
	n_Tween.interpolate_property(n_Neko, "position", initial_pos_Neko + icon_offset, initial_pos_Neko, fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT, fade_dur*1.6)
	
	n_Tween.start()


func _on_TitleVisibilityArea_body_exited(body: Node) -> void:
	if n_Tween.is_active():
		yield(n_Tween, "tween_all_completed")

	n_Tween.interpolate_property(n_Name, "self_modulate", n_Name.self_modulate, Color.transparent, fade_dur*2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(n_GMTK, "self_modulate", n_GMTK.self_modulate, Color.transparent, fade_dur*2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(n_GDC, "self_modulate", n_GDC.self_modulate, Color.transparent, fade_dur*2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(n_Godot, "self_modulate", n_Godot.self_modulate, Color.transparent, fade_dur*2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.interpolate_property(n_Neko, "self_modulate", n_Neko.self_modulate, Color.transparent, fade_dur*2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_Tween.start()	
