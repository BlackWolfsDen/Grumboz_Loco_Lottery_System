local npcid = 390000

LottoSettings = {};
LottoEntries = {};
LottoEntriez = {};
LottoHistory = {};

local function LottoLoader(event)
local LS = WorldDBQuery("SELECT * FROM lotto.settings;");
	if(LS)then
		repeat
			LottoSettings["SERVER"] = {
				item = LS:GetUInt32(1),
				timer = LS:GetUInt32(2),
				operation = LS:GetUInt32(3),
				mumax = LS:GetUInt32(4) -- max for winnings random multiplier
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
	
local LE = WorldDBQuery("SELECT * FROM lotto.entries;");
	if(LE) then
		repeat
			LottoEntries[LE:GetUInt32(0)] = {
				id = LE:GetUInt32(0),
				name = LE:GetString(1),
				count = LE:GetUInt32(2)
							};
		until not LE:NextRow()
	end

end

LottoLoader(1)

local function FirstLotto(gametime)
	local NLID = (1)
	WorldDBQuery("INSERT INTO lotto.history SET `id` = '"..NLID.."';")
	WorldDBQuery("UPDATE lotto.history SET `start` = '"..gametime.."' WHERE `id` = '"..NLID.."';")

	LottoHistory[NLID] = {
					id = NLID,
					initdate = gametime
						};
	CreateLuaEvent(Tally, ((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer)-GetGameTime()), 1)
end

local function GetEntries()
local LZ = WorldDBQuery("SELECT * FROM lotto.entries WHERE `count`>='1';");
	local count = 0

	if(LZ) then
	
		repeat
		count = count + 1
			if(count>=2)then
				LottoEntriez["SERVER"] = {1};
			else
				LottoEntriez["SERVER"] = {0};
			end
		until not LZ:NextRow()
	return count;
	end	
end

GetEntries()

local function GetId(name)
	for id=1, #LottoEntries do
		if(LottoEntries[id].name==player:GetName())then
			return id;
		end
	end
end

local function LottoEntry(playername)
local count = LottoEntries[GetId(playername)].count + 1
	WorldDBQuery("UPDATE lotto.entries SET `count` = '"..count.."' WHERE `name` = '"..playername.."';")
	LottoEntries[GetId(playername)].count = count
end

local function NewLottoEntry(name)
local NLEID = (#LottoEntries+1)
	WorldDBQuery("INSERT INTO lotto.entries SET `name` = '"..name.."';")
	LottoEntries[NLEID] = {
				id = NLEID,
				name = name,
				count = 0
						};
	LottoEntry(name)
end

local function LottoUpdate(id)
	WorldDBQuery("UPDATE lotto.entries SET `count` = '0' WHERE `id` = "..id..";")
	LottoEntries[id].count = 0
end

local function NewLotto(gametime)
local id = (#LottoHistory + 1)
	WorldDBQuery("INSERT INTO lotto.history SET `id` = '"..id.."';");
	WorldDBQuery("UPDATE lotto.history SET `start` = "..gametime.." WHERE `id` = "..id..";")
	LottoHistory[id] = {
			initdate = gametime
						};
end

local function Tally(event)
print("tally")
print(#LottoEntries)
	if(LottoEntriez["SERVER"][1]==0)then
		print("No Lotto Entries")
	else
		local multiplier = math.random(1, LottoSettings["SERVER"].mumax)
		local win = math.random(1, GetEntries())
		print("win:"..win)
		local Winner = LottoEntries[win].name
		print("winner:"..Winner)
--		local player = GetPlayerByName(Winner):GetName()
--		print(GetPlayerByName(Winner):GetName())
		local player = (GetPlayerByName(LottoEntries[win].name))
		print("playername: "..GetPlayerByName(LottoEntries[win].name))
		print(player)
		print("Player:"..Winner.." has won:"..LottoEntries[win].count * multiplier.." coins.")
		GetPlayerByName(LottoEntries[win].name):SendMail("Lotto Winner.", "Contgratulations Winner #"..#LottoHistory..".", 0, GetPlayerByName(LottoEntries[win].name):GetGUIDLow(), 1, 1000, LottoSettings["SERVER"].item, LottoEntries[win].count * multiplier)
		SendWorldMessage("Contgratulations to "..LottoEntries[win].name.." our #"..#LottoEntries.." winner.")
	
		for a=1, #LottoEntries do
			LottoUpdate(a)
		end
	end

	NewLotto(GetGameTime())

	if(LottoSettings["SERVER"].operation==1)then
		CreateLuaEvent(Tally, ((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer)-GetGameTime()), 1)
		print("Grumbo'z Goliath Online")
	end
end

function Lotto(event)

	if(LottoSettings["SERVER"].operation==1)then
		if(#LottoHistory==0)then
			FirstLotto(GetGameTime())
		else
			CreateLuaEvent(Tally, LottoSettings["SERVER"].timer, 1)
			print("Grumbo'z Goliath Online")
		end
	end	
end

RegisterServerEvent(16, Lotto)

Lotto(1)

local function LottoOnHello(event, player, unit)
	VendorRemoveAllItems(npcid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(0, "Enter the lotto.", 0, 100)
	player:GossipMenuAddItem(0, "never mind.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function LottoOnSelect(event, player, unit, sender, intid, code)
	if(intid==10)then
		player:GossipComplete()
	end

	if(intid==100)then
	local id = GetId(player:GetName())
		if(player:GetItemCount(LottoSettings["SERVER"].item)==0)then
			player:SendBroadcastMessage("You dont have enough currency to enter.")
		else
			player:GossipComplete()
			player:RemoveItem(LottoSettings["SERVER"].item, 1)
				if(id~=nil)then
					local count = (LottoEntries[id].count + 1)
					LottoEntry(player:GetName())
					player:SendBroadcastMessage("You have entered "..count.." times.")
				else
					NewLottoEntry(player:GetName())
				end
		end
		player:GossipComplete()
	else
	LottoOnHello(1, player)
	end
end

RegisterCreatureGossipEvent(npcid, 1, LottoOnHello)
RegisterCreatureGossipEvent(npcid, 2, LottoOnSelect)
