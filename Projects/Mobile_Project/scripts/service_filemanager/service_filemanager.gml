global.service_filemanager = {
	name: {
		basic: "save_basic.json",				// gold, current_biome, etc.
		shop: "save_shop.json",					// state of shop
		gear: "save_gear.json",					// state of gear
		character: "save_char.json",			// index of gear usage
		dungeon: "save_dungeon.json",			// currently generated mission
		missions: "save_contract.json",			// state of contracts
		progress: "save_prog.json",				// longterm progression stats
	},
	load: function(file_name) {
		if !file_exists(file_name) return undefined;
		var file = file_text_open_read(file_name);
		var data = json_parse(file_text_read_string(file));
		file_text_close(file);
		return data;
	},
	save: function(file_name, struct) {
		var file = file_text_open_write(file_name)
		file_text_write_string(file, json_stringify(struct))
		file_text_close(file);
	},
	delete_run: function(file_name) {
		var names = struct_get_names(self.name)
		for (var i = 0; i < array_length(names); i++) {
			if names[i] == "progress" continue;
			
		}
	},
	delete_dungeon: function() {
		var name = self.name.dungeon;
		if file_exists(name) file_delete(name);
	},
	generate: function() {
		
	},
	is_gameexist: function() {
		return file_exists(self.name.basic)
	}
}