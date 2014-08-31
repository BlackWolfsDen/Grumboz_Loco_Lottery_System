-- From the mad scientist slp13at420 of EmuDevs.com
print("-----------------------------------")
print("Grumbo\'z Loco Lotto starting ...\n")
local npcid = 390000
Lotto = {};
LottoSettings = {};
LottoEntries = {};

local function LottoLoader(event)
local LS = WorldDBQuery("SELECT * FROM lotto.settings;");
	if(LS)then
		repeat
			LottoSettings = {
				item = LS:GetUInt32(0),
				cost = LS:GetUInt32(1),
				timer = LS:GetUInt32(2),
				operation = LS:GetUInt32(3),
				rndmax = LS:GetUInt32(4),
				require = LS:GetUInt32(5),
				maxcount = LS:GetUInt32(6)
					};
		until not LS:NextRow()
	end	
	
local LE = WorldDBQuery("SELECT * FROM lotto.entries;");
	if(LE)then
		repeat
			LottoEntries[LE:GetUInt32(0)] = {
					id = LE:GetUInt32(0),
					name = LE:GetString(1),
					guid = LE:GetUInt32(2),
					count = LE:GetUInt32(3)
							};
		until not LE:NextRow()
	end
end

LottoLoader(1)

local function GetItemNameById(id)
local err = "ERROR GetItemById() name value is nil(Item "..id.." May not exist in database)"
local search = WorldDBQuery("SELECT `name` FROM `item_template` WHERE `entry` = '"..id.."';");


	if(search)then
		local itemname = search:GetString(0)
		return(itemname)
	else
		error(err)
	end
end

local function GetId(name)
	for id=1, #LottoEntries do
		if(LottoEntries[id].name==name)then
			return id;
		end
	end
end

local function NewLottoEntry(name, guidlow)
local NLEID = (#LottoEntries+1)

CharDBExecute("REPLACE INTO lotto.entries SET `name`='"..name.."';")
CharDBExecute("UPDATE lotto.entries SET `guid`='"..guidlow.."' WHERE `name`='"..name.."';")

LottoEntries[NLEID] = {
		id = NLEID,
		name = name,
		guid = guidlow,
		count = 0
			};
end

local function EnterLotto(name, id)
	local elcount = LottoEntries[id].count + 1
	WorldDBQuery("UPDATE lotto.entries SET `count` = '"..elcount.."' WHERE `name` = '"..name.."';")
	LottoEntries[id].count = elcount
	GetPlayerByName(name):SendBroadcastMessage("You have entered "..elcount.." times.")
end

local function FlushLotto(id)
	WorldDBQuery("UPDATE lotto.entries SET `count` = '0';")
	
	for a=1, #LottoEntries do
		LottoEntries[a].count = 0
	end
end

local function GetEntriez()
LottoEntriez = {};
Lotto = {
	pot = 0
	};
				
	for a=1, #LottoEntries do
	
		if(LottoEntries[a].count > 0)then
			LottoEntriez[(#LottoEntriez+1)] = {
								id = LottoEntries[a].id,
								name = LottoEntries[a].name,
								count = LottoEntries[a].count
											};
			Lotto.pot = ((Lotto.pot)+(LottoEntries[a].count))
		end
	end
return #LottoEntriez;
end

local function Tally(event)
local entriez = GetEntriez()	
	if(entriez < LottoSettings.require)then
		SendWorldMessage("Not enough Loco Lotto Entries this round.")
		SendWorldMessage("Visit a Loco Lotto Vendor to join.")
	else
		math.randomseed(tonumber(os.time()*os.time()))
		local multiplier = math.random(1, LottoSettings.rndmax)
		local win = math.random(1, entriez)
		local name = LottoEntriez[win].name
		local player = GetPlayerByName(name)
		
			if(player)then
				local bet = ((LottoEntriez[win].count * LottoSettings.cost) * multiplier)
				local pot = ((Lotto.pot - LottoEntriez[win].count) * LottoSettings.cost)
				SendWorldMessage("Contgratulations to "..LottoEntriez[win].name.." our new winner. Total:"..(pot + bet)..". Its LOCO!!")
				player:AddItem(LottoSettings.item, (pot+bet))
				print("Loco Lotto -- :Name:"..name..".:Pot:"..pot..".:Wager:"..LottoEntriez[win].count..".:Multiplier:"..multiplier)
				FlushLotto(a)
			else
				SendWorldMessage("You must be logged in to recieve winnings from the Loco Lotto.")
				SendWorldMessage("No Winners this Loco lotto round.")
			end
	end
	
    	if (LottoSettings.operation ~= 1) then
        	RemoveEventById(LottoTimer)
        	LottoTimer = nil
        end
end

local function LottoOnHello(event, player, unit)
local lohid = GetId(player:GetName())
local entered = GetEntriez()
	if(entered==nil)then
		local entered = 0
	end
	if(lohid==nil)then
		NewLottoEntry(player:GetName(), player:GetGUIDLow())
		LottoOnHello(event, player, unit)
	else
		player:GossipClearMenu()
		player:GossipMenuAddItem(10, entered.." of "..LottoSettings.require.." players entered.", 0, 10)
		player:GossipMenuAddItem(10, "You have entered "..LottoEntries[lohid].count.." times", 0, 10)
		player:GossipMenuAddItem(4, "Enter the lotto. Cost "..LottoSettings.cost.." "..GetItemNameById(LottoSettings.item).."'s.", 0, 100)
		player:GossipMenuAddItem(5, "never mind.", 0, 11)
		player:GossipSendMenu(1, unit)
	end
end

local function LottoOnSelect(event, player, unit, sender, intid, code)

	if(intid<=10)then
		LottoOnHello(1, player, unit)
	end
	
	if(intid==11)then
		player:GossipComplete()
	end

	if(intid==100)then

		if(player:GetItemCount(LottoSettings.item) >= LottoSettings.cost)then
		
			local id = GetId(player:GetName())
			
				if(id)then
					if(LottoEntries[id].count < LottoSettings.maxcount)or(LottoSettings.maxcount==0)then
 							player:RemoveItem(LottoSettings.item, LottoSettings.cost)
							EnterLotto(player:GetName(), id)
					else
							player:SendBroadcastMessage("You Loco .. you can only enter "..LottoSettings.maxcount.." times.")
					end
					LottoOnHello(1, player, unit)
				end
		else
			player:SendBroadcastMessage("You Loco .. you dont have enough currency to enter.")
			player:GossipComplete()
		end
	end
end

RegisterCreatureGossipEvent(npcid, 1, LottoOnHello)
RegisterCreatureGossipEvent(npcid, 2, LottoOnSelect)

print("Grumbo'z Loco Lotto Operational.")

	if(LottoSettings.operation==1)then
    		LottoTimer = CreateLuaEvent(Tally, LottoSettings.timer, 0)
		print("...Lotto Started...")
	else
		print("...System idle...")
	end
print("-----------------------------------")
 
