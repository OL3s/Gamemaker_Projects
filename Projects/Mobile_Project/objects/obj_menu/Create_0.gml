global.service_touch_several.clear();
touch_index = global.service_touch_several.create_area(0, 0, 0, 0, TOUCH.FULL);
touch = undefined;
state = "default"
menu_index = 2;
shop_index = -1;
contract_index = -1;
gui_bottom = [
	{ text: "Market", type: "state", action: 0, sprite_index: 0 },
	{ text: "Loadout", type: "state", action: 1, sprite_index: 1 },
	{ text: "Home", type: "state", action: 2, sprite_index: 2 },
	{ text: "Skills", type: "state", action: 3, sprite_index: 3 },
	{ text: "Contracts", type: "state", action: 4, sprite_index: 4 },
];
gui_top = [
	{ sprite_index: spr_menu_icon_gold, value: 0 },
	{ sprite_index: [spr_placeholder_8, 0], value: 0 }
]
data_shop = [];
data_contract = [];

/// debug, Mock data
if (global.debug) {
	data_shop = [
		global.service_item.get("sword"),
		global.service_item.get("sword"),
		global.service_item.get("sword"),
		global.service_item.get("sword"),
		global.service_item.get("sword"),
		global.service_item.get("sword"),
		global.service_item.get("sword"),
		global.service_item.get("sword"),
		global.service_item.get("sword")
	]
	
	data_contract = [
		{ sidequest: undefined, biome: "woodland", difficulty: 4 },
		{ 
			sidequest: {
				type: "rescue",
				reward: {
					type: "gold",
					value: 100
				}
			}, 
			biome: "tunnel ", 
			difficulty: 2 
		},
		{ sidequest: undefined, biome: "woodland", difficulty: 5 }
	]
}

draw_contract = function(_x, _y, w, h, contract) {
	// Draw box
	draw_set_color(c_white);
	draw_roundrect(_x, _y, _x + w, _y + h, true);

	// Draw biome and difficulty
	draw_set_halign(fa_center);
	draw_text_transformed(_x + w / 2, _y + 4, contract.biome, 0.5, 0.5, 0);
	draw_text_transformed(_x + w / 2, _y + 14, string_repeat("*", contract.difficulty), 0.5, 0.5, 0);

	// Draw sidequest info (if exists)
	if (!is_undefined(contract.sidequest)) {
		draw_text_transformed(_x + w / 2, _y + 24, contract.sidequest.type, 0.5, 0.5, 0);
	}
	draw_set_halign(fa_left);
};

draw_weapon_store = function(_x, _y, item, is_selected, item_w, item_h, sin_offset = 0) {
	draw_set_color(is_selected ? c_white : c_gray);
	draw_sprite_ext(item.sprite_index[0], item.sprite_index[1], _x, is_selected ?_y : _y + (1.5 * sin((current_time / 300) + (sin_offset * 8)) / pi), .5, .5, 0, draw_get_color(), 1);
	
	draw_set_halign(fa_center);
	draw_text_transformed(_x, _y + (item_h / 2), item.name, .5, .5, 0);
	draw_set_halign(fa_left);
	draw_text_transformed(_x + (item_w / 2), _y - (item_h / 2), item.cost, .5, .5, 0);
}
signal = {
	shop_buy: function(shop_index, data_shop) {
		array_delete(data_shop, shop_index, 1)
		return true;
	},
	contract_start: function(contract_index, data_contract) {
		room_goto(rom_dungeon)
	}
}