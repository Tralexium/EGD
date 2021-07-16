tool
extends HBoxContainer
class_name Bulletpoint

export var bulletpoint_text := "" setget set_bulletpoint_text

var is_ready := false
onready var n_Label : Label = $Label


func _ready() -> void:
	is_ready = true


func set_bulletpoint_text(new_value: String) -> void:
	bulletpoint_text = new_value
	if not is_ready:
		yield(self, "ready")
	
	n_Label.text = bulletpoint_text
