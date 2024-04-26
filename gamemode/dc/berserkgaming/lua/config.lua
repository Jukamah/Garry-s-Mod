/*
To add a new license follow this template:

local <Unique Class Name> = {
	<Weapon Table>
}

WHEN ADDING A NEW LICENSE CLASS MAKE SURE TO FINISH ALL THE STEPS:
	1. CREATE LOCAL TABLE
	2. CREATE PRICE TABLE UNDER local Permit = { ... }
	3. INSERT IT UNDER local Class = { ... }
	WHEN INSERTING A CLASS, ALL CLASSES ABOVE THE SPECIFIED ARE COVERED UNDER THE SPECIFIED
	MEANING, CHARLIE CAN USE BRAVO AND ALPHA, BRAVO CAN USE ALPHA, AND ALPHA CAN USE ALPHA

To add weapons, here is the weapon table template: (Add this in the table for its required license)

	{ "Weapon Display Name", "Weapon Class Name", <Price>, "Model" },
	
AmmoRate = { <Price>, <Amount> }

Blueprints:
	{ { "Display Name", "Class Name", "Model Dir" }, { "Required Item", "Required Item" }, <Required Intelligence> }

Stocks:
	{ "Company Name", "Company Info", <Base Stock Price> }
*/

local UIColours = {
	["text"]		= Color(255, 255, 255),
	["base.a"]		= Color(0, 0, 0),
	["a.accent.a"]	= Color(0, 0, 255),
	["a.accent.b"]	= Color(0, 0, 100),
	["base.b"]		= Color(50, 50, 50),
	["b.accent.a"]	= Color(0, 0, 0),
	["b.accent.b"]	= Color(0, 0, 0),
}

local MaxStocks = 1000000

local MaxPlayerStocks = 333333

local StockDeviation = 0.05 // In percent .05 = 5%

local StockUpdate = 5 // How often to simulate stock change (in minutes)

local Stocks = {
	{ "SyntheTech", "Company producing droid equipment.", 100 },
	{ "Atlas Corp", "Corporation specialized in armor accessories.", 100},
	{ "Beemon Laboratories", "Company producing cybernetic implants.", 100},
	{ "Galactic Arms", "Company producing firearm add-ons.", 100},
	{ "BlasTech Industries", "One of three, of the top arms manufacturers.", 100},
}

local StockMonitorModel		= "models/props_combine/combine_intmonitor001.mdl"
local StockViewModel		= "models/hunter/plates/plate.mdl"

/* { { "Display Name", "Class Name", "Display Model" }, { "<ItemID>x<Quantity>" } } */
local Blueprints = {
	{ { "ELG-3A", "tfa_swch_elg3a", "models/weapons/w_elg3a.mdl" }, {  } }
}
local BlueprintCheck = #Blueprints

local CraftingTableModel	= "models/props_wasteland/cafeteria_table001a.mdl"

local BlueprintModel = "models/hunter/plates/plate025x05.mdl"

local AmmoRate = { 1, 2 }

local Alpha = {
	{ "ELG-3A", "tfa_swch_elg3a", 4500, "models/weapons/w_elg3a.mdl" },
	{ "DC17", "tfa_swch_dc17", 4500, "models/weapons/synbf3/w_dh17.mdl" },
	{ "Blaster Pistol T1", "tfa_kotor_bp_2", 4500, "models/w_blstrpstl_002.mdl" },
	{ "Papanoid", "tfa_papanoid", 4500 , "models/papanoidapistol/papanoidapistol.mdl" },
}

local Bravo = {
	{ "Blaster Rifle T1", "tfa_kotor_br_1", 10000, "models/w_blstrrfl_001.mdl" },
	{ "A280", "tfa_a280_extended", 10000, "models/weapons/synbf3/w_a280.mdl" },
}

local Charlie = {
	{ "Republic Shotgun", "tfa_sw_repshot", 20000, "models/weapons/w_shotgun.mdl" },
}

/* ["<Class Name>"] = { <Vendor Price>, <Black Market Price> } */

local Permit = {
	["Class Alpha"]	= { 1000, 250 },
	["Class Bravo"]	= { 15000, 5000 },
	["Class Charlie"]	= { 20000, 7000 },
}

local Class = {
	{ "Class Alpha", Alpha },
	{ "Class Bravo", Bravo },
	{ "Class Charlie", Charlie },
}

local VendorModel 		= "models/odessa.mdl" // Model for NPC selling weapons
local LicenseModel		= "models/Humans/group03/male_01.mdl" // Model for NPC selling license
local BMLicenseModel	= "models/Humans/group03/male_09.mdl" // Model for NPC selling fake license

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

/* THIS ALSO APPLIES TO ALL EDIT/CONFIG UI'S (STOCK SCREEN, OUTFIT GENERATOR) */
local AllowedToEditStockScreen	= { "superadmin" }

/* DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU ARE DOING */

VBGMODELS			= { 
	["Vendor.Weapons"] = VendorModel, 
	["Vendor.License"] = LicenseModel, 
	["Vendor.License.BM"] = BMLicenseModel, 
	["Crafting"] = CraftingTableModel, 
	["Stock.Monitor"] = StockMonitorModel, 
	["Stock.View"] = StockViewModel,
	["Blueprint"] = BlueprintModel,
}

VBGCLASS			= Class
VBGPERMIT			= Permit

VBGPROBABILITY		= ProbabilityCheck

VBGALERT			= Alert

VBGUICOLOUR			= UIColours

VBGBP				= Blueprints

VBGSTOCKLIST		= Stocks
VBGSTOCKSETTING		= { MaxStocks, MaxPlayerStocks, StockDeviation, StockUpdate }
VBGCONFIGEDIT		= AllowedToEditStockScreen

VBGARMOUR			= Armour
VBGDAMAGE			= { DamageExceptionsClass, DamageExceptionsDR }

VBGBPCHECK			= BlueprintCheck