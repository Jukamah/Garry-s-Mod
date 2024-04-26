CLASS.name = "Coruscant Guard Officer"
CLASS.faction = FACTION_CORUSCANTGUARD

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", true)
end

CLASS_CG_OFFICER = CLASS.index