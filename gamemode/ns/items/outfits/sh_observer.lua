ITEM.name = "Observer"
ITEM.desc = ""
ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/mass effect 2/player/inferno_armour_colour.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
	item.player:SetColor(0, 0, 0)
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
	item.player:SetColor(255, 255, 255)
end)