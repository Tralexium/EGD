extends Control
class_name Slide

signal visible_elements_finished_intro

var element_node_list : Array
var element_count := 0
var visible_elements := 0
var elements_that_are_fading_in := 0
var fading_out := false
var fade_out_dur := 1.0

onready var n_Tween : Tween = $Tween


func _ready():
	_scan_for_slide_elements()


func _scan_for_slide_elements() -> void:
	var _elements_counted := 0
	for _element in get_children():
		if _element is SlideElement:
			_elements_counted += 1
			_element.connect("element_finished_intro", self, "_on_element_finished_intro")
			element_node_list.append(_element)
	element_count = _elements_counted
	assert(element_count > 0, "No slide elements present!")


func show_next_element() -> void:
	if visible_elements >= element_count:
		_end_slide()
		return
	
	element_node_list[visible_elements].activate_element()
	visible_elements += 1
	elements_that_are_fading_in += 1


func all_elements_visible() -> bool:
	return visible_elements == element_count and elements_that_are_fading_in == 0


func _end_slide() -> void:
	if fading_out:
		return
	
	fading_out = true
	n_Tween.interpolate_property(self, "modulate", self.modulate, Color.transparent, fade_out_dur, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	n_Tween.start()
	yield(n_Tween, "tween_all_completed")
	
	queue_free()


func _on_element_finished_intro() -> void:
	elements_that_are_fading_in -= 1
	if elements_that_are_fading_in == 0:
		emit_signal("visible_elements_finished_intro")
