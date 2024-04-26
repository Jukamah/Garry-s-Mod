ITEM.name = "Tracker"
ITEM.desc = ""
ITEM.model = "models/porky-da-corgi/starwars/mandalorians/bountyhunter.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/porky-da-corgi/starwars/mandalorians/bountyhunter.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)