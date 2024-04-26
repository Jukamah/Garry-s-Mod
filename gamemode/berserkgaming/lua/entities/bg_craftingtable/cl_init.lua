include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

net.Receive("V.BG.Crafting.Menu", function(len, ply)
	ply = ply or LocalPlayer()

	//if IsValid(ply) then
		local indexString = net.ReadString()
		local indexTable, indexFiltered = string.Explode("\n", indexString), {}
		local indexSelected, indexSelectedDir
		
		local indexInventoryString = net.ReadString()
		local indexInventory, indexDisplay = string.Explode("\n", indexInventoryString), {}
		
		for k, v in pairs(indexTable) do
			for a, b in pairs(VBGBP) do
				if b[1][1] == v then
					table.insert(indexFiltered, b)
				end
			end
		end
		
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
		
		local Directory = vgui.Create("DScrollPanel", Frame)
		Directory:SetPos(vBGToX(302), vBGToY(225))
		Directory:SetSize(vBGToX(292), vBGToY(170))
		Directory.Paint = function(self, w, h)
			vBGDrawOutlinedBox(w, h)
		end

		TabItems.DoClick = function()
			tab = 1
			indexSelected = 0
			Directory:Clear()
		end
		TabBlueprints.DoClick = function()
			tab = 2
			indexSelected = 0
			Directory:Clear()
		end
		
		for k, v in pairs(indexFiltered) do
			local Name, Class, Display = v[1][1], v[1][2], v[1][3]
			local Parts = v[2]
		
			local Blueprint = vgui.Create("DButton", ResearchedList)
			Blueprint:SetSize(vBGToX(282), vBGToY(35))
			Blueprint:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
			Blueprint:Dock(TOP)
			Blueprint:SetText("")
			Blueprint.Paint = function(self, w, h)
				vBGDrawOutlinedButtonToggle(w, h, indexSelected == k, self:IsHovered())
				draw.DrawText(Name, "V.BG.Vendor.Title.Item", vBGToX(141), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
			Blueprint.DoClick = function()
				indexSelected = k
				Mdl:SetModel(Display)
				
				local indexPos = Mdl.Entity:GetPos()
				Mdl:SetLookAt(indexPos)
				Mdl:SetCamPos(Vector(-25, 0, 0))
				
				Directory:Clear()
				indexSelectedDir = Parts
				
				for a, b in pairs(Parts) do
					local Quantity, Part = b[1], b[2]
					
					local InsertPart = vgui.Create("DPanel", Directory)
					InsertPart:SetSize(vBGToX(282), vBGToY(30))
					InsertPart:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
					InsertPart:Dock(TOP)
					InsertPart.Paint = function(self, w, h)
						vBGDrawOutlinedButton(true, w, h, true)
						
						draw.DrawText(Quantity.."x "..Part, "V.BG.Vendor.Item", vBGToX(5), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
					end
				end
			end
			
			local Craft = vgui.Create("DButton", Blueprint)
			Craft:SetSize(vBGToX(25), vBGToY(25))
			Craft:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
			Craft:SetText("")
			Craft:Dock(RIGHT)
			Craft.Paint = function(self, w, h)
				vBGDrawOutlinedButton(true and true, w, h, self:IsHovered())
			end
			Craft.DoClick = function()
				net.Start("V.BG.Craft")
					net.WriteString(Name)
				net.SendToServer()
			end
		end
		
		for k, v in pairs(indexInventory) do
			local indexInfo = string.Explode("‼", v)
			
			if indexInfo[2] != "None"  then
				if not string.StartWith(indexInfo[3], "BP - ") then
					table.insert(indexDisplay, v)
				end
			end
		end
		table.insert(indexDisplay, table.concat({ "§", "§", "Open Inventory" }, "‼"))
		
		for k, v in pairs(indexDisplay) do
			local indexInfo = string.Explode("‼", v)
		
			local Item = vgui.Create("DButton", MaterialsList)
			Item:SetSize(vBGToX(282), vBGToY(35))
			Item:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
			Item:Dock(TOP)
			Item:SetText("")
			Item.Paint = function(self, w, h)
				if indexInfo[3] == "Open Inventory" then
					vBGDrawOutlinedButton(true, w, h, self:IsHovered())
				else
					vBGDrawOutlinedButtonToggle(w, h, indexSelected == k, self:IsHovered())
				end	
				draw.DrawText(indexInfo[3], "V.BG.Vendor.Title.Item", vBGToX(141), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
			Item.DoClick = function()
				indexSelected = k
				
				if indexInfo[3] == "Open Inventory" then
					ply:ConCommand("V.BG.Materials")
				else
					Directory:Clear()
					
					for a, b in pairs(VBGMATERIALS) do
						if b[1] == indexInfo[3] then
							Mdl:SetModel(b[3])
							
							local indexPos = Mdl.Entity:GetPos()
							Mdl:SetLookAt(indexPos)
							Mdl:SetCamPos(Vector(-35, 0, 25))
						end
					end
					
					local indexFilteredBP = {}
					for a, b in pairs(indexFiltered) do
						for c, d in pairs(b[2]) do
							table.insert(indexFilteredBP, { b[1][1], d[2] })
						end
					end
					
					for a, b in pairs(indexFilteredBP) do
						if indexInfo[3] == b[2] then
							local InsertBP = vgui.Create("DPanel", Directory)
							InsertBP:SetSize(vBGToX(282), vBGToY(30))
							InsertBP:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
							InsertBP:Dock(TOP)
							InsertBP.Paint = function(self, w, h)
							vBGDrawOutlinedButton(true, w, h, true)	
								draw.DrawText(b[1], "V.BG.Vendor.Item", vBGToX(5), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
							end
						end
					end
				end
			end
		end
		
		local Exit = vgui.Create("DButton", Frame)
		Exit:SetSize(vBGToX(50), vBGToY(20))
		Exit:SetPos(vBGToX(545), vBGToY(5))
		Exit:SetText("")
		Exit.Paint = function(self, w, h)
			vBGDrawCloseButton(w, h, self:IsHovered())
			
			if tab == 1 then
				MaterialsList:SetVisible(true)
				ResearchedList:SetVisible(false)
			else
				MaterialsList:SetVisible(false)
				ResearchedList:SetVisible(true)
			end
		end
		Exit.DoClick = function()
			Frame:Close()
		end
	//end
end)