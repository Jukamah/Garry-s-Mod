CLASS.name = "Hutt Cartel Officer"
CLASS.faction = FACTION_HUTTCARTEL

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", true)
	client:ChatPrint("oof")
end

CLASS_HC_OFFICER = CLASS.index