-- The 'nice' name of the faction.
FACTION.name = "Aliens"
-- This faction is default by the server.
-- This faction does not requires a whitelist.
FACTION.isDefault = false
-- A description used in tooltips in various menus.
FACTION.desc = "The Aliens faction."
-- A color to distinguish factions from others, used for stuff such as
-- name color in OOC chat.
FACTION.color = Color(20, 150, 15)

FACTION.models = {
	"models/player/bith/bithjedi.mdl",
	"models/player/duros/durosjedi.mdl",
	"models/player/gran/granjedi.mdl",
	"models/byan7259/bodian_player/segular_rodian_player.mdl",
	"models/gyan7259/geequay_player/geequay_regular_player.mdl",
}

-- FACTION.index is defined when the faction is registered and is just a numeric ID.
-- Here, we create a global variable for easier reference to the ID.
FACTION_ALIENS = FACTION.index
