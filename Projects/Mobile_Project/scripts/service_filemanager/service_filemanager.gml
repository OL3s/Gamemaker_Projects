global.service_filemanager = {
	name: {
		basic: "save_basic.json",				// gold, current_biome, etc.
		shop: "save_shop.json",					// state of shop
		gear: "save_gear.json",					// state andf index of gear
		xp: "save_experience.json",				// index of gear
		contract: "save_contract.json",			// state of contracts
		// ----------------- //
		progress: "save_prog.json",				// longterm progression stats
		dungeon: "save_dungeon.json",			// currently generated dungeon data
	},
	/// @return {struct}
	load: function(file_name) {
		if !file_exists(file_name) { show_debug_message($"info: file missing; {file_name}."); return; }

		var file = file_text_open_read(file_name);
		try { var data = json_parse(file_text_read_string(file)); }
		catch (e) { show_debug_message($"error: failed to parse {file_name}.") return; }
		file_text_close(file);
		show_debug_message($"info: file loaded; {file_name}.");
		return data;
	},
	save: function(file_name, struct) {
		var file = file_text_open_write(file_name);
		file_text_write_string(file, json_stringify(struct));
		file_text_close(file);
		show_debug_message($"info: file saved {file_name}.");
	},
	del: function(file_name) {
		if file_exists(file_name) { file_delete(file_name); show_debug_message($"info: file deleted; {file_name}.") return true };
		show_debug_message($"info: tried to delete missing file; {file_name}.");
		return false
	},
	delete_run: function() {
		var sf = global.service_filemanager;
		var names = struct_get_names(sf.name);
		for (var i = 0; i < array_length(names); i++) {
			var key = names[i];
			if (key == "progress") continue;

			var file_name = struct_get(self.name, key);
			var is_del = sf.del(file_name);
		}
	},
	basic: {
		load: function() {
			var sf = global.service_filemanager;
			var _load = sf.load(sf.name.basic);
			
			// load failiour
			if is_undefined(_load) {
				show_debug_message($"info: basic file missing, generating; adding to runs progress")
				var basic_struct = { name: sf.name.basic, gold: 1000, biome: BIOME.WOODLAND, wave: 0 };
				sf.save(sf.name.basic, basic_struct);
				
				// add to progress
				var progress = sf.progress.load();
				progress.runs ++;
				sf.save(progress.name, progress)
				
				return basic_struct;
			}
			
			// load sucessfull
			show_debug_message($"info: basic file loaded successfully.")
			return _load;	
		},
		add_gold: function(add_value) {
			// load
			var manager = global.service_filemanager;
			var file_name = manager.name.basic
			var load = manager.load(file_name)
			
			// missing file handler
			if is_undefined(load) { show_debug_message("warning: missing file for adding gold"); return; }
			
			// add val and save
			load.gold += add_value;
			manager.save(file_name, load);
			if global.debug { show_debug_message($"info: added {add_value} gold to {file_name}") }
		},
		
		/// @param {real} remove_value
		/// @param {bool} force_remove
		/// @return {bool}
		remove_gold: function(remove_value, force_remove = false) {
			// load
			var manager = global.service_filemanager;
			var file_name = manager.name.basic
			var load = manager.load(file_name)
			
			// missing file handler
			if is_undefined(load) { show_debug_message("warning: missing file for removing gold"); return false; }
			
			// cannot remove check
			if (remove_value > load.gold && !force_remove) {
				if global.debug show_debug_message("info: cannot remove gold, not enough")
				return false;
			}
			
			// remove
			load.gold -= remove_value;
			manager.save(file_name, load);
			if global.debug { show_debug_message($"info: removed {remove_value} gold to {file_name}") }
			return true;
		},
		add_wave: function() {
			var manager = global.service_filemanager;
			var file_name = manager.name.basic;
			var load = manager.load(file_name);

			if is_undefined(load) { show_debug_message("warning: missing file for adding wave"); return;}

			load.wave += 1;
			manager.save(file_name, load);
			if global.debug { show_debug_message($"info: advanced wave to {load.wave} in {file_name}"); }
		},
		set_biome: function(set_BIOME) {
			var manager = global.service_filemanager;
			var file_name = manager.name.basic;
			var load = manager.load(file_name);

			if is_undefined(load) { show_debug_message("warning: missing file for setting biome"); return; }

			load.biome = set_BIOME;
			manager.save(file_name, load);
			if global.debug { show_debug_message($"info: set biome to {set_BIOME} in {file_name}"); }
		}
	},
	shop: {
		load: function(shop_max, biome, wave) {
			var sf = global.service_filemanager;
			
			// load success
			if (file_exists(sf.name.shop)) {
				show_debug_message("info: shop file loaded successfully.");
				return sf.load(sf.name.shop);
			}
			
			// generate shop
			show_debug_message("info: no shop file found, generating new shop file.");
			var shop_struct = { name: sf.name.shop, items: sf.shop.generate_shop_array(shop_max, biome, wave) }
			sf.save(sf.name.shop, shop_struct);
			return shop_struct;
		},
		generate_shop_array: function(shop_max, biome, wave) {
			var array = [];
			repeat(shop_max) { 
				var _item = choose(
					global.service_item.get("light_sword"),
					global.service_item.get("leather_armor")	
				)
				
				if irandom(1) array_push(array, _item) 
			} 
			return array;
		},
		remove: function(item_index) {
			var sf = global.service_filemanager;
			var _load = sf.load(sf.name.shop);

			// Bounds check
			if (item_index < 0 || item_index >= array_length(_load.items)) {
				show_debug_message("warning: invalid shop item index for removal.");
				return;
			}

			array_delete(_load.items, item_index, 1);
			sf.save(_load.name, _load);
			show_debug_message($"info: removed item at index {item_index} from shop.");
		},
		buy_struct: function(item_struct) {
			var sf = global.service_filemanager;
			var gold = sf.load(sf.name.basic).gold
			var gold_brought = sf.basic.remove_gold(item_struct.cost)
			
			if (!gold_brought) { 
				show_debug_message($"warning: failed to buy item {item_struct.id}."); 
				return false; 
			} else { 
				sf.gear.add_gear(item_struct); 
				show_debug_message($"info: item brought successfully {item_struct.id}") 
				return true; 
			}
		},
		buy_index: function(item_index) {
			var sf = global.service_filemanager;
			var shop_data = sf.load(sf.name.shop);

			// bounds check
			if (item_index < 0 || item_index >= array_length(shop_data.items)) {
				show_debug_message("warning: invalid item index for shop buy.");
				return false;
			}

			var item_struct = shop_data.items[item_index];

			if (sf.shop.buy_struct(item_struct)) {
				sf.shop.remove(item_index);
				return true;
			}

			return false;
		}
	},
	gear: {
		load: function() {
			var sf = global.service_filemanager;
			var _load = sf.load(sf.name.gear);
			
			// load failiour
			if is_undefined(_load) {
				show_debug_message("info: gear file missing; generating.")
				var gear_struct = { name: sf.name.gear, items: [], index: { item: [-1, -1], armor: -1 } }
				sf.save(sf.name.gear, gear_struct);
				return gear_struct;
			}
			
			// load sucessfull
			show_debug_message("info: gear file loaded successfully.")
			return _load;	
		},
		add_gear: function(item_struct) {
			var sf = global.service_filemanager;
			var _load = sf.gear.load();
			show_debug_message(_load)
			array_push(_load.items, item_struct);
			sf.save(_load.name, _load);
			show_debug_message($"info: added item {item_struct.id} to gear.");
		},
		sell_gear: function(item_index, sell_multiplyer = 0.25) {
			var sf = global.service_filemanager;
			var _load = sf.gear.load();

			// Invalids
			if is_undefined(_load) {
				show_debug_message("warning: sell gear is missing gear file!");
				return;
			}
			if (item_index < 0 || item_index >= array_length(_load.items)) {
				show_debug_message("warning: invalid item index for selling.");
				return;
			}

			var item = _load.items[item_index];
			var gold_gain = floor(item.cost * sell_multiplyer);

			array_delete(_load.items, item_index, 1);
			sf.save(_load.name, _load);
			sf.basic.add_gold(gold_gain);

			show_debug_message($"info: sold item {item.id} for {gold_gain} gold.");
		},
		equip_index: function(gear_index, is_lower = true) {
			
			// load
			var gear = global.service_filemanager.gear.load()
			var item = gear.items[gear_index];
			var _type = item.type;
			
			// set index
			if _type == ITEM_TYPE.ABILITY {
				if (gear.index.item[0] == gear_index || gear.index.item[1] == gear_index) {
					debugs("error: already equiped", true)
					return;
				}
				gear.index.item[(is_lower) ? 0 : 1] = gear_index;
				debugs($"info: item {item.name} selected on ability[{(is_lower) ? 0 : 1}].")
			} else if _type == ITEM_TYPE.ARMOR {
				if (gear.index.armor == gear_index) {
					debugs("error: already equiped", true)
					return;
				}
				gear.index.armor = gear_index;
				debugs($"info: item {item.name} selected on armor.")
			} else {
				debugs("error: invalid item_type on equiping gear.", true)
			}
			
			// save
			
			global.service_filemanager.save(gear.name, gear);
		}
	},
	xp: {
		load: function() {
			var sf = global.service_filemanager;
			var _load = sf.load(sf.name.xp);
			
			if (is_undefined(_load)) {
				show_debug_message("info: failed to load xp, generating.")
				var xp_struct = { name: self.name.xp, level: global.service_exp.create_tracker(), tracker: global.service_exp.create_tracker() }
				sf.save(sf.name.xp, xp_struct)
				
				return xp_struct;
			}

			show_debug_message("info: xp file loaded successfully.");
			return _load;
		},
	},
	dungeon: {
		generate_dungeon_array: function() {
			// TODO
		}
	},
	contract: {
		load: function(contract_count, biome, wave) {
			var sf = global.service_filemanager;
			var _load = sf.load(sf.name.contract);
			
			if (is_undefined(_load)) {
				show_debug_message("info: failed to load contracts, generating.")
				var contract_struct = { name: sf.name.contract, contracts: sf.contract.generate_contract_array(contract_count, biome, wave) }
				sf.save(sf.name.contract, contract_struct)
				
				return contract_struct;
			}

			show_debug_message("info: contract file loaded successfully.");
			return sf.load(sf.name.contract);
		},
		generate_contract_array: function(contract_count, _biome, wave) {
			var array = [];
			randomize();
			repeat(contract_count) { array_push(array, {
				sidequest: (!irandom(1) ? undefined : { 
					type: choose(SIDEQUEST.RESCUE, SIDEQUEST.BOSS),
					reward: 100 * (wave+1)
				}),
				biome: choose(BIOME.WOODLAND, BIOME.SWAMP, BIOME.MONTAIN, BIOME.CAVE),
				difficulty: clamp(wave + irandom(3), 0, 9),
				enemy_groups: [ENEMY_GROUP.WILD_FOREST, ENEMY_GROUP.WILD_CAVE, ENEMY_GROUP.WILD_ELEMENTAL]
			})}
			return array;
		}

	},
	progress: {
		load: function() {
			var sf = global.service_filemanager;
			var _load = sf.load(sf.name.progress);
			
			if is_undefined(_load) {
				show_debug_message("info: no progress file found, generating new.")
				var progress_struct = { name: sf.name.progress, gems: [0, 0, 0], runs: 0 };
				sf.save(sf.name.progress, progress_struct);
				return progress_struct;
			}
			
			show_debug_message("info: progress file loaded sucessfully.")
			return _load;
		},
		add_gem: function(gem_index){
			var sf = global.service_filemanager;
			var _load = sf.progress.load();
	
			// check invalid bounds
			if (gem_index < 0 || gem_index >= array_length(_load.gems)) {
				show_debug_message("warning: invalid gem index");
				return;
			}

			_load.gems[gem_index] += 1;
			sf.save(_load.name, _load);
			debugs($"info: added gem in index {gem_index}")
		},
		add_run: function(){
			var sf = global.service_filemanager;
			var _load = sf.progress.load();
			_load.runs ++;
			sf.save(_load.name, _load);
			debugs("info: added a run to progress")
		}
	}
}