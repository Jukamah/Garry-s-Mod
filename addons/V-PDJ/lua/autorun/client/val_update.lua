hook.Add('Tick', "UpdateJumps", function(ply)
	if ply:Team() == 2 then
		ply:SetMaxJumpLevel(1)
	else
		ply:SetMaxJumpLevel(0)
	end
end)