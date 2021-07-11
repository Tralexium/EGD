tool
extends Area2D

export var color_pack : Resource


func _ready() -> void:
	assert(color_pack, "ColorPack is missing!")


func _get_configuration_warning() -> String:
	var _warning := ""
	if !color_pack:
		_warning = "ColorPack is missing!"
	return _warning


func _on_Area2D_body_entered(body: Node) -> void:
	if color_pack:
		ColorManager.change_color_pack(color_pack)
