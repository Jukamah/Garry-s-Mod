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
*/

local AmmoRate = { 1, 2 }

local Alpha = {
	{ "ELG-3A", "elg3a", 4500, "models/weapons/w_elg3a.mdl" },
	{ "DC17", "dc17", 4500, "models/weapons/w_dc17.mdl" },
}

local Bravo = {
	{ "Blaster Rifle", "blasterrifle", 10000, "models/weapons/kotor/w_blaster_rifle.mdl", {} },
}

local Charlie = {

}

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

local VendorModel 		= "models/odessa.mdl"
local LicenseModel		= "models/Humans/group03/male_01.mdl"
local BMLicenseModel	= "models/Humans/group03/male_09.mdl"

/* DO NOT EDIT BELOW */

VBGCLASS			= Class
VBGPERMIT			= Permit

VBGVENDORMODEL = VendorModel
VBGLICENSEMODEL = LicenseModel
VBGLICENSEBMMODEL = BMLicenseModel

VBGAMMOEXCHANGE = AmmoRate