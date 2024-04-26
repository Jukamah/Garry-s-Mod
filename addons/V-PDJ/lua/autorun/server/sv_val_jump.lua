hook.Add("OnEntityCreated", "DoubleJump", function(ply)
	if ply:IsPlayer() then
		ply:SetJumpLevel(0)
		ply:SetExtraJumpPower(1)
	end
end)

ply = (LocalPlayer())
hook.Add("Tick", "UpdateJump", function()
	if IsValid(ply) then
		if ply:Team() == 2 then 
			ply:SetMaxJumpLevel(1)
		else if ply:Team() == 1 then
			ply:SetMaxJumpLevel(0)
		end
	end
end)