net.Receive("V.BG.Outfit.Write", function(len, ply)
	local Name				= net.ReadString()
	local Desc				= net.ReadString()
	local Mdl				= net.ReadString()
	local Price				= net.ReadInt(32)
	local newSkin			= 1
	local Replacement		= net.ReadString()
	local indexBodygroups	= net.ReadString()
	local doBodygroups		= net.ReadBool()
	local Bodygroups		= string.Explode("\n", indexBodygroups)
	local armourType		= net.ReadString()
	local Directory			= net.ReadString()
	
	print(doBodygroups)
	
	local indexTableInfo = {}
	if doBodygroups then
		for k, v in pairs(Bodygroups) do
			local indexTable = string.Explode("‼", v)
			local indexString = "[\""..indexTable[1].."\"] = "..indexTable[2]
			table.insert(indexTableInfo, indexString)
		end
	end
	
	local indexStringInfoA = "ITEM.name = \""..Name.."\""
	local indexStringInfoB = "ITEM.desc = \""..Desc.."\""
	local indexStringInfoC = "ITEM.model = \""..Mdl.."\""
	local indexStringInfoD = "ITEM.newSkin = 1"
	local indexStringInfoE = "ITEM.replacements = \""..Replacement.."\""
	
	local indexStringInfoF
	local indexStringInfoG
	local indexStringInfoH
	
	if doBodygroups then
		indexStringInfoF = "ITEM.bodyGroups = {"
		indexStringInfoG = table.concat(indexTableInfo, "")
		indexStringInfoH = "}"
	else
		indexStringInfoF = ""
		indexStringInfoG = ""
		indexStringInfoH = ""
	end
	
	local indexStringInfoI = "ITEM:hook(\"Equip\"), function(item)"
	local indexStringInfoJ = "item.player:SetNWString(\"V.BG.Armour\", \""..armourType.."\")"
	local indexStringInfoK = "end)"
	local indexStringInfoL = "ITEM:hook(\"EquipUn\"), function(item)"
	local indexStringInfoM = "item.player:SetNWString(\"V.BG.Armour\", \"None\")"
	local indexStringInfoN = "end)"
	
	local indexStringInfo = {
		indexStringInfoA,
		indexStringInfoB,
		indexStringInfoC,
		indexStringInfoD,
		indexStringInfoE,
		indexStringInfoF,
		indexStringInfoG,
		indexStringInfoH,
		indexStringInfoI,
		indexStringInfoJ,
		indexStringInfoK,
		indexStringInfoL,
		indexStringInfoM,
		indexStringInfoN,
	}
	
	local indexString = "Copy the code block into a sh_uniquename.lua in the schema/items/pacoutfit/\n\n"..table.concat(indexStringInfo, "\n")
	
	file.Append(Directory, "\n\n"..indexString)
	print(Name.." created in "..Directory)
end)

local function indexDamage(dmgType)
	local dmgClass, dmgDR = VBGDAMAGE[1], VBGDAMAGE[2]
	
	for k, v in pairs(dmgClass) do
		if v == dmgType then
			return  dmgDR[2]
		end
	end
	
	if not table.HasValue(dmgClass, dmgType) then
		return 1
	end
end

hook.Add('EntityTakeDamage', "V.BG.Armor", function(target, dmg)
	local Armour = target:GetNWString("V.BG.Armour")
	local dmgType = indexDamage(dmg:GetDamageType())
	
	for k, v in pairs(VBGARMOUR) do
		local Type	= v[1]
		local DR	= v[2]
		
		local compDR = 1 - (DR * dmgType)
		
		if Armour == Type then
			dmg:ScaleDamage(compDR)
		end
	end
end)