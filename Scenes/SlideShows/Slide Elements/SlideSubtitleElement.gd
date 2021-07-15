tool
extends SlideElement

export var subtitle_text := ""

var fade_in_dur := 0.7
var move_offset := 96
onready var n_Subtitle: Label = $Subtitle
onready var n_Tween: Tween = $Tween


func _ready() -> void:
	if not Engine.editor_hint:
		n_Subtitle.self_modulate = Color.transparent


func _process(delta: float) -> void:
	# So that we can see the text in the editor
	if n_Subtitle.text != subtitle_text:
		n_Subtitle.text = subtitle_text
		self.rect_min_size.y = n_Subtitle.rect_size.y


func activate_element() -> void:
	if is_active or Engine.editor_hint:
		return
		
	is_active = true
	n_Tween.interpolate_property(n_Subtitle, "self_modulate", Color.transparent, ColorManager.light_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Subtitle, "margin_left", n_Subtitle.margin_left + move_offset, n_Subtitle.margin_left, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	emit_signal("element_finished_intro")
