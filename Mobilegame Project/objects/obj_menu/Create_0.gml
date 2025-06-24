global.service_touch_several.clear();
touch_index = global.service_touch_several.create_area(0, 0, 0, 0, TOUCH.FULL);
touch = undefined;
state = "menu"
buttons = [
	{ text: ["buy", "gear"], type: "state", action: "buy", sprite: [spr_placeholder, 0]},
	{ text: ["change", "loadout"], type: "state", action: "change", sprite: [spr_placeholder, 0]},
	{ text: ["ability", "upgrades"], type: "state", action: "ability", sprite: [spr_placeholder, 0]},
	{ text: ["next", "floor"], type: "room", action: rom_dungeon, sprite: [spr_placeholder, 0]}
];
draw_button_menu = function(_x, _y, _w, _h, button_struct, touch_data) {
	draw_set_font(fnt_def);
	draw_set_halign(fa_center); draw_set_valign(fa_middle);
	var div_center_text = 4
	
	draw_roundrect(_x, _y, _x + _w, _y + _h, true);
	draw_text_transformed(_x + (_w / 2), _y + (_h / div_center_text), button_struct.text[0], .5, .5, 0)
	draw_sprite(button_struct.sprite[0], button_struct.sprite[1], _x + (_w/2), _y + (_h/2))
	draw_text_transformed(_x + (_w / 2), _y + _h - (_h / div_center_text), button_struct.text[1], .5, .5, 0)
	
	draw_set_halign(fa_left); draw_set_valign(fa_top);
}
draw_gui_top_element = function(_x, _y, _w, _h, data) {
	// Draw background
	if struct_exists(data, "border") && data.border
		draw_roundrect(_x, _y, _x + _w, _y + _h, true);

	// Get content
	var text   = struct_exists(data, "text")   ? data.text   : undefined;
	var sprite = struct_exists(data, "sprite") ? data.sprite : undefined;
	var value  = struct_exists(data, "value")  ? data.value  : undefined;

	// Count active elements
	var element_count = 3 
		- is_undefined(text) 
		- is_undefined(sprite) 
		- is_undefined(value);

	if (element_count <= 0) return;

	// Layout
	var section_w = _w / element_count;
	var draw_x = _x;

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	if (!is_undefined(text)) {
		draw_text_transformed(draw_x + section_w * 0.5, _y + _h * 0.5, string(text), .5, .5, 0);
		draw_x += section_w;
	}
	if (!is_undefined(sprite)) {
		draw_sprite_ext(sprite[0], sprite[1], draw_x + section_w * 0.5, _y + _h * 0.5, 1, 1, 0, c_white, 1);
		draw_x += section_w;
	}
	if (!is_undefined(value)) {
		draw_text_transformed(draw_x + section_w * 0.5, _y + _h * 0.5, string(value), .5, .5, 0);
	}
}
draw_gui_back = function(areal) {
	
	//draw
	draw_set_halign(fa_center); draw_set_valign(fa_middle);
	draw_roundrect_ext(areal[0], areal[1], areal[2], areal[3], 4, 4,  true)
	draw_text_transformed(
	    areal[0] + ((areal[2] - areal[0]) / 2),
	    areal[1] + ((areal[3] - areal[1]) / 2),
	    (state == "menu") ? "exit" : "back",
	    0.5, 0.5, 0
	);
	draw_set_halign(fa_left); draw_set_valign(fa_top);
	
	// execute
	if (touch.is_pressed && global.service_touch_several.in_bounds_rect(touch, areal[0], areal[1], areal[2]-areal[0], areal[3]-areal[1])) {
		if state == "menu" game_end() else state = "menu";
	}
}
gui_top = [
	{sprite: [spr_placeholder, 0], value: 0, border: true},
	{text: "game name", border: false},
	{text: "round", sprite: [spr_placeholder, 0], value: 0, border: true}
]