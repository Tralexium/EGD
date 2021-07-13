extends Control
class_name SlideElement

signal element_finished_intro

var is_active := false


func activate_element() -> void:
	if is_active:
		return
	is_active = true
	# do animation shenanigans here...
