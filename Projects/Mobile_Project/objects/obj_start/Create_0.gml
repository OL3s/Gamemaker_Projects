components = [
	{text: "game name", border: false, height: 12, action: undefined},
	{text: "loading...", border: true, height: 32, action: rom_nextFloor},
	{text: "tutorial", border: true, height: 12, action: rom_tutorial}
];
touch_index = global.service_touch_several.create_area(0, 0, 0, 0, TOUCH.FULL);
components[1].text = file_exists("save_run.json") ? "continue" : "new run";