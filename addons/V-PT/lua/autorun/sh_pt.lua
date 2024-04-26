local meta = FindMetaTable( "Player" )
if not meta then return end

function meta:GetPT()
	return self:GetNWInt("TotalPT")
end

function meta:SetPT( num )
	self:SetNWInt("TotalPT", num)
end

function meta:GetPTStart()
	return self:GetNWInt("PTStart")
end

function meta:SetPTStart(num)
	self:SetNWInt("PTStart", num)
end

function meta:GetPTSessionTime()
	return CurTime() - self:GetPTStart()
end

function meta:GetPTTotalTime()
	return self:GetPT() + CurTime() - self:GetPTStart()
end

function timeToStr(time)
	local tmp = time
	local s = tmp % 60
	tmp = math.floor(tmp / 60)
	local m = tmp % 60
	tmp = math.floor(tmp / 60)
	local h = tmp % 24
	tmp = math.floor(tmp / 24)
	local d = tmp % 7
	local w = math.floor(tmp / 7)

	return string.format("%02iw %id %02ih %02im %02is", w, d, h, m, s)
end