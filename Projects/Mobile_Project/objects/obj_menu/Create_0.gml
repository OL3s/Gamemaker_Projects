global.service_touch_several.clear();
touch_index = global.service_touch_several.create_area(0, 0, 0, 0, TOUCH.FULL);
touch = undefined;
state = "none"
menu_index = 2
gui_bottom = [
	{ text: "store", type: "state", action: "buy", sprite_index: 0 },
	{ text: "change", type: "state", action: "change", sprite_index: 1 },
	{ text: "home", type: "state", action: "home", sprite_index: 2 },
	{ text: "ability", type: "state", action: "ability", sprite_index: 3 },
	{ text: "mission", type: "state", action: "ability", sprite_index: 4 },
];
gui_top = [
	{ sprite_index: spr_menu_icon_gold, value: 0 },
	{ sprite_index: [spr_placeholder, 0], value: 0 }
]