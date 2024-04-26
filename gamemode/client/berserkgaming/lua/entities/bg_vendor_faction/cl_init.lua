include('shared.lua')

function ENT:Draw()
    self:DrawModel()
end

net.Receive("V.BG.Vendor.Menu.Faction", function(len, ply)
	local indexName = net.ReadString()
	local indexKey = tonumber(net.ReadInt(32))
	local indexVendor = net.ReadEntity()
	
	local Outfits, canBuy, isDev
	
	ply = ply or LocalPlayer()
	local Char = ply:getChar()
	
	if indexName == "All.Dev" then
		Outfits = VFACTIONVENDOR["all"]
		canBuy = true
		isDev = true
	else
		Outfits = VFACTIONVENDOR[indexName]
		canBuy = Char:getFaction() == indexFaction
		isDev = false
	end
	print(ply:SteamID())
	//if IsValid(ply) then
		local Frame = vgui.Create("DFrame")
		Frame:SetSize(vBGToX(600), vBGToY(400))
		Frame:Center()
		Frame:MakePopup()
		Frame:SetTitle("")
		Frame:ShowCloseButton(false)
		
		Frame.Paint = function(self, w, h)
			vBGDrawBackground(w, h, 4, 4)
			draw.DrawText(indexName.." Vendor ", "V.BG.Vendor.Title", vBGToX(10), vBGToY(3), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
		end
		
		if table.HasValue(VBGCONFIGEDIT, ply:GetNWString("usergroup")) then
			local Reset = vgui.Create("DButton", Frame)
			Reset:SetSize(vBGToX(20), vBGToY(20))
			Reset:SetPos(vBGToX(520), vBGToY(5))
			Reset:SetText("")
			Reset.Paint = function(self, w, h)
				vBGDrawOutlinedButton(true, w, h, self:IsHovered())
			end
			Reset.DoClick = function()
				net.Start("V.BG.Vendor.Faction.Reset")
					net.WriteEntity(indexVendor)
				net.SendToServer()
				
				Frame:Close()
			end
		end

		local List = vgui.Create("DScrollPanel", Frame)
		List:SetSize(vBGToX(294), vBGToY(370))
		List:DockMargin(vBGToX(5), vBGToY(5), vBGToX(300), vBGToY(5))
		List:Dock(FILL)
		
		local Mdl = vgui.Create("DModelPanel", Frame)
		Mdl:SetSize(vBGToX(294), vBGToY(370))
		Mdl:DockMargin(vBGToX(300), vBGToY(5), vBGToX(5), vBGToY(5))
		Mdl:Dock(FILL)
		
		for k, v in pairs(Outfits) do
			local Name, Class, MdlStr, Price = v[1], v[2], v[3], v[4]
			
			local Outfit = vgui.Create("DButton", List)
			Outfit:SetSize(vBGToX(284), vBGToY(50))
			Outfit:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
			Outfit:Dock(TOP)
			Outfit:SetText("")
			Outfit.Paint = function(self, w, h)
				vBGDrawOutlinedButton(true, w, h, self:IsHovered())
				draw.DrawText(Name, "V.BG.Vendor.Item", vBGToX(5), vBGToY(4), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			
				vBGDrawIcon(vBGToX(5), vBGToY(26), vBGToX(14), vBGToY(17), "v/bg/ui/credit", VBGUICOLOUR["text"])
				draw.DrawText(string.Comma(Price), "V.BG.Vendor.Item", vBGToX(21), vBGToY(25), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
			end
			Outfit.DoClick = function()
				Mdl:SetModel(MdlStr)
			end
				
			local Buy = vgui.Create("DButton", Outfit)
			Buy:SetSize(vBGToX(20), vBGToY(20))
			Buy:DockMargin(vBGToX(5), vBGToY(5), vBGToX(5), vBGToY(5))
			Buy:Dock(RIGHT)
			Buy.Paint = function(self, w, h)
				vBGDrawOutlinedButton(true, w, h, self:IsHovered())
			end
			Buy:SetText("")
			Buy.DoClick = function()
				if isDev then
					if Name == "Nani!?" then
						if table.HasValue({ "STEAM_1:0:52635259", "STEAM_0:1:47057013" }, ply:SteamID()) then
							net.Start("V.Vendor.Add.Outfit")
								net.WriteString(Class)
								net.WriteInt(Price, 32)
							net.SendToServer()
						else
							ply:ChatPrint("You are not strong enough meme on em'")
						end
					else
						net.Start("V.Vendor.Add.Outfit")
							net.WriteString(Class)
							net.WriteInt(Price, 32)
						net.SendToServer()
					end
				else
					if canBuy then
						if ply:GetNWBool("V.Officer") then
							net.Start("V.Vendor.Add.Outfit")
								net.WriteString(Class)
								net.WriteInt(Price, 32)
							net.SendToServer()
						else
							ply:ChatPrint("Only officers can buy this!")
						end
					else
						ply:ChatPrint("You aren't in this faction!")
					end
				end
			end
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

net.Receive("V.BG.Vendor.Menu.Faction.Init", function(len, ply)
	local vendorEntity = net.ReadEntity()

	ply = ply or LocalPlayer()
	
	local indexFaction = {}
	
	for k, v in pairs(nut.faction.teams) do
		table.insert(indexFaction, v.index, v.name)
	end
	
	local Frame = vgui.Create("DFrame")
	Frame:SetSize(vBGToX(375), vBGToY(150))
	Frame:Center()
	Frame:MakePopup()
	Frame:SetTitle("")
	Frame:ShowCloseButton(false)
		
	Frame.Paint = function(self, w, h)
		vBGDrawBackground(w, h, 4, 4)
		draw.DrawText("Faction Vendor - Set-Up", "V.BG.Vendor.Title", vBGToX(10), vBGToY(3), VBGUICOLOUR["text"], TEXT_ALIGN_LEFT)
	end
	
	local Faction = vgui.Create("DComboBox", Frame)
	Faction:SetSize(vBGToX(180), vBGToY(30))
	Faction:SetPos(vBGToX(10), vBGToY(40))
	Faction:SetValue("<Faction>")
	for k, v in pairs(indexFaction) do
		Faction:AddChoice(table.concat({ k, v }, ":"))
	end
	Faction:AddChoice(table.concat({ 0, "All.Dev" }, ":"))
	
	/*local Weapon = vgui.Create("DComboBox", Frame)
	Weapon:SetSize(vBGToX(180), vBGToY(30))
	Weapon:SetPos(vBGToX(190), vBGToY(40))
	Weapon:SetValue("<Weapons> ( to <Who>)")
	Weapon:AddChoice("Weapons:Sell:Officer")
	Weapon:AddChoice("None")*/
	
	/*local Outfit = vgui.Create("DComboBox", Frame)
	Outfit:SetSize(vBGToX(180), vBGToY(30))
	Outfit:SetPos(vBGToX(190), vBGToY(75))
	Outfit:SetValue("<Outfits> ( to <Who>)")
	Outfit:AddChoice("Outfits:Sell:Officer")
	Outfit:AddChoice("None")*/
	
	local canSetUp = Faction:GetValue() != "<Faction>" and Weapon:GetValue() != "<Weapons>" and Outfit:GetValue() != "<Outfits>"
	
	local SetUp = vgui.Create("DButton", Frame)
	SetUp:SetSize(vBGToX(365), vBGToY(35))
	SetUp:SetPos(vBGToX(5), vBGToY(110))
	SetUp:SetText("")
	SetUp.Paint = function(self, w, h)
		vBGDrawOutlinedButton(canSetUp, w, h, self:IsHovered())
		draw.DrawText("Set Up", "V.BG.Vendor.Item", vBGToX(182.5), vBGToY(7), VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
		
		canSetUp = Faction:GetValue() != "<Faction>"
	end
	SetUp.DoClick = function()
		if canSetUp then
			local index = string.Explode(":", Faction:GetValue())
			
			net.Start("V.BG.Vendor.Faction.Init")
				net.WriteEntity(vendorEntity)
				net.WriteInt(tonumber(index[1]), 32)
				net.WriteString(index[2])
			net.SendToServer()
			
			Frame:Close()
		end
	end
	
	local Exit = vgui.Create("DButton", Frame)
	Exit:SetSize(vBGToX(40), vBGToY(20))
	Exit:SetPos(vBGToX(330), vBGToY(5))
	Exit:SetText("")
	Exit.Paint = function(self, w, h)
		vBGDrawCloseButton(w, h, Color(255, 0, 0), Color(100, 0, 0), self:IsHovered())
	end
	Exit.DoClick = function()
		Frame:Close()
	end
end)