ITEM.name = "Kal"
ITEM.desc = ""
ITEM.model = "models/smitty/swbf/kalskirata/hero_gunslinger_kalskirata.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/smitty/swbf/kalskirata/hero_gunslinger_kalskirata.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Heavy")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)