var total_height = 0;
var padding = 12; // space between components

// Calculate total height
for (var i = 0; i < array_length(components); i++) {
    total_height += components[i].height + padding;
}
total_height -= padding; // remove last padding

var start_y = (room_height - total_height) / 2;

for (var i = 0; i < array_length(components); i++) {
    var comp = components[i];
    var _y = start_y;

    // Center horizontally
	var width = room_width/2
    var x1 = (room_width - width) / 2; // example width 400
    var x2 = x1 + width;
    var y1 = _y;
    var y2 = _y + comp.height;

    // Draw border if needed
    if (comp.border) {
        draw_roundrect(x1, y1, x2, y2, true);
    }

    // Draw text centered inside
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text((x1 + x2) / 2, (y1 + y2) / 2, comp.text);

	// Execute action
	var touch = global.service_touch_several.get(touch_index)
	if global.service_touch_several.in_bounds_rect(touch,x1, y1, width, comp.height) 
	&& touch.is_pressed 
	&& !is_undefined(components[i].action) {
		room_goto(components[i].action)
	}
	
	draw_set_halign(fa_left);
    draw_set_valign(fa_top);
	

    start_y += comp.height + padding;
}
