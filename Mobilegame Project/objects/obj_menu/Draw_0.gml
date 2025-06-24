if (state == "menu") {
	var button_count = array_length(buttons)
	for (var i = 0; i < button_count; i++) {
		var b = buttons[i];
		var padding = 4
		var _w = (room_width / button_count) - (padding * 2);
		var _h = 40
		var _x = (room_width / button_count) * i + padding;
		var _y = (room_height/2) - (_h/2)

		draw_button_menu(_x, _y, _w, _h, b, touch);
		if (touch.is_pressed && global.service_touch_several.in_bounds_rect(touch, _x, _y, _w, _h)) {
			if (b.type == "state") state = b.action;
			else if (b.type == "room") room_goto(b.action);
		}
	}
}

// back button
draw_gui_back([4, room_height - 14, 32, room_height - 4])

// topbar elements (gold, name, wave)
var top_count = array_length(gui_top);
for (var i = 0; i < top_count; i++) {
	var padding = 4;
	var _w = (room_width / top_count) - (padding * 2);
	var _h = 12;
	var _x = (room_width / top_count) * i + padding;
	var _y = 2;

	draw_gui_top_element(_x, _y, _w, _h, gui_top[i]);
}