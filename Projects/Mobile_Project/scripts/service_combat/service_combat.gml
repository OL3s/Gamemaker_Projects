enum COMBAT_PHYSICAL {
    SLASH,
    PIERCE,
    CRUSH,
    HEAT,
    COLD,
    ACID,
    COUNT
}

enum COMBAT_EFFECT {
    HIT,
    STUN,
    SLOW,
    BURN,
    FREEZE,
    COUNT
}

global.service_combat = {
	
    init: function(_self_id, _hp, _armor_physical, _armor_effect) {
        var combat = {
			host: _self_id,
            health: _hp,
			health_max: _hp,
            armor: {
                physical: _armor_physical,
                effect: _armor_effect
            },
            effects: global.service_combat.create_effect(),
            image_blend: c_white,
            image_yscale: 1
        };
        return combat;
    },
	
	array_sum: function(array) {
	    var total = 0;
	    for (var i = 0; i < array_length(array); i++) {
	        total += array[i];
	    }
	    return total;
	},

    create_physical: function(value_flat = 0) {
        var physical = array_create(COMBAT_PHYSICAL.COUNT, value_flat);
        for (var i = 1; i < argument_count; i += 2) {
            physical[argument[i]] = argument[i + 1];
        }
        return physical;
    },

    create_effect: function(value_flat = 0) {
        var effect = array_create(COMBAT_EFFECT.COUNT, value_flat);
        for (var i = 1; i < argument_count; i += 2) {
            effect[argument[i]] = argument[i + 1];
        }
        return effect;
    },
	
	get_damage_total: function(physical) {
		return self.array_sum(physical)
	},

    effect_update: function(combat) {
        var sc = global.service_combat;
        combat.image_blend = c_white;

        if (combat.effects[COMBAT_EFFECT.HIT] > 0) {
            combat.effects[COMBAT_EFFECT.HIT]--;
            combat.image_blend = c_red;
        }

        if (combat.effects[COMBAT_EFFECT.BURN] > 0) {
            combat.effects[COMBAT_EFFECT.BURN]--;
            combat.image_blend = c_orange;

            if (irandom(59) == 0) {
                sc.hit_physical(combat, sc.create_physical(0, COMBAT_PHYSICAL.HEAT, 1));
            }
        }
    },

    apply_physical: function(combat, _physical, ignore_armor = false) {
        var damage = 0;
        for (var i = 0; i < COMBAT_PHYSICAL.COUNT; i++) {
            var armor_factor = ignore_armor ? 1 : (100 / (100 + combat.armor.physical[i] * 4));
            damage += _physical[i] * armor_factor;
        }
        damage = ceil(damage);
        combat.health -= damage;
        combat.effects[COMBAT_EFFECT.HIT] += damage;
    },

    apply_effect: function(combat, _effect) {
        for (var i = 0; i < COMBAT_EFFECT.COUNT; i++) {
            var reduced = _effect[i] * (100 / (100 + combat.armor.effect[i] * 4));
            combat.effects[i] += ceil(reduced);
        }
    },

    apply_hit: function(combat, _physical, _effect) {
        var sc = global.service_combat;
        if (is_array(_physical)) sc.hit_physical(combat, _physical);
        if (is_array(_effect)) sc.hit_effect(combat, _effect);
		return combat.health <= 0
    },

	draw: function(object, combat, draw_health = true, debug = true) {
	    var xx = object.bbox_left;
	    var yy = object.bbox_top;
	    var width = object.bbox_right - object.bbox_left;

	    // Health bar background (black)
	    draw_set_color(c_black);
	    draw_line_width(xx, yy - 4, xx + width, yy - 4, 2);

	    // Health fill (green)
	    var health_width = (combat.health / combat.health_max) * width;
	    draw_set_color(c_green);
	    draw_line_width(xx, yy - 4, xx + health_width, yy - 4, 2);

	    if (debug) {
	        var bar_height = 2;

	        // Physical armor bar (as before)
	        var total_armor = global.service_combat.array_sum(combat.armor.physical);
	        var bar_x = xx;
	        var bar_y = yy - 10;
	        for (var i = 0; i < COMBAT_PHYSICAL.COUNT; i++) {
	            var portion = total_armor > 0 ? (combat.armor.physical[i] / total_armor) : 0;
	            var segment_width = portion * width;
	            if (segment_width > 0) {
	                var col = c_gray;
	                switch (i) {
	                    case COMBAT_PHYSICAL.SLASH: col = c_red; break;
	                    case COMBAT_PHYSICAL.PIERCE: col = c_yellow; break;
	                    case COMBAT_PHYSICAL.CRUSH: col = c_maroon; break;
	                    case COMBAT_PHYSICAL.HEAT: col = c_orange; break;
	                    case COMBAT_PHYSICAL.COLD: col = c_aqua; break;
	                    case COMBAT_PHYSICAL.ACID: col = c_lime; break;
	                }
	                draw_set_color(col);
	                draw_line_width(bar_x, bar_y, bar_x + segment_width, bar_y, bar_height);
	                bar_x += segment_width;
	            }
	        }

	        // Effects bar below armor.physical
	        var total_effects = global.service_combat.array_sum(combat.effects);
	        bar_x = xx;
	        bar_y = yy - 14; // 4 pixels below health, 4 below armor.physical
	        for (var i = 0; i < COMBAT_EFFECT.COUNT; i++) {
	            var portion = total_effects > 0 ? (combat.effects[i] / total_effects) : 0;
	            var segment_width = portion * width;
	            if (segment_width > 0) {
	                var col = c_gray;
	                switch (i) {
	                    case COMBAT_EFFECT.HIT: col = c_red; break;
	                    case COMBAT_EFFECT.STUN: col = c_yellow; break;
	                    case COMBAT_EFFECT.SLOW: col = c_aqua; break;
	                    case COMBAT_EFFECT.BURN: col = c_orange; break;
	                    case COMBAT_EFFECT.FREEZE: col = c_blue; break;
	                }
	                draw_set_color(col);
	                draw_line_width(bar_x, bar_y, bar_x + segment_width, bar_y, bar_height);
	                bar_x += segment_width;
	            }
	        }

	        // Armor.effect bar below effects
	        var total_armor_effect = global.service_combat.array_sum(combat.armor.effect);
	        bar_x = xx;
	        bar_y = yy - 18; // 4 pixels below effects
	        for (var i = 0; i < COMBAT_EFFECT.COUNT; i++) {
	            var portion = total_armor_effect > 0 ? (combat.armor.effect[i] / total_armor_effect) : 0;
	            var segment_width = portion * width;
	            if (segment_width > 0) {
	                var col = c_gray;
	                switch (i) {
	                    case COMBAT_EFFECT.HIT: col = c_red; break;
	                    case COMBAT_EFFECT.STUN: col = c_yellow; break;
	                    case COMBAT_EFFECT.SLOW: col = c_aqua; break;
	                    case COMBAT_EFFECT.BURN: col = c_orange; break;
	                    case COMBAT_EFFECT.FREEZE: col = c_blue; break;
	                }
	                draw_set_color(col);
	                draw_line_width(bar_x, bar_y, bar_x + segment_width, bar_y, bar_height);
	                bar_x += segment_width;
	            }
	        }
	    }
	}
};