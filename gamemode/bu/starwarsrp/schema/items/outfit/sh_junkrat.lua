ITEM.name = "Junk Rat"
ITEM.desc = ""
ITEM.model = "models/killzone/miner.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/killzone/miner.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Light")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)