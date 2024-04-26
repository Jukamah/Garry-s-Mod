ITEM.name = "Outlaw"
ITEM.desc = ""
ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/masseffectandromeda/outlaw/raiderkadora/m_raider.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Power.Basic")
	item.player:SetColor(88, 88, 88)
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
	item.player:SetColor(0, 0, 0)
end)