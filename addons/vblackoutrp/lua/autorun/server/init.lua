local svSide = file.Find("addons/vblackoutrp/lua/*.lua", "GAME")

for k, v in pairs(svSide) do
	AddCSLuaFile(v)
	include(v)
end

hook.Add('PlayerSpawn', "BlackoutRP.Armoury.Spawn", function(ply)
	local indexWeapons = ply:getJobTable().weapons
	for _, v in pairs(indexWeapons) do
		timer.Simple(0.1, function()
			ply:StripWeapon(v)
		end)
	end
end)

util.AddNetworkString("BlackoutRP.Armoury.Menu")

util.AddNetworkString("BlackoutRP.Armoury.Withdraw")
net.Receive("BlackoutRP.Armoury.Withdraw", function(len, ply)
	ply:Give(net.ReadString(), false)
end)

util.AddNetworkString("BlackoutRP.Armoury.Restock")
net.Receive("BlackoutRP.Armoury.Restock", function(len, ply)
	local indexPrimary = net.ReadString()
	local indexSecondary = net.ReadString()

	ply:GiveAmmo(100, indexPrimary)
	ply:GiveAmmo(50, indexSecondary)
	
	print(indexPrimary)
end)

hook.Add('DarkRPVarChanged', "BlackoutRP.Armoury.Hook", function(ply, varname, oldValue, newvalue)
	timer.Simple(0.25, function()
		if varname == "job" then
			local indexWeapons = ply:getJobTable().weapons
			for _, v in pairs(indexWeapons) do
				timer.Simple(0.1, function()
					ply:StripWeapon(v)
				end)
			end
		end
	end)
end)