AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/props/starwars/tech/machine.mdl" )
	self:DrawShadow(true)
	self.BuildingSound = CreateSound( self.Entity, "ambient/machines/combine_shield_loop3.wav" )
	self.BuildingSound:Play()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	

end

function ENT:Use( ply )

	if ply.InWOSCrafingMenu then return end

	local saber_craft = table.Copy( wOS.DefaultPersonalSaber )
	for typ, item in pairs( ply.PersonalSaberItems ) do
		local data = wOS:GetItemData( item )
		if not data then continue end
		if not wOS:CanEquipItem( ply, data ) then continue end
		data.OnEquip( saber_craft )
	end	
	
	net.Start( "wOS.Crafting.OpenCraftingMenu" )
		net.WriteTable( ply.PersonalSaberItems )
		net.WriteTable( ply.SecPersonalSaberItems )
		net.WriteTable( saber_craft )
		net.WriteTable( ply.SaberInventory )
		net.WriteTable( ply.SaberMiscItems )
	net.Send( ply )

	ply.InWOSCrafingMenu = true
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

