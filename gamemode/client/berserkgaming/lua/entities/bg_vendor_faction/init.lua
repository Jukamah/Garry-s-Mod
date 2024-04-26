AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include('shared.lua')

function ENT:Initialize()
	self:SetModel(VBGVENDORMODEL)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_TURN_HEAD)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	
	self:SetNWBool("V.BG.Vendor.Init", false)
end

function ENT:OnTakeDamage()
	return false
end

function ENT:AcceptInput(name, activator, caller)
	if name == "Use" and caller:IsPlayer() then		
		if self:GetNWBool("V.BG.Vendor.Init") then
			net.Start("V.BG.Vendor.Menu.Faction")
				net.WriteString(self:GetNWString("V.BG.Vendor.Faction.Name"))
				net.WriteInt(tonumber(self:GetNWInt("V.BG.Vendor.Faction.Index")), 32)
				--net.WriteString(self:GetNWString("V.BG.Vendor.Faction.Weapon"))
				--net.WriteString(self:GetNWString("V.BG.Vendor.Faction.Outfit"))
				net.WriteEntity(self)
			net.Send(caller)
		else
			if table.HasValue(VBGCONFIGEDIT, caller:GetNWString("usergroup")) then
				net.Start("V.BG.Vendor.Menu.Faction.Init")
					net.WriteEntity(self)
				net.Send(caller)
			else
				caller:ChatPrint("This faction vendor hasn't been set-up! Contact someone!")
			end
		end
	end
end