local MaterialInventorySize = {
	x = 6,
	y = 8,
}

// [1] = Console command, [2] = Chat command [[ For opening the materials inventory ]]
local Command = { "V.BG.Materials", "!materials"}

/*
	Blueprints:
		{ { "Display Name", "Weapon Class", "Model" }, { <Quantity "Required Item" }, <Required Intelligence or nil> }
*/

local Blueprints = {
	{ 
		{ 
			"BP - Blaster Rifle", 
			"blasterrifle", 
			"models/weapons/kotor/w_blaster_rifle.mdl",
			"Uncommon",
		}, 
		{ 
			{ 1, "Blaster Rifle Frame" }, 
			{ 1, "Blaster Power Pack - Medium" }, 
			{ 1, "Focus Emitter - Medium" },
			{ 5, "Plasteel" },
		} 
	}
}

/*
	Parts:
		{ "Display Name/Key", <bool Show 3D Text>, "Model", "Rarity Key" }
*/

local Parts = {
	{ "Blaster Rifle Frame", false, "models/Items/BoxMRounds.mdl", "Uncommon" },
	{ "Blaster Power Pack - Medium", false, "models/Items/BoxMRounds.mdl", "Uncommon" },
	{ "Focus Emitter - Medium", false, "models/Items/BoxMRounds.mdl", "Rare" },
	{ "Plasteel", false, "models/Items/BoxMRounds.mdl", "Common" },
}

/*
	Rarity:
		["UniqueID"] = Rarity (1-100)
		
	The sum of all Rarity's should be equal to 100
*/

local BlueprintCheck = #Blueprints

local CraftingTableModel= "models/props_wasteland/cafeteria_table001a.mdl"

local BlueprintModel = "models/hunter/plates/plate025x05.mdl"

VBGBP				= Blueprints
VBGBPCHECK			= BlueprintCheck

VBGCRAFTINGTABLEMODEL = CraftingTableModel
VBGCRAFTINGBPMODEL = BlueprintModel

VBGMATERIALSCOMMAND = Command

VBGMATERIALS = Parts

VBGINVENTORYSIZE = MaterialInventorySize