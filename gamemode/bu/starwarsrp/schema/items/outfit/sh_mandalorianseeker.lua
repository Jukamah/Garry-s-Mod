ITEM.name = "Mandalorian Seeker"
ITEM.desc = ""
ITEM.model = "models/player/vengeance/jaster_redhelm/jaster_redhelm.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/vengeance/jaster_redhelm/jaster_redhelm.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)