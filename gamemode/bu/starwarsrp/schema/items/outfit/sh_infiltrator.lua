ITEM.name = "Infilitrator"
ITEM.desc = ""
ITEM.model = "models/killzone2/shock_trooper_citizen.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/killzone2/shock_trooper_citizen.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Light")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)
