--[[
                       .,'          ,.-·.                ,.         ,·´'; '  
     ,.,           ,'´  ;\         /    ;'\'         ;'´*´ ,'\       ,'  ';'\° 
     \`, '`·.    ,·' ,·´\::'\      ;    ;:::\        ;    ';::\      ;  ;::'\ 
      \:';  '`·,'´,·´::::'\:;'     ';    ;::::;'      ;      '\;'      ;  ;:::; 
       `';'\    ,':::::;·´         ;   ;::::;      ,'  ,'`\   \      ;  ;:::; 
         ,·´,   \:;·´    '       ';  ;'::::;       ;  ;::;'\  '\    ;  ;:::;  
     .·´ ,·´:\   '\              ;  ';:::';       ;  ;:::;  '\  '\ ,'  ;:::;'  
  ,·´  .;:::::'\   ';    '        ';  ;::::;'     ,' ,'::;'     '\   ¨ ,'\::;'   
 ;    '.·'\::::;'   ,'\'            \*´\:::;‘     ;.'\::;        \`*´\::\; °  
 ;·-'´:::::\·´ \·:´:::\            '\::\:;'      \:::\'          '\:::\:' '    
  \::::;:·'     '\;:·'´               `*´‘         \:'             `*´'‚      
   `*'´           ‘           

	Changelog:

	1.0 - Script Release
--]]

local version = "1.0"
local author = "Titos & Georgedude"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/TitosOceanus/Bot-of-Legends/master/Xin%20Zhao%20-%20Challenger.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#B40404\"><b>Xin Zhao:</b></font> <font color=\"#FFD700\">"..msg..".</font>") end
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

if myHero.charName ~= "XinZhao" then return end

function OnLoad()
	print("<b><font color=\"#00FFFF\">Titos and GeorgeDude: <font color=\"#B40404\">Xin Zhao <font color=\"#FFFF00\">- <font color=\"#B40404\">Challenger <font color=\"#FFFF00\">["..version.."] <font color=\"#B40404\">Loaded.</font>")
	Variables()
	Menu()
	DelayAction(function() LoadOrbwalker() end, 10)
end

function OnTick()
	Target = GetOrbTarget()
	ComboKey = Settings.Keybind.ComboKey
	Checks()

	if ComboKey then
		Combo(Target)
	end

end

function Variables()
	SkillQ = { name = "Three Talon Strike", range = nil, ready = false }
	SkillW = { name = "Battle Cry", range = nil, ready = false }
	SkillE = { name = "Audacious Charge", range = 600, ready = false }
	SkillR = { name = "Crescent Sweep", range = 187.5, ready = false }

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
		if SkillE.ready and Settings.Draw.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, ARGB(255, 180, 4, 0))
		end
		
		if SkillR.ready and Settings.Draw.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, ARGB(255, 180, 4, 0))
		end
	
		if Settings.Draw.Targetcircle and Target then
			DrawCircle(Target.x, Target.y, Target.z, 100, ARGB(255, 180, 4, 0))
		end
	end
end		

function OnTick()
	if ComboKey then
		Combo()
	end

	Checks()
end

function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)
	Iready = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
end

function Menu()
	Settings = scriptConfig("Xin Zhao - Challenger "..version.."", "XinZhao")
	
	Settings:addSubMenu("["..myHero.charName.."] - Keybind Settings", "Keybind")
		Settings.Keybind:addParam("ComboKey", "Combo Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.Keybind:addParam("HarassKey", "Harass Key:", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		Settings.Keybind:addParam("ClearKey", "Clear Key:", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
		
	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings", "Combo")
		Settings.Combo:addParam("UseQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.Combo:addParam("UseR", "Use (R) in Combo:", SCRIPT_PARAM_LIST, 1, {"Normal", "1v1"}

	Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
		Settings.Harass:addParam("UseQ", "Use (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("UseE", "Use (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("MinMana", "Minimum Mana Percentage:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
	Settings:addSubMenu("["..myHero.charName.."] - Killsteal Settings", "Killsteal")	
		Settings.Killsteal:addParam("UseQ", "Use (Q) in Killsteal", SCRIPT_PARAM_ONOFF, true)
		Settings.Killsteal:addParam("UseE", "Use (E) in Killsteal", SCRIPT_PARAM_ONOFF, true)
		Settings.Killsteal:addParam("UseR", "Use (R) in Killsteal", SCRIPT_PARAM_ONOFF, true)	

	Settings:addSubMenu("["..myHero.charName.."] - Lane Settings", "Lane")
		Settings.Lane:addParam("UseQ", "Use (Q) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Lane:addParam("UseW", "Use (W) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Lane:addParam("UseE", "Use (E) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Lane:addParam("MinMana", "Minimum Mana Percentage:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Jungle Settings", "Jungle")
		Settings.Jungle:addParam("UseQ", "Use (Q) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("UseW", "Use (W) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("UseE", "USe (E) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "Draw")
		Settings.Draw:addParam("Disable", "Disable Range Drawings", SCRIPT_PARAM_ONOFF, false)
		Settings.Draw:addParam("eDraw", "Draw "..SkillE.name.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.Draw:addParam("rDraw", "Draw "..SkillR.name.." (R) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.Draw:addParam("Targetcircle", "Draw Target Circle", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Orbwalker Settings", "Orbwalker")

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, SkillE.range)
	TargetSelector.name = "XinZhao"
	Settings:addTS(TargetSelector)
end

function DefaultCombo(Target)
	if ValidTarget(Target) then
		if GetDistance(Target) <= SkillE.range and SkillE.ready then
			CastSpell(_E, Target)
			if SACLoaded then
				AA = 0
			end
		end
		-- 3 because one is challenged.
		if CountEnemyHeroInRange(SkillR.range, myHero) >= 3 and SkillR.ready then
			CastSpell(_R)
			if SACLoaded then
				AA = 0
			end
		end
		if GetDistance(Target) <= 175 then	
			if SACLoaded and AA >= 1 and SkillQ.ready then
				CastSpell(_Q)
				AA = 0
			elseif SkillQ.ready and not SACLoaded then
				CastSpell(_Q)
			end
			if SkillW.ready then
				CastSpell(_W)
			end
		end
	end
end

function Combo(Target)
	if ValidTarget(Target) then
		if Settings.Combo.UseR == 1 then
			DefaultCombo(Target)
		elseif Settings.Combo.UseR == 2 then
			if SkillR.ready then
				if CountEnemyHeroInRange(SkillE.range, myHero) == 1 and not TargetHaveBuff("xenzhaointimidate", Target) then
					if GetDistance(Target) <= SkillR.range then
						CastSpell(_R)
						if SACLoaded then
							AA = 0
						end
					end
				else
					DefaultCombo(Target)
				end
			else
				DefaultCombo(Target)
			end
		end
	end
end

function OnProcessSpell(unit, spell)
	if unit.isMe and SACLoaded then
		if spell.name:lower():find("attack") then
			AA = AA + 1
		end
	end
end

function Killsteal()
	if(Settings.Killsteal==false)then return end
	local target= GetOrbTarget()
		
		if(target~=nil)then
				if(GetDistance(target)<=175)then
					local ADdmg= myHero:CalcDamage(target, dmgQ)
					if(GetDistance(target)<=175 and target.health<=ADdmg and SkillQ.ready and Settings.Killsteal.UseQ )then
					
						if(SACLoaded)then
							_G.AutoCarry.Orbwalker:Orbwalk(target)
						end
					
						if(SxOrbLoaded)then
							SxOrb:ForceTarget(target)
						end
					
						CastSpell(_Q)
					end
					local Magicdmg = myHero:CalcMagicDamage(target, dmgE)		
				if(GetDistance(target)<=SkillE.range and target.health<=Magicdmg and SkillE.ready and Settings.Killsteal.UseE)then
					CastSpell(_E,target)
				end
				local ADdmg=myHero:CalcDamage(target,dmgR)
					if(GetDistance(target)<=SkillR.range and target.health<=ADdmg and SkillR.ready and Settings.Killsteal.UseR)then
						CastSpell(_R)
					end	
				end
				else
				local Magicdmg= myHero:CalcMagicDamage(target, dmgE)	
					if(GetDistance(target)<=SkillE.range and target.health<=Magicdmg and SkillE.ready and Settings.Killsteal.UseE)then
							CastSpell(_E,target)
					end
					local ADdmg= myHero:CalcDamage(target, dmgQ)
					if(GetDistance(target)<=SkillE.range and target.health<=ADdmg and SkillQ.ready and Settings.Killsteal.UseQ and SkillE.ready )then
						CastSpell(_E,target)
						CastSpell(_Q)
					end
					local ADdmg= myHero:CalcDamage(target, dmgR)
					if(GetDistance(target)<=SkillE.range and target.health<=ADdmg and SkillR.ready and Settings.Killsteal.UseR)then
						CastSpell(_E,target)
						CastSpell(_R)
					end
				end
		end
end





