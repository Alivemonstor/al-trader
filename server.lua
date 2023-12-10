RegisterNetEvent('al-reputation:SellGoldBar', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    local item = Player.Functions.GetItemByName('goldbar')

    Player.Functions.RemoveItem('goldbar', item.amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['goldbar'], "remove", item.amount)
    TriggerClientEvent('startcutscenesell', src, 'goldbar')
    Player.Functions.AddMoney('cash', 100 * item.amount)
end)

RegisterNetEvent('al-reputation:SellSilverBar', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    local item = Player.Functions.GetItemByName('silverbar')

    Player.Functions.RemoveItem('silverbar', item.amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['silverbar'], "remove", item.amount)
    TriggerClientEvent('startcutscenesell', src, 'silverbar')
    Player.Functions.AddMoney('cash', 100 * item.amount)
end)


RegisterNetEvent('al-reputation:SellBloodDiamond', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    local item = Player.Functions.GetItemByName('blooddiamond')

    Player.Functions.RemoveItem('blooddiamond', item.amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['blooddiamond'], "remove", item.amount)
    TriggerClientEvent('startcutscenesell', src, 'blooddiamond')
    Player.Functions.AddMoney('cash', 100 * item.amount)
end)

