ITEM.name = "Arc Sergeant"
ITEM.desc = ""
ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/smitty/bf2_reg/bf2_p1_arc_sergeant/bf2_p1_arc_sergeant.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)