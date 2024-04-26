local function GetMoveVector(move)
	local angle = move:GetAngles()

	local max_speed = move:GetMaxSpeed()

	local forward = math.Clamp(move:GetForwardSpeed(), -max_speed, max_speed)
	local side = math.Clamp(move:GetSideSpeed(), -max_speed, max_speed)

	local abs_xy_move = math.abs(forward) + math.abs(side)

	if abs_xy_move == 0 then
		return Vector(0, 0, 0)
	end

	local mul = max_speed / abs_xy_move

	local vector = Vector()

	vector:Add(angle:Forward() * forward)
	vector:Add(angle:Right() * side)

	vector:Mul(mul)

	return vector
end

hook.Add("SetupMove", "Multi Jump", function(ply, move)
	if ply:OnGround() then
		ply:SetJumpLevel(0)

		return
	end	

	if not move:KeyPressed(IN_JUMP) then
		return
	end

	ply:SetJumpLevel(ply:GetJumpLevel() + 1)

	if ply:GetJumpLevel() > ply:GetMaxJumpLevel() then
		return
	end

	local velocity = GetMoveVector(move)

	velocity.z = ply:GetJumpPower() * ply:GetExtraJumpPower()

	move:SetVelocity(velocity)

	ply:DoCustomAnimEvent(PLAYERANIMEVENT_JUMP , -1)
end)