ITEM.name = "Merc's Garb"
ITEM.desc = ""
ITEM.model = "models/killzone/commander.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/killzone/commander.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Heavy")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)