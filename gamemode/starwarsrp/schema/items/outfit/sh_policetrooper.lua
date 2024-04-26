ITEM.name = "Police Trooper"
ITEM.desc = ""
ITEM.model = "models/Items/BoxMRounds.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/player/ai_soldiers.mdl"
ITEM.bodyGroups = {
	["Skin"] = 1
}

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
	item.player:SetColor(0, 0, 0)
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
	item.player:SetColor(255, 255, 255)
end)