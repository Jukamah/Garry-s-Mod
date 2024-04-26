AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/kiosk/kiosk.mdl" )
	self:DrawShadow(true)
	self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
	self.BuildingSound:Play()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	

end

function ENT:Use( ply )
	
	ply:SendLua( [[wOS:OpenSkillTreeMenu()]] )
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

