include('shared.lua')

function ENT:Draw()
    self:DrawModel()
	
	local w, h = self:GetNWInt("Width"), self:GetNWInt("Height")
	
	cam.Start3D2D(self:GetPos() + (self:GetUp() * 3), self:GetAngles(), 0.1)
		vBGDrawBackground(w, h, 4, 4)
		
		local indexWidth = {}
		local maxWidth, maxHeight = 0, 0
		
		local indexText = string.Explode("§", self:GetNWString("Text"))
		for k, v in pairs(indexText) do
			draw.DrawText(v, "V.BG.Stock.Sign", vBGToX(10), (k - 1) * vBGToY(100), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			
			maxHeight = vBGToY(25) + (k * vBGToY(100))
			
			surface.SetFont("V.BG.Stock.Sign")
			if indexWidth[k] != surface.GetTextSize(v) then
				table.remove(indexWidth, k)
				table.insert(indexWidth, k, surface.GetTextSize(v) + vBGToX(20))
			end
		end
		
		for k, v in pairs(indexWidth) do
			if maxWidth < v then
				maxWidth = v
			end
		end
		
		if self:GetNWBool("AutoFill") then
			self:SetNWInt("Width", maxWidth)
			self:SetNWInt("Height", maxHeight)
		end
		
	cam.End3D2D()
end

net.Receive("V.BG.Sign.Edit", function(len, ply)
	local ent = net.ReadEntity()
	
	local Frame = vgui.Create("DFrame")
	Frame:SetSize(vBGToX(350), vBGToY(220))
	Frame:Center()
	Frame:MakePopup()
	Frame:SetTitle("")
	Frame.Paint = function(self, w, h)
		vBGDrawBackground(w, h, 4, 4)
		
		draw.DrawText("Width:", "V.BG.Vendor.Title", vBGToX(12), vBGToY(30), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		draw.DrawText("Height:", "V.BG.Vendor.Title", vBGToX(5), vBGToY(67), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
	end
	Frame:ShowCloseButton(false)
	
	local Width = vgui.Create("DTextEntry", Frame)
	Width:SetNumeric(true)
	Width:SetSize(vBGToX(235), vBGToY(35))
	Width:SetPos(vBGToX(105), vBGToY(30))
	Width:SetValue(ent:GetNWInt("Width"))
	Width.Paint = function(self, w, h)
		vBGDrawOutlinedBox(w, h)
		
		draw.DrawText(self:GetValue(), "V.BG.Vendor.Title.Item", vBGToX(5), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		
		if self:GetValue() != nil then
			ent:SetNWInt("Width", self:GetValue())
		end
	end
	
	local Height = vgui.Create("DTextEntry", Frame)
	Height:SetNumeric(true)
	Height:SetSize(vBGToX(235), vBGToY(35))
	Height:SetPos(vBGToX(105), vBGToY(70))
	Height:SetValue(ent:GetNWInt("Height"))
	Height.Paint = function(self, w, h)
		vBGDrawOutlinedBox(w, h)
	
		draw.DrawText(self:GetValue(), "V.BG.Vendor.Title.Item", vBGToX(5), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
	
		if self:GetValue() != nil then
			ent:SetNWInt("Height", self:GetValue())
		end
	end
	
	local AddLine = vgui.Create("DButton", Frame)
	AddLine:SetText("Add Line")
	AddLine:SetPos(vBGToX(10), vBGToY(115))
	AddLine.Paint = function(self, w, h)
		vBGDrawOutlinedButton(true, w, h, self:IsHovered())
	end
	
	local Autofill = vgui.Create("DCheckBoxLabel", Frame)
	Autofill:SetPos(vBGToX(80), vBGToY(120))
	Autofill:SetText("Autofill to Text")
	Autofill:SetValue(ent:GetNWBool("AutoFill"))
	function Autofill:OnChange(val)
		ent:SetNWBool("AutoFill", val)
		
		Width:SetEnabled(!val)
		Height:SetEnabled(!val)
	end
	
	local TextList = vgui.Create("DScrollPanel", Frame)
	TextList:SetPos(vBGToX(5), vBGToY(140))
	TextList:SetSize(vBGToX(340), vBGToY(75))

	local indexText = string.Explode("§", ent:GetNWString("Text"))
	
	for k, v in pairs(indexText) do
		local Text = vgui.Create("DTextEntry", TextList)
		Text:SetSize(vBGToX(330), vBGToY(35))
		Text:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
		Text:Dock(TOP)
		Text:SetValue(v)
		Text.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h)
		
			draw.DrawText(self:GetValue(), "V.BG.Vendor.Title.Item", vBGToX(5), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		Text.OnEnter = function()
			local indexTable = indexText
			table.remove(indexTable, k)
			table.insert(indexTable, k, Text:GetValue())
		
			local indexString = table.concat(indexText, "§")
			ent:SetNWString("Text", indexString)
		end
		print(ent:GetNWString("Text"))
	end
	
	AddLine.DoClick = function()
		table.insert(indexText, "New Line")
		local indexString = table.concat(indexText, "§")
		ent:SetNWString("Text", indexString)
	end
		
	local Exit = vgui.Create("DButton", Frame)
	Exit:SetSize(vBGToX(40), vBGToY(20))
	Exit:SetPos(vBGToX(305), vBGToY(5))
	Exit:SetText("")
	Exit.Paint = function(self, w, h)
		vBGDrawCloseButton(w, h, self:IsHovered())
	end
	Exit.DoClick = function()
		Frame:Close()
	end
end)