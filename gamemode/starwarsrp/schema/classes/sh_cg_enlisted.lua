CLASS.name = "Coruscant Guard"
CLASS.faction = FACTION_CORUSCANTGUARD

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", false)
end

CLASS_CG_ENLISTED = CLASS.index