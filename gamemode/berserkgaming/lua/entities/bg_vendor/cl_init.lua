include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

net.Receive("V.BG.Vendor.Menu.Weapons", function(len, ply)
	ply = ply or LocalPlayer()
	local Char = ply:getChar()

	//if IsValid(ply) then
		local indexWeapon, indexAmmoPrice

		local Frame = vgui.Create("DFrame")
		Frame:SetSize(vBGToX(600), vBGToY(400))
		Frame:Center()
		Frame:MakePopup()
		Frame:SetTitle("")
		Frame:ShowCloseButton(false)
		
		local Ammo = vgui.Create("DPanel", Frame)
		Ammo:SetSize(vBGToX(265), vBGToY(40))
		Ammo:SetPos(vBGToX(12), vBGToY(40))
		Ammo.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h)
			draw.DrawText("Ammo", "V.BG.Vendor.Item", vBGToX(5), vBGToY(8), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		
		local Amount = vgui.Create("DTextEntry", Ammo)
		Amount:SetSize(vBGToX(55), vBGToY(30))
		Amount:SetPos(vBGToX(65), vBGToY(5))
		Amount:SetNumeric(true)
		Amount.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h)
			draw.DrawText(self:GetValue(), "V.BG.Vendor.Item", vBGToX(27), vBGToY(4), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
		end
		
		local Price = vgui.Create("DTextEntry", Ammo)
		Price:SetSize(vBGToX(80), vBGToY(30))
		Price:SetPos(vBGToX(125), vBGToY(5))
		Price:SetEnabled(false)
		Price.Paint = function(self, w, h)
			if Amount:GetValue() == "" then
				indexAmmoPrice = 0
			else
				indexAmmoPrice = (tonumber(Amount:GetValue()) * VBGAMMOEXCHANGE[1] / VBGAMMOEXCHANGE[2])
			end
			
			self:SetValue(indexAmmoPrice)
		
			vBGDrawOutlinedBox(w, h)
			vBGDrawIcon(vBGToX(5), vBGToY(5), vBGToX(11), vBGToY(17), "v/bg/ui/credit", VBGUICOLOUR["text"])
			draw.DrawText(string.Comma(self:GetValue()), "V.BG.Vendor.Item", vBGToX(17), vBGToY(4), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		
		local BuyAmmo = vgui.Create("DButton", Ammo)
		BuyAmmo:SetSize(vBGToX(50), vBGToY(30))
		BuyAmmo:SetPos(vBGToX(210), vBGToY(5))
		BuyAmmo:SetText("")
		BuyAmmo.Paint = function(self, w, h)
			vBGDrawOutlinedButton(Char:hasMoney(indexAmmoPrice), w, h, self:IsHovered())
			draw.DrawText("Buy", "V.BG.Vendor.Item", vBGToX(25), vBGToY(3), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			self:SetEnabled(Char:hasMoney(indexAmmoPrice) and tonumber(Amount:GetValue()) != nil)
		end
		BuyAmmo.DoClick = function()
			net.Start("V.BG.Vendor.Ammo")
				net.WriteInt(tonumber(Amount:GetValue()), 32)
				net.WriteInt(indexAmmoPrice, 32)
			net.SendToServer()
		end
		
		local WeaponList = vgui.Create("DScrollPanel", Frame)
		WeaponList:SetPos(vBGToX(6), vBGToY(80))
		WeaponList:SetSize(vBGToX(292), vBGToY(360))
		WeaponList.Paint = function(self, w, h) end
		
		local WeaponListBar = WeaponList:GetVBar()
		WeaponListBar.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h)
		end
		WeaponListBar.btnUp.Paint = function(self, w, h)
			vBGDrawOutlinedButton(true, w, h, WeaponListBar.btnUp:IsHovered())
		end
		WeaponListBar.btnDown.Paint = function(self, w, h)
			vBGDrawOutlinedButton(true, w, h, WeaponListBar.btnDown:IsHovered())
		end
		WeaponListBar.btnGrip.Paint = function(self, w, h)
			vBGDrawOutlinedButton(true, w, h, WeaponListBar.btnGrip:IsHovered())
		end
		
		local WeaponModel = vgui.Create("DModelPanel", Frame)
		WeaponModel:SetSize(vBGToX(292), vBGToY(300))
		WeaponModel:SetPos(vBGToX(304), vBGToY(35))
		
		for k, v in pairs(VBGCLASS) do
			local indexTitle = v[1]
			local indexWeapons = v[2]
			local indexHeight = #indexWeapons * vBGToY(25)
		
			local WeaponClass = vgui.Create("DPanel", WeaponList)
			WeaponClass:SetSize(vBGToX(282), vBGToY(70) + indexHeight)
			WeaponClass:Dock(TOP)
			WeaponClass.Paint = function(self, w, h)			
				draw.DrawText(indexTitle, "V.BG.Vendor.Title.Item", vBGToX(5), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
			
			for a, b in pairs(indexWeapons) do
				local indexName = b[1]
				local indexClass = b[2]
				local indexPrice = b[3]
				local indexModel = b[4]
				
				local WeaponIndex = vgui.Create("DButton", WeaponClass)
				WeaponIndex:SetPos(vBGToX(5), vBGToY(25 * a))
				WeaponIndex:SetSize(vBGToX(282), vBGToY(30))
				WeaponIndex:SetText("")
				WeaponIndex.Paint = function(self, w, h)
					local indexColour
					if indexWeapon != nil then
						if indexWeapon[1] == indexClass then
							indexColour = VBGUICOLOUR["a.accent.a"]
						else
							indexColour = VBGUICOLOUR["text"]
						end	
					else
						indexColour = VBGUICOLOUR["text"]
					end
				
					draw.DrawText(indexName, "V.BG.Vendor.Item", vBGToX(5), vBGToY(7), indexColour, TEXT_ALIGN_LEFT)
				end
				WeaponIndex.DoClick = function()
					WeaponModel:SetModel(indexModel)
					
					local indexPos = WeaponModel.Entity:GetPos()
					WeaponModel:SetLookAt(indexPos)
					WeaponModel:SetCamPos(Vector(-25, 0, 0))
					
					indexWeapon = { indexClass, indexPrice, indexTitle, indexName }
				end
			end
		end
		
		local Buy = vgui.Create("DButton", Frame)
		Buy:SetPos(vBGToX(385), vBGToY(335))
		Buy:SetSize(vBGToX(120), vBGToY(35))
		Buy:SetText("")
		Buy.Paint = function(self, w, h)
			vBGDrawOutlinedButton(indexWeapon != nil, w, h, self:IsHovered())
		
			if indexWeapon != nil then			
				local price = indexWeapon[2]
				draw.DrawText("Buy:", "V.BG.Vendor.Item", vBGToX(5), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				vBGDrawIcon(vBGToX(48), vBGToY(8), vBGToX(11), vBGToY(17), "v/bg/ui/credit", VBGUICOLOUR["text"])
				draw.DrawText(price, "V.BG.Vendor.Item", vBGToX(60), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
		end
		Buy.DoClick = function()
			if indexWeapon != nil then
				local indexPrice, indexClass, indexClearance, indexName = indexWeapon[2], indexWeapon[1], indexWeapon[3], indexWeapon[4]
				local plyClearance = ply:GetNWString("V.BG.License")
			
				if not Char:hasMoney(indexPrice) then
					ply:ChatPrint("You don't have enough for that!")
				else
					if indexClearance == "Class Charlie" then
						if plyClearance != indexClearance then
							ply:ChatPrint("You don't have the clearance for that!")
						else
							net.Start("V.BG.Vendor.Buy")
								net.WriteString(indexClass)
								net.WriteInt(tonumber(indexPrice), 32)
								net.WriteString(indexName)
							net.SendToServer()
						end
					elseif indexClearance == "Class Bravo" then
						if plyClearance == indexClearance or plyClearance == "Class Charlie" then
							net.Start("V.BG.Vendor.Buy")
								net.WriteString(indexClass)
								net.WriteInt(tonumber(indexPrice), 32)
								net.WriteString(indexName)
							net.SendToServer()	
						else
							ply:ChatPrint("You don't have the clearance for that!")
						end
					elseif indexClearance == "Class Alpha" then
						if table.HasValue({ "Class Alpha", "Class Bravo", "Class Charlie" }, plyClearance) then
							net.Start("V.BG.Vendor.Buy")
								net.WriteString(indexClass)
								net.WriteInt(tonumber(indexPrice), 32)
								net.WriteString(indexName)
							net.SendToServer()
						else
							ply:ChatPrint("You don't have the clearance for that!")
						end
					end
				end
			end
		end

		
		Frame.Paint = function(self, w, h)
			vBGDrawBackground(w, h, 4, 4)
			draw.DrawText("Weapon Vendor ", "V.BG.Vendor.Title", vBGToX(10), vBGToY(3), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		
		local Exit = vgui.Create("DButton", Frame)
		Exit:SetSize(vBGToX(50), vBGToY(20))
		Exit:SetPos(vBGToX(545), vBGToY(5))
		Exit:SetText("")
		Exit.Paint = function(self, w, h)
			vBGDrawCloseButton(w, h, Color(255, 0, 0), Color(100, 0, 0), self:IsHovered())
		end
		Exit.DoClick = function()
			Frame:Close()
		end
	//end
end)