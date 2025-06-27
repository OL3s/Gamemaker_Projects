enum ITEM_TYPE {
	ABILITY,
	ARMOR
}

global.service_item = {
	mapping: undefined,
	init: function() { 
		self.mapping = ds_map_create() 
		ds_map_add(self.mapping, "light_sword", self.item_struct(
			"lsword", "Light Sword", "sword", ITEM_TYPE.ABILITY, 50, [spr_item_sword_l, 0], {
				type: "teleport",
				range: 6,
				direction: "default",
				on_destroy: {
					action: {
						type: "collision",
						radius: 4,
						physical: global.service_combat.create_physical(0, COMBAT_PHYSICAL.SLASH, 10, COMBAT_PHYSICAL.PIERCE, 10, COMBAT_PHYSICAL.CRUSH, 5)
					}
				}
			}
		))
		ds_map_add(self.mapping, "leather_armor", self.item_struct(
			"leather_armor", "Leather Armor", "leather", ITEM_TYPE.ARMOR, 30, [spr_placeholder_16, 0], {
				physical: global.service_combat.create_physical(0, 
					COMBAT_PHYSICAL.COLD, 80,
					COMBAT_PHYSICAL.HEAT, 50,
					COMBAT_PHYSICAL.ACID, 50,
					COMBAT_PHYSICAL.SLASH, 20
				),
				effect: global.service_combat.create_effect(0, 
					COMBAT_EFFECT.FREEZE, 200
				)
			}
		))
	},
	destroy: function() { ds_map_destroy(self.mapping) },
	get: function(key) {
		if !ds_exists(self.mapping, ds_type_map) { show_debug_message("error: item mapping memory missing"); return; }
		if !ds_map_exists(self.mapping, key) show_debug_message($"warning: item '{key}' in mapping not found.")
		var _return = self.mapping[? key];
		return _return
	},
	item_struct: function(_id, _name, _name_s, _type, _cost, _sprite_index, _action_struct) {
		return {
			id: _id,
			name: _name,
			name_short: _name_s,
			type: _type,
			cost: _cost,
			sprite_index: _sprite_index,
			action: _action_struct
		}
	}
}