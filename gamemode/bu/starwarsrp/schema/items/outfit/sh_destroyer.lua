ITEM.name = "Destroyer"
ITEM.desc = ""
ITEM.model = "models/nailgunner/slow.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/nailgunner/slow.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Power.Advance")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)