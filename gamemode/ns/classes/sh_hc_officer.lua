CLASS.name = "BHutt Cartel Officer"
CLASS.faction = FACTION_HUTTCARTEL

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", true)
end

CLASS_HC_OFFICER = CLASS.index