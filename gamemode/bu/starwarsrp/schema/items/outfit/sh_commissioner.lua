ITEM.name = "Commissioner"
ITEM.desc = ""
ITEM.model = "models/player/ai_soldiers.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/ai_soldiers.mdl"
ITEM.bodyGroups = {
	["Skin"] = 5
}

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)