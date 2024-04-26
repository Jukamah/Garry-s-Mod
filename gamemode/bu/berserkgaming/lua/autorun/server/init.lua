local svSide = file.Find("addons/berserkgaming/lua/*.lua", "GAME")

for k, v in pairs(svSide) do
	AddCSLuaFile(v)

	if v != "fonts.lua" then
		include(v)
	end
end

local ThisATable = {
	["Underworld Police"] = {
		{ Vector(-5439.437012, -4857.455566, -637.468750),
		Angle(0, 0, 0) },
		
		{ Vector(-5439.568848, -4914.547363, -637.468750),
		Angle(0, 0, 0) }
	}
}

hook.Add('InitPostEntity', "V.BG.Vendor.Spawn", function()
	for k, v in pairs(ThisATable) do
		for a, b in pairs(v) do
			local VendorEntity = ents.Create("bg_vendor_faction")
			VendorEntity:SetPos(b[1])
			VendorEntity:SetAngles(b[2])
			VendorEntity:Spawn()		
			for c, d in pairs(nut.faction.teams) do
				if v.name == k then
					indexVendor:SetNWInt("V.BG.Vendor.Faction.Index", d.index)
					indexVendor:SetNWString("V.BG.Vendor.Faction.Name", d.name)
					indexVendor:SetNWBool("V.BG.Vendor.Init", true)
				end
			end
		end
	end
end)

util.AddNetworkString("V.BG.Vendor.Menu.Weapons")
util.AddNetworkString("V.BG.Vendor.Menu.License")
util.AddNetworkString("V.BG.Vendor.Menu.License.BM")
util.AddNetworkString("V.BG.Vendor.License.Buy")
util.AddNetworkString("V.BG.Vendor.Buy")
util.AddNetworkString("V.BG.Vendor.Ammo")
util.AddNetworkString("V.BG.Crafting.Menu")
util.AddNetworkString("V.BG.Craft")
util.AddNetworkString("V.BG.Stock.Menu")
util.AddNetworkString("V.BG.Stock.Menu.Edit")
util.AddNetworkString("V.BG.Stock.Change")
util.AddNetworkString("V.BG.Sign.Edit")
util.AddNetworkString("V.BG.Outfit.Write")
util.AddNetworkString("V.BG.Blueprint.Pickup")
util.AddNetworkString("V.BG.BP.Add")
util.AddNetworkString("V.BG.Materials.Request")
util.AddNetworkString("V.BG.Materials")
util.AddNetworkString("V.BG.Materials.Drop")
util.AddNetworkString("V.BG.Item.Move")
util.AddNetworkString("V.BG.Vendor.Menu.Faction")
util.AddNetworkString("V.BG.Vendor.Menu.Faction.Init")
util.AddNetworkString("V.BG.Vendor.Faction.Init")
util.AddNetworkString("V.BG.Vendor.Faction.Reset")
util.AddNetworkString("V.Vendor.Add.Outfit")

file.CreateDir("v/bg/")

local meta = FindMetaTable("Player")

function meta:bgGetInventory()
	local indexDir = self:GetNWString("V.BG.Dir").."materials.txt"
	
	if file.Exists(indexDir, "DATA") then
		local indexString = file.Read(indexDir, "DATA")
		local indexTable = string.Explode("\n", indexString)
		
		return indexTable
	else
		local x, y = VBGINVENTORYSIZE.x, VBGINVENTORYSIZE.y
		local indexTable, indexString = {}
		
		for a = 1, x do
			for b = 1, y do
				table.insert(indexTable, table.concat({ a..b, "None" }, "‼"))
			end
		end
		
		indexString = table.concat(indexTable, "\n")
		
		file.Write(indexDir, indexString)

		return false
	end
end

function meta:bgRewriteInventory(data)
	local indexDir = self:GetNWString("V.BG.Dir").."materials.txt"
	local indexString = table.concat(data, "\n")
	
	file.Write(indexDir, indexString)
end

function meta:bgGetEmptySlot()
	local indexInventory = self:bgGetInventory()
	
	for k, v in pairs(indexInventory) do
		local indexInformation = string.Explode("‼", v)
		
		if indexInformation[2] == "None" then
			return indexInformation[1]
		end
	end
end

function meta:bgHasItem(data)
	local indexInventory = self:bgGetInventory()
	local indexQuantity, indexSlot, indexRarity
	
	for k, v in pairs(indexInventory) do
		local indexInformation = string.Explode("‼", v)
		
		if indexInformation[3] == data[2] then
			indexQuantity = tonumber(indexInformation[2])
			indexSlot = indexInformation[1]
			indexRarity = indexInformation[4]
		end
	end
	
	if indexQuantity then
		if data[1] <= indexQuantity then
			return { indexSlot, indexQuantity, data[2], indexRarity }
		else
			return false
		end
	else
		return false
	end
end

function meta:bgAddItem(data)
	local indexInventory, indexNewInventory = self:bgGetInventory(), {}

	if self:bgHasItem({ 1, data[2] }) then
		local indexTable = self:bgHasItem({ 1, data[2] })
		local slot, oldQuantity = indexTable[1], indexTable[2]
		
		for k, v in pairs(indexInventory) do
			local indexLine = string.Explode("‼", v)

			if indexLine[1] == slot then
				table.insert(indexNewInventory, k, table.concat({ slot, data[1] + tonumber(oldQuantity), data[2], data[3] }, "‼"))
			else
				table.insert(indexNewInventory, k, v)
			end
		end
		
		
	else
		slot = self:bgGetEmptySlot()

		for k, v in pairs(indexInventory) do
			local indexLine = string.Explode("‼", v)

			if indexLine[1] == slot then
				table.insert(indexNewInventory, k, table.concat({ slot, data[1], data[2], data[3] }, "‼"))
			else
				table.insert(indexNewInventory, k, v)
			end
		end
	end
	
	self:bgRewriteInventory(indexNewInventory)
	self:notify(data[1].."x "..data[2].." picked up!")
end

function meta:bgAddItemToSlot(data, slot, oldSlot)
	local indexInventory, newInventory = self:bgGetInventory(), {}

	for k, v in pairs(indexInventory) do
		local indexLine = string.Explode("‼", v)
			
		if indexLine[1] == slot then
			if indexLine[2] == "None" then
				table.insert(newInventory, k, table.concat({ indexLine[1], data[1], data[2], data[3] }, "‼"))
			end
		elseif indexLine[1] == oldSlot then
			table.insert(newInventory, k, table.concat({ indexLine[1], "None" }, "‼"))
		else
			table.insert(newInventory, k, v)
		end
	end
	self:bgRewriteInventory(newInventory)
end

function meta:bgGetInfoAtSlot(slot)
	local indexInventory = self:bgGetInventory()
	
	for k, v in pairs(indexInventory) do
		local indexLine = string.Explode("‼", v)
		
		if indexLine[1] == slot then
			if indexLine[2] == "None" then
				return "Empty"
			else
				return { indexLine[2], indexLine[3], indexLine[4] }
			end
		end
	end
end

function meta:bgRemoveItem(data)
	local indexInventory, indexNewInventory = self:bgGetInventory(), {}
	local indexItem = self:bgHasItem(data)
	
	for k, v in pairs(indexInventory) do
		local indexLine = string.Explode("‼", v)
		
		if indexLine[1] == indexItem[1] then
			local oldQuantity = tonumber(indexLine[2])
			
			if oldQuantity > data[1] then
				table.insert(indexNewInventory, k, table.concat({ indexLine[1], oldQuantity - data[1], data[2], indexLine[4] }, "‼"))
			else
				table.insert(indexNewInventory, k, table.concat({ indexLine[1], "None"}, "‼"))
			end
		else
			table.insert(indexNewInventory, k, v)
		end
	end
	
	self:bgRewriteInventory(indexNewInventory)
	self:notify(data[1].."x "..data[2].." removed!")
end

function meta:bgReorganizeInventory()
	local x, y = VBGINVENTORYSIZE.x, VBGINVENTORYSIZE.y
	local indexTable, indexString = {}

	local oldInventory, newInventory = self:bgGetInventory(), {}
	
	for k, v in pairs(oldInventory) do
		local indexInfo = string.Explode("‼", v)
		table.insert(newInventory, { indexInfo[2], indexInfo[3], indexInfo[4] })
	end
	
	for a = 1, x do
		for b = 1, y do
			table.insert(indexTable, table.concat({ a..b, "None" }, "‼"))
		end
	end
	
	self:bgRewriteInventory(indexTable)
	
	for k, v in pairs(newInventory) do
		self:bgAddItem(v)
	end
end

function meta:bgGetLicense()
	local indexString = file.Read(self:GetNWString("V.BG.Dir").."/license.txt", "DATA")
	local indexTable = string.Explode("‼", indexString)

	return indexTable
end
	
function meta:bgSetLicense(class)
	local indexTable = {}
	local indexClass = string.Explode("‼", class)
		
	for k, v in pairs(VBGCLASS) do
		table.insert(indexTable, v[1])
	end
	
	if table.HasValue(indexTable, indexClass[1]) then
		self:SetNWString("V.BG.License", indexClass[1])
		self:SetNWString("V.BG.License.Roll", indexClass[2])
		
		local indexDir = self:GetNWString("V.BG.Dir").."license.txt"
		file.Write(indexDir, class)
	end
end

function meta:bgGetBlueprints()
	local indexDir = self:GetNWString("V.BG.Dir").."blueprints.txt"
	local indexString = file.Read(indexDir, "DATA")
	local indexTable = string.Explode("\n", indexString)
	
	return indexTable
end
	
function meta:bgAddBlueprint(data)
	local indexDir = self:GetNWString("V.BG.Dir").."blueprints.txt"
	local indexStringA = file.Read(indexDir, "DATA")
	local indexTableA = string.Explode(indexStringA, "\n")
	
	if not table.HasValue(indexTableA, data) then
		table.insert(indexTableA, data)
		
		local indexStringB = table.concat(indexTableA, "\n")
		file.Write(indexDir, indexStringB)
		
		return true
	else
		return false
	end	
end

function meta:bgGetPlayerStocks()
	local indexDir = self:GetNWString("V.BG.Dir").."stocks.txt"
	
	if file.Exists(indexDir, "DATA") then
		local indexString = file.Read(indexDir, "DATA")
		local indexTable = string.Explode("\n", indexString)
		
		return indexTable
	else
		local indexStocks = VBGSTOCKLIST
		local indexTable = {}
		
		for k, v in pairs(indexStocks) do
			table.insert(indexTable, k, table.concat({ v[1], 0 }, "‼"))
		end
		
		local indexString = table.concat(indexTable, "\n")
		
		file.Write(indexDir, indexString)
		
		return false
	end
end

function meta:bgSetPlayerStocks(data)
	data = data or self:bgGetPlayerStocks()
	
	local indexDir = self:GetNWString("V.BG.Dir").."stocks.txt"
	
	local indexString = table.concat(data, "\n")
	
	file.Write(indexDir, indexString)
end

function bgGetStocks()
	local indexDir		= "v/bg/stocks.txt"
	
	if file.Exists(indexDir, "DATA") then
		local indexString	= file.Read(indexDir, "DATA")
		local indexTable	= string.Explode("\n", indexString)
		
		return indexTable
	else
		local indexStocks = VBGSTOCKLIST
		
		local indexTable  = {}
		
		for k, v in pairs(indexStocks) do
			local name = v[1]
			local price = v[3]
			local dev	= 0
			local av = VBGSTOCKSETTING[1]
			
			local indexString = table.concat({name, price, VBGSTOCKSETTING[1], 0}, "‼")
			table.insert(indexTable, k, indexString)
		end
		
		local indexString = table.concat(indexTable, "\n")
		
		file.Write(indexDir, indexString)
		
		return false
	end
end

function bgUpStocks(data)
	local indexDir = "v/bg/stocks.txt"

	data = data or bgGetStocks()
	
	local indexString = table.concat(data, "\n")
	
	file.Write(indexDir, indexString)
end

timer.Create("V.BG.Stock.Update", VBGSTOCKSETTING[4] * 60, 0, function()
	local indexStocks = bgGetStocks()
	local indexUp = {}
	
	for k, v in pairs(indexStocks) do
		local indexStock = string.Explode("‼", v)
	
		local indexPrice = indexStock[3]
		local indexDev = VBGSTOCKSETTING[3]
		
		local data = { [1] = indexStock[1], [3] = indexStock[3] }
		local probability1 = math.random(0, 10)
		local probability2 = math.Rand(1, 1000)
		local comp
		
		if probability1 < 5 then
			comp = -1
		else
			comp = 1
		end
		data[2] = tonumber(indexStock[2]) + (tonumber(indexStock[2]) * (indexDev * (probability2 / 1000) * comp))
		data[4] = (indexDev * (probability2 / 1000) * comp)
		
		table.insert(indexUp, k, table.concat(data, "‼"))
	end
	
	bgUpStocks(indexUp)
end)

net.Receive("V.BG.Vendor.License.Buy", function(len, ply)
	local Char = ply:getChar()

	local indexPrice = net.ReadInt(32)
	local indexClass = net.ReadString()

	Char:takeMoney(indexPrice)
	ply:bgSetLicense(indexClass)
end)
	
net.Receive("V.BG.Vendor.Buy", function(len, ply)
	local Char = ply:getChar()
	local Inv = Char:getInv()
	
	local indexClass = net.ReadString()
	local indexPrice = net.ReadInt(32)
	local indexName = net.ReadString()
	
	Char:takeMoney(indexPrice)

	Inv:add(indexClass, 1, nil)

	ply:notify(indexName.." has been added to your inventory!")
end)

net.Receive("V.BG.Stock.Change", function(len, ply)
	local Data = ply:bgGetPlayerStocks()
	local newData = {}
	local Char = ply:getChar()

	local Func	 = net.ReadString()
	local Key	 = net.ReadInt(32)
	local Amount = net.ReadInt(32)
	local Price

	local oldStocks = bgGetStocks()
	local newStocks = {}
	
	for k, v in pairs(oldStocks) do
		local asd = string.Explode("‼", v)
	
		if Key == k then
			Price = math.Round(tonumber(asd[2]), 1) * Amount
		end
	end

	if Func == "Buy" then
		for k, v in pairs(Data) do
			local asd = string.Explode("‼", v)
		
			if Key != k then
				table.insert(newData, k, v)
			else
				local amountOld = string.Explode("‼", v)[2]
				local amountNew = tonumber(amountOld) + tonumber(Amount)
				
				table.insert(newData, Key, table.concat({ asd[1], amountNew }, "‼"))
			end
		end
		
		for k, v in pairs(oldStocks) do
			local asd = string.Explode("‼", v)
		
			if Key != k then
				table.insert(newStocks, k, v)
			else
				local amountOld = string.Explode("‼", v)[3]
				local amountNew = tonumber(amountOld) - tonumber(Amount)
				
				table.insert(newStocks, k, table.concat({ asd[1], asd[2], amountNew, asd[4] }, "‼"))
			end
		end
		
		ply:bgSetPlayerStocks(newData)
		Char:takeMoney(Price)
		bgUpStocks(newStocks)
	elseif Func == "Sell" then
		for k, v in pairs(Data) do
			local asd = string.Explode("‼", v)
		
			if Key != k then
				table.insert(newData, k, v)
			else
				local amountOld = string.Explode("‼", v)[2]
				local amountNew = tonumber(amountOld) - tonumber(Amount)
				
				table.insert(newData, Key, table.concat({ asd[1], amountNew }, "‼"))
			end
		end
		
		for k, v in pairs(oldStocks) do
			local asd = string.Explode("‼", v)
		
			if Key != k then
				table.insert(newStocks, k, v)
			else
				local amountOld = string.Explode("‼", v)[3]
				local amountNew = tonumber(amountOld) + tonumber(Amount)
				
				table.insert(newStocks, k, table.concat({ asd[1], asd[2], amountNew, asd[4] }, "‼"))
			end
		end
		
		ply:bgSetPlayerStocks(newData)
		bgUpStocks(newStocks)
		Char:giveMoney(Price)
	end
	
	net.Start("V.BG.Stock.Menu")
		local indexStocks = ply:bgGetPlayerStocks()
		local indexStringA = table.concat(indexStocks, "\n")
		
		local indexTableA = bgGetStocks()
		local indexTableB = {}
		
		for k, v in pairs(indexTableA) do
			local indexTableC = string.Explode("‼", v)
		
			table.insert(indexTableB, k, table.concat({ indexTableC[2], indexTableC[3] }, "‼"))
		end
		
		local indexStringB = table.concat(indexTableB, "\n")
		
		net.WriteString(indexStringA)
		net.WriteString(indexStringB)
	net.Send(ply)
end)

net.Receive("V.BG.BP.Add", function(len, ply)
	local BlueprintKey = net.ReadString()
	
	if not ply:bgAddBlueprint(BlueprintKey) then
		ply:notify("You already know this blueprint!")
	end
	
	ply:bgRemoveItem({ 1, BlueprintKey })
end)

net.Receive("V.BG.Vendor.Ammo", function(len, ply)
	local Amount = net.ReadInt(32)
	local Price = net.ReadInt(32)
	
	ply:getChar():takeMoney(Price)
	ply:GiveAmmo(tonumber(Amount), "AR2", true)
	ply:notify("Ammo received! ("..string.Comma(Amount)..")")
end)

net.Receive("V.BG.Materials.Request", function(len, ply)
	net.Start("V.BG.Materials")
		net.WriteString(table.concat(ply:bgGetInventory(), "\n"))
		net.WriteString(table.concat(ply:bgGetBlueprints(), "\n"))
	net.Send(ply)
end)

net.Receive("V.BG.Materials.Drop", function(len, ply)
	local indexQuantity = 1
	local indexName = net.ReadString()

	ply:bgRemoveItem({ tonumber(indexQuantity), indexName })
	
	if string.StartWith(indexName, "BP - ") then
		local Blueprint = ents.Create("bg_blueprint")
		
		Blueprint:SetPos(ply:EyePos() + (ply:GetForward() * 35))
		Blueprint:Spawn()
		
		Blueprint:SetNWString("V.BG.BP.Name", indexName)
		
		for k, v in pairs(VBGBP) do
			if v[1][1] == indexName then
				Blueprint:SetNWString("V.BG.Rarity", v[1][4])
			end
		end
	else
		local Part = ents.Create("bg_crafting_material")
		
		Part:SetPos(ply:EyePos() + (ply:GetForward() * 35))
		Part:Spawn()
		
		Part:SetNWString("V.BG.Key", indexName)
		for k, v in pairs(VBGMATERIALS) do
			if v[1] == indexName then
				Part:SetNWString("V.BG.Rarity", v[4])
			end
		end
	end
end)

net.Receive("V.BG.Craft", function(len, ply)
	local indexName = net.ReadString()
	
	local Blueprint
	
	for k, v in pairs(VBGBP) do
		if v[1][1] == indexName then
			Blueprint = v
		end
	end
	
	local Required = Blueprint[2]
	local Check = 0
	
	for k, v in pairs(Required) do
		if not ply:bgHasItem({ v[1], v[2] }) then
			ply:ChatPrint("You lack the required items!")
			return
		else
			Check = Check + 1
		end
	end
	
	if Check == #Required then
		local Inv = ply:getChar():getInv()
	
		Inv:add(Blueprint[1][2], 1, nil)
		
		ply:notify("You have crafted a(n) "..string.Replace(Blueprint[1][1], "BP - ", ""))
		
		for k, v in pairs(Required) do
			ply:bgRemoveItem({ v[1], v[2] })
		end
	end
end)

net.Receive("V.BG.Vendor.Faction.Init", function(len, ply)
	local indexVendor = net.ReadEntity()
	local indexFactionKey = net.ReadInt(32)
	local indexFactionName = net.ReadString()
	--local indexFactionWeapon = net.ReadString()
	--local indexFactionOutfit = net.ReadString()

	indexVendor:SetNWInt("V.BG.Vendor.Faction.Index", tonumber(indexFactionKey))
	indexVendor:SetNWString("V.BG.Vendor.Faction.Name", indexFactionName)
	--indexVendor:SetNWString("V.BG.Vendor.Faction.Weapon", indexFactionWeapon)
	--indexVendor:SetNWString("V.BG.Vendor.Faction.Outfit", indexFactionOutfit)
	indexVendor:SetNWBool("V.BG.Vendor.Init", true)
end)

net.Receive("V.BG.Vendor.Faction.Reset", function(len, ply)
	local indexVendor = net.ReadEntity()
	indexVendor:SetNWBool("V.BG.Vendor.Init", false)
end)

net.Receive("V.Vendor.Add.Outfit", function(len, ply)
	local indexClass = net.ReadString()
	local indexPrice = net.ReadInt(32)
	
	if ply:getChar():getInv():hasItem(indexClass) != false then
		ply:ChatPrint("You already have this outfit!")
	else
		if ply:getChar():hasMoney(indexPrice) then
			ply:getChar():getInv():add(indexClass, 1)
			ply:getChar():takeMoney(indexPrice)
			ply:notify("Outfit added.")
		else
			ply:ChatPrint("You can't afford that!")
		end
	end
end)

net.Receive("V.BG.Item.Move", function(len, ply)
	local oldSlot = net.ReadString()
	local newSlot = net.ReadString()
	
	local itemData = ply:bgGetInfoAtSlot(oldSlot)
	
	ply:bgAddItemToSlot({ tonumber(itemData[1]), itemData[2], itemData[3] }, newSlot, oldSlot)
	ply:notify("Item moved.")
end)

/*
hook.Add('Initialize', "V.BG.Init", function()	
	bgGetStocks()
	
	for k, v in pairs(VBGCLASS) do
		for a, b in pairs(v[2]) do
			local ITEM = nut.item.register(b[2], "base_weapons", nil, nil, true)
			ITEM.name = b[1]
			ITEM.class = b[2]
			ITEM.model = b[4]
			ITEM.desc = ""
			ITEM.category = "Blaster"
			ITEM.price = b[3]
				
			ITEM.width = 1
			ITEM.height = 1
		end
	end

	for k, v in pairs(VBGOUTFITS) do
		local ITEM = nut.item.register(v[2], "base_outfit", nil, nil, true)
		ITEM.name = v[1]
		ITEM.model = v[3]
		ITEM.replacements = v[3]
		ITEM.desc = ""
		ITEM.category = "Outfits"
		ITEM.price = 0
		
		ITEM.width = 1
		ITEM.height = 1
		
		ITEM:hook("Equip", function(item)
			item.player:SetNWString("V.BG.Armour", v[4])
		end)
		
		ITEM:hook("EquipUn", function(item)
			item.player:SetNWString("V.BG.Armour", "None")
		end)
	end
end)
*/
hook.Add('PlayerInitialSpawn', "V.BG.Player.Init", function(ply)
	local indexDir = "v/bg/"..string.lower(string.Replace(ply:SteamID(), ":", "_"))
	file.CreateDir(indexDir)
	ply:SetNWString("V.BG.Dir", indexDir.."/")
		
	if not file.Exists(indexDir.."/license.txt", "DATA") then
		file.Write(indexDir.."/license.txt", "")
		ply:SetNWString("V.BG.License", "")
	else
		local indexString = file.Read(indexDir.."/license.txt", "DATA")
		ply:SetNWString("V.BG.License", indexString)
	end
	
	if not file.Exists(indexDir.."/blueprints.txt", "DATA") then
		file.Write(indexDir.."/blueprints.txt", "")
	end
	
	ply:bgGetInventory()
	
	ply:SetNWString("V.BG.License", ply:bgGetLicense()[1])
	ply:SetNWString("V.BG.License.Roll", ply:bgGetLicense()[2])
	
	ply:bgGetPlayerStocks()
end)

hook.Add('PlayerSay', "V.BG.Command.Chat", function(ply, text)
	if string.lower(text) == VBGMATERIALSCOMMAND[2] then
		ply:ConCommand(VBGMATERIALSCOMMAND[1])
		return false
	end
end)