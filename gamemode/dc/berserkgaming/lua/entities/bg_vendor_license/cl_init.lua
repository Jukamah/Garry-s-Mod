include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

net.Receive("V.BG.Vendor.Menu.License", function(len, ply)
	ply = ply or LocalPlayer()
	local Char = ply:getChar()

	//if IsValid(ply) then
		local tablePermit	= VBGPERMIT
		local tableClass	= VBGCLASS
		
		local selected = "None"

		local Frame = vgui.Create("DFrame")
		Frame:SetSize(vBGToX(600), vBGToY(400))
		Frame:Center()
		Frame:MakePopup()
		Frame:SetTitle("")
		Frame.Paint = function(self, w, h)
			vBGDrawBackground(w, h, 4, 4)
			
			draw.DrawText("License Vendor", "V.BG.Vendor.Title", vBGToX(10), vBGToY(3), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		Frame:ShowCloseButton(false)
		
		local LicenseList = vgui.Create("DPanel", Frame)
		LicenseList:SetPos(vBGToX(6), vBGToY(35))
		LicenseList:SetSize(vBGToX(292), vBGToY(360))
		LicenseList.Paint = function(self, w, h) end
		
		local InfoList = vgui.Create("DPanel", Frame)
		InfoList:SetPos(vBGToX(302), vBGToY(35))
		InfoList:SetSize(vBGToX(292), vBGToY(360))
		InfoList.Paint = function(self, w, h) 
			local info = "Licenses allow for the legal \npossession of blasters. There are \n3 classes of licenses: Alpha, \nBravo, and Charlie. Alpha allows \nfor the possession of Blaster \nPistols. Bravo, above Alpha, \nclears Alpha with the addition of \nBlaster Rifles. Charlie, above \nBravo, clears both Alpha and \nBravo with the addition of Heavy \nBlasters."
		
			draw.DrawText(info, "V.BG.Vendor.Item", vBGToX(7), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		
		for k, v in pairs(tableClass) do
			local class = tableClass[k][1]
			local price = tablePermit[tableClass[k][1]][1]
		
			local PermitInfo = vgui.Create("DButton", LicenseList)
			PermitInfo:SetText("")
			PermitInfo:SetPos(vBGToX(4), vBGToY(4) + ((k - 1) * vBGToY(90)))
			PermitInfo:SetSize(vBGToX(288), vBGToY(75))
			PermitInfo.Paint = function(self, w, h)
				vBGDrawOutlinedButtonToggle(w, h, self:IsHovered(), selected == class)
				
				draw.DrawText(class, "V.BG.Vendor.Title.Item", vBGToX(7), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				vBGDrawIcon(vBGToX(7), vBGToY(36), vBGToX(14), vBGToY(20), "v/bg/ui/credit", VBGUICOLOUR["text"])
				draw.DrawText(string.Comma(price), "V.BG.Vendor.Title.Item", vBGToX(21), vBGToY(35), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
			PermitInfo.DoClick = function()
				selected = class
			end
		end
		
		local Buy = vgui.Create("DButton", Frame)
		Buy:SetPos(vBGToX(385), vBGToY(335))
		Buy:SetSize(vBGToX(120), vBGToY(35))
		Buy:SetText("")
		Buy.Paint = function(self, w, h)
			vBGDrawOutlinedButton(selected != none, w, h, self:IsHovered())
		
			if selected != "None" then			
				local price = tablePermit[selected][1]
				draw.DrawText("Buy:", "V.BG.Vendor.Item", vBGToX(5), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				vBGDrawIcon(vBGToX(48), vBGToY(8), vBGToX(11), vBGToY(17), "v/bg/ui/credit", VBGUICOLOUR["text"])
				draw.DrawText(price, "V.BG.Vendor.Item", vBGToX(60), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
		end
		Buy.DoClick = function()
			local hasLicense = false
			if selected != "None" then
				local price = tonumber(tablePermit[selected][1])
				
				if selected == "Class Charlie" then
					if ply:GetNWString("V.BG.License") == "Class Charlie" then
						hasLicense = true
					elseif ply:GetNWString("V.BG.License") == "Class Bravo" then
						price = price - tonumber(tablePermit[selected][2])
						hasLicense = false
					elseif ply:GetNWString("V.BG.Class") == "Class Alpha" then
						price = price - tonumber(tablePermit[selected][1])
						hasLicense = false
					end
				elseif selected == "Class Bravo" then
					if ply:GetNWString("V.BG.License") == "Class Charlie" or ply:GetNWString("V.BG.License") == "Class Bravo" then
						hasLicense = true
					elseif ply:GetNWString("V.BG.License") == "Class Alpha" then
						price = price - tonumber(tablePermit[selected][1])
						hasLicense = false
					end
				elseif selected == "Class Alpha" then
					if ply:GetNWString("V.BG.License") == "Class Charlie" or ply:GetNWString("V.BG.License") == "Class Bravo" or ply:GetNWString("V.BG.License") == "Class Alpha" then
						
						hasLicense = true
					end
				end

				if not Char:hasMoney(price) then
					ply:ChatPrint("You don't have enough for that!")
				else
					if not hasLicense then
						net.Start("V.BG.Vendor.License.Buy")
							net.WriteInt(price, 32)
							net.WriteString(table.concat({selected, "real"}, "‼"))
						net.SendToServer()
						Frame:Close()
					else
						ply:ChatPrint("You already have this licenese!")
					end
				end
			end
		end
		
		local Exit = vgui.Create("DButton", Frame)
		Exit:SetSize(vBGToX(50), vBGToY(25))
		Exit:SetPos(vBGToX(545), vBGToY(5))
		Exit:SetText("")
		Exit.Paint = function(self, w, h)
			vBGDrawCloseButton(w, h, self:IsHovered())
		end
		Exit.DoClick = function()
			Frame:Close()
		end
	//end
end)