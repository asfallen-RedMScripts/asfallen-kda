local PlayerStats = {
    kills = 0,
    deaths = 0,
    kda = 0.0
}


RegisterNetEvent('vorp:playerSpawn')
AddEventHandler('vorp:playerSpawn', function()

    SetNuiFocus(false, false)

    SendNUIMessage({
        type = "updateKDA",
        kills = PlayerStats.kills,
        deaths = PlayerStats.deaths,
        kda = PlayerStats.kda
    })
end)


RegisterNetEvent('vorp_core:Client:OnPlayerDeath')
AddEventHandler('vorp_core:Client:OnPlayerDeath', function(killerserverid, causeofdeath)
    local playerId = GetPlayerServerId(PlayerId())
    

    if killerserverid and playerId ~= killerserverid then
        TriggerServerEvent('asfallen_kda:playerDied', playerId, killerserverid)
    else
    
        TriggerServerEvent('asfallen_kda:playerDied', playerId, 0)
    end
end)


RegisterNetEvent('asfallen_kda:updateStats')
AddEventHandler('asfallen_kda:updateStats', function(stats)
    if stats then
   
        PlayerStats = stats
        
 
        local message = {
            type = "updateKDA",
            kills = stats.kills,
            deaths = stats.deaths,
            kda = stats.kda
        }
 
        SendNUIMessage(message)
        

        local display = true
        SetNuiFocus(false, false)
        DisplayHud(display)
    else
        print('Stats is nil')
    end
end)


RegisterNUICallback('loaded', function(data, cb)
    print('NUI started.PlayerStats')
    cb('ok')
end) 