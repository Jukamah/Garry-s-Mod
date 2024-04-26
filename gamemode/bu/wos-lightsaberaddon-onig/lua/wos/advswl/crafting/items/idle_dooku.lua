local ITEM = {}

ITEM.Name = "Dooku's Hum"

ITEM.Description = "Dooku's Idle Regulator"

ITEM.Type = WOSTYPE.IDLE

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/barrel/barrel.mdl"
ITEM.Rarity = 40

ITEM.OnEquip = function( wep )
	wep.UseLoopSound = "lightsaber/saber_loop7.wav"
end

wOS:RegisterItem( ITEM )