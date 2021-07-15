extends SlideElement


func activate_element() -> void:
	if is_active:
		return
	
	is_active = true
	for child in get_children():
		if child is SlideElement:
			child.activate_element()
			self.rect_min_size.y += child.rect_min_size.y
