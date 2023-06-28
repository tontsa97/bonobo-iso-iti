QBCore = nil
QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

-- ASETUSMUUTTUJAT
local grannypos = vector4(2436.63, 4966.73, 42.35, 92.87)
local model = "ig_mrs_thornhill"

Citizen.CreateThread(function()
    local hash = GetHashKey(model) -- Mallin hash-arvo
    RequestModel(hash)
    
    -- Odota, kunnes malli on ladattu
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    
    -- Luo hahmo paikkaan grannypos
    ped = CreatePed(4, hash, grannypos.x, grannypos.y, grannypos.z, 0.0, true, true)
    
    -- Tee hahmosta haavoittumaton ja estä muita tapahtumia
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    
    local pedanimdict = "mini@drinking"
    local pedanim = "shots_barman_b"
    loadAnimDict(pedanimdict)
    
    -- Toista animaatio hahmolle
    TaskPlayAnim(ped, pedanimdict, pedanim, 3.0, 3.0, -1, 49, 1, 0, 0, 0)
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

local grannypos = vector4(2436.63, 4966.73, 42.35, 92.87)

local prob = math.random(1, 10)

healAnimDict = "mini@cpr@char_a@cpr_str"
healAnim = "cpr_pumpchest"

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(PlayerPedId(), 0)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local distance = #(vector3(grannypos.x, grannypos.y, grannypos.z) - plyCoords)
        
        if distance < 10 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
                    QBCore.Functions.DrawText3D(grannypos.x, grannypos.y, grannypos.z + 0.5, '[E] - Pyydä apua isoäidiltä hintaan $2,000')
                    DisableControlAction(0, 57, true)
                    
                    if IsDisabledControlJustReleased(0, 54) then
                        QBCore.Functions.Progressbar("check-", "Pyydetään apua isoäidiltä", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {},
                        function()
                            if prob > 5 then
                                loadAnimDict('missheistdockssetup1clipboard@base')
                                TaskPlayAnim(PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 3.0, 1.0, -1, 49, 0, 0, 0, 0)
                                loadAnimDict(healAnimDict)
                                TaskPlayAnim(ped, healAnimDict, healAnim, 3.0, 3.0, 8000, 49, 0, 0, 0, 0)
                                
                                QBCore.Functions.Progressbar("check-", "Siunataan sinua elämällä", 10000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {},
                                function()
                                    QBCore.Functions.Notify("Olet saanut hoitoa! ..", "success")
                                    TriggerEvent('hospital:client:Revive')
                                    TriggerServerEvent('bonobo-isoäiti:server:Charge')
                                    ClearPedTasks(PlayerPedId())
                                end,
                                function() -- Peruuta
                                    ClearPedTasks(PlayerPedId())
                                end)
                            else
                                QBCore.Functions.Notify("Isoäiti kieltäytyi auttamasta", "error")
                            end
                        end)
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
