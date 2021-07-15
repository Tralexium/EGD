tool
extends SlideElement

export var image : StreamTexture setget set_image
export var caption : String setget set_caption

var fade_in_dur := 1.0
var caption_grow_dur := 0.6
var move_offset := 96
onready var n_Image: TextureRect = $CenterContainer/Image
onready var n_ImageBottomBar: ColorRect = $CenterContainer/Image/ImageBottomBar
onready var n_CaptionBG: ColorRect = $CenterContainer/Image/CaptionBG
onready var n_Caption: Label = $CenterContainer/Image/CaptionBG/Caption
onready var n_Tween: Tween = $Tween

onready var initial_caption_bg_size := n_CaptionBG.margin_left


func _ready() -> void:
	if not Engine.editor_hint:
		n_Image.self_modulate = Color.transparent
		n_Caption.self_modulate = Color.transparent
		n_ImageBottomBar.color = ColorManager.light_color
		n_ImageBottomBar.rect_pivot_offset = n_ImageBottomBar.rect_size / 2
		n_ImageBottomBar.rect_scale = Vector2(0, 1)
		n_CaptionBG.color = ColorManager.light_color
		n_CaptionBG.rect_scale = Vector2(1, 0)
		
		activate_element()


func set_image(new_value: StreamTexture) -> void:
	n_Image.texture = new_value


func set_caption(new_value: String) -> void:
	n_Caption.text = new_value
	if new_value == "":
		n_CaptionBG.margin_left = initial_caption_bg_size


func activate_element() -> void:
	if is_active or Engine.editor_hint:
		return
		
	is_active = true
	n_Tween.interpolate_property(n_Image, "self_modulate", Color.transparent, ColorManager.light_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Image, "rect_position", n_Image.rect_position + Vector2(0, move_offset), n_Image.rect_position, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	n_Tween.interpolate_property(n_ImageBottomBar, "rect_scale", n_ImageBottomBar.rect_scale, Vector2(1, 1), caption_grow_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_CaptionBG, "rect_scale", n_CaptionBG.rect_scale, Vector2(1, 1), caption_grow_dur, Tween.TRANS_SINE, Tween.EASE_OUT, caption_grow_dur * 0.5)
	n_Tween.interpolate_property(n_Caption, "self_modulate", Color.transparent, ColorManager.darker_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT, caption_grow_dur * 0.5)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	emit_signal("element_finished_intro")


func _on_Caption_minimum_size_changed():
	n_CaptionBG.margin_left = -(n_Caption.rect_size.x + n_Caption.margin_left*2)
