include('shared.lua')

local function brpTo(x, var)
	if x then
		return ((var / 1768) * ScrW())
	else
		return ((var / 992) * ScrH())
	end
end

// Source: https://wiki.garrysmod.com/page/surface/DrawPoly
local function DrawCircle(x, y, radius, seg)
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function ENT:Draw()
    self:DrawModel()
	
	cam.Start3D2D(self:GetPos() + (self:GetUp() * 3), self:GetAngles(), 0.1)
		
	cam.End3D2D()
end

net.Receive("BlackoutRP.Armoury.Menu", function()
	local ply = LocalPlayer()

	local indexWeapons = ply:getJobTable().weapons
	local indexDisplay = {}
	
	for _, indexWeapon in pairs(indexWeapons) do
		local indexWeaponData = weapons.GetStored(indexWeapon)
		table.insert(indexDisplay, { 
			indexWeaponData.PrintName, 
			indexWeaponData.WorldModel,
			indexWeapon,
			indexWeaponData.Primary.Ammo,
			indexWeaponData.Secondary.Ammo,
		})
	end

	local Frame = vgui.Create("DFrame")
	Frame:SetSize(brpTo(true, 700), brpTo(false, 384))
	Frame:Center()
	Frame:MakePopup()
	Frame:SetTitle("")
	Frame.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 150)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(brpTo(true, 2), brpTo(false, 2), (w - brpTo(true, 4)), (h - brpTo(false, 4)))
	end
	Frame:ShowCloseButton(false)
	
	local PanelWeapon = vgui.Create("DPanel", Frame)
	PanelWeapon:SetSize(brpTo(true, 344), brpTo(false, 350))
	PanelWeapon:SetPos(brpTo(true, 4), brpTo(false, 30))
	PanelWeapon.Paint = function(self, w, h)
		surface.SetDrawColor(0, 0, 150)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(brpTo(true, 2), brpTo(false, 2), (w - brpTo(true, 4)), (h - brpTo(false, 4)))
	end
	
	
	local PanelModel = vgui.Create("DModelPanel", Frame)
	PanelModel:SetSize(brpTo(true, 344), brpTo(false, 350))
	PanelModel:SetPos(brpTo(true, 352), brpTo(false, 30))
	
	local indexSelected = 0
	for k, v in pairs(indexDisplay) do
		local indexName, indexModel, indexClass = v[1], v[2], v[3]
		local indexPrimary, indexSecondary = v[4], v[5]
		
		local Weapon = vgui.Create("DButton", PanelWeapon)
		Weapon:SetSize(brpTo(true, 340), brpTo(false, 40))
		Weapon:DockMargin(brpTo(true, 5), brpTo(false, 5), brpTo(true, 5), brpTo(false, 5))
		Weapon:Dock(TOP)
		Weapon:SetText("")
		Weapon.Paint = function(self, w, h)
			if self:IsHovered() then
				surface.SetDrawColor(0, 0, 255)
			else
				surface.SetDrawColor(0, 0, 150)
			end
			surface.DrawRect(0, 0, w, h)
			if indexSelected == k then
				surface.SetDrawColor(25, 25, 25)
			else
				surface.SetDrawColor(0, 0, 0)
			end
			surface.DrawRect(brpTo(true, 2), brpTo(false, 2), (w - brpTo(true, 4)), (h - brpTo(false, 4)))
			draw.DrawText(indexName, "BRP.Armoury.Weapon", brpTo(true, 5), brpTo(false, 7), Color(255, 255, 255), TEXT_ALIGN_LEFT)
		end
		Weapon.DoClick = function()
			indexSelected = k
			
			PanelModel:SetModel(indexModel)
			local indexPos = PanelModel.Entity:GetPos()
			PanelModel:SetLookAt(indexPos)
			PanelModel:SetCamPos(Vector(-25, 0, 15))
		end
		
		local Withdraw = vgui.Create("DButton", Weapon)
		Withdraw:SetSize(brpTo(true, 30), brpTo(false, 30))
		Withdraw:DockMargin(brpTo(true, 5), brpTo(false, 5), brpTo(true, 5), brpTo(false, 5))
		Withdraw:Dock(RIGHT)
		Withdraw:SetText("")
		Withdraw.Paint = function(self, w, h)
			if self:IsHovered() then
				surface.SetDrawColor(0, 0, 255)
			else
				surface.SetDrawColor(0, 0, 150)
			end
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(brpTo(true, 2), brpTo(false, 2), (w - brpTo(true, 4)), (h - brpTo(false, 4)))
		
			if self:IsHovered() then
				surface.SetDrawColor(0, 0, 255)
			else
				surface.SetDrawColor(0, 0, 150)
			end
			surface.DrawRect(brpTo(true, 4), brpTo(false, 12), brpTo(true, 21), brpTo(false, 5))
			surface.DrawRect(brpTo(true, 12), brpTo(false, 4), brpTo(true, 5), brpTo(false, 21))
		end
		Withdraw.DoClick = function()
			net.Start("BlackoutRP.Armoury.Withdraw")
				net.WriteString(indexClass)
			net.SendToServer()
		end
		
		local Restock = vgui.Create("DButton", Weapon)
		Restock:SetSize(brpTo(true, 30), brpTo(false, 30))
		Restock:DockMargin(brpTo(true, 5), brpTo(false, 5), brpTo(true, 5), brpTo(false, 5))
		Restock:Dock(RIGHT)
		Restock:SetText("")
		Restock.Paint = function(self, w, h)
			if self:IsHovered() then
				surface.SetDrawColor(0, 0, 255)
			else
				surface.SetDrawColor(0, 0, 150)
			end
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(brpTo(true, 2), brpTo(false, 2), (w - brpTo(true, 4)), (h - brpTo(false, 4)))
		
			if self:IsHovered() then
				surface.SetDrawColor(0, 0, 255)
			else
				surface.SetDrawColor(0, 0, 150)
			end
			DrawCircle(brpTo(true, 9), brpTo(false, 10), brpTo(true, 5), 50)
			DrawCircle(brpTo(true, 21), brpTo(false, 10), brpTo(true, 5), 50)
			
			surface.SetDrawColor(0, 0, 0)
			surface.DrawRect(brpTo(true, 3), brpTo(false, 10), (w - brpTo(true, 6)), brpTo(false, 10))
			
			if self:IsHovered() then
				surface.SetDrawColor(0, 0, 255)
			else
				surface.SetDrawColor(0, 0, 150)
			end
			surface.DrawRect(brpTo(true, 4), brpTo(false, 13), brpTo(true, 10), brpTo(false, 13))
			surface.DrawRect(brpTo(true, 16), brpTo(false, 13), brpTo(true, 10), brpTo(false, 13))
		end
		Restock.DoClick = function()
			net.Start("BlackoutRP.Armoury.Restock")
				net.WriteString(indexPrimary)
				net.WriteString(indexSecondary)
			net.SendToServer()
		end
	end
	
	local Close = vgui.Create("DButton", Frame)
	Close:SetSize(brpTo(true, 45), brpTo(false, 20))
	Close:SetPos(brpTo(true, 650), brpTo(false, 5))
	Close:SetText("")
	Close.Paint = function(self, w, h)
		if self:IsHovered() then
			surface.SetDrawColor(255, 0, 0)
		else
			surface.SetDrawColor(200, 0, 0)
		end
		surface.DrawRect(0, 0, w, h)
	end
	Close.DoClick = function()
		Frame:Close()
	end
end)