global.service_item = {
	mapping: undefined,
	init: function() { 
		self.mapping = ds_map_create() 
		ds_map_add(self.mapping, "sword", {
			id: "sword",
			name: "Sword",
			type: "ability",
			cost: 50,
			sprite_index: [spr_placeholder_16, 0],
			action: {
				type: "meele",
				range: 6,
				on_destroy: {
					action: {
						type: "collision",
						radius: 4,
						physical: global.service_combat.create_physical(0, COMBAT_PHYSICAL.SLASH, 10, COMBAT_PHYSICAL.PIERCE, 10, COMBAT_PHYSICAL.CRUSH, 5)
					}
				}
			}
		})
	},
	destroy: function() { ds_map_destroy(self.mapping) },
	get: function(key) {
		return (ds_exists(mapping, ds_type_map)) ? mapping[? key] : undefined;
	}
}