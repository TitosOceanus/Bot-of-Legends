--[[ 
          _____                    _____                    _____                    _____                    _____                    _____          
         /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \         
        /::\    \                /::\____\                /::\    \                /::\____\                /::\    \                /::\    \        
       /::::\    \              /::::|   |                \:::\    \              /:::/    /                \:::\    \              /::::\    \       
      /::::::\    \            /:::::|   |                 \:::\    \            /:::/    /                  \:::\    \            /::::::\    \      
     /:::/\:::\    \          /::::::|   |                  \:::\    \          /:::/    /                    \:::\    \          /:::/\:::\    \     
    /:::/__\:::\    \        /:::/|::|   |                   \:::\    \        /:::/____/                      \:::\    \        /:::/__\:::\    \    
   /::::\   \:::\    \      /:::/ |::|   |                   /::::\    \       |::|    |                       /::::\    \      /::::\   \:::\    \   
  /::::::\   \:::\    \    /:::/  |::|   | _____    ____    /::::::\    \      |::|    |     _____    ____    /::::::\    \    /::::::\   \:::\    \  
 /:::/\:::\   \:::\    \  /:::/   |::|   |/\    \  /\   \  /:::/\:::\    \     |::|    |    /\    \  /\   \  /:::/\:::\    \  /:::/\:::\   \:::\    \ 
/:::/  \:::\   \:::\____\/:: /    |::|   /::\____\/::\   \/:::/  \:::\____\    |::|    |   /::\____\/::\   \/:::/  \:::\____\/:::/  \:::\   \:::\____\
\::/    \:::\  /:::/    /\::/    /|::|  /:::/    /\:::\  /:::/    \::/    /    |::|    |  /:::/    /\:::\  /:::/    \::/    /\::/    \:::\  /:::/    /
 \/____/ \:::\/:::/    /  \/____/ |::| /:::/    /  \:::\/:::/    / \/____/     |::|    | /:::/    /  \:::\/:::/    / \/____/  \/____/ \:::\/:::/    / 
          \::::::/    /           |::|/:::/    /    \::::::/    /              |::|____|/:::/    /    \::::::/    /                    \::::::/    /  
           \::::/    /            |::::::/    /      \::::/____/               |:::::::::::/    /      \::::/____/                      \::::/    /   
           /:::/    /             |:::::/    /        \:::\    \               \::::::::::/____/        \:::\    \                      /:::/    /    
          /:::/    /              |::::/    /          \:::\    \               ~~~~~~~~~~               \:::\    \                    /:::/    /     
         /:::/    /               /:::/    /            \:::\    \                                        \:::\    \                  /:::/    /      
        /:::/    /               /:::/    /              \:::\____\                                        \:::\____\                /:::/    /       
        \::/    /                \::/    /                \::/    /                                         \::/    /                \::/    /        
         \/____/                  \/____/                  \/____/                                           \/____/                  \/____/         
                                                                                                                                                      
	Changelog:
		2.0 - Rewrote Script Code to be more familiar/functional.
		    - Added Ignite features.
		    - Added Jungle Clear.
		    - Added Harass.
		    - Fixed Q Cast.
		    - Changed Target Selector to Cast Priority.
		    - Fixed Ignite errors.
		    - Fixed E Cast.
		    - Added Combo customization.
		    - Fixed Qdet.
		    - Fixed Ult.
 
		2.1 - Fixed E Killsteal
			- Added Ult Cancelling Toggle
			- Added E and R Settings in Menu
			- Readded Ult on Stunned
 
		2.5 - Added Auto W on Flee
		2.51 - Fixed injection
		2.531 - Fixed SAC:R / SxOrb
		2.532 - Fixed Target Selector
		2.533 - Disabled SAC:R
		2.54 - Re-enabled SAC:R

		2.6 - Added Kill Text (Thanks Totally Legit)
			- Reorganized Functions
		2.62 - Fixed WintoR being always true

		2.7 - Added Interrupter
		2.71 - Changed Update Directory
]]

-- Variables -- 
local version = "2.71"
local author = "Titos"
local Qobject = nil
local Robject = nil
local Qobj = false
local Robj = false
local SACLoaded = false
local SxOrbLoaded = false
local TextList = {"Ignite = Kill", "Q = Kill", "Q + Ignite = Kill", "Q + E = Kill", "Q + E + Ignite = Kill", "Not Killable"}
local KillText = {}

-- Updates --
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#00ffff\"><b>Anivia:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Anivia.version")
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
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("REHGJKDHHDG") 

-- Client-Side Functions --
if myHero.charName ~= "Anivia" then return end
require 'UPL'

-- On Start Procedure --
function OnLoad()
	print("<b><font color=\"#00FFFF\">Cryophoenix Anivia version ["..version.."] by Titos loaded.</font>")
	Variables()
	Menu()
	DelayAction(function() LoadOrbwalker() end, 10)
end

-- SAC:R or SxOrb --
function LoadOrbwalker()
	if _G.AutoCarry ~= nil then
		SACLoaded = true
		Settings.orbwalker:addParam("info", "Detected SAC", SCRIPT_PARAM_INFO, "")
		_G.AutoCarry.Skills:DisableAll()
		PrintChat("<font color=\"#DF7401\"><b>SAC: </b></font> <font color=\"#D7DF01\">Loaded</font>")
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
		_G.SxOrb:LoadToMenu(Settings.orbwalker)
	end
end

function GetOrbTarget()
	TargetSelector:update()
	if SACLoaded then return _G.AutoCarry.Crosshair:GetTarget() end
	if SxOrbLoaded then return _G.SxOrb:GetTarget() end
	return TargetSelector.target
end

-- Every Tick --
function OnTick()
	Target = GetOrbTarget()
	ComboKey = Settings.combo.comboKey
	HarassKey = Settings.harass.harassKey
	JungleKey = Settings.jungle.jungleKey
	FarmKey = Settings.farm.farmKey
	WIntoR(Target)
	Checks()
	DetQ()
	CancelR()
	DrawKillable()

	if ComboKey then
		Combo(Target)
	end

	if HarassKey then
		Harass(Target)
	end

	if JungleKey then
		JungleClear()
	end

	if Settings.ks.killSteal then
		KillSteal()
	end

	if ignite ~= nil and Settings.ks.ignite and Settings.combo.comboKey then
		UseIgnite()
	end
end

function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)
	Iready = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end

-- Drawing Function --
function OnDraw()
	if not myHero.dead and not Settings.drawing.mDraw then 
		if SkillQ.ready and Settings.drawing.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
		end
		
		if SkillW.ready and Settings.drawing.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillW.range, RGB(Settings.drawing.wColor[2], Settings.drawing.wColor[3], Settings.drawing.wColor[4]))
		end
		
		if SkillE.ready and Settings.drawing.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, RGB(Settings.drawing.eColor[2], Settings.drawing.eColor[3], Settings.drawing.eColor[4]))
		end
		
		if SkillR.ready and Settings.drawing.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, RGB(Settings.drawing.rColor[2], Settings.drawing.rColor[3], Settings.drawing.rColor[4]))
		end
		
		if Settings.drawing.myHero then
			DrawCircle(myHero.x, myHero.y, myHero.z, 600, RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
		end
		
		if Settings.drawing.targetcircle and Target then
			DrawCircle(Target.x, Target.y, Target.z, 100, RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
		end
	end
	if Settings.drawing.KillText then
		for i = 1, heroManager.iCount do
			local enemy = heroManager:getHero(i)
			if ValidTarget(enemy) then
	 			local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 50  
				DrawText(TextList[KillText[i]], 15, PosX, PosY, ARGB(255,0,255,255))
			end 
		end 
	end 
end

-- Client-Side Complete --
-- Anivia Commands --
-- Combo Settings --
function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Settings.combo.useQ then
			CastQ(unit)
		end
		if Settings.combo.useE then
			CastE(unit)
		end
		if Settings.combo.useR then
			CastR(unit)
		end
	end
end

-- Harass Settings --
function Harass(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type and not LowMana() then
		if Settings.harass.useQ then CastQ(unit) end
		if Settings.harass.useE then CastE(unit) end
	end
end

-- Mana Watch --
function LowMana()
	if myHero.mana < (myHero.maxMana * ( Settings.harass.harassMana / 100)) then
		return true
	else
		return false
	end
end

-- Jungle Clear Settings --
function JungleClear()
	if Settings.jungle.jungleKey then
		local JungleMob = GetJungleMob()
		
		if JungleMob ~= nil then
			if Settings.jungle.jungleQ and GetDistance(JungleMob) <= SkillQ.range and SkillQ.ready and not Qobj then
				CastSpell(_Q, JungleMob.x, JungleMob.z)
			end
			if Settings.jungle.jungleQ and GetDistance(JungleMob, Qobject) <= 200 and SkillQ.ready and Qobj then
				CastSpell(_Q)
			end
			if Settings.jungle.jungleE and GetDistance(JungleMob) <= SkillE.range and SkillE.ready then
				if TargetHaveBuff("chilled", JungleMob) then
					CastSpell(_E, JungleMob)
				end
			end
			if Settings.jungle.jungleR and GetDistance(JungleMob) <= SkillR.range and SkillR.ready and not Robj then
				CastSpell(_R, JungleMob.x, JungleMob.z)
			end
		end
	end
end

-- Killsteal Settings --
function KillSteal()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if not enemy.dead and enemy.visible then
			local eDmg = getDmg("E", enemy, myHero)
			local iDmg = ((useIgnite and Iready and getDmg("IGNITE", enemy, myHero)) or 0)
			
			if iDmg > enemy.health then
				CastSpell(ignite, enemy)
			elseif TargetHaveBuff("chilled", champ) then
				if enemy.health <= (eDmg * 2) then
					CastE(enemy)
				end
			elseif enemy.health <= (eDmg) then
				CastE(enemy)
			end
		end
	end
end

-- Skill Specifics --
-- Q --
function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= SkillQ.range and SkillQ.ready and not Qobj then
		local CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, unit)
		
		if HitChance >= 2 then
			CastSpell(_Q, CastPosition.x, CastPosition.z)
		end
	end
end

function DetQ()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) and enemy.visible and Qobj and not enemy.dead then
			if GetDistance(enemy, Qobject) <= 200 then
				CastSpell(_Q)
			end
		end
	end
end

-- W --
function WIntoR(unit)
	if Settings.skill.Wskill.WintoR then
		if unit and unit.type == myHero.type and unit.team ~= myHero.team then
			if unit.hasMovePath and unit.path.count > 1 and Robject and SkillW.ready then
				local path = unit.path:Path(2)
			
				if GetDistance(path, Robject) > 210 and GetDistance(unit, Robject) < 175  then
					local p1 = Vector(unit) + (Vector(path) - Vector(unit)):normalized() * 0.6 * unit.ms
				
					if GetDistance(p1) < 1000 and GetDistance(Robject, p1) > 150 and GetDistance(Robject, p1) < 250 and GetDistance(unit, path) > GetDistance(unit, p1) then
						CastSpell(_W, p1.x, p1.z)
					end
				end
			end
		end
	end
end

-- E --
function CastE(unit)
	if GetDistance(unit) <= SkillE.range and ValidTarget(unit) then
		if SkillE.ready then
			if Settings.skill.Eskill.chilledE then
				if TargetHaveBuff("chilled", unit) then
					CastSpell(_E, unit)
				end
			else
				CastSpell(_E, unit)
			end
		end
	end
end

-- R --
function CastR(unit)
	if unit ~= nil then
		if not Robj and SkillR.ready and GetDistance(unit) <= SkillR.range then
			local point = FindBestCircle(unit, SkillR.range, SkillR.width)
			CastSpell(_R, point.x, point.z)
		end
	end
end

function CancelR()
	if Settings.farm.cancelR and not Settings.jungle.jungleKey then
		if Robj then
			local rcount = 0
			for i, enemy in ipairs(GetEnemyHeroes()) do
				if GetDistance(enemy, Robject) < SkillR.range and ValidTarget(enemy) and not enemy.dead then
					rcount = rcount + 1
				end
			end
	
			if rcount == 0 then
				CastSpell(_R) 
			end
		end
	end
end

-- Ignite --
function UseIgnite()
	local iDmg = (50 + (20 * myHero.level))
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if GetDistance(enemy, myHero) < 600 and ValidTarget(enemy, 600) and Settings.ks.ignite then
			if Iready and enemy.health < iDmg then
				CastSpell(ignite, enemy)
			end
		end
	end
end

-- In-Game Menu --
function Menu()
	Settings = scriptConfig("Anivia - Eternal Winter "..version.."", "TitosAnivia")

	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings (SBTW)", "combo")
		Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.combo:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("useE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("useR", "Use (R) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:permaShow("comboKey")

	Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "harass")
		Settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		Settings.harass:addParam("useQ", "Use "..SkillQ.name.." (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.harass:addParam("useE", "Use "..SkillE.name.." (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.harass:addParam("harassMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		Settings.harass:permaShow("harassKey")

	Settings:addSubMenu("["..myHero.charName.."] - Farm Settings", "farm")
		Settings.farm:addParam("cancelR", "Automatically Cancel Ult", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("K"))
		Settings.farm:permaShow("cancelR")

	Settings:addSubMenu("["..myHero.charName.."] - Jungle Clear Settings", "jungle")
		Settings.jungle:addParam("jungleKey", "Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
		Settings.jungle:addParam("jungleQ", "Clear with "..SkillQ.name.." (Q)", SCRIPT_PARAM_ONOFF, true)
		Settings.jungle:addParam("jungleE", "Clear with "..SkillE.name.." (E)", SCRIPT_PARAM_ONOFF, true)
		Settings.jungle:addParam("jungleR", "Clear with "..SkillR.name.." (R)", SCRIPT_PARAM_ONOFF, true)
		Settings.jungle:permaShow("jungleKey")

	Settings:addSubMenu("["..myHero.charName.."] - Skill Settings", "skill")
		Settings.skill:addSubMenu("["..SkillW.name.."] (W) Settings", "Wskill")
			Settings.skill.Wskill:addParam("WintoR", "Use (W) with (R)", SCRIPT_PARAM_ONOFF, true)
		Settings.skill:addSubMenu("["..SkillE.name.."] (E) Settings", "Eskill")
			Settings.skill.Eskill:addParam("chilledE", "Use (E) on Chilled Targets Only", SCRIPT_PARAM_ONOFF, true)
		Settings.skill:addSubMenu("["..SkillR.name.."] (R) Settings", "Rskill")
			Settings.skill.Rskill:addParam("autoR", "Auto (R) on Stunned", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "ks")
		Settings.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
		Settings.ks:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		Settings.ks:permaShow("killSteal")

	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")      
		Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
		Settings.drawing:addParam("myHero", "Draw My Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("myColor", "Draw My Range Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("qDraw", "Draw "..SkillQ.name.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("qColor", "Draw "..SkillQ.name.." (Q) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("wDraw", "Draw "..SkillW.name.." (W) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("wColor", "Draw "..SkillW.name.." (W) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("eDraw", "Draw "..SkillE.name.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("eColor", "Draw "..SkillE.name.." (E) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("rDraw", "Draw "..SkillR.name.." (R) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("rColor", "Draw "..SkillR.name.." (R) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("KillText", "Draw Killable Text", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("targetcircle", "Draw Circle On Target", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Interrupt Settings", "interrupt")
		Settings.interrupt:addParam("skill", "Skill to Interrupt:", SCRIPT_PARAM_LIST, 3, {"Q", "W", "Smart", "Off"})
		local Interruptable = false
		for index, data in pairs(isAChampToInterrupt) do
			for inex, enemy in ipairs(GetEnemyHeroes()) do
				if data['Champ'] == enemy.charName then
					Settings.interrupt:addSubMenu(enemy.charName..' '..data.spellKey..'...', enemy.charName)
					Settings.interrupt[enemy.charName]:addParam('stop', 'Interrupt '..enemy.charName..' '..data.spellKey, SCRIPT_PARAM_ONOFF, true)
					Interruptable = true
				end
			end
		end
		if not Interruptable then
			Settings.interrupt:addParam('nil', 'No enemies to Interrupt found', SCRIPT_PARAM_INFO, '')
		end

	Settings:addSubMenu("["..myHero.charName.."] - Orbwalker Settings", "orbwalker")

	Settings:addSubMenu("["..myHero.charName.."] - Prediction Settings", "Prediction")
		UPL:AddToMenu(Settings.Prediction)

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, SkillQ.range, DAMAGE_MAGIC, true)
	TargetSelector.name = "Anivia"
	Settings:addTS(TargetSelector)
end

-- Interrupter --
function OnProcessSpell(unit, spell)
	if unit.team ~= myHero.team then
		if isAChampToInterrupt[spell.name] then
			if Settings.interrupt[unit.charName].stop then
				if Settings.interrupt.skill == 1 then
					if GetDistance(unit) <= SkillQ.range and SkillQ.ready and not Qobj then
						CastSpell(_Q, unit)
					end
				elseif Settings.interrupt.skill == 2 then
					if GetDistance(unit) <= SkillW.range and SkillW.ready then
						CastSpell(_W, unit)
					end
				elseif Settings.interrupt.skill == 3 then
					if GetDistance(unit) >= 150 and GetDistance(unit) <= 1000 then
						CastSpell(_W, unit)
					elseif GetDistance(unit) >= 150 and GetDistance(unit) > 1000 then
						CastSpell(_Q, unit)
					end
				end
			end
		end
	end
end

-- Drawings --
function DrawKillable()
	for i = 1, heroManager.iCount, 1 do
		local enemy = heroManager:getHero(i)
		if ValidTarget(enemy) then
			if enemy.team ~= myHero.team then 
				local iDmg = ((ignite ~= nil and Iready and getDmg("IGNITE", enemy, myHero)) or 0)
				local qDmg = getDmg("Q", enemy, myHero)
				local eDmg = getDmg("E", enemy, myHero)

				if iDmg > enemy.health then
					KillText[i] = 1
				elseif qDmg > enemy.health then
					KillText[i] = 2
				elseif qDmg + iDmg > enemy.health then
					KillText[i] = 3
				elseif qDmg + (eDmg * 2) > enemy.health then
					KillText[i] = 4
				elseif qDmg + (eDmg * 2) + iDmg > enemy.health then
					KillText[i] = 5
				else
					KillText[i] = 6
				end
			end
		end
	end
end

function DrawCircle(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
		
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(40, Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
		
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)	
end

-- Misc. --

-- Finding Jungle Mobs --
function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, SkillQ.range) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, SkillQ.range) then return Mob end
	end
end

-- Finding Debuffs --
function OnApplyBuff(source, unit, buff)
	if buff.type == 5 --[[Stun]] or buff.type == 11 --[[Root]] then
		if Settings.skill.Rskill.autoR and not Robj and SkillR.ready and unit.type == myHero.type and unit.team ~= myHero.team and GetDistance(unit) < SkillR.range then
			CastSpell(_R, unit.x, unit.z)
		end
	end
end

-- Q & R Objects --
function OnCreateObj(object)
	if object.name == "cryo_FlashFrost_Player_mis.troy" then
		Qobject = object
		Qobj = true
	end
	
	if object.name == "cryo_storm_green_team.troy" then
		Robject = object
		Robj = true
	end
end

function OnDeleteObj(object)
	if object.name == "cryo_FlashFrost_mis.troy" then
		Qobject = nil
		Qobj = false
	end
	
	if object.name == "cryo_storm_green_team.troy" then
		Robject = nil
		Robj = false
	end
end

-- W Logic --
function OnNewPath(unit,startPos,endPos,isDash,dashSpeed,dashGravity,dashDistance)
	if isDash and SkillW.ready and Settings.skill.Wskill.WintoR then
		if GetDistance(startPos, endPos) < 0.55 * dashSpeed then
			castPos = Vector(startPos) + (Vector(endPos) - Vector(startPos)):normalized() * 0.55 * dashSpeed
		else
			castPos = Vector(startPos) + (Vector(endPos) - Vector(startPos)):normalized() * (dashDistance + 50)
		end
			
		if AngleDifference(myHero, startPos, castPos) < 45 and GetDistance(castPos) > 50 and GetDistance(castPos) < 500 then
			CastSpell(_W, castPos.x, castPos.z)
		end
	end
end

function AngleDifference(from, p1, p2)
	local p1Z = p1.z - from.z
	local p1X = p1.x - from.x
	local p1Angle = math.atan2(p1Z , p1X) * 180 / math.pi
	
	local p2Z = p2.z - from.z
	local p2X = p2.x - from.x
	local p2Angle = math.atan2(p2Z , p2X) * 180 / math.pi
	
	return math.sqrt((p1Angle - p2Angle) ^ 2)
end

-- Finds the best position for cast --
function FindBestCircle(target, range, radius)
	local points = {}
	
	local rgDsqr = (range + radius) * (range + radius)
	local diaDsqr = (radius * 2) * (radius * 2)

	local Position = VPred:GetPredictedPos(target, 0.25)

	table.insert(points,Position)
	
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy.networkID ~= target.networkID and not enemy.dead and GetDistanceSqr(enemy) <= rgDsqr and GetDistanceSqr(target,enemy) < diaDsqr then
			local Position = VPred:GetPredictedPos(enemy, 0.25)
			table.insert(points, Position)
		end
	end
	
	while true do
		local MECObject = MEC(points)
		local OurCircle = MECObject:Compute()
		
		if OurCircle.radius <= radius then
			return OurCircle.center, #points
		end
		
		local Dist = -1
		local MyPoint = points[1]
		local index = 0
		
		for i=2, #points, 1 do
			local DistToTest = GetDistanceSqr(points[i], MyPoint)
			if DistToTest >= Dist then
				Dist = DistToTest
				index = i
			end
		end
		if index > 0 then
			table.remove(points, index)
		else
			return points[1], 1
		end
	end
end

--Source: http://stackoverflow.com/questions/1073336/circle-line-segment-collision-detection-algorithm
function PointsOfIntersection(A, B, C, R)
	local D, E, F, G = {}, {}, {}, {}
	
	--compute the euclidean distance between A and B
	LAB = math.sqrt((B.x-A.x)^ 2+(B.y-A.y)^ 2)

	--compute the direction vector D from A to B
	D.x = (B.x-A.x)/LAB
	D.y = (B.y-A.y)/LAB

	--Now the line equation is x = Dx*t + Ax, y = Dy*t + Ay with 0 <= t <= 1.
	--compute the value t of the closest point to the circle center (Cx, Cy)
	t = D.x*(C.x-A.x) + D.y*(C.y-A.y)    

	--This is the projection of C on the line from A to B.
	--compute the coordinates of the point E on line and closest to C
	E.x = t*D.x+A.x
	E.y = t*D.y+A.y

	-- compute the euclidean distance from E to C
	LEC = math.sqrt( (E.x-C.x)^ 2+(E.y-C.y)^ 2 )

	--test if the line intersects the circle
	if LEC < R then
		-- compute distance from t to circle intersection point
		dt = math.sqrt( R^ 2 - LEC^ 2)

		--compute first intersection point
		F.x = (t-dt)*D.x + A.x
		F.y = (t-dt)*D.y + A.y

		--compute second intersection point
		G.x = (t+dt)*D.x + A.x
		G.y = (t+dt)*D.y + A.y
	end
	
	return F, G
end

function Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end

-- Defining Variables --
function Variables()
	SkillQ = { name = "Flash Frost", range = 1100, delay = 0.25, speed = 850, width = 150, ready = false }
	SkillW = { name = "Crystallize", range = 1000, delay = 0.5, speed = math.huge, width = nil, ready = false }
	SkillE = { name = "Frostbite", range = 650, delay = 0.25, speed = math.huge, width = nil, ready = false }
	SkillR = { name = "Glacial Storm", range = 625, delay = 0.25, speed = math.huge, width = 210, ready = false }

	isAChampToInterrupt = {
		['KatarinaR']					= {true, Champ = 'Katarina',	spellKey = 'R'},
		['GalioIdolOfDurand']			= {true, Champ = 'Galio',		spellKey = 'R'},
		['Crowstorm']					= {true, Champ = 'FiddleSticks',spellKey = 'R'},
		['Drain']						= {true, Champ = 'FiddleSticks',spellKey = 'W'},
		['AbsoluteZero']				= {true, Champ = 'Nunu',		spellKey = 'R'},
		['ShenStandUnited']				= {true, Champ = 'Shen',		spellKey = 'R'},
		['UrgotSwap2']					= {true, Champ = 'Urgot',		spellKey = 'R'},
		['AlZaharNetherGrasp']			= {true, Champ = 'Malzahar',	spellKey = 'R'},
		['FallenOne']					= {true, Champ = 'Karthus',		spellKey = 'R'},
		['Pantheon_GrandSkyfall_Jump']	= {true, Champ = 'Pantheon',	spellKey = 'R'},
		['VarusQ']						= {true, Champ = 'Varus',		spellKey = 'Q'},
		['CaitlynAceintheHole']			= {true, Champ = 'Caitlyn',		spellKey = 'R'},
		['MissFortuneBulletTime']		= {true, Champ = 'MissFortune',	spellKey = 'R'},
		['InfiniteDuress']				= {true, Champ = 'Warwick',		spellKey = 'R'},
		['LucianR']						= {true, Champ = 'Lucian',		spellKey = 'R'}
	}

	local ignite = nil
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		ignite = SUMMONER_2
	end

	UPL = UPL()
	UPL:AddSpell(_Q, { speed = SkillQ.speed, delay = SkillQ.delay, range = SkillQ.range, width = SkillQ.width, collision = false, aoe = true, type = "linear" })   

	VPred = VPrediction()
	
	enemyMinions = minionManager(MINION_ENEMY, SkillR.range, myHero, MINION_SORT_HEALTH_ASC)
	
	JungleMobs = {}
	JungleFocusMobs = {}

	if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true
	else
		TwistedTreeline = false
	end

	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2

	priorityTable = {
			AP = {
				"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
				"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
				"Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz", "Ekko"
			},
			
			Support = {
				"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum", "TahnKench"
			},
			
			Tank = {
				"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
				"Warwick", "Yorick", "Zac"
			},
			
			AD_Carry = {
				"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
				"Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
			},
			
			Bruiser = {
				"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
				"Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
			}
	}
	if not TwistedTreeline then
		JungleMobNames = { 
			["SRU_MurkwolfMini2.1.3"]	= true,
			["SRU_MurkwolfMini2.1.2"]	= true,
			["SRU_MurkwolfMini8.1.3"]	= true,
			["SRU_MurkwolfMini8.1.2"]	= true,
			["SRU_BlueMini1.1.2"]		= true,
			["SRU_BlueMini7.1.2"]		= true,
			["SRU_BlueMini21.1.3"]		= true,
			["SRU_BlueMini27.1.3"]		= true,
			["SRU_RedMini10.1.2"]		= true,
			["SRU_RedMini10.1.3"]		= true,
			["SRU_RedMini4.1.2"]		= true,
			["SRU_RedMini4.1.3"]		= true,
			["SRU_KrugMini11.1.1"]		= true,
			["SRU_KrugMini5.1.1"]		= true,
			["SRU_RazorbeakMini9.1.2"]	= true,
			["SRU_RazorbeakMini9.1.3"]	= true,
			["SRU_RazorbeakMini9.1.4"]	= true,
			["SRU_RazorbeakMini3.1.2"]	= true,
			["SRU_RazorbeakMini3.1.3"]	= true,
			["SRU_RazorbeakMini3.1.4"]	= true
		}
		
		FocusJungleNames = {
			["SRU_Blue1.1.1"]			= true,
			["SRU_Blue7.1.1"]			= true,
			["SRU_Murkwolf2.1.1"]		= true,
			["SRU_Murkwolf8.1.1"]		= true,
			["SRU_Gromp13.1.1"]			= true,
			["SRU_Gromp14.1.1"]			= true,
			["Sru_Crab16.1.1"]			= true,
			["Sru_Crab15.1.1"]			= true,
			["SRU_Red10.1.1"]			= true,
			["SRU_Red4.1.1"]			= true,
			["SRU_Krug11.1.2"]			= true,
			["SRU_Krug5.1.2"]			= true,
			["SRU_Razorbeak9.1.1"]		= true,
			["SRU_Razorbeak3.1.1"]		= true,
			["SRU_Dragon6.1.1"]			= true,
			["SRU_Baron12.1.1"]			= true
		}
	else
		FocusJungleNames = {
			["TT_NWraith1.1.1"]			= true,
			["TT_NGolem2.1.1"]			= true,
			["TT_NWolf3.1.1"]			= true,
			["TT_NWraith4.1.1"]			= true,
			["TT_NGolem5.1.1"]			= true,
			["TT_NWolf6.1.1"]			= true,
			["TT_Spiderboss8.1.1"]		= true
		}		
		JungleMobNames = {
			["TT_NWraith21.1.2"]		= true,
			["TT_NWraith21.1.3"]		= true,
			["TT_NGolem22.1.2"]			= true,
			["TT_NWolf23.1.2"]			= true,
			["TT_NWolf23.1.3"]			= true,
			["TT_NWraith24.1.2"]		= true,
			["TT_NWraith24.1.3"]		= true,
			["TT_NGolem25.1.1"]			= true,
			["TT_NWolf26.1.2"]			= true,
			["TT_NWolf26.1.3"]			= true
		}
	end
	
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object and object.valid and not object.dead then
			if FocusJungleNames[object.name] then
				JungleFocusMobs[#JungleFocusMobs+1] = object
			elseif JungleMobNames[object.name] then
				JungleMobs[#JungleMobs+1] = object
			end
		end
	end
end
