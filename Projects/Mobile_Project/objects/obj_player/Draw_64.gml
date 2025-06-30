if object_exists(obj_gameplay) {
	var input = [obj_gameplay.input.left, obj_gameplay.input.rightDown, obj_gameplay.input.rightUp];
	for (var i = 0; i < array_length(input); i++) {
		var _input = input[i];
		if (_input.is_down) draw_circle(_input.start_x, _input.start_y, 4, true)
	}
}