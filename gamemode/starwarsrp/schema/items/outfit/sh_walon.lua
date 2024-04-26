ITEM.name = "Walon"
ITEM.desc = ""
ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/smitty/swbf/walonvau/hero_gunslinger_walonvau.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Heavy")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)