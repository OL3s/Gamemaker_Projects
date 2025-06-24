draw_set_halign(fa_center);
draw_set_valign(fa_middle);

/// DRAW BOTTOM UI
var padding = 6,
    gui_count = array_length(gui_bottom),
    width = room_width / (gui_count + 1);

var _y = room_height - 14; // vertical position near bottom

for (var i = 0; i < gui_count; i++) {
    var _x = width * i + width;

    // Set color for rect background (lime if selected, white if not)
    draw_set_color(menu_index != gui_bottom[i].sprite_index ? c_gray : c_white);

    // Draw icon scaled to half size (color white)
    draw_sprite_ext(spr_menu_select_icon, gui_bottom[i].sprite_index, _x, _y, 0.5, 0.5, 0, draw_get_color(), 1);

    // Draw text below icon, scaled smaller
    draw_text_transformed(_x, _y + 6, gui_bottom[i].text, 0.5, 0.5, 0);
	draw_set_color(c_white);
	
	// Execute
	if global.service_touch_several.in_bounds_circle(touch, _x, _y, 6) && touch.is_pressed {
		menu_index = gui_bottom[i].sprite_index;
	}
}

/// DRAW TOP UI
draw_set_halign(fa_left);
	padding = 6;
    gui_count = array_length(gui_top);
    width = room_width / (gui_count + 1);
	_y = 8; // vertical position near top

for (var i = 0; i < gui_count; i++) {
    var _x = width * i + width;

    // Check if sprite_index is array (sprite, image_index) or just sprite
    var spr = gui_top[i].sprite_index;
    var img_index = 0;
    if (is_array(spr)) {
        img_index = spr[1];
        spr = spr[0];
    }

    // Draw sprite at normal size
    draw_sprite_ext(spr, img_index, _x, _y, .5, .5, 0, draw_get_color(), draw_get_alpha());

    // Draw value next to icon (right side, small)
    draw_text_transformed(_x + 4, _y, string(gui_top[i].value), .5, .5, 0);
	
}

draw_set_valign(fa_top);