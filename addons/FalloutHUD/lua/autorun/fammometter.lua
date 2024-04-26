if CLIENT then
	local htock = surface.GetTextureID("hud/fo/tick") 
	local hammo = surface.GetTextureID("hud/fo/ammo") 

	hook.Add("HUDPaint","DrawHUDFO",function() 
		if(GetConVar("fh_on"):GetInt() >= 1) then
			text = (Vector(219, 156, 59))

			surface.SetTexture(hammo)
			surface.SetDrawColor(text.x + 40,text.y + 40,text.z + 40,255)
			surface.DrawTexturedRectRotated( ScrW() - 170, ScrH() - 40, 390,200,0 )

			if(LocalPlayer():Armor() < 100) then
				local hl = (LocalPlayer():Armor())

				for i = 0, hl / 2.75 do
					surface.SetTexture(htock)
					surface.SetDrawColor(text.x + 25,text.y + 25,text.z + 25,255)
					surface.DrawTexturedRectRotated( ScrW()  - 90 - i * 6, ScrH() - 100, 20,24,0 )
				end
			else
				for i = 0, 36.3636 do
					surface.SetTexture(htock)
					surface.SetDrawColor(text.x + 25,text.y + 25,text.z + 25,255)
					surface.DrawTexturedRectRotated( ScrW()  - 90 - i * 6, ScrH() - 100, 20,24,0 )
				end
			end
		end
	end)
end