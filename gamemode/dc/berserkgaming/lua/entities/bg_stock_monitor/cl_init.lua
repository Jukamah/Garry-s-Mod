	include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

local function tradeStock(func, key, amount)
	net.Start("V.BG.Stock.Change")
		net.WriteString(func)
		net.WriteInt(key, 32)
		net.WriteInt(amount, 32)
	net.SendToServer()
end

local function availableStock(owned, total)
	local Max = tonumber(VBGSTOCKSETTING[2]) - tonumber(owned)
	
	if Max > 0 then
		
		if tonumber(Max) <= tonumber(total) then
			return tonumber(Max)
		else
			return tonumber(total)
		end
	else
		return 0
	end
end

net.Receive("V.BG.Stock.Menu", function(len, ply)
	ply = ply or LocalPlayer()
	local play = ply:getChar()

	local indexStringA = net.ReadString()
	local indexTable = string.Explode("\n", indexStringA)
	
	local indexStringB = net.ReadString()
	local indexCurrent = string.Explode("\n", indexStringB)

	//if IsValid(ply) then	
		local Frame = vgui.Create("DFrame")
		Frame:SetSize(vBGToX(350), vBGToY(500))
		Frame:Center()
		Frame:MakePopup()
		Frame:SetTitle("")
		Frame.Paint = function(self, w, h)
			vBGDrawBackground(w, h, 4, 4)
			draw.DrawText("Stock Market", "V.BG.Vendor.Title", vBGToX(10), vBGToY(3), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		Frame:ShowCloseButton(false)
		
		local StockList = vgui.Create("DScrollPanel", Frame)
		StockList:SetSize(vBGToX(340), vBGToY(460))
		StockList:SetPos(vBGToX(5), vBGToY(35))
		
		for k, v in pairs(VBGSTOCKLIST) do
			local indexStock = string.Explode("‼", indexTable[k])
			
			local indexStockStats = string.Explode("‼", indexCurrent[k])
			local indexAvailable = indexStockStats[2]
			local indexPrice = math.Round(indexStockStats[1], 0)
		
			local indexName = v[1]
			local indexDesc = v[2]
			local indexBase = v[3]
		
			local Stock = vgui.Create("DPanel", StockList)
			Stock:SetSize(vBGToX(330), vBGToY(75))
			Stock:DockMargin(vBGToX(5), vBGToY(2), vBGToX(5), vBGToY(2))
			Stock:Dock(TOP)
		
			local Owned = vgui.Create("DTextEntry", Stock)
			Owned:SetEnabled(false)
			Owned:SetNumeric(true)
			Owned:SetValue(indexStock[2])
			Owned.Paint = function(self, w, h)
				vBGDrawOutlinedBox(w, h)
				draw.DrawText(self:GetValue(), "V.BG.Stock.Under", vBGToX(25), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
			
			local Available = vgui.Create("DTextEntry", Stock)
			Available:SetEnabled(false)
			Available:SetNumeric(true)
			Available:SetValue(availableStock(indexStock[2], indexAvailable))
			Available.Paint = function(self, w, h)
				vBGDrawOutlinedBox(w, h)
				draw.DrawText(self:GetValue(), "V.BG.Stock.Under", vBGToX(25), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
			
			Stock.Paint = function(self, w, h)
				vBGDrawOutlinedBox(w, h)
				
				local indexNameUp
				
				surface.SetFont("V.BG.Vendor.Title.Item")
				if surface.GetTextSize(indexName) > vBGToX(216) then
					for i = 0, string.len(indexName), 1 do
						if surface.GetTextSize(string.Left(indexName, i).."...") <= vBGToX(216) then
							indexNameUp = string.Left(indexName, i).."..."
						end
					end
					
					draw.DrawText(indexNameUp, "V.BG.Vendor.Title.Item", vBGToX(5), vBGToY(1), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				else
					draw.DrawText(indexName, "V.BG.Vendor.Title.Item", vBGToX(5), vBGToY(1), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
				end
				
				draw.DrawText("Owned", "V.BG.Stock.Under", Stock:GetSize() - Owned:GetSize() + vBGToX(20), vBGToY(30), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
				draw.DrawText("Available", "V.BG.Stock.Under", Stock:GetSize() - Available:GetSize() - Owned:GetSize() + vBGToX(20), vBGToY(30), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
				
				vBGDrawIcon(vBGToX(5), vBGToY(32), vBGToX(12), vBGToY(15), "v/bg/ui/credit", VBGUICOLOUR["text"])
				draw.DrawText(indexPrice, "V.BG.Vendor.Item", vBGToX(17), vBGToY(30), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
			
			Owned:SetSize(vBGToX(50), vBGToY(25))
			Owned:SetPos(Stock:GetSize() - Owned:GetSize() - vBGToX(5), vBGToY(5))			
			
			Available:SetSize(vBGToX(50), vBGToY(25))
			Available:SetPos(Stock:GetSize() - Available:GetSize() - Owned:GetSize() - vBGToX(7), vBGToY(5))	
		
			local Amount = vgui.Create("DTextEntry", Stock)
		
			local Buy = vgui.Create("DButton", Stock)
			Buy:SetSize(vBGToX(50), vBGToY(25))
			Buy:SetPos(Stock:GetSize() - Available:GetSize() - Owned:GetSize() - vBGToX(7), vBGToY(45))
			Buy:SetText("")
			Buy.Paint = function(self, w, h)
				if Amount:GetValue() == "" then
					vBGDrawOutlinedButton(false, w, h, self:IsHovered())
				else
					vBGDrawOutlinedButton(tonumber(Available:GetValue()) > 0 and tonumber(Amount:GetValue()) <= availableStock(indexStock[2], indexAvailable), w, h, self:IsHovered())
				end
				draw.DrawText("Buy", "V.BG.Stock.Under", vBGToX(25), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
			Buy.DoClick = function()
				if Amount:GetValue() != "" then
					if tonumber(Amount:GetValue()) > 0 then
						if tonumber(Amount:GetValue()) <= availableStock(indexStock[2], indexAvailable) then
							if play:hasMoney(tonumber(indexPrice) * tonumber(Amount:GetValue())) then
								tradeStock("Buy", k, tonumber(Amount:GetValue()))
								Frame:Close()
							end
						end
					end
				end
			end
			
			local Sell = vgui.Create("DButton", Stock)
			Sell:SetSize(vBGToX(50), vBGToY(25))
			Sell:SetPos(Stock:GetSize() - Owned:GetSize() - vBGToX(5), vBGToY(45))
			Sell:SetText("")
			Sell.Paint = function(self, w, h)
				vBGDrawOutlinedButton(tonumber(Owned:GetValue()) > 0, w, h, self:IsHovered())
				
				if Amount:GetValue() == "" then
					vBGDrawOutlinedButton(false, w, h, self:IsHovered())
				else
					vBGDrawOutlinedButton(tonumber(Amount:GetValue()) <= tonumber(Owned:GetValue()) and tonumber(Owned:GetValue()) > 0, w, h, self:IsHovered())
				end
				draw.DrawText("Sell", "V.BG.Stock.Under", vBGToX(25), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
			Sell.DoClick = function()
				if Amount:GetValue() != "" then
					if tonumber(Amount:GetValue()) <= tonumber(Owned:GetValue()) then
						if tonumber(Amount:GetValue()) > 0 then
							if play:hasMoney(tonumber(indexPrice) * tonumber(Amount:GetValue())) then
								tradeStock("Sell", k, tonumber(Amount:GetValue()))
								Frame:Close()
							end
						end
					end
				end
			end
			
			Amount:SetSize(vBGToX(50), vBGToY(25))
			Amount:SetPos(Stock:GetSize() - Available:GetSize() - Owned:GetSize() - Amount:GetSize() - vBGToX(9), vBGToY(45))
			Amount:SetNumeric(true)
			Amount.Paint = function(self, w, h)
				vBGDrawOutlinedBox(w, h)
				draw.DrawText(self:GetValue(), "V.BG.Stock.Under", vBGToX(25), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
			end
		end
		
		local Exit = vgui.Create("DButton", Frame)
		Exit:SetSize(vBGToX(50), vBGToY(25))
		Exit:SetPos(vBGToX(295), vBGToY(5))
		Exit:SetText("")
		Exit.Paint = function(self, w, h)
			vBGDrawCloseButton(w, h, self:IsHovered())
		end
		Exit.DoClick = function()
			Frame:Close()
		end
	//end
end)