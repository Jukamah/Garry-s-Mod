local ITEM = {}

ITEM.Name = "Corrupted Crystal ( Dark Inner Yellow )"

ITEM.Description = "Cracked by the force, it bleeds with it's ignition"

ITEM.Type = WOSTYPE.CRYSTAL

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/yellow2/yellow2.mdl"
ITEM.Rarity = 1

ITEM.OnEquip = function( wep )
	wep.CustomSettings[ "Corrupted" ] = true
	wep.UseColor = Color( 255, 255, 0 )
	wep.UseDarkInner = 1
end

wOS:RegisterItem( ITEM )