local UIColours = {
	["text"]		= Color(255, 255, 255),
	["base.a"]		= Color(0, 0, 0),
	["a.accent.a"]	= Color(0, 0, 255),
	["a.accent.b"]	= Color(0, 0, 100),
	["base.b"]		= Color(50, 50, 50),
	["b.accent.a"]	= Color(0, 0, 0),
	["b.accent.b"]	= Color(0, 0, 0),
}

/* THIS ALSO APPLIES TO ALL EDIT/CONFIG UI'S (STOCK SCREEN, AND FACTION VENDORS) */

local AllowedToEditStockScreen	= { "superadmin" }

/* DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU ARE DOING */

VBGUICOLOUR			= UIColours
VBGCONFIGEDIT		= AllowedToEditStockScreen