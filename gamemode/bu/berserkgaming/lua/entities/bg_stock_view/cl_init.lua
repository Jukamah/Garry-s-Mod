include('shared.lua')

function ENT:Draw()
    self:DrawModel()
	
	local w, h = self:GetNWInt("Width"), self:GetNWInt("Height")
	
	local posX = CurTime() * 0
	
	cam.Start3D2D(self:GetPos() + (self:GetUp() * 3), self:GetAngles(), 0.1)
		vBGDrawBackground(w, h, 4, 4)

		local indexTable = string.Explode(" | ", self:GetNWString("Text"))
		
		local indexWidth = {}
		local maxWidth, maxHeight = 0, 0
		
		for k, v in pairs(indexTable) do
			draw.DrawText(v, "V.BG.Stock.Sign", 0, vBGToY(105) * (k - 1), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			
			maxHeight = (k * vBGToY(105)) + vBGToY(20)
			
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
		
		self:SetNWInt("Width", maxWidth)
		self:SetNWInt("Height", maxHeight)
	cam.End3D2D()
end

net.Receive("V.BG.Stock.Menu.Edit", function(len, ply)
	local ent = net.ReadEntity()
	
	local Frame = vgui.Create("DFrame")
	Frame:SetSize(vBGToX(350), vBGToY(115))
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