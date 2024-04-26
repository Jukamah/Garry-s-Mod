if CLIENT then
	local settings = {}
	settings[1] = true			// True = Blinking Health Bar On Low Health
	settings[2] = false			// True = Still Bar, False = Moving Bar
	settings[3] = true			// True = Change Colour Based On Health

	// THESE ONLY APPLY WHEN SETTINGS[3] IS SET TO TRUE
	local colour = {}
	colour[1] = Color(50, 200, 50, 255)		// Colour At Full Health ( 100 - 90 Health )
	colour[2] = Color(200, 100, 0, 255)		// Colour At Injured	( 89 - 20 Health )
	colour[3] = Color(255, 150, 150, 255)	// Colour At Near Death ( 19 - 1 Health )

	colour[4] = Color(0, 0, 255, 255) 		// Detective Colour
	colour[5] = Color(0, 255, 0, 255) 		// Innocent Colour
	colour[6] = Color(255, 0, 0, 255)		// Traitor Colour
	colour[7] = Color(100, 100, 100, 255)	// Preparing/Waiting Colour

	colour[9] = Color(255, 255, 255)		// Text Colour

	colour[10] = Color(0, 200, 0)	// Health Bar Colour ( If Change Is False )
	colour[11] = Color(175, 100, 0)	// Ammo Bar Colour

	// TEXT
	local text = {}
	text[1] = "Waiting"
	text[2] = "Preparing"
	text[3] = "Haste Mode"
	text[4] = "Over Time"
	text[5] = "Round Over"

	text[6] = "Detective"
	text[7] = "Innocent"
	text[8] = "Traitor"

	// IMPORTANT MAKE SURE BOTH NAMES TO THE WEAPON ARE IN THE SAME POSITION IN THE TABLE
	// THE UNWANTED CROWBAR NAME IS FIRST, SO THE FIRST NAME WILL BE GIVEN TO IT

	// THE NAME THAT IS PRINTED THAT YOU DON'T WANT
	local fakeNames = { "crowbar_name", "unarmed_name", "magnet_name" }

	// THE NAME THAT YOU WANT
	local realNames = { "Crowbar", "Holstered", "Magneto-stick" }

	// DO NOT EDIT BELOW CODE, IF ANY PROBLEMS PERSIST CONTACT VALASKAIR

	local bool, change, initFontStat = false

	function initFont()
		surface.CreateFont("NA-HUD-ROLE", {
			font = "Roboto",
			size = ScreenScale(15),
			weight = 1000,
			antialias = true
		})
		
		surface.CreateFont("NA-HUD-POINT", {
			font = "Roboto",
			size = ScreenScale(12),
			weight = 1000,
			antialias = true
		})
		
		surface.CreateFont("NA-HUD-TIME", {
			font = "Roboto",
			size = ScreenScale(9),
			weight = 1000,
			antialias = true
		})
		
		surface.CreateFont("NA-HUD-SEL", {
			font = "Roboto",
			size = ScreenScale(7),
			weight = 1000,
			antialias = true
		})
		initFontStat = true
	end

	function draw.Circle(x, y, radius, segments)
		local circle = {}

		table.insert(circle, {x = x, y = y, u = 0.5, v = 0.5})
		for i = 0, segments do
			local a = math.rad(( i / segments) * -360)
			table.insert(circle, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })
		end

		local a = math.rad(0)
		table.insert(circle, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5 })

		draw.NoTexture()
		surface.DrawPoly(circle)
	end

	function draw.OutlinedBox(x, y, w, h, thickness, col)
		surface.SetDrawColor(col)
		for i = 0, thickness - 1 do
			surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
		end
	end

	function draw.Base(xx)
		surface.SetDrawColor(0, 0, 0, 255)
		draw.NoTexture()
		local z = {
			{ x = xx + (ScrW() * 0.4296875), y = ScrH() },
			{ x = xx + (ScrW() * 0.4296875), y = (ScrH() * 0.9444444444444444) },
			{ x = xx + (ScrW() * 0.4453125), y = (ScrH() * 0.9166666666666667) },
			{ x = xx + (ScrW() * 0.5546875), y = (ScrH() * 0.9166666666666667) },
			{ x = xx + (ScrW() * 0.5703125), y = (ScrH() * 0.9444444444444444) },
			{ x = xx + (ScrW() * 0.5703125), y = ScrH() }
		}
		surface.DrawPoly(z)
	end

	function draw.Panel(xx)
		draw.NoTexture()
		local z = {
			{ x = xx + (ScrW() * 0.4375), y = ScrH() },
			{ x = xx + (ScrW() * 0.4375), y = (ScrH() * 0.95) },
			{ x = xx + (ScrW() * 0.45), y = (ScrH() * 0.9277777777777778) },
			{ x = xx + (ScrW() * 0.55), y = (ScrH() * 0.9277777777777778) },
			{ x = xx + (ScrW() * 0.5625), y = (ScrH() * 0.95) },
			{ x = xx + (ScrW() * 0.5625), y = ScrH() }
		}
		surface.DrawPoly(z)
	end

	local function returnStatusColour(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if ply:Health() > 89 then
				return colour[1]
			elseif ply:Health() < 90 and ply:Health() > 19 then
				return colour[2]
			elseif ply:Health() < 20 and ply:Health() > 0 then
				return colour[3]
			elseif ply:Health() <= 0 then
				return Color(0, 0, 0, 255)
			end
		end
	end

	local roundStatus = "Waiting"

	hook.Add("TTTPrepareRound", "PreparingNA", function()
		roundStatus = "Preparing"
		bool = false
	end)

	hook.Add("TTTBeginRound", "BeginNA", function()
		roundStatus = "Begin"
		timer.Simple((GetConVar("ttt_haste_starting_minutes"):GetInt() * 60), function() bool = true end)
	end)

	hook.Add("TTTBeginRound", "EndNA", function(result)
		roundStatus = "End"
	end)

	local function getTime()
		return util.SimpleTime(math.max(0, GetGlobalFloat("ttt_round_end", 0) - CurTime()), "%02i:%02i")
	end

	local function returnRoleColour(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if roundStatus == "Preparing" then
				return colour[7]
			elseif roundStatus == "Being" or roundStatus == "End" then
				if ply:GetRole() == ROLE_DETECTIVE then
					return colour[4]
				elseif ply:GetRole() == ROLE_INNOCENT then
					return colour[5]
				elseif ply:GetRole() == ROLE_TRAITOR then
					return colour[6]
				else
					return colour[7]
				end
			else
				return colour[7]
			end
		end
	end

	local function returnRoleString(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if roundStatus == "Preparing" then
				return "Preparing!"
			elseif roundStatus == "Begin" or roundStatus == "End" then
				if ply:GetRole() == ROLE_DETECTIVE then
					return text[6]
				elseif ply:GetRole() == ROLE_INNOCENT then
					return text[7]
				elseif ply:GetRole() == ROLE_TRAITOR then
					return text[8]
				else
					return "Spectator"
				end
			elseif roundStatus == "Waiting" then
				return "Waiting"
			end
		end
	end

	local function getAmmoInfo(ply)
		if IsValid(ply) and ply:IsPlayer() then
			if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon() and ply:Alive() then
				local clip = ply:GetActiveWeapon():Clip1() or 0
				local clipMax = ply:GetActiveWeapon().Primary.ClipSize or 0
				local ammo = ply:GetActiveWeapon():Ammo1() or 0
				
				return clip.. " / ".. clipMax.. " : ".. ammo
			end
		end
	end

	function draw.VarBar(var, x, y, w, h, col1, col2)
		draw.NoTexture()
		surface.SetDrawColor(col1)
		surface.DrawRect(x, y, w, h)
		
		draw.NoTexture()
		surface.SetDrawColor(col2)
		surface.DrawRect(x + 2, y + 2, var * (w - 5), h - 5)
	end

	local function getWeaponName(name)
		for k, v in pairs(fakeNames) do
			if name == v then
				return realNames[k]
			end
		end
	end

	local ammoVar, barHealth, barVar, playerHealth, round
	local function showUI()
		if not initFontStat then
			initFont()
		end
		
		drawHUD()
		drawSel()
	end
	hook.Add("HUDPaint", "HUD_NEWAGE", showUI)

	function drawHUD()
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, (ScrH() * 0.9722222222222222), ScrW(), (ScrH() * 0.0277777777777778))

		draw.Base(-(ScrW() * 0.446875))
		draw.Base(0)
		draw.Base((ScrW() * 0.446875))
		
		surface.SetDrawColor(colour[7])
		draw.Panel(-(ScrW() * 0.45))	
		
		if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
			surface.SetDrawColor(returnRoleColour(LocalPlayer()))
		else
			surface.SetDrawColor(100, 100, 100, 255)
		end
		draw.Panel(0)
		if gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
			draw.SimpleText(returnRoleString(LocalPlayer()), "NA-HUD-ROLE", (ScrW() * 0.5), (ScrH() * 0.9638888888888889), colour[9], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Player", "NA-HUD-ROLE", (ScrW() * 0.5), (ScrH() * 0.9638888888888889), colour[9], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		surface.SetDrawColor(colour[7])
		draw.Panel((ScrW() * 0.45))
		
		if not settings[2] == true then
			if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():Alive() then
				ammoVar = (LocalPlayer():GetActiveWeapon():Clip1() / LocalPlayer():GetActiveWeapon().Primary.ClipSize)
			else
				ammoVar = 0
			end
			barVar = (LocalPlayer():Health() / LocalPlayer():GetMaxHealth())
		else
			ammoVar = 1
			barVar = 1
		end
		
		if settings[3] == true then
			barColour = returnStatusColour(LocalPlayer())
		else
			barColour = colour[10]
		end
		
		draw.VarBar(barVar, (ScrW() * 0.003125), (ScrH() * 0.9366666666666667), (ScrW() * 0.09375), (ScrH() * 0.0555555555555556), Color(50, 50, 50), barColour)	
		draw.VarBar(ammoVar, (ScrW() * 0.903125), (ScrH() * 0.9366666666666667), (ScrW() * 0.09375), (ScrH() * 0.0555555555555556), Color(50, 50, 50), colour[11])
		
		draw.SimpleText(LocalPlayer():Health(), "NA-HUD-POINT", (ScrW() * 0.048), (ScrH() * 0.9625), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(getAmmoInfo(LocalPlayer()), "NA-HUD-POINT", (ScrW() * 0.94375), (ScrH() * 0.9666666666666667), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText(getTime(), "NA-HUD-TIME", (ScrW() * 0.5), (ScrH() * 0.8944444444444444), colour[9], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if GetRoundState() == 1 then
			round = text[1]
		elseif GetRoundState() == 2 then
			round = text[2]
		elseif GetRoundState() == 3 then
			if bool then
				round = text[4]
			else
				round = text[3]
			end
		else
			round = text[5]
		end
		draw.SimpleText(round, "NA-HUD-TIME", (ScrW() * 0.5), (ScrH() * 0.8722222222222222), colour[9], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	local cur = 1
	function drawSel()
		if change then
			for i = 0, #(LocalPlayer():GetWeapons()) - 1, 1 do
				drawCell(i, LocalPlayer():GetWeapons()[i + 1], cur)
			end
		else
			
		end
		
		if IsValid(LocalPlayer()) and LocalPlayer():IsPlayer() and LocalPlayer():Alive() and LocalPlayer():GetWeapons()[cur] != nil then
			net.Start("WeaponSelection")
			net.WriteString(LocalPlayer():GetWeapons()[cur]:GetClass())
			net.SendToServer()
		end
	end

	function tick(x)
		timer.Stop("WeaponSel")
		change = true
		if x == 1 and cur < #(LocalPlayer():GetWeapons()) then
			cur = cur + x/2
		elseif x == -1 and cur > 1 then
			cur = cur + x/2
		end
	end


	hook.Add("PlayerBindPress", "idk", function(ply, bind, pressed) 
		if bind == "invnext" then
			tick(1)
		elseif bind == "invprev" then
			tick(-1)
		end
		
		if bind == "invnext" or bind == "invprev" then
			if not pressed and change then
				timer.Create("WeaponSel", 2, 1, function() change = false end)
			end
		end
	end)

	function drawCell(index, weapon, highlight)
		if (index + 1) == highlight then
			surface.SetDrawColor(50, 50, 150)
		else
			surface.SetDrawColor(0, 0, 0)
		end
		surface.DrawRect((ScrW() * 0.90625), (ScrH() * 0.8722222222222222) - (index * (ScrH() * 0.0555555555555556)), (ScrW() * 0.084375), (ScrH() * 0.0288888888888889))
		draw.Circle((ScrW() * 0.990625), ((ScrH() * 0.8861111111111111) - (index * (ScrH() * 0.0555555555555556))), (ScrW() * 0.0078125), 15)
		
		surface.SetDrawColor(100, 100, 100)
		surface.DrawRect((ScrW() * 0.90625), ((ScrH() * 0.8755555555555556) - (index * (ScrH() * 0.0555555555555556))), (ScrW() * 0.08125), (ScrH() * 0.0222222222222222))
		
		surface.SetDrawColor(100, 100, 255)
		draw.Circle((ScrW() * 0.90625), ((ScrH() * 0.8861111111111111) - (index * (ScrH() * 0.0555555555555556))), (ScrW() * 0.0125), 5)
		
		draw.SimpleText((index + 1), "NA-HUD-SEL", (ScrW() * 0.905625), (ScrH() * 0.8861111111111111) - (index * (ScrH() * 0.0555555555555556)), colour[9], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(getWeaponName(weapon:GetPrintName()), "NA-HUD-SEL", (ScrW() * 0.91875), (ScrH() * 0.8862) - (index * (ScrH() * 0.0555555555555556)), colour[9], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	hook.Add( "HUDShouldDraw", "hide hud", function( name )
		 if name == "CHudHealth" or name == "CHudBattery" or name == "CudWeaponSelection" then
			 return false
		 end
	end )
end