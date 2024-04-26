
include( "shared.lua" )

surface.CreateFont( "RobotoHuge", {
	font = "Roboto",
	size = 50,
	weight = 1000,
	shadow = true,
} )

ENT.lastTime = 0
ENT.rotate = 0

function ENT:Draw()
    self:DrawModel()
end