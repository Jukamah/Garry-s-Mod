ITEM.name = "Kappa"
ITEM.desc = ""
ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/hutt/huttjedi.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Power.Advanced")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)