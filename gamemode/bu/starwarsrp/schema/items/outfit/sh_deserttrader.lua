ITEM.name = "Desert Trader"
ITEM.desc = ""
ITEM.model = "models/valley/lgn/cgi pack/dengar/dengar.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/valley/lgn/cgi pack/dengar/dengar.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Light")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)