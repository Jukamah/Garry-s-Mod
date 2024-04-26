local healthStatusS = {}
healthStatusS[1] = "Healthy" 				// 100+

healthStatusS[2] = "Injured" 				// 99 - 75
healthStatusS[3] = "Majorly Injured" 		// 74 - 50
healthStatusS[4] = "Critically Injured"		// 49 - 25
healthStatusS[5] = "Dying"					// 24 - 1

healthStatusS[6] = "Dead" 					// 0-

local healthStatusC = {}
healthStatusC[1] = (Color(0, 215, 50))
healthStatusC[2] = (Color(255, 190, 50))
healthStatusC[3] = (Color(255, 50, 50))
healthStatusC[4] = (Color(0, 0, 0))

local healthStatusCB = {}
healthStatusCB[1] = (Color(0, 215, 50, 50))
healthStatusCB[2] = (Color(255, 190, 50, 50))
healthStatusCB[3] = (Color(255, 50, 50, 50))
healthStatusCB[4] = (Color(0, 0, 0, 50))

local healthStatusColor = (Color(0, 215, 50))
local armorStatusColor = (Color(100, 100, 255))

/* FOR COLOURS I SUGGEST COLORPICKER.COM THEN FIND THE COLOR AND COPY IT 
	FORMAT:
		Color(r, g, b)
		Colorpicker will tell you each (and alpha (a) but you don't need that unless you want translucent)
		Color(r, g, b, a)
*/

/* ABOVE IS CUSTOM CONFIGURATION : LIKE THE HEALTH STATUS NAMES AND COLORS */

local initFontB = false

if !ConVarExists("V-HUD-O-HEALTH") then
	CreateClientConVar("V-HUD-O-HEALTH", "0", true, false)
end

if !ConVarExists("V-HUD-O-ARMOR") then
	CreateClientConVar("V-HUD-O-ARMOR", "0", true, false)
end

function hideHUD(name)
	for k, v in pairs({"CHudHealth", "CHudBattery"})do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "HideHL2HUD", hideHUD)

function draw.OutlinedBox(x, y, w, h, thickness, col)
	surface.SetDrawColor(col)
	for i = 0, thickness - 1 do
		surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2)
	end
end

function initFont()
	surface.CreateFont("V-HUD-F1", {
		font = "Roboto",
		size = ScreenScale(10),
		weight = 1000,
		antialias = true
	})
	surface.CreateFont("V-HUD-F2", {
		font = "Roboto",
		size = ScreenScale(8),
		weight = 500,
		antialias = true
	})
	surface.CreateFont("V-HUD-F3", {
		font = "Roboto",
		size = ScreenScale(9),
		weight = 500,
		antialias = true
	})
	initFontB = true
end

function returnHealthStatusString(ply)
	if IsValid(ply) and ply:IsPlayer() then
		if ply:Health() >= 100 then
			return healthStatusS[1]
		elseif ply:Health() < 100 and ply:Health() >= 75 then
			return healthStatusS[2]
		elseif ply:Health() < 75 and ply:Health() >= 50 then
			return healthStatusS[3]
		elseif ply:Health() < 50 and ply:Health() >= 25 then
			return healthStatusS[4]
		elseif ply:Health() < 25 and ply:Health() > 0 then
			return healthStatusS[5]
		elseif ply:Health() <= 0 then
			return healthStatusS[6]
		end
	end
end

function returnHealthStatusColor(ply)
	if IsValid(ply) and ply:IsPlayer() then
		if ply:Health() >= 100 then
			return healthStatusC[1]
		elseif ply:Health() < 100 and ply:Health() >= 75 then
			return healthStatusC[2]
		elseif ply:Health() < 75 and ply:Health() >= 50 then
			return healthStatusC[2]
		elseif ply:Health() < 50 and ply:Health() >= 25 then
			return healthStatusC[3]
		elseif ply:Health() < 25 and ply:Health() > 10 then
			return healthStatusC[3]
		elseif ply:Health() <= 10 and ply:Health() > 0 then
			return healthStatusC[4]
		elseif ply:Health() <= 0 then
			return healthStatusC[4]
		end
	end
end

function returnHealthStatusColorB(ply)
	if IsValid(ply) and ply:IsPlayer() then
		if ply:Health() >= 100 then
			return healthStatusCB[1]
		elseif ply:Health() < 100 and ply:Health() >= 75 then
			return healthStatusCB[2]
		elseif ply:Health() < 75 and ply:Health() >= 50 then
			return healthStatusCB[2]
		elseif ply:Health() < 50 and ply:Health() >= 25 then
			return healthStatusCB[3]
		elseif ply:Health() < 25 and ply:Health() > 10 then
			return healthStatusCB[3]
		elseif ply:Health() <= 10 and ply:Health() > 0 then
			return healthStatusCB[4]
		elseif ply:Health() <= 0 then
			return healthStatusCB[4]
		end
	end
end

local Health = 0
local function showHUDV()
	if not initFontB then
		initFont()
	end

	local bloodMat = Material("decals/bloodstain_002")
	surface.SetMaterial(bloodMat)
	surface.SetDrawColor(Color(255, 255, 255, 135))
	surface.DrawTexturedRect(0, ScrH() - (ScrH() * 0.140625), (ScrW() * 0.3046875), (ScrH() * 0.2916666666666667), Color(195, 195, 195, 195))


	LocalPlayer().DarkRPVars = LocalPlayer().DarkRPVars or {}
	local v1 = LocalPlayer().DarkRPVars.money
	if not v1 then v1 = "" end
	local v2 = LocalPlayer().DarkRPVars.salary
	if not v2 then v2 = "" end

	-- [[ Base (Octagon + Strip)]] --
	originX = (ScrW() * 0.06875)
	originY = (ScrH() - (ScrH() * 0.12222))
	local octagonBG = {
		{x = (originX - (ScrW() * 0.03125)), y = (originY - (ScrH() * 0.11111))},
		{x = (originX + (ScrW() * 0.03125)), y = (originY - (ScrH() * 0.11111))},
		{x = (originX + (ScrW() * 0.06250)), y = (originY - (ScrH() * 0.05555))},
		{x = (originX + (ScrW() * 0.06250)), y = (originY + (ScrH() * 0.05555))},
		{x = (originX + (ScrW() * 0.03125)), y = (originY + (ScrH() * 0.11111))},
		{x = (originX - (ScrW() * 0.03125)), y = (originY + (ScrH() * 0.11111))},
		{x = (originX - (ScrW() * 0.06250)), y = (originY + (ScrH() * 0.05555))},
		{x = (originX - (ScrW() * 0.06250)), y = (originY - (ScrH() * 0.05555))}
	}
	surface.SetDrawColor( 0, 0, 0, 150 )
	draw.NoTexture()
	surface.DrawPoly(octagonBG)
	local infobarBG = {
		{x = (originX + (ScrW() * 0.203125)), y = (originY - (ScrH() * 0.08333))},
		{x = (originX + (ScrW() * 0.218750)), y = (originY - (ScrH() * 0.05555))},
		{x = (originX + (ScrW() * 0.218750)), y = (originY + (ScrH() * 0.05555))},
		{x = (originX + (ScrW() * 0.203125)), y = (originY + (ScrH() * 0.08333))},
		{x = (originX + (ScrW() * 0.046875)), y = (originY + (ScrH() * 0.08333))},
		{x = (originX + (ScrW() * 0.062500)), y = (originY + (ScrH() * 0.05555))},
		{x = (originX + (ScrW() * 0.062500)), y = (originY - (ScrH() * 0.05555))},
		{x = (originX + (ScrW() * 0.046875)), y = (originY - (ScrH() * 0.08333))}
	}
	surface.SetDrawColor( 0, 0, 0, 150 )
	draw.NoTexture()
	surface.DrawPoly(infobarBG)
	local octagon = {
		{x = (originX - (ScrW() * 0.028125)), y = (originY - (ScrH() * 0.10555))},
		{x = (originX + (ScrW() * 0.028125)), y = (originY - (ScrH() * 0.10555))},
		{x = (originX + (ScrW() * 0.059375)), y = (originY - (ScrH() * 0.05000))},
		{x = (originX + (ScrW() * 0.059375)), y = (originY + (ScrH() * 0.05000))},
		{x = (originX + (ScrW() * 0.028125)), y = (originY + (ScrH() * 0.10555))},
		{x = (originX - (ScrW() * 0.028125)), y = (originY + (ScrH() * 0.10555))},
		{x = (originX - (ScrW() * 0.059375)), y = (originY + (ScrH() * 0.05000))},
		{x = (originX - (ScrW() * 0.059375)), y = (originY - (ScrH() * 0.05000))}
	}
	surface.SetDrawColor( 50, 50, 50, 200 )
	draw.NoTexture()
	surface.DrawPoly(octagon)
	
	-- [[ Information (Name, Wallet, Income, Health, Armor) ]] --
	
	draw.OutlinedBox((originX + (ScrW() * 0.059375)), (originY - (ScrH() * 0.048)), (ScrW() * 0.125), (ScrH() * 0.09777), 2, (Color(50, 50, 50, 200)))
	
	draw.OutlinedBox((originX + (ScrW() * 0.059375)), (originY - (ScrH() * 0.048)), (ScrW() * 0.125), (ScrH() * 0.068), 2, (Color(50, 50, 50, 200)))
	
	surface.SetDrawColor(255, 255, 255)
	
	local userMaterial = (Material("icon16/user.png"))
	local walletMaterial = (Material("icon16/money.png"))
	local salaryMaterial = (Material("icon16/money_add.png"))
	
	surface.SetMaterial(userMaterial)
	surface.DrawTexturedRect((originX + (ScrW() * 0.0615)), (ScrH() - (ScrH() * 0.165)), 16, 16)
 
	surface.SetMaterial(walletMaterial)
	surface.DrawTexturedRect((originX + (ScrW() * 0.0615)), (ScrH() - (ScrH() * 0.145)), 16, 16)
 
	surface.SetMaterial(salaryMaterial)
	surface.DrawTexturedRect((originX + (ScrW() * 0.0615)), (ScrH() - (ScrH() * 0.1245)), 16, 16)
	
	draw.SimpleText(LocalPlayer():Nick(), "V-HUD-F1", (originX + (ScrW() * 0.0625)), (ScrH() - (ScrH() * 0.175)), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText(LocalPlayer().DarkRPVars.job, "V-HUD-F2", (originX + (ScrW() * 0.075)), (ScrH() - (ScrH() * 0.145)), Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Wallet: $" .. v1,    "V-HUD-F2", (originX + (ScrW() * 0.075)), (ScrH() - (ScrH() * 0.125)), Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	draw.SimpleText("Salary: $" .. v2,    "V-HUD-F2", (originX + (ScrW() * 0.075)), (ScrH() - (ScrH() * 0.105)), Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	local x, y = (ScrW() * 0.01875), (ScrH() - (ScrH() * 0.02222))
	draw.SimpleText(returnHealthStatusString(LocalPlayer()), "V-HUD-F3", ((originX + (ScrW() * 0.0025)) + (ScrW() * 0.12) / 2), (originY + (ScrH() * 0.045)), returnHealthStatusColor(LocalPlayer()), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	
	local showHealthDefault = (ScrW() * 0.1225)

	
	local showHealth = (GetConVar("V-HUD-O-HEALTH"):GetInt())
	surface.SetDrawColor(returnHealthStatusColorB(LocalPlayer()))
	if showHealth == 1 then
		if LocalPlayer():Alive() then
			if LocalPlayer():Health() < LocalPlayer():GetMaxHealth() then
				surface.DrawRect((originX + (ScrW() * 0.060625)), (originY + (ScrH() * 0.0205555555555556)), (showHealthDefault * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth())), (ScrH() * 0.02777))
			else
				surface.DrawRect((originX + (ScrW() * 0.060625)), (originY + (ScrH() * 0.0205555555555556)), showHealthDefault, (ScrH() * 0.02777))
			end
		end
	else
		surface.DrawRect((originX + (ScrW() * 0.060625)), (originY + (ScrH() * 0.019)), showHealthDefault, (ScrH() * 0.02777))
	end
	
	local showArmor = (GetConVar("V-HUD-O-ARMOR"):GetInt())
	if showArmor == 1 then
		draw.SimpleText(LocalPlayer():Armor(), "V-HUD-F3", ((originX + (ScrW() * 0.0585)) + (ScrW() * 0.12) / 2), (originY + (ScrH() * 0.075)), armorStatusColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end
end
hook.Add("HUDPaint", "HUD_VAL", showHUDV)

-- [[ Drawn Playermodel ]] --

local function PlayerModel()
	PlayerModel = vgui.Create("DModelPanel")
	function PlayerModel:LayoutEntity( Entity ) return end
	PlayerModel:SetModel( LocalPlayer():GetModel() )
	PlayerModel:SetPos((ScrW() * 0.0390625), (ScrH() * 0.75))
	PlayerModel:SetSize((ScrW() * 0.05625), (ScrH() * 0.2))
	PlayerModel:SetCamPos(Vector( 16, 0, 65 ))
	PlayerModel:SetLookAt(Vector( 0, 0, 65 ))
   
	timer.Create( "UpdatePlayerModel", 0.5, 0, function()
			if LocalPlayer():GetModel() != PlayerModel.Entity:GetModel() then
					PlayerModel:Remove()
					PlayerModel = vgui.Create("DModelPanel")
					function PlayerModel:LayoutEntity( Entity ) return end         
					PlayerModel:SetModel( LocalPlayer():GetModel())
					PlayerModel:SetPos((ScrW() * 0.0390625), (ScrH() * 0.75))
					PlayerModel:SetSize((ScrW() * 0.05625), (ScrH() * 0.2))
					PlayerModel:SetCamPos(Vector( 16, 0, 65 ))
					PlayerModel:SetLookAt(Vector( 0, 0, 65 ))
			end
	end)

end
hook.Add("InitPostEntity", "PlayerModel", PlayerModel)

local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

usermessage.Hook("GotArrested", function(msg)
	local StartArrested = CurTime()
	local ArrestedUntil = msg:ReadFloat()

	Arrested = function()
		if CurTime() - StartArrested <= ArrestedUntil and localplayer:getDarkRPVar("Arrested") then
			draw.DrawNonParsedText(DarkRP.getPhrase("youre_arrested", math.ceil(ArrestedUntil - (CurTime() - StartArrested))), "DarkRPHUD1", Scrw/2, Scrh - Scrh/12, colors.white, 1)
		elseif not localplayer:getDarkRPVar("Arrested") then
			Arrested = function() end
		end
	end
end)

local AdminTell = function() end

usermessage.Hook("AdminTell", function(msg)
	timer.Destroy("DarkRP_AdminTell")
	local Message = msg:ReadString()

	AdminTell = function()
		draw.RoundedBox(4, 10, 10, Scrw - 20, 110, colors.darkblack)
		draw.DrawNonParsedText(DarkRP.getPhrase("listen_up"), "GModToolName", Scrw / 2 + 10, 10, colors.white, 1)
		draw.DrawNonParsedText(Message, "ChatFont", Scrw / 2 + 10, 90, colors.brightred, 1)
	end

	timer.Create("DarkRP_AdminTell", 10, 1, function()
		AdminTell = function() end
	end)
end)