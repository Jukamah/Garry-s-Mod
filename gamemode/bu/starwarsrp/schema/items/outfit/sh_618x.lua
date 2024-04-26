ITEM.name = "618-X"
ITEM.desc = ""
ITEM.model = "models/killzone/cm_hazmat2.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/killzone/cm_hazmat2.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Power.Normal")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)
