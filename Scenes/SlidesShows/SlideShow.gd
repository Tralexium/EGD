extends Control

signal finished_slideshow_intro

export(Array, PackedScene) var slides : Array

var intro_fade_dur := 0.5
var title_fade_in_dur := 1.0
var has_finished_intro := false
var slide_element_count := 0

onready var n_Tween : Tween = $Tween
onready var n_Title : Label = $VBoxContainer/TitleBarBGColor/Title
onready var n_NextArrow : TextureRect = $VBoxContainer/ContentsBGColor/NextArrow
onready var n_ContentsBGTexture : TextureRect = $VBoxContainer/ContentsBGColor/Texture
onready var n_TitleBarFade : TextureRect = $VBoxContainer/TitleBarBGColor/TitleBarFade
onready var n_TitleBarBGColor : ColorRect = $VBoxContainer/TitleBarBGColor
onready var n_ContentsBGColor : ColorRect = $VBoxContainer/ContentsBGColor
onready var n_IntroFade : ColorRect = $IntroFade

onready var t_NextElementArrow := preload("res://Assets/Slide Show Elements/Next Slide Element Arrow.png")
onready var t_NextSlideArrow := preload("res://Assets/Slide Show Elements/Next Slide Arrow.png")


func _ready() -> void:
	_check_if_slides_are_valid()
	_do_intro()


func _process(delta: float) -> void:
	if !has_finished_intro:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		# Check 
		print("yeeep")


func _check_if_slides_are_valid() -> void:
	var _slide_num := 0
	for _slide in slides:
		assert(_slide is Slide, "Slide element num " + str(_slide_num) + " is invalid!")
		_slide_num += 1


func _do_intro() -> void:
	_update_node_colors()
	n_Title.self_modulate = Color.transparent
	n_NextArrow.self_modulate = Color.transparent
	n_TitleBarFade.self_modulate = Color.transparent
	n_ContentsBGTexture.self_modulate = Color.transparent
	n_IntroFade.visible = true
	
	yield(get_tree().create_timer(0.5), "timeout")
	n_Tween.interpolate_property(n_IntroFade, "rect_scale", Vector2(1, 1), Vector2(1, 0), intro_fade_dur, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	n_Tween.interpolate_property(n_Title, "self_modulate", Color.transparent, ColorManager.light_color, title_fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Title, "margin_left", 192, 64, title_fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_TitleBarFade, "self_modulate", Color.transparent, ColorManager.complimentary_color, title_fade_in_dur, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.interpolate_property(n_ContentsBGTexture, "self_modulate", Color.transparent, ColorManager.primary_color, title_fade_in_dur, Tween.TRANS_SINE, Tween.EASE_IN)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	_finish_intro()


func _finish_intro() -> void:
	has_finished_intro = true
	emit_signal("finished_slideshow_intro")
	_show_next_element()


func _show_next_element() -> void:
	pass


func _update_node_colors() -> void:
	n_Title.self_modulate = ColorManager.light_color
	n_NextArrow.self_modulate = ColorManager.light_color
	n_TitleBarBGColor.color = ColorManager.primary_color
	n_IntroFade.color = ColorManager.primary_color
	n_ContentsBGColor.color = ColorManager.dark_color
