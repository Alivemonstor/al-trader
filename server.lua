QBCore = exports['qb-core']:GetCoreObject()
local Groups = {}
local coords = {
    [1] = {
        [1] = vector4(1902.90, 592.38, 178.40, 155),
        [2] = vector4(1904.22, 593.45, 178.40, 154),
        [3] = vector4(1902.75, 594.19, 178.40, 154)
    },
    [2] = {
        [1] = vector4(-937.52, 6616.12, 3.42, 0),
        [2] = vector4(-938.65, 6614.36, 3.42, 1),
        [3] = vector4(-936.10, 6614.40, 3.42, 1)
    },
    [3] = {
        [1] = vector4(-1206.32, -1307.57, 4.81, 114),
        [2] = vector4(-1205.52, -1306.17, 4.82, 117),
        [3] = vector4(-1204.87, -1307.38, 4.84, 117)
    },
}
local peds = {
    [1] = {
        model = `s_m_m_movprem_01`,
        coords = vector4(1902.90, 592.38, 178.40, 155),
        entity = nil,
        target = true,
    },
    [2] = {
        model = `s_m_m_highsec_02`,
        coords = vector4(1904.22, 593.45, 178.40, 154),
        entity = nil,
        target = false,
    },
    [3] = {
        model = `s_m_m_highsec_02`,
        coords = vector4(1902.75, 594.19, 178.40, 154),
        entity = nil,
        target = false,
    },
}


AddEventHandler('onResourceStart', function(r)
    if GetCurrentResourceName() ~= r then return end

    local updatedcoords = coords[math.random(1,#coords)] 
    for i = 1, #peds do
        peds[i].coords = updatedcoords[i]
    end
end)

function GetClosestPlayers(ped, coords)
    local players = GetPlayers()
    local closestPlayers = {}
    for i = 1, #players do
        local playerId = players[i]
        local playerPed = GetPlayerPed(playerId)
        if playerPed ~= ped then
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - coords)
            if distance < 10 and #closestPlayers ~= 3 then
                closestPlayers[#closestPlayers+1] = tonumber(playerId)
            end
        end
    end
    return closestPlayers
end

function GroupCreate(source)
    local PlayerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(PlayerPed)

    Groups[source] = {}
    Groups[source][1] = tonumber(source)
    local Players = GetClosestPlayers(PlayerPed, coords)
    for k,v in pairs(Players) do
        Groups[source][#Groups[source]+1] = tonumber(v)
    end
end

lib.addCommand('trade', {
    help = 'quickmoney',
    params = {},
}, function(source, args)
    local src = source
    local amount = tonumber(args[1])
    local Player = QBCore.Functions.GetPlayer(src)


    exports['qb-inventory']:AddItem(src, 'markedbills', 10, nil, {worth = 500}, 'al-trader')
end)

RegisterNetEvent('al-trader:memberSync', function()
    local src = source
    local amount = 0
    local Player = QBCore.Functions.GetPlayer(src)
    local Items = exports['qb-inventory']:GetItemsByName(src, 'markedbills')

    if Items == nil then return QBCore.Functions.Notify(src, 'You do not have anything to trade', 'error') end


    for k,v in pairs(Items) do
        amount += v.info.worth*v.amount
    end

    for k,v in pairs(Items) do
        if not exports['qb-inventory']:RemoveItem(src, v.name, v.amount, v.slot, 'al-trader') then return QBCore.Functions.Notify(src, 'Couldnt remove '..v.name..' '..QBCore.Shared.Items[v.name].label) end
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[v.name], "remove", v.amount)
    end

    if amount == 0 then return QBCore.Functions.Notify(src, 'You do not have anything to trade', 'error') end

    Player.Functions.AddMoney('cash', amount, 'al-trader')

    GroupCreate(src)
    Wait(10)
    for k,v in pairs(Groups[src]) do
        TriggerClientEvent('startcutscenesell', v, Groups[src])
        SetPlayerRoutingBucket(v, 55)
    end
end)

RegisterNetEvent('al-trader:RemoveGroup', function()
    local src = source
    for k,v in pairs(Groups[src]) do
        SetPlayerRoutingBucket(v, 0)
    end
    Groups[src] = nil
end)

lib.callback.register('al-trader:GetPeds', function()
    return peds
end)
