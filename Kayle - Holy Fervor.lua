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
		1.061 - Added ScriptStatus Update
		
		1.07 - Added Auto Harass Feature
                     - Changed Menu
		     - Small Change to JungleFarm()
		     - Min. Mana to Chase lowered

		1.072 - Fixed Q Cast in Combo/Harass
		      - Fixed Chase with W (Kayle & Allies)
			  - Fixed E Cast in Harass

		1.073 - Added BOTRK/Cutlass/Zhonya's
              - Self Ult Rework
	          - Refixed Q Cast/E Cast
		1.0731 - New Script Status Info
		1.074 - Won't Ult Without Enemies

		1.075 - Changed Ultimate Logic (Very Basic Now)
              - Fixed Q/E calls on jungling
              - Temporarily removed ally ulting
              - Temporarily disabled automatic Zhonyas
--]]

local version = "1.075"
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

-- Script Status --
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("TGJJFIGHKMO") 
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
end

function OnTick()
	Target = GetOrbTarget()
	ComboKey = Settings.Keybind.ComboKey
	HarassKey = Settings.Keybind.HarassKey
	ClearKey = Settings.Keybind.ClearKey
	AutoHarass = Settings.Keybind.AutoHarass
	AutoHeal = Settings.Keybind.HealKey
	AutoUlt = Settings.Keybind.UltimateKey
	Checks()
	Healing()
	Intervention()
	Killsteal()

	if ComboKey then
		Combo(Target)
	end

	if HarassKey or AutoHarass then
		Harass(Target)
	end

	if ClearKey then
		LaneClear()
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

	Settings:addSubMenu("["..myHero.charName.."] - Keybind Settings", "Keybind")
		Settings.Keybind:addParam("ComboKey", "Combo Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.Keybind:addParam("HarassKey", "Harass Key:", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		Settings.Keybind:addParam("AutoHarass", "Automatic Harass:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
		Settings.Keybind:addParam("ClearKey", "Clear Key:", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
		Settings.Keybind:addParam("HealKey", "Automatic Healing:", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("H"))
		Settings.Keybind:addParam("UltimateKey", "Automatic Ulting:", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("U"))
		Settings.Keybind:permaShow("AutoHarass")
		Settings.Keybind:permaShow("HealKey")
		Settings.Keybind:permaShow("UltimateKey")

	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings", "Combo")
		Settings.Combo:addParam("UseQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("BoostAlly", "Use (W) to Boost Ally", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("ChaseMana", "Min. Mana to Chase:", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
		Settings.Harass:addParam("UseQ", "Use (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("UseE", "Use (E) in Harass", SCRIPT_PARAM_ONOFF, false)
		Settings.Harass:addParam("MinMana", "Min. Mana Percentage:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Clear Settings", "Clear")
		Settings.Clear:addParam("UseE", "Use (E) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Clear:addParam("MinMana", "Min. Mana Percentage:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Jungle Settings", "Jungle")
		Settings.Jungle:addParam("UseQ", "Use (Q) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("UseE", "Use (E) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("MinMana", "Min. Mana Percentage:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Heal Settings", "Heal")
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
		Settings.Ultimate:addParam("UltimateKayle", "Ultimate Kayle", SCRIPT_PARAM_ONOFF, true)
		for _, ally in ipairs(GetAllyHeroes()) do
			Settings.Ultimate:addParam(""..ally.charName.."", "Ultimate "..ally.charName.."", SCRIPT_PARAM_ONOFF, true)
		end
		Settings.Ultimate:addSubMenu("Ultimate Preferences", "UltPref")
			Settings.Ultimate.UltPref:addParam("MyUltHP", "My Maximum HP to Ult Self:", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
			Settings.Ultimate.UltPref:addParam("MinSelfHP", "My Minimum HP to Ult Allies:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
			Settings.Ultimate.UltPref:addParam("MaxAllyHP", "Allies Maximum HP for Ult:", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Item Settings", "Items")
		Settings.Items:addSubMenu("Blade of the Ruined King", "BOTRK")
			Settings.Items.BOTRK:addParam("UseBOTRK", "Use BOTRK in Combo", SCRIPT_PARAM_ONOFF, true)
			Settings.Items.BOTRK:addParam("MyHP", "My Maximum HP to use BOTRK:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			Settings.Items.BOTRK:addParam("EnemyHP", "Enemy Minimum HP to use BOTRK:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		Settings.Items:addSubMenu("Bilgewater Cutlass", "Cutlass")
			Settings.Items.Cutlass:addParam("UseCutlass", "Use Bilgewater Cutlass in Combo", SCRIPT_PARAM_ONOFF, true)
			Settings.Items.Cutlass:addParam("MyHP", "My Maximum HP to use Cutlass:", SCRIPT_PARAM_SLICE, 80, 0, 100, 0)
			Settings.Items.Cutlass:addParam("EnemyHP", "Enemy Minimum HP to use Cutlass:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		Settings.Items:addSubMenu("Zhonya's Hourglass", "Zhonya")
			Settings.Items.Zhonya:addParam("UseZhonya", "Use Zhonya's Hourglass", SCRIPT_PARAM_ONOFF, true)
			Settings.Items.Zhonya:addParam("MinHP", "Minimum HP to use Zhonyas", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
			Settings.Items.Zhonya:addParam("Order", "Zhonya's Before or After Ult", SCRIPT_PARAM_LIST, 2, {"Before", "After"})

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

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGIC)
	TargetSelector.name = "Kayle"
	Settings:addTS(TargetSelector)
end

function Combo(unit)
	if ValidTarget(unit) then
		if Settings.Combo.UseQ and SkillQ.ready then
			if GetDistance(unit) <= SkillQ.range then
				CastSpell(_Q, unit)
			end
		end
		if Settings.Combo.UseW and SkillW.ready then
			if GetDistance(unit) > SkillE.range then
				CastSpell(_W, myHero)
			else
				for _, ally in ipairs(GetAllyHeroes()) do
					if GetDistance(ally, myHero) <= SkillW.range then
						if GetDistance(ally, unit) <= SkillW.range then
							CastSpell(_W, ally)
						end
					end
				end
			end
		end
		if Settings.Combo.UseE and SkillE.ready then
			if GetDistance(unit) < SkillE.range then
				CastSpell(_E)
			end
		end
		if Settings.Combo.UseItems then
			if Settings.Items.BOTRK.UseBOTRK then
				local BOTRKSlot = GetInventorySlotItem(3153)
				if myHero.health < (myHero.maxHealth * (Settings.Items.BOTRK.MyHP / 100)) then
					if unit.health > (unit.maxHealth * (Settings.Items.BOTRK.EnemyHP / 100)) then
						if BOTRKSlot ~= nil and myHero:CanUseSpell(BOTRKSlot) == READY then
							if GetDistance(unit) <= 550 then
								CastSpell(BOTRKSlot, unit)
							end
						end
					end
				end
			end
			if Settings.Items.Cutlass.UseCutlass then
				local CutlassSlot = GetInventorySlotItem(3144)
				if myHero.health < (myHero.maxHealth * (Settings.Items.Cutlass.MyHP / 100 )) then
					if unit.health > (unit.maxHealth * (Settings.Items.Cutlass.EnemyHP / 100 )) then
						if CutlassSlot ~= nil and myHero:CanUseSpell(CutlassSlot) == READY then
							if GetDistance(unit) <= 550 then
								CastSpell(CutlassSlot, unit)
							end
						end
					end
				end
			end
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if myHero.mana > (myHero.maxMana * (Settings.Harass.MinMana / 100)) then
			if Settings.Harass.UseQ and SkillQ.ready then
				if GetDistance(unit) <= SkillQ.range then
					CastSpell(_Q, unit)
				end
			end
			if Settings.Harass.UseE and SkillE.ready then
				if GetDistance(unit) < SkillE.range then
					CastSpell(_E)
				end
			end
		end
	end
end

function LaneClear()
	EnemyMinions:update()
	for i, minions in pairs(EnemyMinions.objects) do
		if Settings.Clear.UseE and myHero.mana >= (myHero.maxMana * (Settings.Clear.MinMana/100)) and SkillE.ready then
			CastSpell(_E)
		end
	end
end

function JungleClear()
	JungleMinions:update()
	JungleCreep = JungleMinions.objects[1]
	if ValidTarget(JungleCreep) then
		if SkillE.ready and GetDistance(JungleCreep) <= SkillE.range and Settings.Jungle.UseE then
			CastSpell(_E)
		end
		if SkillQ.ready and GetDistance(JungleCreep) <= SkillQ.range and Settings.Jungle.UseQ then
			CastSpell(_Q, JungleCreep)
		end
	end
end
			

function Healing()
	if myHero.mana > (myHero.maxMana * (Settings.Heal.HealPref.MinMana/100)) and SkillW.ready and Settings.Keybind.HealKey and not Recalling() then
		if myHero.health < (myHero.maxHealth * (Settings.Heal.HealPref.MinSelfHP/100)) and Settings.Heal.HealKayle then
			CastSpell(_W, myHero)
		elseif myHero.health < (myHero.maxHealth * (Settings.Heal.HealPref.MaxHealSelf/100)) and Settings.Heal.HealKayle then
			CastSpell(_W, myHero)
		else
			for _, ally in ipairs(GetAllyHeroes()) do
				if ally.health < (ally.maxHealth * (Settings.Heal.HealPref.MaxAllyHP/100)) and GetDistance(ally, myHero) < SkillW.range and not ally.dead then
					if Settings.Heal[ally.charName] then
						CastSpell(_W, ally)
					end
				end
			end
		end
	end
end

function Intervention()
	if Settings.Ultimate.UltimateKayle then
		if Settings.Keybind.UltKey and not Settings.Keybind.Clearkey then
			if ((myHero.health/myHero.maxHealth) * 100) <= (Settings.Ultimate.UltPref.MyUltHP) and CountEnemyHeroInRange(SkillE.range, myHero) > 0 then
				if SkillR.ready then
					CastSpell(_R, myHero)
				end
			end
		end
	end
end

--[[	local ZhonyaSlot = GetInventorySlotItem(3157)
	if myHero.health <= (myHero.maxHealth * (Settings.Ultimate.UltPref.MyUltHP/100)) and CountEnemyHeroInRange(SkillQ.range, myHero) > 0 then
		if Settings.Ultimate.UltimateKayle then
			if Settings.Keybind.UltKey and not Settings.Keybind.Clearkey then
				if not Settings.Items.Zhonya.UseZhonya then
					if SkillR.ready then 
						CastSpell(_R, myHero)
					end
				else 
					if Settings.Items.Zhonya.Order == 2 then
						if SkillR.ready then
							CastSpell(_R, myHero)
						else
							if myHero:CanUseSpell(ZhonyaSlot) == READY and ZhonyaSlot ~= nil then
								if myHero.health <= (myHero.maxHealth * (Settings.Items.Zhonya.MinHP/100)) then
									CastSpell(ZhonyaSlot)
								end
							end
						end
					else
						if myHero:CanUseSpell(ZhonyaSlot) == READY and ZhonyaSlot ~= nil then
							if myHero.health <= (myHero.maxHealth * (Settings.Items.Zhonya.MinHP/100)) then
								CastSpell(ZhonyaSlot)
							end
						else
							CastSpell(_R, myHero)
						end
					end
				end
			end
		else
			if Settings.Items.Zhonya.UseZhonya and ZhonyaSlot ~= nil then
				if myHero.health <= (myHero.maxHealth * (Settings.Items.Zhonya.MinHP/100)) then
					CastSpell(ZhonyaSlot)
				end
			end
		end
	else
		for _, ally in ipairs(GetAllyHeroes()) do
			if GetDistance(ally) <= SkillR.range and Settings.Ultimate[ally.charName] and CountEnemyHeroInRange(650, ally) > 0 then
				if ally.health < (ally.maxHealth * (Settings.Ultimate.UltPref.MaxAllyHP/100)) then
					CastSpell(_R, ally)
				end
			end
		end
	end
end]]

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
