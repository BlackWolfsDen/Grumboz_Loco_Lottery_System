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
--local lecount = 0
	if(LE) then
	
		repeat
			LottoEntries[LE:GetUInt32(0)] = {
				id = LE:GetUInt32(0),
				GUIDLow = LE:GetUInt64(1),
				count = LE:GetUInt32(2)
							};
		until not LE:NextRow()
	end
local LZ = WorldDBQuery("SELECT * FROM lotto.entries WHERE `count`>='1';");
local lzcount = 0
	repeat
		lzcount = lzcount + 1
			if(lzcount>=4)then
				LottoEntriez["SERVER"] = {1};
			else
				LottoEntriez["SERVER"] = {0};
			end
	until not LZ:NextRow()
end

LottoLoader(1)

local function FirstLotto(gametime)
	local NLID = (1)
	WorldDBQuery("INSERT INTO lotto.history SET `start` = '"..gametime.."';") --  WHERE `id` = '"..NLID.."';")

	LottoHistory[NLID] = {
					id = NLID,
					initdate = gametime
						};
	CreateLuaEvent(Tally, ((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer)-GetGameTime()), 1)
end

local function GetId(guidlow)
	for id=1, #LottoEntries do
		if(LottoEntries[id].GUIDLow==guidlow)then
			return id;
		end
	end
end

local function EnterLotto(guidlow)
local elid = GetId(guidlow)
local elcount = LottoEntries[elid].count + 1
	WorldDBQuery("UPDATE lotto.entries SET `count` = '"..elcount.."' WHERE `guidlow` = '"..guidlow.."';")
	LottoEntries[GetId(guidlow)].count = elcount
	GetPlayerByGUID(guidlow):SendBroadcastMessage("You have entered "..elcount.." times.")
end

local function NewLottoEntry(guidlow, chain)
local NLEID = (#LottoEntries+1)
	WorldDBQuery("INSERT INTO lotto.entries SET `guidlow` = '"..guidlow.."';")
	LottoEntries[NLEID] = {
				id = NLEID,
				GUIDLow = guidlow,
				count = 0
						};
	if(chain==1)then
		EnterLotto(guidlow)
	else
	end
end

local function FlushLotto(id)
	WorldDBQuery("UPDATE lotto.entries SET `count` = '0' WHERE `id` = '"..id.."';")
	LottoEntries[id].count = 0
end

local function LottoStart(gametime)
local id = (#LottoHistory + 1)
	WorldDBQuery("UPDATE lotto.history SET `start` = '"..gametime.."';") --  WHERE `id` = "..id..";")
	LottoHistory[id] = {
			initdate = gametime
						};
end

local function Tally(event)
print("tally")
print(#LottoEntries)
	if(#LottoEntries < 4)then
		print("Not enough Lotto Entries")
	else
		local multiplier = math.random(1, LottoSettings["SERVER"].mumax)
		local win = math.random(1, #LottoEntries)
		print("win:"..win)
		GetPlayerByGUID(LottoEntries[win].GUIDLow):SendMail("Lotto Winner.", "Contgratulations Winner #"..#LottoHistory..".", 0, LottoEntries[win].GUIDLow, 1, 1000, LottoSettings["SERVER"].item, LottoEntries[win].count * multiplier)
		SendWorldMessage("Contgratulations to "..LottoEntries[win].name.." our #"..#LottoEntries.." winner.")
	
		for a=1, #LottoEntries do
			FlushLotto(a)
		end
	end

	LottoStart(GetGameTime())

	if(LottoSettings["SERVER"].operation==1)then
		CreateLuaEvent(Tally, ((LottoHistory[#LottoHistory].initdate+LottoSettings["SERVER"].timer)-GetGameTime()), 1)
	end
end

function Lotto(event)

	if(LottoSettings["SERVER"].operation==1)then
		if(#LottoHistory==0)then
			FirstLotto(GetGameTime())
		else
			CreateLuaEvent(Tally, LottoSettings["SERVER"].timer, 1)
		end
	end	
end

Lotto(1)

local function LottoOnHello(event, player, unit)
local lohid = GetId(player:GetGUIDLow())
	if(lohid==nil)then
		NewLottoEntry(player:GetGUIDLow(), 0)
		LottoOnHello(1, player, unit)
	end
	VendorRemoveAllItems(npcid)
	player:GossipClearMenu()
	player:GossipMenuAddItem(0, "You have entered "..LottoEntries[lohid].count.." times", 0, 10)
	player:GossipMenuAddItem(0, "Enter the lotto.", 0, 100)
	player:GossipMenuAddItem(0, "never mind.", 0, 10)
	player:GossipSendMenu(1, unit)
end

local function LottoOnSelect(event, player, unit, sender, intid, code)
	if(intid < 10)then
	end
	if(intid==10)then
		player:GossipComplete()
	end

	if(intid==100)then
		if(player:GetItemCount(LottoSettings["SERVER"].item)==0)then
			player:SendBroadcastMessage("You dont have enough currency to enter.")
		else
			local id = GetId(player:GetGUIDLow())
			player:GossipComplete()
			player:RemoveItem(LottoSettings["SERVER"].item, 1)

			if(id)then
				local count = (LottoEntries[id].count + 1)
				EnterLotto(player:GetGUIDLow())
			else
				NewLottoEntry(player:GetGUIDLow(), 1)
			end
			LottoOnHello(1, player)
		end
		player:GossipComplete()
		
	else
	LottoOnHello(1, player)
	end
end

RegisterCreatureGossipEvent(npcid, 1, LottoOnHello)
RegisterCreatureGossipEvent(npcid, 2, LottoOnSelect)

print("Grumbo'z Goliath Online")
