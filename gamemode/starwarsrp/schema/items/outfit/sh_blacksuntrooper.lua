ITEM.name = "Black Sun Trooper"
ITEM.desc = ""
ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/valley/lgn/cgi pack/blacksun_soldier/blacksun_soldier.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)