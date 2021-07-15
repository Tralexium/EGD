tool
extends HBoxContainer
class_name Bulletpoint

export var bulletpoint_text := ""

onready var n_Label : Label = $Label


func _ready() -> void:
	if not Engine.editor_hint:
		n_Label.self_modulate = Color.transparent


func _process(delta: float) -> void:
	# So that we can see the text in the editor
	if n_Label.text != bulletpoint_text:
		n_Label.text = bulletpoint_text
