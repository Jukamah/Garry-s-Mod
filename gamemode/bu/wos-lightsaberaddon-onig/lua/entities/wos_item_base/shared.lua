ENT.Type 		= "anim"
ENT.PrintName	= "Modular Item Base"
ENT.Author		= "King David"
ENT.Contact		= ""
ENT.Category = "wiltOS Technologies"
ENT.Spawnable			= false
ENT.AdminSpawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "ItemName" )
	self:NetworkVar( "String", 1, "ItemDescription" )
	self:NetworkVar( "Int", 0, "ItemType" )
	self:NetworkVar( "Int", 1, "Amount" )
end

