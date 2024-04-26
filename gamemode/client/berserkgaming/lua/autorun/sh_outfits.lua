/* { "ID", <Damage Reduction> } */
local Armour = {
	{ "Heavy", 0.70 },
	{ "Medium", 0.60 },
	{ "Light", 0.50 },
	
	{ "Power.NextGen", 0.90 },
	{ "Power.Advance", 0.80 },
	{ "Power.Normal", 0.80 },
	{ "Power.Basic", 0.75 },
}

local Outfits = {
	{ "618-X", "618x", "models/killzone/cm_hazmat2.mdl", "Power.Normal" }
}

/*
	THESE ARE DAMAGES THAT ARE REDUCED BY ARMOUR DIFFERENTLY
	USE https://wiki.garrysmod.com/page/Enums/DMG AS REFERENCE
	DMG_...
	<Percent of DR> 0 means Damage Reduction does not reduce it
*/

local DamageExceptionsClass = {
	[1] = DMG_DROWN,
	[2] = DMG_FALL,
}

local DamageExceptionsDR = {
	[1] = 0,
	[2] = 0,
}

/* DO NOT EDIT BELOW */

VBGOUTFITS = Outfits

VBGARMOUR			= Armour
VBGDAMAGE			= { DamageExceptionsClass, DamageExceptionsDR }