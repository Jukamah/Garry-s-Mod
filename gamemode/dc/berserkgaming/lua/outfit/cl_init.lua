concommand.Add("BG.Outfits", function(ply)
	if table.HasValue(VBGCONFIGEDIT, ply:GetNWString("usergroup")) or ply:SteamID() == "STEAM_1:1:47057013" then
		local Frame = vgui.Create("DFrame")
		Frame:SetTitle("")
		Frame:SetSize(vBGToX(215), vBGToY(265))
		Frame:Center()
		Frame:ShowCloseButton(false)
		Frame:MakePopup()
		Frame.Paint = function(self, w, h)
			vBGDrawBackground(w, h, 4, 4)
		end
		
		local Name = vgui.Create("DTextEntry", Frame)
		Name:SetPos(vBGToX(5), vBGToY(35))
		Name:SetSize(vBGToX(100), vBGToY(20))
		Name:SetValue("<Name>")
		
		local Desc = vgui.Create("DTextEntry", Frame)
		Desc:SetPos(vBGToX(110), vBGToY(35))
		Desc:SetSize(vBGToX(100), vBGToY(20))
		Desc:SetValue("<Description>")
		
		local Mdl = vgui.Create("DTextEntry", Frame)
		Mdl:SetPos(vBGToX(5), vBGToY(60))
		Mdl:SetSize(vBGToX(100), vBGToY(20))
		Mdl:SetValue("<Icon Model>")
		
		local Price = vgui.Create("DTextEntry", Frame)
		Price:SetPos(vBGToX(5), vBGToY(85))
		Price:SetSize(vBGToX(100), vBGToY(20))
		Price:SetNumeric(true)
		Price:SetValue("<Price>")
		
		local Replacement = vgui.Create("DTextEntry", Frame)
		Replacement:SetPos(vBGToX(110), vBGToY(60))
		Replacement:SetSize(vBGToX(100), vBGToY(20))
		Replacement:SetValue("<Player Model>")
		
		local ArmourType = vgui.Create("DComboBox", Frame)
		ArmourType:SetSize(vBGToX(100), vBGToY(20))
		ArmourType:SetPos(vBGToX(110), vBGToY(85))
		ArmourType:SetValue("<Armour Type>")
		for k, v in pairs(VBGARMOUR) do
			ArmourType:AddChoice(v[1])
		end
		
		local Directory = vgui.Create("DTextEntry", Frame)
		Directory:SetPos(vBGToX(5), vBGToY(110))
		Directory:SetSize(vBGToX(100), vBGToY(20))
		Directory:SetValue("v/bg/outfits.txt")
		Directory:SetEnabled(false)
		
		local Bodygroups = vgui.Create("DScrollPanel", Frame)
		Bodygroups:SetPos(vBGToX(5), vBGToY(135))
		Bodygroups:SetSize(vBGToX(205), vBGToY(95))
		
		local Table = { 
			{ false, "<Bodygroup>", "<Value>" },
			{ false, "<Bodygroup>", "<Value>" },
			{ false, "<Bodygroup>", "<Value>" },
			{ false, "<Bodygroup>", "<Value>" },
			{ false, "<Bodygroup>", "<Value>" },
		}
		for k, v in pairs(Table) do
			local Bodygroup = vgui.Create("DPanel", Bodygroups)
			Bodygroup:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
			Bodygroup:SetSize(vBGToX(195), vBGToY(34))
			Bodygroup:Dock(TOP)
			
			local Enabled = vgui.Create("DCheckBox", Bodygroup)
			Enabled:SetPos(vBGToX(5), vBGToY(9))
			Enabled:SetEnabled(false)
			Enabled:SetValue(v[1])
			
			local ID = vgui.Create("DTextEntry", Bodygroup)
			ID:SetPos(vBGToX(25), vBGToY(7))
			ID:SetSize(vBGToX(75), vBGToY(20))
			ID:SetValue(v[2])
			
			local Value = vgui.Create("DTextEntry", Bodygroup)
			Value:SetNumeric(true)
			Value:SetPos(vBGToX(105), vBGToY(7))
			Value:SetSize(vBGToX(50), vBGToY(20))
			Value:SetValue(v[3])
			
			local Insert = vgui.Create("DButton", Bodygroup)
			Insert:SetPos(vBGToX(160), vBGToY(10))
			Insert:SetSize(vBGToX(14), vBGToY(14))
			Insert:SetText("")
			Insert.DoClick = function()
				Enabled:Toggle()
			end
			
			function Enabled:OnChange(val)
				if val then
					v[1] = true
					v[2] = ID:GetValue()
					v[3] = Value:GetValue()
				else
					v[1] = false
				end
			end
		end
		
		local Generate = vgui.Create("DButton", Frame)
		Generate:SetText("Generate")
		Generate:SetSize(vBGToX(100), vBGToY(20))
		Generate:SetPos(vBGToX(5), vBGToY(235))
		Generate.DoClick = function()
			local TableUse = {}
			
			for k, v in pairs(Table) do
				if v[1] then
					table.insert(TableUse, table.concat({ v[2], v[3] }, "‼"))
				end
			end
			
			local StringUse = table.concat(TableUse, "\n")
			net.Start("V.BG.Outfit.Write")
				net.WriteString(Name:GetValue())
				net.WriteString(Desc:GetValue())
				net.WriteString(Mdl:GetValue())
				net.WriteInt(tonumber(Price:GetValue()), 32)
				net.WriteString(Replacement:GetValue())
				net.WriteString(StringUse)
				net.WriteBool(#TableUse > 0)
				net.WriteString(ArmourType:GetValue())
				net.WriteString(Directory:GetValue())
			net.SendToServer()
		end
		
		local Close = vgui.Create("DButton", Frame)
		Close:SetText("")
		Close:SetSize(vBGToX(35), vBGToY(15))
		Close:SetPos(vBGToX(175), vBGToY(5))
		Close.Paint = function(self, w, h)
			vBGDrawCloseButton(w, h, self:IsHovered())
		end
		Close.DoClick = function()
			Frame:Close()
		end
	end
end)