if SERVER then
	util.AddNetworkString("WeaponSelection")
	
	net.Receive("WeaponSelection", function(len, ply)
		local weapon = net.ReadString()
		ply:SelectWeapon(weapon)
	end)
end