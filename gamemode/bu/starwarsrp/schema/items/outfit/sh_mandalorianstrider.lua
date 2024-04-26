ITEM.name = "Mandalorian Strider"
ITEM.desc = ""
ITEM.model = "models/player/vengeance/mandalorian_black/mandalorian_black.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/vengeance/mandalorian_black/mandalorian_black.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)