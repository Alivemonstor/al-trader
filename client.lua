local table = {}
QBCore = exports['qb-core']:GetCoreObject()

function LoadPeds()
    for k,v in pairs(table) do
        lib.RequestModel(v.model)
        v.entity = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z-1, v.coords.w, false, true)
        SetPedDefaultComponentVariation(v.entity)
        FreezeEntityPosition(v.entity, true)
        SetPedCanBeTargetted(v.entity, false)
        SetEntityInvincible(v.entity, true)
        SetBlockingOfNonTemporaryEvents(v.entity, true)
        if v.target then
            exports['qb-target']:AddTargetEntity(v.entity, {
                options = {
                    {
                        type = 'server',
                        icon = 'fas fa-briefcase',
                        label = 'Do Business',
                        event = 'al-trader:memberSync'
                    },
                },
                distance = 2.5,
            })
        else
            exports['qb-target']:AddTargetEntity(v.entity, {
                options = {
                    {
                        type = 'server',
                        icon = 'fas fa-briefcase',
                        label = 'Do Business',
                        action = function()
                            QBCore.Functions.Notify('Speak to the boss.')
                        end,
                    },
                },
                distance = 2.5,
            })
        end
    end
end

AddEventHandler('onResourceStop', function(r)
    if GetCurrentResourceName() ~= r then return end

    for k, v in pairs(table) do
        DeleteEntity(v.entity)
    end

    DoScreenFadeIn(500)
end)

AddEventHandler('onResourceStart', function(r)
    if GetCurrentResourceName() ~= r then return end

    table = lib.callback.await('al-trader:GetPeds')
    LoadPeds()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    table = lib.callback.await('al-trader:GetPeds')
    LoadPeds()
end)

RegisterNetEvent('startcutscenesell', function(ids)
    local plyrId = PlayerPedId()
    local coords = GetEntityCoords(plyrId)
    local thisCutsceneName = 'hs3f_all_drp3'
    local clones = {}

    DoScreenFadeOut(500)

    for k,v in pairs(table) do
        SetEntityVisible(v.entity, false)
    end
    SetEntityVisible(plyrId, false)

    for k, v in pairs(ids) do
        clones[k] = {}
        clones[k].ped = GetPlayerPed(GetPlayerFromServerId(v))
        clones[k].id = v
        clones[k].clone = ClonePed(clones[k].ped, false, false, true)
    end

    RequestCutscene(thisCutsceneName)
    while not HasCutsceneLoaded() do Wait(10) end 
    
    for k, v in pairs(clones) do
        SetCutsceneEntityStreamingFlags('MP_'..k, 0, 1) 
        RegisterEntityForCutscene(v.clone, 'MP_'..k, 0, 0, 64)
    end


    if #clones < 4 then 
        local remainder = 4-#clones
        for i = #clones+1, #clones+remainder do
            SetCutsceneEntityStreamingFlags('MP_'..i, 0, 1) 
            RegisterEntityForCutscene(0, 'MP_'..i, 3, 0, 64)
        end
    end

    DoScreenFadeIn(500)

	NewLoadSceneStartSphere(coords.x, coords.y, coords.z, 1000, 0)
    

    StartCutsceneAtCoords(coords.x, coords.y, coords.z-1, 0)

    for k, v in pairs(clones) do
        while not (DoesCutsceneEntityExist('MP_'..k, 0)) do
            Wait(0)
        end
    end

    for k, v in pairs(clones) do
        ClonePedToTarget(v.ped, v.clone)
    end

    Wait(GetCutsceneTotalDuration()-500)
    DoScreenFadeOut(500)
    for k, v in pairs(clones) do
        ClonePedToTarget(v.clone, v.ped)
        DeleteEntity(v.clone)
    end
    Wait(2000)
    StopCutsceneImmediately()

    for k,v in pairs(table) do
        SetEntityVisible(v.entity, true)
    end
    SetEntityVisible(plyrId, true)

    if clones[1].ped == PlayerPedId() then TriggerServerEvent('al-trader:RemoveGroup') end
    DoScreenFadeIn(500)


end)
