extends Control

signal finished_slideshow_intro

export(Array, PackedScene) var slides : Array

var intro_fade_dur := 0.5
var title_fade_in_dur := 1.0
var arrow_wiggle_dist := 32
var arrow_wiggle_dur := 1.0
var arrow_fade_dur := 1.0
var has_finished_intro := false
var slide_count := 0
var current_slide_num := 0
var n_Current_slide : Slide

onready var n_Tween : Tween = $Tween
onready var n_ArrowTween : Tween = $ArrowTween
onready var n_SlideArrowTween : Tween = $SlideArrowTween
onready var n_Title : Label = $VBoxContainer/TitleBarBGColor/Title
onready var n_SlideMargin : MarginContainer = $VBoxContainer/ContentsBGColor/SlideMargin
onready var n_NextArrow : TextureRect = $VBoxContainer/ContentsBGColor/NextArrow
onready var n_NextSlideArrow : TextureRect = $VBoxContainer/ContentsBGColor/NextSlideArrow
onready var n_ContentsBGTexture : TextureRect = $VBoxContainer/ContentsBGColor/Texture
onready var n_TitleBarFade : TextureRect = $VBoxContainer/TitleBarBGColor/TitleBarFade
onready var n_TitleBarBGColor : ColorRect = $VBoxContainer/TitleBarBGColor
onready var n_ContentsBGColor : ColorRect = $VBoxContainer/ContentsBGColor
onready var n_IntroFade : ColorRect = $IntroFade


func _ready() -> void:
	slide_count = slides.size()
	_do_intro()


func _process(delta: float) -> void:
	if !has_finished_intro:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		_proceed_slide()
		_hide_arrows()


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
	
	n_ArrowTween.interpolate_property(n_NextArrow, "rect_position", n_NextArrow.rect_position, n_NextArrow.rect_position - Vector2(0, arrow_wiggle_dist), arrow_wiggle_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_ArrowTween.interpolate_property(n_NextArrow, "rect_position", n_NextArrow.rect_position - Vector2(0, arrow_wiggle_dist), n_NextArrow.rect_position, arrow_wiggle_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT, arrow_wiggle_dur)
	n_ArrowTween.start()
	
	n_SlideArrowTween.interpolate_property(n_NextSlideArrow, "rect_position", n_NextSlideArrow.rect_position, n_NextSlideArrow.rect_position - Vector2(arrow_wiggle_dist, 0), arrow_wiggle_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	n_SlideArrowTween.interpolate_property(n_NextSlideArrow, "rect_position", n_NextSlideArrow.rect_position - Vector2(arrow_wiggle_dist, 0), n_NextSlideArrow.rect_position, arrow_wiggle_dur, Tween.TRANS_SINE, Tween.EASE_IN_OUT, arrow_wiggle_dur)
	n_SlideArrowTween.start()
	
	_finish_intro()


func _finish_intro() -> void:
	has_finished_intro = true
	emit_signal("finished_slideshow_intro")
	_add_next_slide_to_tree()
	_proceed_slide()


func _add_next_slide_to_tree() -> void:
	if current_slide_num == slide_count:
		# End slideshow
		_end_slideshow()
		return
	else:
		# Next slide
		n_Current_slide = slides[current_slide_num].instance()
		assert(n_Current_slide is Slide, "Slide num " + str(current_slide_num) + " is invalid!")
		n_Current_slide.connect("visible_elements_finished_intro", self, "_on_visible_elements_finished_intro")
		n_Current_slide.connect("tree_exited", self, "_on_slide_tree_exited")
		n_SlideMargin.add_child(n_Current_slide)
		current_slide_num += 1


func _end_slideshow() -> void:
	# TODO
	pass


func _proceed_slide() -> void:
	n_Current_slide.show_next_element()


func _update_node_colors() -> void:
	n_Title.self_modulate = ColorManager.light_color
	n_NextArrow.self_modulate = ColorManager.light_color
	n_TitleBarBGColor.color = ColorManager.primary_color
	n_IntroFade.color = ColorManager.primary_color
	n_ContentsBGColor.color = ColorManager.dark_color


func _hide_arrows() -> void:
	n_Tween.stop_all()
	n_NextArrow.self_modulate = Color.transparent
	n_NextSlideArrow.self_modulate = Color.transparent


func _on_visible_elements_finished_intro() -> void:
	n_Tween.stop_all()
	if n_Current_slide.all_elements_visible():
		n_Tween.interpolate_property(n_NextSlideArrow, "self_modulate", n_NextSlideArrow.self_modulate, ColorManager.light_color, arrow_fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	else:
		n_Tween.interpolate_property(n_NextArrow, "self_modulate", n_NextSlideArrow.self_modulate, ColorManager.light_color, arrow_fade_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()


func _on_slide_tree_exited() -> void:
	_add_next_slide_to_tree()
	_proceed_slide()
