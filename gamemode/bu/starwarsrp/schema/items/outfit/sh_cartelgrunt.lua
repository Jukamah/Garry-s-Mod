ITEM.name = "Cartel Grunt"
ITEM.desc = ""
ITEM.model = "models/helghast1/helghast_a.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/helghast1/helghast_a.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)
