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

if myHero.charName ~= "XinZhao" then return end

function OnLoad()
	print("<b><font color=\"#00FFFF\">Titos and GeorgeDude: <font color=\"#B40404\">Xin Zhao <font color=\"#FFFF00\">- <font color=\"#B40404\">Challenger <font color=\"#FFFF00\">["..version.."] <font color=\"#B40404\">Loaded.</font>")
	Menu()
	DelayAction(function() LoadOrbwalker() end, 10)
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

function Menu()
	Settings = scriptConfig("Xin Zhao - Challenger "..version.."", "XinZhao")
	
	Settings:addSubMenu("["..myHero.charName.."] - Keybind Settings", "Keybind")
		Settings.Keybind:addParam("ComboKey", "Combo Key:", SCRIPT_PARAM_ONKEYDOWN, false, 32)
end






