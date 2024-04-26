ITEM.name = "Trooper"
ITEM.desc = ""
ITEM.model = "models/reizer_cgi_p2/guard_d1/guard_d1.mdl"
ITEM.newSkin = 1
ITEM.replacements = "models/reizer_cgi_p2/guard_d1/guard_d1.mdl"

ITEM:hook("Equip", function(item)
	item.player:SetNWString("V.BG.Armour", "Medium")
end)
ITEM:hook("EquipUn", function(item)
	item.player:SetNWString("V.BG.Armour", "None")
end)