local clSide = file.Find("addons/berserkgaming/lua/*.lua", "GAME")

for k, v in pairs(clSide) do
	include(v)
end

function vBGToX(x)
	return (x / 1768 * ScrW())
end

function vBGToY(y)
	return (y / 992 * ScrH())
end

function vBGDrawBackground(w, h, x, y)
	surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
	surface.DrawRect(0, 0, w, h)
		
	local upW, upH = w - vBGToX(4), h - vBGToY(4)

	for a = 0, x - 1, 1 do
		for b = 0, y - 1, 1 do
			surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
			surface.DrawRect(upW / x * a + vBGToX(2), upH / y * b + vBGToY(2), upW / x , upH / y)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(upW / x * a + vBGToX(3), upH / y * b + vBGToY(3), upW / x - vBGToX(2), upH / y - vBGToY(2))		
		end
	end
end

function vBGDrawOutlinedBox(w, h)
	surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(VBGUICOLOUR["base.a"])
	surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
end
	
function vBGDrawCloseButton(w, h, condition)
	if condition then
		surface.SetDrawColor(255, 0, 0)
	else
		surface.SetDrawColor(100, 0, 0)
	end
	surface.DrawRect(0, 0, w, h)
end
	
function vBGDrawOutlinedButton(enabled, w, h, condition)
	if enabled then
		if condition then
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		else
			surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		end
	else
		surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(VBGUICOLOUR["base.a"])
		surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
	end
end

function vBGDrawOutlinedButtonToggle(w, h, condition1, condition2)
	if condition1 then
		if condition2 then
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		else
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		end
	else
		if condition2 then
			surface.SetDrawColor(VBGUICOLOUR["a.accent.a"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		else
			surface.SetDrawColor(VBGUICOLOUR["a.accent.b"])
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.a"])
			surface.DrawRect(vBGToX(2), vBGToY(2), w - vBGToX(4), h - vBGToY(4))
		end
	end
end
	
function vBGDrawIcon(x, y, w, h, texture, colour)
	surface.SetDrawColor(colour)
	surface.SetTexture(surface.GetTextureID(texture))
	surface.DrawTexturedRect(x, y, w, h)
end

concommand.Add(VBGMATERIALSCOMMAND[1], function(ply)
	net.Start("V.BG.Materials.Request")
	net.SendToServer()
end)

net.Receive("V.BG.Materials", function(len, ply)
	ply = ply or LocalPlayer()
	
	local indexInventoryString = net.ReadString()
	local indexInventory = string.Explode("\n", indexInventoryString)
	
	local indexBlueprintString = net.ReadString()
	local indexBlueprint = string.Explode("\n", indexBlueprintString)

	local Frame = vgui.Create("DFrame")
	Frame:SetSize(vBGToX(600), vBGToY(350))
	Frame:Center()
	Frame:MakePopup()
	Frame:SetTitle("")
	Frame.Paint = function(self, w, h)
		vBGDrawBackground(w, h, 6, 4)
		
		draw.DrawText("Inventory - Crafting", "V.BG.Materials.Title", vBGToX(10), vBGToY(4), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
	end
	Frame:ShowCloseButton(false)
	
	local EmptyOutline = vgui.Create("DPanel", Frame)
	EmptyOutline:DockMargin(vBGToX(5), vBGToY(5), vBGToX(200), vBGToY(5))
	EmptyOutline:Dock(FILL)
	EmptyOutline.Paint = function(self, w, h)
		vBGDrawOutlinedBox(w, h)
	end
	
	local InventoryPanel = vgui.Create("DScrollPanel", Frame)
	InventoryPanel:DockMargin(vBGToX(5), vBGToY(5), vBGToX(200), vBGToY(10))
	InventoryPanel:Dock(FILL)
	InventoryPanel.Paint = function(self, w, h)
		
	end
	
	local InformationPanel = vgui.Create("DPanel", Frame)
	InformationPanel:DockMargin(vBGToX(400), vBGToY(5), vBGToX(5), vBGToY(5))
	InformationPanel:Dock(FILL)
	
	local InformationButton = vgui.Create("DButton", InformationPanel)
	InformationButton:SetSize(vBGToX(390), vBGToY(35))
	InformationButton:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
	InformationButton:Dock(BOTTOM)
	InformationButton:SetText("")
	
	local InformationButtonSecondary = vgui.Create("DButton", InformationPanel)
	InformationButtonSecondary:SetSize(vBGToX(390), vBGToY(35))
	InformationButtonSecondary:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), 0)
	InformationButtonSecondary:Dock(BOTTOM)
	InformationButtonSecondary:SetText("")
	
	local InformationButtonTertiary = vgui.Create("DButton", InformationPanel)
	InformationButtonTertiary:SetSize(vBGToX(390), vBGToY(35))
	InformationButtonTertiary:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), 0)
	InformationButtonTertiary:Dock(BOTTOM)
	InformationButtonTertiary:SetText("")
	
	local size = (vBGToX(370) - ((VBGINVENTORYSIZE.x - 1) * vBGToX(5))) / VBGINVENTORYSIZE.x
	
	local selectedSlot = ""
	local indexInfo
	local isMoving = false
	
	for k, v in pairs(indexInventory) do
		local isEmpty
	
		local indexItem = string.Explode("‼", v)
		local emptyTable = string.Explode("", indexItem[1])
		local indexSlot = { x = tonumber(emptyTable[1]), y = tonumber(emptyTable[2]) }
		
		local PanelItem = vgui.Create("DButton", InventoryPanel)
		PanelItem:SetSize(size, size)
		PanelItem:SetPos(vBGToX(5) + (indexSlot.x - 1) * (size + vBGToX(3)), vBGToY(5) + (indexSlot.y - 1) * (size + vBGToY(3)))
		PanelItem:SetText("")
		PanelItem.Paint = function(self, w, h)
			surface.SetDrawColor(VBGUICOLOUR["base.b"])
			surface.DrawRect(0, 0, w, h)

			if indexItem[2] == "None" then
				isEmpty = true
				
				if isMoving then
					draw.DrawText("Available", "V.BG.Stock.Under", size / 2, size / 3, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
				else
					draw.DrawText("Empty", "V.BG.Stock.Under", size / 2, size / 3, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
				end
			else
				isEmpty = false
				
				local Quantity, Name = indexItem[2], indexItem[3]
				
				vBGDrawOutlinedButton(true, w, h, selectedSlot == indexItem[1])
				draw.DrawText(Quantity.."x", "V.BG.Vendor.Item", vBGToX(5), vBGToY(35), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
			
			if isMoving then
				if isEmpty then
					if self:IsHovered() then
						surface.SetDrawColor(0, 0, 255, 100)
					else
						surface.SetDrawColor(0, 0, 150, 100)
					end
					surface.DrawRect(0, 0, w, h)
				end
			end
		end
		PanelItem.DoClick = function()
			if isMoving then
				net.Start("V.BG.Item.Move")
					net.WriteString(selectedSlot)
					net.WriteString(indexItem[1])
				net.SendToServer()
				
				isMoving = false
				
				Frame:Close()
			else
				if not isEmpty then
					selectedSlot = indexItem[1]
					
					indexInfo = { indexItem[2], indexItem[3], indexItem[4] }
					
					if string.StartWith(indexInfo[2], "BP - ") then
						InformationButtonSecondary:SetVisible(true)
						InformationButtonTertiary:SetVisible(true)
					else
						InformationButtonSecondary:SetVisible(true)
					end
				end
			end
		end
	end
	
	InformationPanel.Paint = function(self, w, h)
		vBGDrawOutlinedBox(w, h)
		
		if indexInfo then
			draw.DrawText("Quantity: "..indexInfo[1], "V.BG.Vendor.Item", vBGToX(5), vBGToY(25), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		
			if string.StartWith(indexInfo[2], "BP - ") then
				draw.DrawText(string.Replace(indexInfo[2], "BP - ", ""), "V.BG.Vendor.Item", vBGToX(5), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				draw.DrawText("Blueprint", "V.BG.Vendor.Item", vBGToX(5), vBGToY(45), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				draw.DrawText(table.concat({ "(", indexInfo[3], ")"}, ""), "V.BG.Vendor.Item", vBGToX(5), vBGToY(65), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			else
				draw.DrawText(indexInfo[2], "V.BG.Vendor.Item", vBGToX(5), vBGToY(5), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				draw.DrawText(table.concat({ "(", indexInfo[3], ")"}, ""), "V.BG.Vendor.Item", vBGToX(5), vBGToY(45), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
		end
	end
	
	InformationButton.Paint = function(self, w, h)
		if indexInfo != nil then
			vBGDrawOutlinedButton(indexInfo != nil, w, h, self:IsHovered())
			
			if string.StartWith(indexInfo[2], "BP - ") then
				draw.DrawText("Research", "V.BG.Vendor.Item", w / 2, h / 5, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			else
				draw.DrawText("Drop", "V.BG.Vendor.Item", w / 2, h / 5, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
		end
	end
	InformationButton.DoClick = function()
		if indexInfo != nil then			
			if string.StartWith(indexInfo[2], "BP - ") then
				if not table.HasValue(indexBlueprint, indexInfo[2]) then
					net.Start("V.BG.BP.Add")
						net.WriteString(indexInfo[2])
					net.SendToServer()
					
					Frame:Close()
				else
					ply:ChatPrint("You already know this blueprint!")
				end
			else
				net.Start("V.BG.Materials.Drop")
					net.WriteString(indexInfo[2])
				net.SendToServer()
			
				Frame:Close()
			end
		end
	end
	
	InformationButtonSecondary.Paint = function(self, w, h)
		if indexInfo != nil then
			vBGDrawOutlinedButton(indexInfo != nil, w, h, self:IsHovered())
			
			if string.StartWith(indexInfo[2], "BP - ") then
				draw.DrawText("Drop", "V.BG.Vendor.Item", w / 2, h / 5, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			else
				draw.DrawText("Move", "V.BG.Vendor.Item", w / 2, h / 5, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
		end
	end
	InformationButtonSecondary.DoClick = function()
		if indexInfo != nil then
			if string.StartWith(indexInfo[2], "BP - ") then
				net.Start("V.BG.Materials.Drop")
					net.WriteString(indexInfo[2])
				net.SendToServer()
				
				Frame:Close()
			else
				isMoving = true
			end
		end
	end
	
	InformationButtonTertiary.Paint = function(self, w, h)
		if indexInfo != nil then
			vBGDrawOutlinedButton(indexInfo != nil, w, h, self:IsHovered())
			
			if string.StartWith(indexInfo[2], "BP - ") then
				draw.DrawText("Move", "V.BG.Vendor.Item", w / 2, h / 5, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			else
				self:SetVisible(false)
			end
		end
	end
	InformationButtonTertiary.DoClick = function()
		if indexInfo != nil then
			if string.StartWith(indexInfo[2], "BP - ") then
				isMoving = true
			end
		end
	end
	
	local Close = vgui.Create("DButton", Frame)
	Close:SetSize(vBGToX(40), vBGToY(20))
	Close:SetPos(vBGToX(555), vBGToY(5))
	Close:SetText("")
	Close.Paint = function(self, w, h)
		vBGDrawCloseButton(w, h, self:IsHovered())
	end
	Close.DoClick = function()
		Frame:Close()
	end
end)