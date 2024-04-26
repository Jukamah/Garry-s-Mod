ITEM.name = "Reactive Armour"
ITEM.desc = ""
ITEM.model = "models/player/legion/legionary_soldier.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/legion/legionary_soldier.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)