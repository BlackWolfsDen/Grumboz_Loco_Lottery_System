local function LottoPreparedStatement(key, ...)
	local Query = {
		[1] = "UPDATE lotto."..table.." SET `%s` = '%s' WHERE `id` = '%s';",
		[2] = "UPDATE lotto.history SET `%s` = '%s' WHERE `id` = '%s';",
		[3] = "UPDATE lotto.entries SET `%s` = '%s' WHERE `id` = '%s';"
	}
	
end

function Lotto(event)

local LS = WorldDBQuery("SELECT * FROM lotto.settings;");
	if(LS)then
		repeat
			LottoSettings[SERVER] = {
				item = LS:GetUInt32(0),
				timer = LS:GetUInt32(1)
												};
		until not LS:NextRow()
	end
		
local LH = WorldDBQuery("SELECT * FROM lotto.history;");
	if(LH)then
		repeat
			LottoHistory[LH:GetUInt32(0)] = {
				id = LH:GetUInt32(0),
				initdate = LH:GetUInt32(1),
				winner = LH:GetString(2),
				amount = LH:GetUInt32(3)
												};
		until not (LH)
	end
	
local LE = WorldDBQuery("SELECT * FROM lotto.entries;");
	if(LE) then
		repeat
		
			LottoEntries[LE:GetUInt32(0)] = {
							id = LE:GetUInt32(0),
							name = LE:GetString(1),
							count = LE:GetUInt32(2)
											};
		until not LQ:NextRow()
	end
	if(LE)then
	end
end

RegisterServerEvent(16, Lotto)

