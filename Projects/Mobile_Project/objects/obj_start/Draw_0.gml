// Draw logo at top
var logo_h = sprite_get_height(spr_logo_game);
draw_sprite_ext(spr_logo_game, 0, room_width/2, logo_h / 2, 1, 1, 0, c_white, 1);

var comp_count = array_length(components);
var spacing = 4;
var elem_w = 32;
var elem_h = 32;
var total_w = comp_count * (elem_w + spacing) - spacing;
var start_x = (room_width - total_w) / 2;
var _y = room_height - elem_h - 8; // 16px from bottom

for (var i = 0; i < comp_count; i++) {
	var comp = components[i];
	var _x = start_x + i * (elem_w + spacing);
	var cx = _x + elem_w / 2;
	var cy = _y + elem_h / 2;

	if (comp.type == "gem") {
		draw_sprite_ext(spr_gemstones_empty, comp.image_index, cx, cy, 1, 1, 0, make_colour_rgb(30, 30, 30), 0.8);
		if (comp.obtained) {
			var y_offset = (cos(current_time / 300 + (i * 200)) + 1) * 1;
			draw_sprite(spr_gemstones_full, comp.image_index, cx, cy - y_offset);
		}
	}
}

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var delay       = 3000;  // initial delay before first fade-in
var delay_after = 6000;  // delay between repeating cycles (after first run)
var fade_in     = 4000;
var _visible    = 3000;
var fade_out    = 6000;

var first_cycle = delay + fade_in + _visible + fade_out;
var repeat_cycle = delay_after + fade_in + _visible + fade_out;

var t = current_time;
var alpha;

if (t < delay) {
	alpha = 0;
} else if (t < first_cycle) {
	// First full run
	var t1 = t - delay;
	if (t1 < fade_in)
		alpha = t1 / fade_in;
	else if (t1 < fade_in + _visible)
		alpha = 1;
	else
		alpha = 1 - ((t1 - fade_in - _visible) / fade_out);
} else {
	// Repeat loop
	var t2 = (t - first_cycle) mod repeat_cycle;
	if (t2 < delay_after)
		alpha = 0;
	else {
		var t3 = t2 - delay_after;
		if (t3 < fade_in)
			alpha = t3 / fade_in;
		else if (t3 < fade_in + _visible)
			alpha = 1;
		else
			alpha = 1 - ((t3 - fade_in - _visible) / fade_out);
	}
}

draw_set_alpha(clamp(alpha, 0, 1));

var text = "tap to start game.\nhold for tutorial.";
draw_set_color(c_black);
draw_text(room_width / 2, _y + elem_h / 2 + 1, text);
draw_set_color(c_white);
draw_text(room_width / 2, _y + elem_h / 2, text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);