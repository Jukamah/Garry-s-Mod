ITEM.name = "Hunter"
ITEM.desc = ""
ITEM.model = "models/player/swtor/arsenic/slactir/slactirtest2.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/swtor/arsenic/slactir/slactirtest2.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)