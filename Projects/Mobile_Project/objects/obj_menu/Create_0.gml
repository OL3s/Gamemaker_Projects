// clear touch indexes
global.service_touch_several.clear();
//global.service_resolution.apply();

// load data
var sf = global.service_filemanager
data_basic = sf.basic.load();
data_shop = sf.shop.load(9, data_basic.biome, data_basic.wave);
data_contract = sf.contract.load(3, data_basic.biome, data_basic.wave)
data_gear = sf.gear.load()

touch_index = global.service_touch_several.create_area(0, 0, 0, 0, TOUCH.FULL);
touch = undefined;
state = "default"
menu_index = -1;
shop_index = -1;
gear_index = -1;
contract_index = -1;
gui_bottom = [
	{ text: "Market", type: "state", action: 0, sprite_index: 0 },
	{ text: "Loadout", type: "state", action: 1, sprite_index: 1 },
	{ text: "Home", type: "state", action: 2, sprite_index: 2 },
	{ text: "Skills", type: "state", action: 3, sprite_index: 3 },
	{ text: "Contracts", type: "state", action: 4, sprite_index: 4 },
];
gui_top = [
	{ sprite_index: spr_menu_icon_gold, value: data_basic.gold, active_timer: 0 },
	{ sprite_index: [spr_icon_biome, data_basic.biome], value: data_basic.wave + 1 }
];

draw_contract = function(_x, _y, w, h, contract) {
	// Draw box
	draw_set_color(c_white);
	draw_roundrect(_x, _y, _x + w, _y + h, true);

	// Draw biome and difficulty
	draw_set_halign(fa_center);
	draw_sprite_ext(spr_icon_biome, contract.biome, _x + w/2, _y + 8, .5, .5, 0, c_white, 1)
	//draw_text_transformed(_x + w / 2, _y + 4, global.service_enum.biome_tostring(contract.biome), 0.5, 0.5, 0);
	draw_text_transformed(_x + w / 2, _y + 14, string_repeat("*", contract.difficulty), 0.5, 0.5, 0);

	// Draw sidequest info (if exists)
	if (!is_undefined(contract.sidequest)) {
		draw_text_transformed(_x + w / 2, _y + 24, global.service_enum.sidequest_tostring(contract.sidequest.type), 0.5, 0.5, 0);
	}
	draw_set_halign(fa_left);
};

draw_weapon_store = function(_x, _y, item, is_selected, item_w, item_h, sin_offset = 0, use_shortname = true, draw_price = true) {
	draw_set_color(is_selected ? c_white : c_gray);
	draw_sprite_ext(item.sprite_index[0], item.sprite_index[1], _x, is_selected ?_y : _y + (1.5 * sin((current_time / 300) + (sin_offset * 8)) / pi), .5, .5, 0, draw_get_color(), 1);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text_transformed(_x, _y + (item_h / 2), use_shortname ? item.name_short : item.name, .5, .5, 0);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);
	if draw_price
		draw_text_transformed(_x + (item_w / 2), _y - (item_h / 2), item.cost, .5, .5, 0);
}
signal = {
	shop_buy: function(item_index, self_id) {
		var sf = global.service_filemanager;

		if (sf.shop.buy_index(item_index)) {
			self_id.data_shop = sf.load(sf.name.shop);   // refresh
			self_id.data_basic = sf.load(sf.name.basic); // refresh
			self_id.data_gear = sf.load(sf.name.gear);
			self_id.gui_top[0].value = self_id.data_basic.gold;
			self_id.gui_top[0].active_timer = 10;		// buy effect
			return true;
		}	return false;
	},
	contract_start: function(contract_index, data_contract) {
		room_goto(rom_dungeon)
	},
	equip_gear: function(gear_index, is_lower = true){
		var sf = global.service_filemanager;
		sf.gear.equip_index(gear_index, is_lower)
	}
}