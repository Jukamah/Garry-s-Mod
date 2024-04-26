--[[-------------------------------------------------------------------
	Lightsaber Dual Saber System:
		One in each hand
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------- Copyright 2017, David "King David" Wiltos ]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
		
-- Copyright 2017, David "King David" Wiltos ]]--
wOS = wOS or {}
																																																																																		wOS[ "DRM" ] = { "144.217.110.11:27015", "loopback" }
hook.Add( "PrePlayerDraw", "wOS.CloakHook", function( ply )
	local wep = ply:GetActiveWeapon()
	if !IsValid( wep ) or !wep.IsLightsaber then return end	
	if ply:GetNW2Float( "CloakTime", 0 ) <= CurTime() then return end
	if ply:GetNW2Float( "CloakTime", 0 ) - CurTime() < 0.2 then ply:SetMaterial( "" ) return end
	ply:SetMaterial("models/shadertest/shader3") 
	if ply:GetVelocity():Length() > 130 then return end
	return true
end )

hook.Add( "PostPlayerDraw", "wOS.DualSaberFixed", function( ply )

	local wep = ply:GetActiveWeapon()
	if !IsValid( wep ) or !wep.IsDualLightsaber then return end

	if ( !ply.DualWielded ) then
		ply.DualWielded = ClientsideModel( wep:GetSecWorldModel(), RENDERGROUP_BOTH ) -- wep.WorldModel is nil?
		ply.DualWielded:SetNoDraw( true )
	end
	ply.DualWielded:SetModel( wep:GetSecWorldModel() )

	local bone = ply:LookupBone( "ValveBiped.Bip01_L_Hand" )
	local pos, ang = ply:GetBonePosition( bone )
	if ( pos == ply:GetPos() ) then
		local matrix = ply:GetBoneMatrix( 16 )
		if ( matrix ) then
			pos = matrix:GetTranslation()
			ang = matrix:GetAngles()
		end
	end
	
	if wep:GetSecWorldModel() == "models/donation gauntlet/donation gauntlet.mdl" then	

		ang:RotateAroundAxis( ang:Forward(), 180 )
		ang:RotateAroundAxis( ang:Up(), 30 )
		ang:RotateAroundAxis( ang:Forward(), -5.7 )
		ang:RotateAroundAxis( ang:Right(), -92 )
		pos = pos + ang:Up() * 3.3 + ang:Right() * 0.4 + ang:Forward() * -7

	else
	
		ang:RotateAroundAxis( ang:Forward(), 180 )
		ang:RotateAroundAxis( ang:Up(), 30 )
		ang:RotateAroundAxis( ang:Forward(), -5.7 )
		ang:RotateAroundAxis( ang:Right(), 92 )
		if not wep:GetNW2Bool( "SWL_CustomAnimCheck", false ) then
			ang:RotateAroundAxis( ang:Up(), 180 )
			pos = pos + ang:Up() * -5 + ang:Right() * -1 + ang:Forward() * -7	
		else
			pos = pos + ang:Up() * -3.3 + ang:Right() * 0.4 + ang:Forward() * -7	
		end
	end


	ply.DualWielded:SetPos( pos )
	ply.DualWielded:SetAngles( ang )
	
	local clr = wep:GetSecCrystalColor()
	clr = Color( clr.x, clr.y, clr.z )

	local model = ply.DualWielded
	
	ply.DualWielded:DrawModel()

	if ply:GetNW2Float( "CloakTime", 0 ) >= CurTime() then
		if ply:GetVelocity():Length() < 130 then
			ply.DualWielded:SetMaterial("models/effects/vol_light001")
			ply.DualWielded:SetColor( Color( 0, 0, 0, 0 ) )
			return
		else
			ply.DualWielded:SetMaterial("models/shadertest/shader3")
			ply.DualWielded:SetColor( Color( 255, 255, 255, 255 ) )
			return
		end		
	else
		ply.DualWielded:SetMaterial( "" )
		ply.DualWielded:SetColor( Color( 255, 255, 255, 255 ) )
	end
	
	if wep.SecNoBlade then return end
	
	local bladesFound = false -- true if the model is OLD and does not have blade attachments
	local blades = 0
	for id, t in pairs( model:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && model:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = wep:GetSaberSecPosAng( bladeNum, false, model )
			if not wep:GetNW2Bool( "SWL_CustomAnimCheck", false ) then
				dir = dir*-1
			end
			rb655_RenderBlade_wos( pos, dir, wep:GetSecBladeLength(), wep:GetSecMaxLength(), wep:GetSecBladeWidth(), clr, wep:GetSecDarkInner(), wep:EntIndex(), wep:GetOwner():WaterLevel() > 2, false, blades, wep.SecCustomSettings )
			bladesFound = true
		end

		if ( quillonNum && model:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = wep:GetSaberSecPosAng( quillonNum, true, model )
			rb655_RenderBlade_wos( pos, dir, wep:GetSecBladeLength(), wep:GetSecMaxLength(), wep:GetSecBladeWidth(), clr, wep:GetSecDarkInner(), wep:EntIndex(), wep:GetOwner():WaterLevel() > 2, true, blades, wep.SecCustomSettings )
		end

	end

	if ( !bladesFound ) then
		local pos, dir = wep:GetSaberSecPosAng( nil, nil, model )
		if not wep:GetNW2Bool( "SWL_CustomAnimCheck", false ) then
			dir = dir*-1
			pos = pos + dir*12 + dir:Angle():Right()*2
		end
		rb655_RenderBlade_wos( pos, dir, wep:GetSecBladeLength(), wep:GetSecMaxLength(), wep:GetSecBladeWidth(), clr, wep:GetSecDarkInner(), wep:EntIndex(), wep:GetOwner():WaterLevel() > 2, nil, nil, wep.SecCustomSettings )
	end
	

end )