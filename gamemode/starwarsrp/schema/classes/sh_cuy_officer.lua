CLASS.name = "Cuy'val Dar"
CLASS.faction = FACTION_CUYVALDAR

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", true)
end

CLASS_CUY_OFFICER = CLASS.index