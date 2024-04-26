ITEM.name = "Cui'val Dar Trooper"
ITEM.desc = ""
ITEM.model = "models/player/lillwasa/sw/deathwatchassassin3.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/lillwasa/sw/deathwatchassassin3.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)