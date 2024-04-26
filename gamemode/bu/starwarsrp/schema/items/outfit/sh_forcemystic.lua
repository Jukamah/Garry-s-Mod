ITEM.name = "Force Mystic"
ITEM.desc = ""
ITEM.model = "models/jedigrey/jedigrey.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/jedigrey/jedigrey.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)