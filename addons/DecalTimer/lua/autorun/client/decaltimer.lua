Time = 600 // In seconds how often to clear decals

function ClearDecals()
	for k,v in pairs ( player.GetAll() ) do
		v:ConCommand("r_cleardecals")
		v:SendLua("game.RemoveRagdolls()")
	end
end
timer.Create("DecalTimer", Time, 0, ClearDecals)