local ITEM = {}

ITEM.Name = "Corrupted Crystal ( Red )"

ITEM.Description = "Cracked by the force, it bleeds with it's ignition"

ITEM.Type = WOSTYPE.CRYSTAL

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

--A simple description of what the item will ACTUALLY do
ITEM.Effects = "Permits a red corrupted blade"

ITEM.Model = "models/red2/red2.mdl"
ITEM.Rarity = 5

ITEM.OnEquip = function( wep )
	wep.CustomSettings[ "Corrupted" ] = true
	wep.UseColor = Color( 255, 0, 0 )
end

wOS:RegisterItem( ITEM )