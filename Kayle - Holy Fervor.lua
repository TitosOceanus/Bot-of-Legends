--[[
 ____  __.             .__          
|    |/ _|____  ___.__.|  |   ____  
|      < \__  \<   |  ||  | _/ __ \ 
|    |  \ / __ \\___  ||  |_\  ___/ 
|____|__ (____  / ____||____/\___  >
        \/    \/\/               \/ 

	Change Log:
		1.0 - Script Release
		1.03 - No W on Back
		1.04 - No Ult on Jungle
		1.05 - Fixed ally heal/ult
		1.06 - Fixed ally heal/ult auto moving
--]]

local version = "1.06"
local author = "Titos"
local TextList = {"Do Not Chase", "You Can Chase", "Ally Can Chase"}
local ChaseText = {}
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/TitosOceanus/Bot-of-Legends/master/Kayle%20-%20Holy%20Fervor.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#FFA500\"><b>Kayle:</b></font> <font color=\"#FFD700\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/TitosOceanus/Bot-of-Legends/master/version/Kayle.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				_AutoupdaterMsg("New version available "..ServerVersion)
				_AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () _AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				_AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		_AutoupdaterMsg("Error downloading version info")
	end
end

if myHero.charName ~= "Kayle" then return end

function OnLoad()
	print("<b><font color=\"#00FFFF\">Titos: <font color=\"#FFA500\">Kayle <font color=\"#FFFF00\">- <font color=\"#FFA500\">Holy Fervor <font color=\"#FFFF00\">["..version.."] <font color=\"#FFA500\">Loaded.</font>")
	Variables()
	Menu()
	DelayAction(function() LoadOrbwalker() end, 10)
end

function Variables()
	SkillQ = { name = "Reckoning", range = 650, ready = false }
	SkillW = { name = "Divine Blessing", range = 900, ready = false }
	SkillE = { name = "Righteous Fury", range = 525, width = 150, ready = false }
	SkillR = { name = "Intervention", range = 900, ready = false }

	local ignite = nil
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		ignite = SUMMONER_2
	end

	EnemyMinions = minionManager(MINION_ENEMY, SkillE.range, myHero, MINION_SORT_MAXHEALTH_DEC)
	JungleMinions = minionManager(MINION_JUNGLE, SkillE.range, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function LoadOrbwalker()
	if _G.AutoCarry ~= nil then
		SACLoaded = true
		Settings.Orbwalker:addParam("info", "Detected SAC", SCRIPT_PARAM_INFO, "")
		_G.AutoCarry.Skills:DisableAll()
		PrintChat("<font color=\"#800080\"><b>SAC: </b></font> <font color=\"#FFFF00\">Loaded</font>")
	else
		if not FileExist(LIB_PATH.."SxOrbWalk.lua") then
			LuaSocket = require("socket")
			ScriptSocket = LuaSocket.connect("sx-bol.eu", 80)
			ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script=raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
			ScriptReceive, ScriptStatus = ScriptSocket:receive('*a')
			ScriptRaw = string.sub(ScriptReceive, string.find(ScriptReceive, "<bols".."cript>")+11, string.find(ScriptReceive, "</bols".."cript>")-1)
			ScriptFileOpen = io.open(LIB_PATH.."SxOrbWalk.lua", "w+")
			ScriptFileOpen:write(ScriptRaw)
			ScriptFileOpen:close()
		end
		require("SxOrbwalk")
		SxOrbLoaded = true
		_G.SxOrb:LoadToMenu(Settings.Orbwalker)
	end
end

function GetOrbTarget()
	TargetSelector:update()
	if SACLoaded then return _G.AutoCarry.Crosshair:GetTarget() end
	if SxOrbLoaded then return _G.SxOrb:GetTarget() end
	return TargetSelector.target
end

function OnDraw()
	if not myHero.dead and not Settings.Draw.Disable then
		if SkillQ.ready and Settings.Draw.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, ARGB(255, 255, 125, 0))
		end
		
		if SkillW.ready and Settings.Draw.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillW.range, ARGB(255, 255, 125, 0))
		end
		
		if SkillE.ready and Settings.Draw.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, ARGB(255, 255, 125, 0))
		end
		
		if SkillR.ready and Settings.Draw.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, ARGB(255, 255, 125, 0))
		end
	
		if Settings.Draw.targetcircle and Target then
			DrawCircle(Target.x, Target.y, Target.z, 100, ARGB(255, 255, 125, 0))
		end
	end
--[[	if Settings.Draw.ChaseText then
		for i = 1, heroManager.iCount do
			local enemy = heroManager:getHero(i)
			if ValidTarget(enemy) then
				local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 50
				DrawText(TextList[ChaseText[i]]--[[, 15, PosX, PosY, ARGB(255, 255, 165, 0))
			end
		end
	end]]
end

function OnTick()
	Target = GetOrbTarget()
	ComboKey = Settings.Combo.ComboKey
	HarassKey = Settings.Harass.HarassKey
	ClearKey = Settings.Clear.ClearKey
	Checks()
	Healing()
	Intervention()
	Killsteal()

	if Settings.Combo.ComboKey then
		Combo(Target)
	end

	if Settings.Harass.HarassKey then
		Harass(Target)
	end

	if Settings.Clear.ClearKey then
		LaneClear()
	end
	
	if Settings.Jungle.JungleKey then
		JungleClear()
	end
end

function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)
	Iready = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end

function Menu()
	Settings = scriptConfig("Kayle - Holy Fervor "..version.."", "Kayle")

	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings", "Combo")
		Settings.Combo:addParam("ComboKey", "Combo Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.Combo:addParam("UseQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("BoostAlly", "Use (W) to Boost Ally", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("ChaseMana", "Min. Mana to Chase:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		Settings.Combo:permaShow("ComboKey")

	Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
		Settings.Harass:addParam("HarassKey", "Harass Key:", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		Settings.Harass:addParam("UseQ", "Use (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("UseE", "Use (E) in Harass", SCRIPT_PARAM_ONOFF, false)
		Settings.Harass:addParam("MinMana", "Min. Mana Percentage:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		Settings.Harass:permaShow("HarassKey")

	Settings:addSubMenu("["..myHero.charName.."] - Clear Settings", "Clear")
		Settings.Clear:addParam("ClearKey", "Clear Key:", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
		Settings.Clear:addParam("UseE", "Use (E) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Clear:addParam("MinMana", "Min. Mana Percentage:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
		Settings.Clear:permaShow("ClearKey")

	Settings:addSubMenu("["..myHero.charName.."] - Jungle Settings", "Jungle")
		Settings.Jungle:addParam("JungleKey", "Jungle Key:", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
		Settings.Jungle:addParam("UseQ", "Use (Q) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("UseE", "Use (E) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("MinMana", "Min. Mana Percentage:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Heal Settings", "Heal")
		Settings.Heal:addParam("HealKey", "Automatic Healing", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("H"))
		Settings.Heal:permaShow("HealKey")
		Settings.Heal:addParam("HealKayle", "Heal Kayle", SCRIPT_PARAM_ONOFF, true)
		for _, ally in ipairs(GetAllyHeroes()) do
			Settings.Heal:addParam(""..ally.charName.."", "Heal " ..ally.charName.."", SCRIPT_PARAM_ONOFF, true)
		end
		Settings.Heal:addSubMenu("Healing Preferences", "HealPref")
			Settings.Heal.HealPref:addParam("MaxHealSelf", "My Maximum HP to Heal Self:", SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
			Settings.Heal.HealPref:addParam("MinSelfHP", "My Minimum HP to Heal Allies:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			Settings.Heal.HealPref:addParam("MaxAllyHP", "Allies Maximum HP For Heal:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			Settings.Heal.HealPref:addParam("MinMana", "Minimum Mana to Heal:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Ultimate Settings", "Ultimate")
		Settings.Ultimate:addParam("UltimateKey", "Automatic Ulting", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("U"))
		Settings.Ultimate:permaShow("UltimateKey")
		Settings.Ultimate:addParam("UltimateKayle", "Ultimate Kayle", SCRIPT_PARAM_ONOFF, true)
		for _, ally in ipairs(GetAllyHeroes()) do
			Settings.Ultimate:addParam(""..ally.charName.."", "Ultimate "..ally.charName.."", SCRIPT_PARAM_ONOFF, true)
		end
		Settings.Ultimate:addSubMenu("Ultimate Preferences", "UltPref")
			Settings.Ultimate.UltPref:addParam("MyUltHP", "My Maximum HP to Ult Self:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
			Settings.Ultimate.UltPref:addParam("MinSelfHP", "My Minimum HP to Ult Allies:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
			Settings.Ultimate.UltPref:addParam("MaxAllyHP", "Allies Maximum HP for Ult:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "Killsteal")
		Settings.Killsteal:addParam("UseQ", "Use (Q) to Killsteal", SCRIPT_PARAM_ONOFF, true)
		Settings.Killsteal:addParam("UseIgnite", "Use Ignite to Killsteal", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "Draw")
		Settings.Draw:addParam("Disable", "Disable Range Drawings", SCRIPT_PARAM_ONOFF, false)
		Settings.Draw:addParam("qDraw", "Draw "..SkillQ.name.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.Draw:addParam("wDraw", "Draw "..SkillW.name.." (W) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.Draw:addParam("eDraw", "Draw "..SkillE.name.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.Draw:addParam("rDraw", "Draw "..SkillR.name.." (R) Range", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Orbwalker Settings", "Orbwalker")

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGIC, true)
	TargetSelector.name = "Kayle"
	Settings:addTS(TargetSelector)
end

function Combo(unit)
	if ValidTarget(unit) and unit~= nil and unit.type == myHero.type then
		if Settings.Combo.UseQ and SkillQ.ready then
			CastSpell(_Q, unit)
		end
		if Settings.Combo.UseW and SkillW.ready then
			if GetDistance(unit) > 525 and GetDistance(unit) < 900 then
				CastSpell(_W, myHero)
			elseif Settings.Combo.BoostAlly and GetDistance(unit) > 525 and GetDistance(unit, ally) < 900 then
				CastSpell(_W, ally)
			end
		end
		if Settings.Combo.UseE and SkillE.ready then
			if GetDistance(unit) < 525 then
				CastSpell(_E)
			end
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit~= nil and unit.type == myHero.type then
		if myHero.mana > (myHero.maxMana * ( Settings.Harass.MinMana / 100)) then
			if Settings.Harass.UseQ and SkillQ.ready then
				CastSpell(_Q, unit)
			end
			if Settings.Harass.UseE and SkillE.ready and GetDistance(unit) < 525 then
				CastSpell(_E)
			end
		end
	end
end

function LaneClear()
	EnemyMinions:update()
	for i, minions in pairs(EnemyMinions.objects) do
		if Settings.Clear.UseE and myHero.mana > (myHero.maxMana * (Settings.Clear.MinMana/100)) and SkillE.ready then
			CastSpell(_E)
		end
	end
end

function JungleClear()
	JungleMinions:update()
	JungleCreep = JungleMinions.objects[1]
	if ValidTarget(JungleCreep) then
		if SkillE.ready and GetDistance(JungleCreep) <= SkillE.range then
			CastSpell(_E)
		end
		if SkillQ.ready and GetDistance(JungleCreep) <= SkillQ.range then
			CastSpell(_Q, JungleCreep)
		end
	end
end

function Healing()
	if myHero.mana > (myHero.maxMana * (Settings.Heal.HealPref.MinMana/100)) and SkillW.ready and Settings.Heal.HealKey and not Recalling() then
		if myHero.health < (myHero.maxHealth * (Settings.Heal.HealPref.MinSelfHP/100)) and Settings.Heal.HealKayle then
			CastSpell(_W, myHero)
		elseif myHero.health < (myHero.maxHealth * (Settings.Heal.HealPref.MaxHealSelf/100)) and Settings.Heal.HealKayle then
			CastSpell(_W, myHero)
		else
			for _, ally in ipairs(GetAllyHeroes()) do
				if ally.health < (ally.maxHealth * (Settings.Heal.HealPref.MaxAllyHP/100)) and GetDistance(ally, myHero) < SkillW.range then
					if Settings.Heal[ally.charName] then
						CastSpell(_W, ally)
					end
				end
			end
		end
	end
end

function Intervention()
	if Settings.Ultimate.UltimateKayle and (myHero.health < (myHero.maxHealth * (Settings.Ultimate.UltPref.MyUltHP/100))) and Settings.Ultimate.UltKey and not Settings.Jungle.JungleKey then
		CastSpell(_R, myHero)
	else
		for _, ally in ipairs(GetAllyHeroes()) do
			if GetDistance(ally) <= SkillW.range and Settings.Ultimate[ally.charName] and (myHero.health > (myHero.maxHealth * (Settings.Ultimate.UltPref.MinSelfHP/100))) then
				if ally.health < (ally.maxHealth * (Settings.Ultimate.UltPref.MaxAllyHP/100)) and GetDistance(ally, myHero) < SkillR.range then
					CastSpell(_R, ally)
				end
			end
		end
	end
end

function Killsteal()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if not enemy.dead and enemy.visible then
			local qDmg = getDmg("Q", enemy, myHero)
			local iDmg = (50 + (20 * myHero.level))
			if Settings.Killsteal.UseIgnite and Iready and iDmg > enemy.health and GetDistance(enemy) < 600 then
				CastSpell(ignite, enemy)
			elseif Settings.Killsteal.UseQ and qDmg > enemy.health and GetDistance(enemy) < SkillQ.range then
				CastSpell(_Q, enemy)
			end
		end
	end
end

function Recalling()
  for i = 1, myHero.buffCount do --iterates through your heroes buff's, buffCount=64
    local recallBuff = myHero:getBuff(i) --Get's the buff contained in the buff table from the current iteration
    if recallBuff.valid and recallBuff.name:lower():find('recall') then --you must check for validity as the buff will remain in the table until replaced
      return true
    end	
  end
  return false
end
