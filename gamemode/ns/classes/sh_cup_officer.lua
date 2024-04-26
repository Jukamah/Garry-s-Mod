CLASS.name = "Underworld Police Officer"
CLASS.faction = FACTION_UNDERWORLDPOLICE

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", true)
end

CLASS_CUP_OFFICER = CLASS.index