CLASS.name = "Underworld Police"
CLASS.faction = FACTION_UNDERWORLDPOLICE

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", false)
end

CLASS_CUP_ENLISTED = CLASS.index