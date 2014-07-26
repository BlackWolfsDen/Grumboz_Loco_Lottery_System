local npcid = 390000

local function NewLottoEntry(name)
local NLEID = (#LottoHistory+1)
	WorldDBQuery("INSERT INTO lotto.entries SET `id` = '"..NLEID.."';")
	WorldDBQuery("UPDATE lotto.entries SET `name` = '"..name.."' WHERE `id` = '"..NLEID.."';")
end

local function LottoEnter(name)
	WorldDBQuery("UPDATE lotto.entries SET `count` = `count`+1 WHERE `name` = "..name..";")
	LottoEntries[id].count = 0
end

local function LottoUpdate(table, location,  data, id)
	WorldDBQuery("UPDATE lotto."..table.." SET `"..location.."` = "..data.." WHERE `id` = "..id..";")
	LottoEntries[id].count = 0
end

local function NewLotto(gametime)
local id = (#LottoHistory + 1)
	WorldDBQuery("INSERT INTO lotto.history SET `id` = '"..id.."';");
	WorldDBQuery("UPDATE lotto.history SET `start` = "..gametime.." WHERE `id` = "..id..";")
	LottoHistory[id].initdate = gametime	
end

function Lotto(event)

local LS = WorldDBQuery("SELECT * FROM lotto.settings;");
	if(LS)then
		repeat
			LottoSettings["SERVER"] = {
				item = LS:GetUInt32(0),
				timer = LS:GetUInt32(1),
				operation = LS:GetUInt32(2),
				mumax = LS:GetUInt32(3) -- max for winnings random multiplier
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
	
local LE = WorldDBQuery("SELECT * FROM lotto.entries WHERE `count` > '0';");
	if(LE) then
		repeat
			LottoEntries[LE:GetUInt32(1)] = {
				id = LE:GetUInt32(0),
				name = LE:GetString(1),
				count = LE:GetUInt32(2)
							};
		until not LQ:NextRow()
	end

	if(LS["SERVER"].operation==1)then
		CreateLuaEvent(Tally, 1, (LottoHistory[#LotoHistory].initdate+LS["SERVER"].timer-GetGameTime()))
	end
end

local function Tally(event)
	local multiplier = math.random(1, LottoSettings["SERVER"].mumax)
	local win = math.random(1, #LottoEntries)
	local Winner = LottoEntries[win].name
	local player = GetPlayerByName(Winner)
	player:SendMail("Lotto Winner.", "Contgratulations Winner #"..#LottoHistory..".", player:GetGUIDLow(), 0, 1, 1000, LottoSettings["SERVER"].item, LottoEntries[win].count * multiplier)
	SendWorldMessage("Contgratulations to "..LottoEntries[win].name.." our #"..#LottoEntries.." winner.")

		for a=1, #LottoEntries do
			LottoUpdate(entries, count, 0, a)
		end
	NewLotto(GetGameTime())
	if(LottoSettings["SERVER"].operation==1)then
		CreateLuaEvent(Tally, 1, (LottoHistory[#LotoHistory].initdate+LS["SERVER"].timer-GetGameTime()))
	end
end

RegisterServerEvent(16, Lotto)


local function LottoOnHello(event, player)
	player:GossipClearMenu()
	player:GossipMenuAddItem(0, "Enter the lotto.", 0, 100)
	player:GossipMenuAddItem(0, "never mind.", 0, 10)
	player:GossipSendMenu(1, player)
end

local function LottoOnSelect(event, player, unit, sender, intid, code)
	if(intid==10)then
		player:GossipComplete()
	end
	if(intid==100)then
		if(player:GetItemCount(LottoSettings["SERVER"].item)==0)then
			player:SendBroadcastMessage("You dont have enough currency to enter.")
		else
			player:RemoveItem(LottoSettings["SERVER"].item, 1)

			if(LottoEntries[player:GetName()])then
				LottoEnter(name)
			else
				NewLottoEntry(name)
			end
		end
		player:GossipComplete()
	else
	LottoOnHello(1, player)
	end
end

RegisterCreatureGossipEvent(npcid, 1, LottoOnHello)
RegisterCreatureGossipEvent(npcid, 2, LottoOnSelect)
