tool
extends SlideElement

export(String, MULTILINE) var paragraph_text := "" setget set_paragraph_text

var fade_in_dur := 0.7
var move_offset := 96
var is_ready := false
onready var n_Paragraph: Label = $Paragraph
onready var n_Tween: Tween = $Tween


func _ready() -> void:
	is_ready = true
	
	if not Engine.editor_hint:
		n_Paragraph.self_modulate = Color.transparent


func set_paragraph_text(new_value: String) -> void:
	paragraph_text = new_value
	if not is_ready:
		yield(self, "ready")
	
	n_Paragraph.text = paragraph_text
	yield(get_tree().create_timer(0.05), "timeout")  # Stupid bug where the size doesn't update on the same frame
	self.rect_min_size.y = n_Paragraph.rect_size.y


func activate_element() -> void:
	if is_active or Engine.editor_hint:
		return
		
	is_active = true
	n_Tween.interpolate_property(n_Paragraph, "self_modulate", Color.transparent, ColorManager.light_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Paragraph, "margin_left", n_Paragraph.margin_left + move_offset, n_Paragraph.margin_left, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Paragraph, "margin_right", n_Paragraph.margin_right + move_offset, n_Paragraph.margin_right, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	emit_signal("element_finished_intro")
