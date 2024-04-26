CLASS.name = "Black Sun Officer"
CLASS.faction = FACTION_BLACKSUN

function CLASS:OnSet(client)
	client:SetNWBool("V.Officer", true)
end

CLASS_BS_OFFICER = CLASS.index