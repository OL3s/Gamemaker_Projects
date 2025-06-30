enum BIOME {
	WOODLAND,
	SWAMP,
	DESERT,
	MONTAIN,
	CAVE,
	ICE_CAVE,
	VOLCANIC,
	RUINS,
	CRYPT,
	ABYSS,
	
	COUNT
}

enum ENEMY_GROUP {
	WILD_FOREST,
	WILD_DESERT,
	WILD_TUNDRA,
	WILD_CAVE,
	
	ELEMENTAL,
	GOBLIN,
	BANDIT,
	UNDEAD,
	CULTIST,
	ABYSSAL,
	
	COUNT
}

enum SIDEQUEST {
	RESCUE,
	BOSS,
	COUNT
}

enum XP {
	STRENGTH,
	AGILITY,
	MANA,
	VITALITY,
	COUNT
}
global.service_enum = {
	biome_tostring: function(index) {
	    switch (index) {
	        case BIOME.WOODLAND:  return "woodland";
	        case BIOME.SWAMP:     return "swamp";
	        case BIOME.DESERT:    return "desert";
	        case BIOME.MONTAIN:   return "mountain";
	        case BIOME.CAVE:	  return "cave";
	        case BIOME.ICE_CAVE:  return "ice cave";
	        case BIOME.VOLCANIC:  return "volcanic";
	        case BIOME.RUINS:     return "ruins";
	        case BIOME.CRYPT:     return "crypt";
	        case BIOME.ABYSS:     return "abyss";
	        default:              return "invalid enum index!";
	    }
	},

    sidequest_tostring: function(index) {
        switch (index) {
            case SIDEQUEST.RESCUE: return "rescue";
            case SIDEQUEST.BOSS: return "boss";
            default: return "invalid enum index!";
        }
    },

    xp_tostring: function(index) {
        switch (index) {
            case XP.STRENGTH: return "strength";
            case XP.AGILITY: return "agility";
            case XP.MANA: return "mana";
            case XP.VITALITY: return "vitality";
            default: return "invalid enum index!";
        }
    },

	enemy_group_tostring: function(index) {
	    switch (index) {
	        case ENEMY_GROUP.WILD_FOREST:
	        case ENEMY_GROUP.WILD_DESERT:
	        case ENEMY_GROUP.WILD_TUNDRA:
	        case ENEMY_GROUP.WILD_CAVE:
	            return "wild";

	        case ENEMY_GROUP.ELEMENTAL: return "elemental";
	        case ENEMY_GROUP.GOBLIN:   return "goblin";
	        case ENEMY_GROUP.BANDIT:   return "bandit";
	        case ENEMY_GROUP.UNDEAD:   return "undead";
	        case ENEMY_GROUP.CULTIST:  return "cultist";
	        case ENEMY_GROUP.ABYSSAL:  return "abyssal";

	        default: return "invalid enum index!";
	    }
	}
};
