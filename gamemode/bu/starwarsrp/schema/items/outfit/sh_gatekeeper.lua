ITEM.name = "Gatekeeper"
ITEM.desc = ""
ITEM.model = "models/models/konnie/labyrinth/labyrinth.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/models/konnie/labyrinth/labyrinth.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Heavy")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)