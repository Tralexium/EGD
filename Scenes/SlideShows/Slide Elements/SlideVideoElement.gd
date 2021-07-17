tool
extends SlideElement

export var video : VideoStreamTheora setget set_video
export var video_scale := 0.4 setget set_video_scale
export var caption : String setget set_caption

var fade_in_dur := 0.7
var caption_grow_dur := 0.5
var move_offset := 96
var initial_caption_bg_left_margin := -100
var is_ready := false
onready var n_CenterContainer: CenterContainer = $CenterContainer
onready var n_Video: VideoPlayer = $CenterContainer/Video
onready var n_VideoBottomBar: ColorRect = $CenterContainer/Video/VideoBottomBar
onready var n_CaptionBG: ColorRect = $CenterContainer/Video/CaptionBG
onready var n_Caption: Label = $CenterContainer/Video/CaptionBG/Caption
onready var n_Tween: Tween = $Tween



func _ready() -> void:
	is_ready = true
	
	if not Engine.editor_hint:
		n_Video.self_modulate = Color.transparent
		n_Caption.self_modulate = Color.transparent
		n_VideoBottomBar.color = ColorManager.light_color
		n_VideoBottomBar.rect_pivot_offset = n_VideoBottomBar.rect_size / 2
		n_VideoBottomBar.rect_scale = Vector2(0, 1)
		n_CaptionBG.color = ColorManager.light_color
		n_CaptionBG.rect_scale = Vector2(1, 0)


func set_video(new_value: VideoStreamTheora) -> void:
	video = new_value
	if not is_ready:
		yield(self, "ready")
	n_Video.stream = video
	n_Video.play()


func set_video_scale(new_value: float) -> void:
	video_scale = new_value
	if not is_ready:
		yield(self, "ready")
	n_Video.rect_min_size = Vector2(1920, 1080) * video_scale
	n_CenterContainer.rect_size.y = n_Video.rect_min_size.y
	n_VideoBottomBar.rect_pivot_offset = n_VideoBottomBar.rect_size / 2
	self.rect_min_size.y = n_CenterContainer.rect_size.y


func set_caption(new_value: String) -> void:
	caption = new_value
	if not is_ready:
		yield(self, "ready")
	n_Caption.text = caption
	if new_value == "":
		n_CaptionBG.margin_left = 0


func activate_element() -> void:
	if is_active or Engine.editor_hint:
		return
		
	is_active = true
	n_Tween.interpolate_property(n_Video, "self_modulate", Color.transparent, Color.white, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Video, "rect_position", n_Video.rect_position + Vector2(0, move_offset), n_Video.rect_position, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	n_Tween.interpolate_property(n_VideoBottomBar, "rect_scale", n_VideoBottomBar.rect_scale, Vector2(1, 1), caption_grow_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_CaptionBG, "rect_scale", n_CaptionBG.rect_scale, Vector2(1, 1), caption_grow_dur, Tween.TRANS_SINE, Tween.EASE_OUT, caption_grow_dur * 0.5)
	n_Tween.interpolate_property(n_Caption, "self_modulate", Color.transparent, ColorManager.darker_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT, caption_grow_dur * 0.5)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	emit_signal("element_finished_intro")


func _on_Caption_minimum_size_changed():
	n_CaptionBG.margin_left = -(n_Caption.rect_size.x + n_Caption.margin_left*2)


func _on_Video_finished() -> void:
	n_Video.play()
