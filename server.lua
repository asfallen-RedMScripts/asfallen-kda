local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

local PlayerStats = {}


local function GetSteamId(source)
    if not source then return nil end
    
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.find(identifier, "steam:") then
            return identifier
        end
    end
    return nil
end


CreateThread(function()
    exports.oxmysql:execute([[
        CREATE TABLE IF NOT EXISTS asfallen_kda (
            steamid VARCHAR(50) NOT NULL PRIMARY KEY,
            kills INT DEFAULT 0,
            deaths INT DEFAULT 0,
            kda FLOAT DEFAULT 0.0
        );
    ]])
    print("KDA Table initialized")
end)


local function LoadPlayerStats(steamId)
    if not steamId then return nil end

    local result = exports.oxmysql:executeSync('SELECT * FROM asfallen_kda WHERE steamid = ?', {steamId})
    
    if result and result[1] then
        return {
            kills = tonumber(result[1].kills),
            deaths = tonumber(result[1].deaths),
            kda = tonumber(result[1].kda)
        }
    else
  
        local success = exports.oxmysql:executeSync('INSERT INTO asfallen_kda (steamid, kills, deaths, kda) VALUES (?, ?, ?, ?)',
            {steamId, 0, 0, 0.0})
        
        if success then
            return {
                kills = 0,
                deaths = 0,
                kda = 0.0
            }
        end
        return nil
    end
end

RegisterNetEvent('vorp:playerSpawn')
AddEventHandler('vorp:playerSpawn', function()
    local _source = source
    local steamId = GetSteamId(_source)
    
    if steamId then
        local dbStats = LoadPlayerStats(steamId)
        if dbStats then
            PlayerStats[steamId] = dbStats
            TriggerClientEvent('asfallen_kda:updateStats', _source, PlayerStats[steamId])
        else
            PlayerStats[steamId] = {
                kills = 0,
                deaths = 0,
                kda = 0.0
            }
            TriggerClientEvent('asfallen_kda:updateStats', _source, PlayerStats[steamId])
        end
    end
end)


RegisterServerEvent('asfallen_kda:playerDied')
AddEventHandler('asfallen_kda:playerDied', function(victim, killer)
   -- print("Server received - Victim: " .. tostring(victim) .. " Killer: " .. tostring(killer)) -- Debug için
    
    local steamId = GetSteamId(victim)
    if not steamId then
      --  print("Steam ID bulunamadı - Victim: " .. tostring(victim)) -- Debug için
        return
    end
    
    if not PlayerStats[steamId] then
        PlayerStats[steamId] = LoadPlayerStats(steamId)
    end
    
    if PlayerStats[steamId] then
        PlayerStats[steamId].deaths = PlayerStats[steamId].deaths + 1
        
      
        if PlayerStats[steamId].deaths == 0 then
            PlayerStats[steamId].kda = PlayerStats[steamId].kills
        else
            PlayerStats[steamId].kda = math.floor((PlayerStats[steamId].kills / PlayerStats[steamId].deaths) * 100) / 100
        end
        
    
        exports.oxmysql:execute('UPDATE asfallen_kda SET deaths = ?, kda = ? WHERE steamid = ?',
            {PlayerStats[steamId].deaths, PlayerStats[steamId].kda, steamId})
                
    
        TriggerClientEvent('asfallen_kda:updateStats', victim, PlayerStats[steamId])
    end
    
  
    if killer and killer ~= 0 and killer ~= victim then
        local killerSteamId = GetSteamId(killer)
        if not killerSteamId then
            --print("Killer Steam ID bulunamadı - Killer: " .. tostring(killer)) -- Debug için
            return
        end
        
        if not PlayerStats[killerSteamId] then
            PlayerStats[killerSteamId] = LoadPlayerStats(killerSteamId)
        end
        
        if PlayerStats[killerSteamId] then
            PlayerStats[killerSteamId].kills = PlayerStats[killerSteamId].kills + 1
            
         
            if PlayerStats[killerSteamId].deaths == 0 then
                PlayerStats[killerSteamId].kda = PlayerStats[killerSteamId].kills
            else
                PlayerStats[killerSteamId].kda = math.floor((PlayerStats[killerSteamId].kills / PlayerStats[killerSteamId].deaths) * 100) / 100
            end
            
       
            exports.oxmysql:execute('UPDATE asfallen_kda SET kills = ?, kda = ? WHERE steamid = ?',
                {PlayerStats[killerSteamId].kills, PlayerStats[killerSteamId].kda, killerSteamId})
                        
            
            TriggerClientEvent('asfallen_kda:updateStats', killer, PlayerStats[killerSteamId])
        end
    end
end) 