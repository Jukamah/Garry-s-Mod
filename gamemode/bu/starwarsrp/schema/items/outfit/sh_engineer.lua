ITEM.name = "Engineer"
ITEM.desc = ""
ITEM.model = "models/killzone/cm/cm_pyro.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/killzone/cm/cm_pyro.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)