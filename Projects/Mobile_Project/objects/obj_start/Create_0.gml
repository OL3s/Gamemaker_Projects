//global.service_resolution.apply()
global.debug = true;
touch = undefined;
data_progress = global.service_filemanager.progress.load()
show_debug_message(data_progress)
components = [
	{ image_index: 0, obtained: data_progress.gems[0] ? true : false, type: "gem" },
	{ image_index: 1, obtained: data_progress.gems[1] ? true : false, type: "gem" },
	{ image_index: 2, obtained: data_progress.gems[2] ? true : false, type: "gem" },
	
];

touch_index = global.service_touch_several.create_area(0, 0, 0, 0, TOUCH.FULL);
components[0].text = file_exists("save_run.json") ? "continue" : "new run";
