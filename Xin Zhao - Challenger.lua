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
	HarassKey = Settings.Keybind.HarassKey
	ClearKey = Settings.Keybind.ClearKey
	Checks()

	if ComboKey then
		Combo()
	end

	if HarassKey then
		Harass()
	end

	if ClearKey then
		LaneClear()
		JungleClear()
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

function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)
	Iready = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
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
	
		if Settings.Draw.targetcircle and Target then
			DrawCircle(Target.x, Target.y, Target.z, 100, ARGB(255, 180, 4, 0))
		end
	end
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
		Settings.Combo:addParam("UseR", "Use (R) in Combo", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "Harass")
		Settings.Harass:addParam("UseQ", "Use (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("UseE", "Use (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.Harass:addParam("MinMana", "Minimum Mana Percentage:", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Lane Settings", "Lane")
		Settings.Lane:addParam("UseQ", "Use (Q) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Lane:addParam("UseW", "Use (W) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Lane:addParam("UseE", "Use (E) in Lane Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Lane:addParam("MinMana", "Minimum Mana Percentage:", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Jungle Settings", "Jungle")
		Settings.Jungle:addParam("UseQ", "Use (Q) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("UseW", "Use (W) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)
		Settings.Jungle:addParam("UseE", "USe (E) in Jungle Clear", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Skill Settings", "Skill")
		Settings.Skill:addSubMenu("["..SkillR.name.."] (R) Settings", "RSkill")
			Settings.Skill.RSkill:addParam("StunCount", "Minimum Enemies to Stun:", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)

	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "Draw")
		Settings.Draw:addParam("Disable", "Disable Range Drawings", SCRIPT_PARAM_ONOFF, false)
		Settings.Draw:addParam("eDraw", "Draw "..SkillE.name.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.Draw:addParam("rDraw", "Draw "..SkillR.name.." (R) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.Draw:addParam("targetcircle", "Draw Target Circle", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Orbwalker Settings", "Orbwalker")

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 600)
	TargetSelector.name = "XinZhao"
	Settings:addTS(TargetSelector)
end






