global.debug = true;
touch = undefined;
components = [
	{ image_index: 0, obtained: true, type: "gem"},
	{ image_index: 1, obtained: false, type: "gem"},
	{ image_index: 2, obtained: true, type: "gem"},
	
];

touch_index = global.service_touch_several.create_area(0, 0, 0, 0, TOUCH.FULL);
components[0].text = file_exists("save_run.json") ? "continue" : "new run";