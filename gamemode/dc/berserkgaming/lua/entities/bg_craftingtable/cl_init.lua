include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

net.Receive("V.BG.Crafting.Menu", function(len, ply)
	//if IsValid(ply) then
		local tab = 1
	
		local Frame = vgui.Create("DFrame")
		Frame:SetSize(vBGToX(600), vBGToY(400))
		Frame:Center()
		Frame:MakePopup()
		Frame:SetTitle("")
		Frame.Paint = function(self, w, h)
			vBGDrawBackground(w, h, 4, 4)
			draw.DrawText("Crafting Bench", "V.BG.Vendor.Title", vBGToX(10), vBGToY(3), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		Frame:ShowCloseButton(false)
		
		local TabItems = vgui.Create("DButton", Frame)		
		TabItems:SetPos(vBGToX(5), vBGToY(45))
		TabItems:SetSize(vBGToX(75), vBGToY(25))
		TabItems:SetText("")
		TabItems.Paint = function(self, w, h) //V.BG.Crafting.Tab
			vBGDrawOutlinedButtonToggle(w, h, self:IsHovered(), tab == 1)
			
			if tab == 1 then
				draw.DrawText("Materials", "V.BG.Crafting.Tab", vBGToX(3), vBGToY(5), VBGUICOLOUR["a.accent.a"], TEXT_ALIGN_LEFT)
			else
				draw.DrawText("Materials", "V.BG.Crafting.Tab", vBGToX(3), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
		end
		
		local TabBlueprints = vgui.Create("DButton", Frame)
		TabBlueprints:SetPos(vBGToX(80), vBGToY(45))
		TabBlueprints:SetSize(vBGToX(75), vBGToY(25))
		TabBlueprints:SetText("")
		TabBlueprints.Paint = function(self, w, h)
			vBGDrawOutlinedButtonToggle(w, h, self:IsHovered(), tab == 2)
		
			if tab == 2 then
				draw.DrawText("Researched", "V.BG.Crafting.Tab", vBGToX(3), vBGToY(5), VBGUICOLOUR["a.accent.a"], TEXT_ALIGN_LEFT)
			else
				draw.DrawText("Researched", "V.BG.Crafting.Tab", vBGToX(3), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
		end
		
		local MaterialsList = vgui.Create("DPanel", Frame)
		MaterialsList:SetPos(vBGToX(5), vBGToY(70))
		MaterialsList:SetSize(vBGToX(292), vBGToY(325))
		MaterialsList.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h, VBGUICOLOUR["base.a"], VBGUICOLOUR["a.accent.a"])
		end
		
		local ResearchedList = vgui.Create("DPanel", Frame)
		ResearchedList:SetPos(vBGToX(5), vBGToY(70))
		ResearchedList:SetSize(vBGToX(292), vBGToY(325))
		ResearchedList.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h, VBGUICOLOUR["base.a"], VBGUICOLOUR["a.accent.a"])
		end
		
		local Mdl = vgui.Create("DModelPanel", Frame)
		Mdl:SetPos(vBGToX(302), vBGToY(45))
		Mdl:SetSize(vBGToX(292), vBGToY(170))
		
		local Directory = vgui.Create("DPanel", Frame)
		Directory:SetPos(vBGToX(302), vBGToY(225))
		Directory:SetSize(vBGToX(292), vBGToY(170))
		Directory.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h)
		end
		
		TabItems.DoClick = function()
			tab = 1
			
			MaterialsList:SetVisible(true)
			ResearchedList:SetVisible(false)
		end
		TabBlueprints.DoClick = function()
			tab = 2
			
			MaterialsList:SetVisible(false)
			ResearchedList:SetVisible(true)
		end
		
		local Exit = vgui.Create("DButton", Frame)
		Exit:SetSize(vBGToX(50), vBGToY(20))
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