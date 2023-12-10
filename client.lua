AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    local elegodown = BoxZone:Create(vector3(965.16, 58.66, 112.55), 1.5, 1.5, {
        name = 'elevatorgodown',
        heading = 232.52,
        minZ = 112.55 - 1.0,
        maxZ = 112.55 + 5.0,
        debugPoly = false
    })

    local elegoup = BoxZone:Create(vector3(959.97, 43.0, 71.7), 1.5, 1.5, {
        name = 'elevatorgoup',
        heading = 103.57,
        minZ = 71.7 - 1.0,
        maxZ = 71.7 + 5.0,
        debugPoly = false
    })

    elegodown:onPlayerInOut(function(isPointInside)
        if isPointInside then
            exports['qb-core']:DrawText('[E] To Go Down The Elevator', 'right')
            inZone = 1
        else
            inZone = 0
            exports['qb-core']:HideText()
        end
    end)

    elegoup:onPlayerInOut(function(isPointInside)
        if isPointInside then
            exports['qb-core']:DrawText('[E] To Go Up The Elevator', 'right')
            inZone = 2
        else
            inZone = 0
            exports['qb-core']:HideText()
        end
    end)
end)

CreateThread(function()
    while true do
        Wait(1)
        if inZone == 1 and IsControlPressed(0,46) then
            inZone = 0
            QBCore.Functions.Progressbar("elegoup", "Waiting..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
            }, {}, {}, function() -- Done
                exports['qb-core']:HideText()
                SetEntityCoords(PlayerPedId(), 961.1, 43.13, 71.7)
            end)
        elseif inZone == 2 and IsControlPressed(0,46) then
            inZone = 0
            QBCore.Functions.Progressbar("elegoup", "Waiting..", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
            }, {}, {}, function() -- Done
                exports['qb-core']:HideText()
                SetEntityCoords(PlayerPedId(), 964.26, 59.36, 112.55)
            end)
        end
    end
end)

CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = 's_m_m_movprem_01',
        coords = vector4(920.89, 54.35, 111.7, 194.84),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        component = true,
        target = {
            options = {
                {
                    type = 'client',
                    action = function()
                        QBCore.Functions.TriggerCallback('al-reputation:server:GetLevel', function(result)
                            if result >= 5 then
                                TargetMenu()
                            else
                                QBCore.Functions.Notify('You dont have enough street rep.', 'error')
                            end
                        end)
                    end,
                    icon = 'fas fa-briefcase',
                    label = 'Do Business',
                },
            },
            distance = 2.5,
        },
    })
    exports['qb-target']:SpawnPed({
        model = 's_m_m_highsec_01',
        coords = vector4(919.37, 55.1, 111.7, 198.21),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        component = true,
        target = {
            options = {
                {
                    type = 'client',
                    action = function()
                        QBCore.Functions.Notify('Talk To The Boss.', 'info')
                    end,
                    icon = 'fas fa-briefcase',
                    label = 'Do Business',
                },
            },
            distance = 2.5,
        },
    })
    exports['qb-target']:SpawnPed({
        model = 's_m_m_highsec_02',
        coords = vector4(921.29, 55.67, 111.7, 202.8),
        minusOne = true,
        freeze = true,
        invincible = true,
        blockevents = true,
        component = true,
        target = {
            options = {
                {
                    type = 'client',
                    action = function()
                        QBCore.Functions.Notify('Talk To The Boss.', 'info')
                    end,
                    icon = 'fas fa-briefcase',
                    label = 'Do Business',
                },
            },
            distance = 2.5,
        },
    })
end)

RegisterNetEvent('startcutscenesell', function(name)
    local plyrId = PlayerPedId()
    local thisCutsceneName = 'hs3f_all_drp3'
    local PlayerData = QBCore.Functions.GetPlayerData()
    local charName = 'MP_1'
    local clone = ClonePed(plyrId, false, false, true)

    RequestCutscene(thisCutsceneName)
    while not HasCutsceneLoaded() do Wait(10) end 
    
    RegisterEntityForCutscene(clone, charName, 0, 0, 64)
    SetCutsceneEntityStreamingFlags(charName, 0, 1) 
    
	SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
	RegisterEntityForCutscene(plyrId, 'MP_2', 3, GetEntityModel(plyrId), 64)

	SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
	RegisterEntityForCutscene(plyrId, 'MP_3', 3, GetEntityModel(plyrId), 64)

	SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
	RegisterEntityForCutscene(plyrId, 'MP_4', 3, GetEntityModel(plyrId), 64)
    
    SetCutsceneOrigin(914.59, 58.7, 110.66, 9.79)


	NewLoadSceneStartSphere(914.59, 58.7, 110.66, 1000, 0)


    StartCutscene(0)
    
    while not (DoesCutsceneEntityExist(charName, 0)) do
        Wait(0)
    end

    ClonePedToTarget(plyrId, clone)

    Wait(11000)
    ClonePedToTarget(clone, plyrId)
    DeleteEntity(clone)
    DoScreenFadeOut(500)
    Wait(2000)
    StopCutsceneImmediately()
    DoScreenFadeIn(500)
    local amount = 0
    if name == 'blooddiamond' then amount = math.floor(math.random(45,50)) elseif name == 'goldbar' then amount = math.floor(math.random(40,45)) elseif name == 'silverbar' then amount = math.floor(math.random(30,35)) end
    TriggerServerEvent('reputation:server:GiveRep', name..'selling-npc', amount)  
end)

function TargetMenu()
    local goldbar = true
    local silverbar = true
    local blooddiamond = true
    local replevel = 0
    
    QBCore.Functions.TriggerCallback('al-reputation:server:GetLevel', function(result)
        print(result)
        replevel = result
    end)

    print(replevel)

    if QBCore.Functions.HasItem('goldbar') and replevel >= 6 then goldbar = false end
    if QBCore.Functions.HasItem('silverbar') and replevel >= 3 then silverbar = false end


    exports['qb-menu']:openMenu({
        {
            header = "Local Business",
            isMenuHeader = true
        },
        {
            header = "Sell Gold Bars",
            txt = "",
            hidden = goldbar,
            params = {
                isServer = true,
                event = "al-trader:SellGoldBar",
            }
        },
        {
            header = "Sell Silver Bars",
            txt = "",
            hidden = silverbar,
            params = {
                isServer = true,
                event = "al-trader:SellSilverBar",
            }
        },
    })
end