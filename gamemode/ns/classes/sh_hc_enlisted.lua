CLASS.name = "Hutt Cartel"
CLASS.faction = FACTION_HUTTCARTEL

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", false)
end

CLASS_HC_ENLISTED = CLASS.index