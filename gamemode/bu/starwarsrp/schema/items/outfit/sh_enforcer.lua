ITEM.name = "Enforcer"
ITEM.desc = ""
ITEM.model = "models/killzone/rifleman.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/killzone/rifleman.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Heavy")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)