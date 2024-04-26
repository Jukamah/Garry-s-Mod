CLASS.name = "Cuy'val Dar"
CLASS.faction = FACTION_CUYVALDAR

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", false)
end

CLASS_CUY_ENLISTED = CLASS.index