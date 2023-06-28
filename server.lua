QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('bonobo-isoäiti:server:Charge')
AddEventHandler('bonobo-isoäiti:server:Charge', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if TriggerClientEvent("QBCore:Notify", src, "Jumala siunatkoon sinua!", "Onnistui", 5000) then
        Player.Functions.RemoveMoney('cash', 2000)
    end
end)
