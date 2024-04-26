ITEM.name = "Mandalorian Knight"
ITEM.desc = ""
ITEM.model = "models/player/vengeance/mandalorian_blue/mandalorian_blue.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/vengeance/mandalorian_blue/mandalorian_blue.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)