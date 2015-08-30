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