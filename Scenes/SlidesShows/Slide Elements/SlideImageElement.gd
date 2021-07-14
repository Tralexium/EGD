tool
extends SlideElement

export var image : Texture

var fade_in_dur := 1.0
var move_offset := 96
onready var n_Image: TextureRect = $Image
onready var n_Tween: Tween = $Tween


func _ready() -> void:
	if not Engine.editor_hint:
		n_Image.self_modulate = Color.transparent


func _process(delta: float) -> void:
	# So that we can see the image in the editor
	if n_Image.texture != image:
		n_Image.texture = image  
		n_Image.rect_size.y = image.get_height()


func activate_element() -> void:
	if is_active or Engine.editor_hint:
		return
		
	is_active = true
	n_Tween.interpolate_property(n_Image, "self_modulate", Color.transparent, ColorManager.light_color, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.interpolate_property(n_Image, "rect_position", n_Image.rect_position + Vector2(0, move_offset), n_Image.rect_position, fade_in_dur, Tween.TRANS_SINE, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	emit_signal("element_finished_intro")
