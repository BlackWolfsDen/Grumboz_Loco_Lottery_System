local npcid = 390000
LottoSettings = {};
LottoEntries = {};
LottoHistory = {};

local function LottoLoader(event)
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
		until not LH:NextRow()
	end
	
local LE = WorldDBQuery("SELECT * FROM lotto.entries WHERE `count` > '0';");
	if(LE) then
		repeat
			LottoEntries[LE:GetString(1)] = {
				id = LE:GetUInt32(0),
				name = LE:GetString(1),
				count = LE:GetUInt32(2)
							};
		until not LQ:NextRow()
		LottoEntries["SERVER"] = {1};
	else
		LottoEntries["SERVER"] = {0};
	
	end
end
LottoLoader(1)

local function FirstLotto(gametime)
	local NLID = (#LottoHistory+1)
	WorldDBQuery("INSERT INTO lotto.history SET `id` = '"..NLID.."';")
	WorldDBQuery("UPDATE lotto.history SET `start` = '"..gametime.."' WHERE `id` = '"..NLID.."';")

	LottoHistory[NLID] = {
					id = NLID,
					initdate = gametime
						};
	CreateLuaEvent(Tally, ((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer)-GetGameTime()), 1)
	print("Grumbo'z Goliath Online")
end

local function NewLottoEntry(name)
local NLEID = (#LottoHistory+1)
	WorldDBQuery("INSERT INTO lotto.entries SET `id` = '"..NLEID.."';")
	WorldDBQuery("UPDATE lotto.entries SET `name` = '"..name.."' WHERE `id` = '"..NLEID.."';")
	LottoEntries[name] = {
				id = NLEID,
				name = name
						};
	LottoEnter(name)
end

local function LottoEnter(name)
	WorldDBQuery("UPDATE lotto.entries SET `count` = `count`+1 WHERE `name` = "..name..";")
	LottoEntries[name].count = (LottoEntries[name].count +1)
end

local function LottoUpdate(table, location,  data, id)
	WorldDBQuery("UPDATE lotto."..table.." SET `"..location.."` = "..data.." WHERE `id` = "..id..";")
	LottoEntries[name].count = 0
end

local function NewLotto(gametime)
local id = (#LottoHistory + 1)
	WorldDBQuery("INSERT INTO lotto.history SET `id` = '"..id.."';");
	WorldDBQuery("UPDATE lotto.history SET `start` = "..gametime.." WHERE `id` = "..id..";")
	LottoHistory[id].initdate = gametime	
end

local function Tally(event)
print(#LottoEntries)
print(LottoSettings["SERVER"].timer)
print((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer))
print(GetGameTime())
	if(LottoEntries["SERVER"][1]==0)then
		print("No Lotto Entries")
	else
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
	end
	if(LottoSettings["SERVER"].operation==1)then
		CreateLuaEvent(Tally, ((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer)-GetGameTime()), 1)
	end
end

function Lotto(event)

	if(LottoSettings["SERVER"].operation==1)then
		if(#LottoHistory==0)then
			FirstLotto(GetGameTime())
		else
			CreateLuaEvent(Tally, ((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer)-GetGameTime()), 1)
			print("Grumbo'z Goliath Online")
		end
	end	
end

RegisterServerEvent(16, Lotto)

Lotto(1)

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
