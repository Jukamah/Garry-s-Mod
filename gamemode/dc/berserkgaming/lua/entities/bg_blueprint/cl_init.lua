include('shared.lua')

function ENT:Draw()
    self:DrawModel()
	
	local ply = LocalPlayer()
	
	local offsetVector = self:GetPos() + (self:GetUp() * 2)
	local offsetAngle = self:GetAngles()
	offsetAngle:RotateAroundAxis(self:GetAngles():Up(), 90)

	cam.Start3D2D(offsetVector, offsetAngle, 0.1)
		surface.SetDrawColor(VBGUICOLOUR["base.a"].r, VBGUICOLOUR["base.a"].g, VBGUICOLOUR["base.a"].b, 100)
		surface.DrawRect(-75, -50, 150, 60)
		draw.DrawText(self:GetNWString("V.BG.BP.Name"), "V.BG.Vendor.Title", 0, -50, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
		draw.DrawText("Blueprint", "V.BG.Vendor.Title", 0, -25, VBGUICOLOUR["text"], TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

net.Receive("V.BG.Blueprint.Pickup", function(len, ply)
	ply = ply or LocalPlayer()

	local indexKey = net.ReadInt(32)
	
	local indexBlueprint = VBGBP[indexKey]
	local blueprintName = indexBlueprint[1][1]
	local indexString = net.ReadString()
	local indexTable = string.Explode("\n", indexString)
	
	local indexEntity = net.ReadEntity()
	
	if table.HasValue(indexTable, blueprintName) then
		ply:ChatPrint("You already know this blueprint!")
	else
		net.Start("V.BG.BP.Add")
			net.WriteEntity(indexEntity)
			net.WriteString(blueprintName)
		net.SendToServer()
	end
end)