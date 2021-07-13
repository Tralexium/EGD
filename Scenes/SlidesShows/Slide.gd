extends VBoxContainer
class_name Slide

var element_node_list : Array
var element_count := 0


func _ready():
	_check_if_elements_are_valid()
	element_node_list = get_children()
	element_count = get_child_count()


func _check_if_elements_are_valid() -> void:
	for _element in get_children():
		assert(_element is SlideElement, "Element named '" + _element.name + "' is invalid!")
