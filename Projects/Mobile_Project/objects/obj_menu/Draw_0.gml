draw_set_halign(fa_center);
draw_set_valign(fa_middle);

#region MAIN UI
///
/// BOTTOM UI
var padding = 6, padding_touch = 2,
    gui_count = array_length(gui_bottom),
    width = room_width / (gui_count + 1),
	button_w = 8 + padding_touch, button_h = 8 + padding_touch;

var _y = room_height - 14; // vertical position near bottom

for (var i = 0; i < gui_count; i++) {
    var _x = width * i + width;

    // Set color for rect background (lime if selected, white if not)
    draw_set_color(menu_index != gui_bottom[i].action ? c_gray : c_white);

    // Draw icon scaled to half size (color white)
	var is_back = (menu_index == i && state != "default")
    draw_sprite_ext((is_back) ? spr_icon_back : spr_menu_select_icon, gui_bottom[i].sprite_index, _x, (is_back) ? _y + 2 * sin(current_time / 300) / pi : _y, 0.5, 0.5, 0, draw_get_color(), 1);

    // Draw text below icon, scaled smaller
    draw_text_transformed(_x, _y + 6, gui_bottom[i].text, 0.5, 0.5, 0);
	draw_set_color(c_white);
	
	// Execute
	if global.service_touch_several.in_bounds_rect(touch, _x - (button_w/2), _y - (button_h/2), button_w, button_h) 
		&& touch.is_tap
		//&& gui_bottom[i].action != menu_index
	{
		menu_index = gui_bottom[i].action;
		state = "default"
		shop_index = -1;
		audio_play_sound(snd_click, 1, 0)
	}
}

/// TOP UI
draw_set_halign(fa_left);
	padding = 6;
    gui_count = array_length(gui_top);
    width = room_width / (gui_count + 1);
	_y = 8;

for (var i = 0; i < gui_count; i++) {
    var _x = width * i + width;

    // Check if sprite_index is array (sprite, image_index) or just sprite
    var spr = gui_top[i].sprite_index;
    var img_index = 0;
    if (is_array(spr)) {
        img_index = spr[1];
        spr = spr[0];
    }

    // Draw icon
    draw_sprite_ext(spr, img_index, _x, _y, .5, .5, 0, draw_get_color(), draw_get_alpha());

    // Draw value next to icon (right side, small)
    draw_text_transformed(_x + 4, _y, string(gui_top[i].value), .5, .5, 0);
	
}

draw_set_valign(fa_top);
///
#endregion
#region MENU SHOP
if (menu_index == 0) {
	/// Items - (1/2 of the left screen)
	var padding_screen = [16, 24], padding_gap = 8;
	var item_w_raw = 8, item_w_offset = 6, item_w = item_w_raw + item_w_offset, item_h = 8;
	var grid_cols = 3;

	var start_x = padding_screen[0];
	var start_y = padding_screen[1];

	for (var i = 0; i < array_length(data_shop); ++i) {
		
		// Position
		if is_undefined(data_shop[i]) continue;
		var col = i mod grid_cols;
		var row = i div grid_cols;

		var _x = start_x + col * (item_w + padding_gap);
			_y = start_y + row * (item_h + padding_gap);

		// Draw
		try { draw_weapon_store(_x, _y, data_shop[i], (shop_index == i), item_w_raw, item_h, i) }
		catch (e) { draw_text_transformed(_x, _y, "N/A", .5, .5, 0); }

		// Execute
		if (touch.is_tap && global.service_touch_several.in_bounds_rect(touch,
		    _x - (item_w / 2) - (padding_gap / 2),
		    _y - (item_h / 2) - (padding_gap / 2),
		    item_w + padding_gap,
		    item_h + padding_gap))
		{
		    shop_index = i;
		    state = "selected";
			audio_play_sound(snd_click, 1, 0)
		}
	} draw_set_color(c_white)
	

	/// Showcase - (1/2 of the right screen)
	if state == "selected" && shop_index >= 0 && shop_index < array_length(data_shop) {
		var item = data_shop[shop_index];

		var padding_border = [8, 16]; // [x, y]
			padding_gap = 8;

		var right_x = room_width / 2 + padding_border[0];
		var right_y = padding_border[1];

		// Draw item name
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text_transformed(right_x, right_y, item.name, 0.5, 0.5, 0);
		right_y += padding_gap;

		// Draw sprite
		var sprite_space = 12
		draw_sprite_ext(item.sprite_index[0], item.sprite_index[1], right_x + sprite_space, right_y + sprite_space, 1, 1, 0, c_white, 1);
		right_y += sprite_space*2;

		// Draw cost
		draw_text_transformed(right_x, right_y, "Cost: " + string(item.cost), 0.5, 0.5, 0);
		right_y += padding_gap;

		// Buy button
		var btn_w = 32;
		var btn_h = 8;
		var btn_x = right_x;
		var btn_y = right_y;

		draw_roundrect(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, true);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text_transformed(btn_x + btn_w / 2, btn_y + btn_h / 2, "Buy", 0.5, 0.5, 0);

		// Execute Buy
		if touch.is_tap && global.service_touch_several.in_bounds_rect(touch, btn_x, btn_y, btn_w, btn_h) {
			if (signal.shop_buy(shop_index, data_shop)) {
				state = "default";
				shop_index = -1;
				audio_play_sound(snd_click, 1, 0)
			}
		}
	}


	// Reset alignment
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
}
///
#endregion
#region MENU CONTRACT
///
else if (menu_index == 4) {
	if state = "default" {
		var contract_count = array_length(data_contract);
		if (contract_count == 0) exit;

		// Set pos values
		var contract_w = 32;
		var contract_h = 32;
		var screen_padding = 16;
		var usable_w = room_width - screen_padding * 2;

		var spacing = (contract_count > 1)
			? (usable_w - contract_count * contract_w) / (contract_count - 1)
			: 0;
		spacing = max(spacing, 0);

		var start_x = screen_padding;
		

		// loop contracts
		for (var i = 0; i < contract_count; i++) {
			
			// pos
			var _x = start_x + i * (contract_w + spacing);
				_y = (room_height / 4) + 3*(sin((current_time / 300) + (i * 20))/pi);
			
			// draw
			try			{ draw_contract(_x, _y, contract_w, contract_h, data_contract[i]) }
			catch(e)	{ draw_text_transformed(_x, _y, "N/A", .5, .5, 0) }
			
			// execute
			if touch.is_tap && global.service_touch_several.in_bounds_rect(touch, _x, _y, contract_w, contract_h) {
				contract_index = i;
				state = "selected";
				audio_play_sound(snd_click, 1, 0)
			}
		}
	}
	
	else if state == "selected" {
		// Get selected contract
		if (contract_index < 0 || contract_index >= array_length(data_contract)) exit;
		var contract = data_contract[contract_index];

		// Layout
		var padding_border = 16;
		var padding_gap = 8;

		var left_x = padding_border;
		var left_y = room_height / 4;
		var contract_w = 36;
		var contract_h = 36;

		// Draw selected contract on left
		draw_contract(left_x, left_y, contract_w, contract_h, contract);

		// Right-side layout
		var right_x = room_width / 2 + padding_border;
		var text_y = left_y;

		draw_set_halign(fa_left);
		draw_set_valign(fa_top);

		if (contract.sidequest != undefined) {
			draw_text_transformed(right_x, text_y, "Sidequest: " + string(contract.sidequest.type), 0.5, 0.5, 0);
			text_y += padding_gap;
		}
		draw_text_transformed(right_x, text_y, "Biome: " + contract.biome, 0.5, 0.5, 0);
		text_y += padding_gap;
		draw_text_transformed(right_x, text_y, "Difficulty: " + string(contract.difficulty), 0.5, 0.5, 0);
		text_y += padding_gap;

		// Start button
		var btn_w = 32;
		var btn_h = 12;
		var btn_x = right_x;
		var btn_y = text_y;

		draw_roundrect(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, true);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text_transformed(btn_x + btn_w / 2, btn_y + btn_h / 2, "Start", 0.5, 0.5, 0);

		// Execute
		if touch.is_tap && global.service_touch_several.in_bounds_rect(touch, btn_x, btn_y, btn_w, btn_h) {
			audio_play_sound(snd_click, 1, 0)
			signal.contract_start(contract_index, data_contract)
		}

		// Reset alignment
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
	}

}



#endregion