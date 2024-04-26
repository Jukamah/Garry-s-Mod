include('config.lua')
AddCSLuaFile("config.lua")
AddCSLuaFile("fonts.lua")

include('outfit/init.lua')
AddCSLuaFile("outfit/cl_init.lua")

util.AddNetworkString("V.BG.Vendor.Menu.Weapons")
util.AddNetworkString("V.BG.Vendor.Menu.License")
util.AddNetworkString("V.BG.Vendor.Menu.License.BM")
util.AddNetworkString("V.BG.Vendor.License.Buy")
util.AddNetworkString("V.BG.Vendor.Buy")

util.AddNetworkString("V.BG.Crafting.Menu")
util.AddNetworkString("V.BG.Crafting.Craft")

util.AddNetworkString("V.BG.Stock.Menu")
util.AddNetworkString("V.BG.Stock.Menu.Edit")
util.AddNetworkString("V.BG.Stock.Change")

util.AddNetworkString("V.BG.Sign.Edit")

util.AddNetworkString("V.BG.Outfit.Write")

util.AddNetworkString("V.BG.Blueprint.Pickup")
util.AddNetworkString("V.BG.BP.Add")

file.CreateDir("v/bg/")

local meta = FindMetaTable("Player")
	
function meta:bgGetLicense()
	local indexString = self:GetNWString("V.BG.License", file.Read(self:GetNWString("V.BG.Dir").."/license.txt", "DATA"))
		
	return indexString
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
		data[2] = tonumber(indexStock[2]) * (1 + (indexDev * (probability2 / 1000) * comp))
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

	local indexClass = net.ReadString()
	local indexPrice = net.ReadInt(32)
	
	Char:takeMoney(indexPrice)
	/*
		Add to nutscript inventory.
	*/
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
				local amountOld = string.Explode("‼", v)[2]
				local amountNew = tonumber(amountOld) - tonumber(Amount)
				
				table.insert(newStocks, k, table.concat({ asd[1], amountNew, asd[3], asd[4] }, "‼"))
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
				local amountOld = string.Explode("‼", v)[2]
				local amountNew = tonumber(amountOld) + tonumber(Amount)
				
				table.insert(newStocks, k, table.concat({ asd[1], amountNew, asd[3], asd[4] }, "‼"))
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
	local Blueprint = net.ReadEntity()
	local BlueprintKey = net.ReadString()
	
	print(ply:bgAddBlueprint(BlueprintKey))
	Blueprint:Remove()
end)

hook.Add('Initialize', "V.BG.Init", function()
	bgGetStocks()
end)
	
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
	
	ply:bgGetPlayerStocks()
end)