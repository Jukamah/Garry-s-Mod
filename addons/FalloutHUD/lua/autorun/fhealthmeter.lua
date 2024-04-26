if CLIENT then
	surface.CreateFont( "FOFont_big", {
		font      = "Impact",
		size      = 45,
		weight    = 400,
		underline = 0,
		additive  = false,
		outline = false,
		blursize = 0
	})
	surface.CreateFont( "FOFont_big_blur", {
		font      = "Impact",
		size      = 45,
		weight    = 400,
		underline = 0,
		additive  = false,
		outline = false,
		blursize = 5
	})
	surface.CreateFont( "FOFont_normal", {
		font      = "Impact",
		size      = 25,
		weight    = 400,
		underline = 0,
		additive  = false,
		outline = false,
		blursize = 0
	})
	surface.CreateFont( "FOFont_normal_blur", {
		font      = "Impact",
		size      = 25,
		weight    = 400,
		underline = 0,
		additive  = false,
		outline = false,
		blursize = 2
	})

	local function drawBlur(x,y,text,allign,blur)
		if blur == nil then blur = false end

		if(blur == false)then
			for i=0,1 do
				draw.SimpleText( text, "FOFont_normal_blur",x, y, Color(255,70,70,255),allign,0)
			end

			draw.SimpleText( text, "FOFont_normal",x, y, Color(255,70,70,255),allign,0 )
		else
			for i = 0, 1 do
				draw.SimpleText( text, "FOFont_big_blur",x, y, Color(255,70,70,255),allign,0)
			end

			draw.SimpleText( text, "FOFont_big",x, y, Color(255,70,70,255),allign,0 )
		end

	end
	
	local function drawBlurM(x,y,text,allign,blur)
		if blur == nil then blur = false end
		getHUDColor = (Vector(219, 156, 59))

		if(blur == false)then
			for i=0,1 do
				draw.SimpleText( text, "FOFont_normal_blur",x, y, Color(getHUDColor.x-20,getHUDColor.y-20,getHUDColor.z-20,200),allign,0)
			end
			draw.SimpleText( text, "FOFont_normal",x, y, Color(getHUDColor.x + 40,getHUDColor.y + 40,getHUDColor.z + 40,255),allign,0 )
		else
			for i=0,1 do
				draw.SimpleText( text, "FOFont_big_blur",x, y, Color(getHUDColor.x-20,getHUDColor.y-20,getHUDColor.z-20,200),allign,0)
			end
			draw.SimpleText( text, "FOFont_big",x, y, Color(getHUDColor.x + 40,getHUDColor.y + 40,getHUDColor.z + 40,255),allign,0 )
		end
	end
	local htick = surface.GetTextureID("hud/fo/tick") 
	local hbar = surface.GetTextureID("hud/fo/life_hud") 

	hook.Add("HUDPaint","FOHL",function()
		LocalPlayer().DarkRPVars = LocalPlayer().DarkRPVars or {}
		local v1 = LocalPlayer().DarkRPVars.money
		if not v1 then v1 = "" end
	
		if (GetConVar("fh_on"):GetInt() >= 1) then
			text = (Vector(219, 156, 59))
			
			surface.SetTexture(hbar)
			surface.SetDrawColor(text.x + 40,text.y + 40,text.z + 40,255)
			surface.DrawTexturedRectRotated( 264, ScrH() - 40, 390,200,0 )

			if(LocalPlayer():Health() <= 100 && LocalPlayer():Health() > 0) then
				hl = LocalPlayer():Health()

				for i = 0, hl / 2.75 do
					surface.SetTexture(htick)
					surface.SetDrawColor(text.x + 25,text.y + 25,text.z + 25, 255)
					surface.DrawTexturedRectRotated( 92.5 + i * 6, ScrH() - 100, 20,24,0 )
				end
			elseif (LocalPlayer():Health() > 0) then
				for i = 0, 36.3636 do
					surface.SetTexture(htick)
					surface.SetDrawColor(text.x + 25,text.y + 25,text.z + 25, 255)
					surface.DrawTexturedRectRotated(92.5 + i * 6, ScrH() - 100, 20,24,0 )
				end
			end
			
			drawBlurM(90, ScrH() - 135,"HP: "..tostring(LocalPlayer():Health()),0)
			drawBlurM(225, ScrH() - 135, "Caps: ".. tostring(v1))
			drawBlurM(ScrW() - 95, ScrH() - 135,"Armor: "..tostring(LocalPlayer():Armor()),2)

			if(LocalPlayer():GetActiveWeapon():IsValid()) then
				if LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 || LocalPlayer():GetActiveWeapon():Clip1() > -1 then
					if(LocalPlayer():GetActiveWeapon():Clip1() > -1) then
						drawBlur(ScrW() - 95,ScrH() - 80,tostring(LocalPlayer():GetActiveWeapon():Clip1()).."/"..tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())),2)
					else
						drawBlur(ScrW() - 95,ScrH() - 80,tostring(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())),2)
					end
				end
			end
		end
	end)
end


